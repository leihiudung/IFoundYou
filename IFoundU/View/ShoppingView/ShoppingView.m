//
//  ShoppingView.m
//  IFoundU
//
//  Created by Tom-Li on 2019/4/15.
//  Copyright © 2019 litong. All rights reserved.
//

#import "ShoppingView.h"
#import "MerchantTableViewTipsView.h"
#import "OperationFlagCommon.h"

#import <Masonry/Masonry.h>
#import <ReactiveObjC/ReactiveObjC.h>

@interface ShoppingView()<UITableViewDataSource,  UITableViewDelegate> {
    BOOL _isOperating;
}
@property (nonatomic, strong) UIButton *merchantBtn;
@property (nonatomic, strong) UIButton *settingBtn;
@property (nonatomic, strong) UIButton *operationBtn;

@property (nonatomic, strong) UITableView *nearbyTableView;

@property (nonatomic, strong) NSArray *resultData;

// 点击cell后显示
@property (nonatomic, strong) MerchantTableViewTipsView *tipsView;
@end

@implementation ShoppingView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
        [self initRAC];
        [self initData];
        
        
        _isOperating = NO;
    }
    return self;
}

- (void)initView {
    self.merchantBtn = [[UIButton alloc]init];
    self.settingBtn = [[UIButton alloc]init];
    self.operationBtn = [[UIButton alloc]init];
    self.nearbyTableView = [[UITableView alloc]init];
    [self.nearbyTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"CellId"];
    
    [self addSubview:self.merchantBtn];
    [self addSubview:self.settingBtn];
    [self addSubview:self.operationBtn];
    [self addSubview:self.nearbyTableView];
    
    [self.merchantBtn setTitle:@"商家列表" forState:UIControlStateNormal];
    [self.merchantBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [self.settingBtn setTitle:@"定位参数" forState:UIControlStateNormal];
    [self.settingBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [self.operationBtn setTitle:@"开始" forState:UIControlStateNormal];
    [self.operationBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [self.merchantBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self).mas_offset(-150);
        make.centerX.mas_equalTo(self);
        make.height.mas_equalTo(60);
        make.width.mas_equalTo(120);
    }];
    
    [self.settingBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self).mas_offset(-90);
        make.centerX.mas_equalTo(self);
        make.height.mas_equalTo(self.merchantBtn);
        make.width.mas_equalTo(self.merchantBtn);
    }];
    
    [self.operationBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self).mas_offset(-30);
        make.centerX.mas_equalTo(self);
        make.height.mas_equalTo(self.merchantBtn);
        make.width.mas_equalTo(self.merchantBtn);
    }];
    
    [self.nearbyTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.operationBtn.mas_bottom).mas_offset(22);
        make.width.mas_equalTo(self);
        make.bottom.mas_equalTo(self.mas_bottom).mas_offset(-88);
    }];
    
    [self.nearbyTableView setDataSource:self];
    [self.nearbyTableView setDelegate:self];
    
    // 地址详细信息
    self.tipsView = [[MerchantTableViewTipsView alloc]initWithFrame:UIScreen.mainScreen.bounds ofType:Hide];
    [self.tipsView setHidden:YES];
    [self addSubview:self.tipsView];

}

- (void)initRAC {

   
    __block typeof(self) weakself = self;
    [[self.merchantBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"MerchantNotification" object:nil userInfo:@{}];
    }];
    
    [[self.settingBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"SettingNotification" object:nil userInfo:@{@"class" : [MerchantController class]}];
    }];
    
    [[self.operationBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        weakself->_isOperating = !weakself->_isOperating;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"OperationNotification" object:nil userInfo:@{@"class" : [MerchantController class], @"isOperating": @(weakself->_isOperating)}];
        
        if (weakself->_isOperating) {
            [weakself.operationBtn setTitle:@"停车" forState:UIControlStateNormal];
        } else {
            [weakself.operationBtn setTitle:@"开始" forState:UIControlStateNormal];
        }
        
    }];
}

- (void)initData {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(nearbyMerchant:) name:@"DataWidhConditionNotification" object:nil];
    
    self.resultData = @[];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.resultData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dic = self.resultData[indexPath.row];
    NSString *addr = dic[@"addr"];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellId" forIndexPath:indexPath];
    cell.textLabel.text = addr;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tipsView setContentWithDic:self.resultData[indexPath.row]];
}

- (void)nearbyMerchant:(NSNotification *)notification {
    NSArray *nearbyArray = notification.userInfo[@"resultArray"];
    self.resultData = nearbyArray.copy;
    [self.nearbyTableView reloadData];
}

@end
