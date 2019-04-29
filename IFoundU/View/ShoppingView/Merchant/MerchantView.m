//
//  MechantView.m
//  IFoundU
//
//  Created by Tom-Li on 2019/4/16.
//  Copyright © 2019 litong. All rights reserved.
//

#import "MerchantView.h"
#import "LingTextField.h"
#import "HrefButton.h"
#import "CertaintyButton.h"
#import "MerchantTableView.h"
#import "MerchantTableViewTipsView.h"

#import "ShoppingViewMode.h"

#import <Masonry/Masonry.h>
#import <ReactiveObjC/ReactiveObjC.h>
// 百度地图
#import <BaiduMapAPI_Base/BMKBaseComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>

@interface MerchantView() <UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate> {
    BOOL _isRefreshing;
}
@property (nonatomic, strong) LingTextField *storeView;
@property (nonatomic, strong) LingTextField *districtView;
@property (nonatomic, strong) LingTextField *coordinateView;

@property (nonatomic, strong) HrefButton *importBtn;
@property (nonatomic, strong) CertaintyButton *confirmBtn;

@property (nonatomic, strong) MerchantTableView *resultTabelView;

@property (nonatomic, strong) NSMutableArray *resultArray;

// 点击cell后显示
@property (nonatomic, strong) MerchantTableViewTipsView *tipsView;

@property (nonatomic, strong) ShoppingViewMode *viewMode;

@end

@implementation MerchantView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
        [self initRAC];
        
        self.resultArray = [NSMutableArray array];
    }
    return self;
}



- (void)initView {
    // 收回键盘
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selfTouchAction:)];
    gesture.delegate = self;
    [self addGestureRecognizer:gesture];
    
    self.storeView = [[LingTextField alloc]init];
    self.districtView = [[LingTextField alloc]init];
    self.coordinateView = [[LingTextField alloc]init];
    
    [self.storeView setPlaceholder:@"商家名称"];
    [self.districtView setPlaceholder:@"区域"];
    [self.coordinateView setPlaceholder:@"经纬度(可选)"];
    
    self.importBtn = [[HrefButton alloc]initWithTitle:@"导入"];
    self.confirmBtn = [[CertaintyButton alloc]initWithTitle:@"是它"];
    
    [self addSubview:self.storeView];
    [self addSubview:self.districtView];
    [self addSubview:self.coordinateView];
    [self addSubview:self.importBtn];
    [self addSubview:self.confirmBtn];
    
    // tableview
    self.resultTabelView = [[MerchantTableView alloc]init];
    [self addSubview:self.resultTabelView];
    
    [self.resultTabelView setDataSource:self];
    [self.resultTabelView setDelegate:self];
    [self.resultTabelView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"CellId"];
    
    // 地址详细信息
    self.tipsView = [[MerchantTableViewTipsView alloc]initWithFrame:UIScreen.mainScreen.bounds];
    [self.tipsView setHidden:YES];
    [self addSubview:self.tipsView];
 
    [self.coordinateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self).mas_offset(-60);
        make.centerX.mas_equalTo(self);
        make.width.mas_equalTo(self).multipliedBy(0.6);
        make.height.mas_equalTo(60);
    }];

    [self.districtView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.coordinateView.mas_top).mas_offset(-20);
        make.centerX.mas_equalTo(self);
        make.width.mas_equalTo(self).multipliedBy(0.6);
        make.height.mas_equalTo(60);
    }];
    
    [self.storeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.districtView.mas_top).mas_offset(-20);
        make.centerX.mas_equalTo(self);
        make.width.mas_equalTo(self).multipliedBy(0.6);
        make.height.mas_equalTo(60);
    }];
    
    [self.importBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.coordinateView.mas_bottom).mas_offset(20);
        make.centerX.mas_equalTo(self);

    }];
    
    [self.confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.importBtn.mas_bottom).mas_offset(20);
        make.centerX.mas_equalTo(self);
        make.width.mas_equalTo(self).multipliedBy(0.6);
        make.height.mas_equalTo(60);
    }];
    
    [self.resultTabelView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.confirmBtn.mas_bottom).mas_offset(30);
        make.width.mas_equalTo(self);
        make.bottom.mas_equalTo(self.mas_bottom);
    }];
    
    
}


- (void)initRAC {
    self.viewMode = [[ShoppingViewMode alloc]init];
    RAC(self.viewMode, storeString) = self.storeView.rac_textSignal;
    RAC(self.viewMode, districtString) = self.districtView.rac_textSignal;
    RAC(self.viewMode, coordinateString) = self.districtView.rac_textSignal;
    
    __block typeof(self) weakself = self;
    
    [RACObserve(self.viewMode, resultArray) subscribeNext:^(NSArray * _Nullable x) {
        if (x == nil) {
            return ;
        }
        [weakself.resultArray addObjectsFromArray:x];
        [weakself.resultTabelView reloadData];
        weakself->_isRefreshing = NO;
    }];
    
    [[self.confirmBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        [weakself.resultArray removeAllObjects];
        [self.viewMode poiSearchInCity];

    }];
    
    [[self.importBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        UIViewController *vc = [UIViewController new];
        vc.view = self;

    }];
}
// 
- (void)selfTouchAction:(UITapGestureRecognizer *)gesture {
    [self.storeView resignFirstResponder];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.resultArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellId" forIndexPath:indexPath];
//    cell.userInteractionEnabled = YES;
    cell.textLabel.text = self.resultArray.count == 0 ? nil : self.resultArray[indexPath.row][@"addr"];
    return cell;
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {

    if (self.resultTabelView.contentOffset.y + self.resultTabelView.frame.size.height - 83 >= self.resultTabelView.contentSize.height && !_isRefreshing) {
//        ShoppingViewMode *viewMode = [ShoppingViewMode share];
        [self.viewMode poiResearchInCity:self.resultArray == nil ? 0 : self.resultArray.count / 5];
        _isRefreshing = YES;
    }

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tipsView setContentWithDic:self.resultArray[indexPath.row]];

}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([touch.view isKindOfClass:[MerchantView class]]) {
        return YES;
    }
    NSLog(@"done");
    return NO;
    
}

@end
