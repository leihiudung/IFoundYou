//
//  MerchantTableViewTipsView.m
//  IFoundU
//
//  Created by Tom-Li on 2019/4/17.
//  Copyright © 2019 litong. All rights reserved.
//

#import "MerchantTableViewTipsView.h"

#import <Masonry/Masonry.h>
#import <ReactiveObjC/ReactiveObjC.h>

#define UIColorOfRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16)) / 255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1]


@interface MerchantTableViewTipsView()

@property (nonatomic, strong) UIView *detailView;
@property (nonatomic, strong) UILabel *titleView;
@property (nonatomic, strong) UILabel *addrView;
@property (nonatomic, strong) UILabel *telView;

@property (nonatomic, strong) UIButton *uncertaintyBtn;
@property (nonatomic, strong) UIButton *certaintyBtn;

@property (nonatomic, strong) NSDictionary *transDic;
@end

@implementation MerchantTableViewTipsView

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
        [self initRAC];
    }
    return self;
}

- (void)initView {

    [self setAlpha:0.8];
    [self setBackgroundColor:UIColorOfRGB(0X004D76)];
    
    self.detailView = [[UIView alloc]init];
    CALayer *detailLayer = self.detailView.layer;
    detailLayer.masksToBounds = YES;
    detailLayer.cornerRadius = 5;
    [self.detailView setBackgroundColor:UIColor.whiteColor];
    [self addSubview:self.detailView];
    
    
    // titleView
    self.titleView = [[UILabel alloc]init];
    [self.titleView setTextAlignment:NSTextAlignmentCenter];
    [self.titleView setFont:[UIFont boldSystemFontOfSize:18]];
    [self.detailView addSubview:self.titleView];
    
    self.addrView = [[UILabel alloc]init];
    [self.addrView setNumberOfLines:0];
    [self.detailView addSubview:self.addrView];
    
    self.telView = [[UILabel alloc]init];
    [self.detailView addSubview:self.telView];
    
    self.uncertaintyBtn = [[UIButton alloc]init];
    [self.uncertaintyBtn setTitle:@"Uncertainty" forState:UIControlStateNormal];
    [self.uncertaintyBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.uncertaintyBtn setBackgroundColor:[UIColor blueColor]];
    CALayer *uncertaintyLayer = self.uncertaintyBtn.layer;
    uncertaintyLayer.masksToBounds = YES;
    uncertaintyLayer.cornerRadius = 5;
    [self.detailView addSubview:self.uncertaintyBtn];
    
    self.certaintyBtn = [[UIButton alloc]init];
    [self.certaintyBtn setTitle:@"Certainty" forState:UIControlStateNormal];
    [self.certaintyBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.certaintyBtn setBackgroundColor:[UIColor redColor]];
    CALayer *certaintyLayer = self.certaintyBtn.layer;
    certaintyLayer.masksToBounds = YES;
    certaintyLayer.cornerRadius = 5;
    [self.detailView addSubview:self.certaintyBtn];
    
    [self.detailView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self);
        make.width.mas_equalTo(self).multipliedBy(0.8);
        make.height.mas_equalTo(320);
    }];
    
    [self.titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.detailView);
        make.width.mas_equalTo(self.detailView);
        make.height.mas_equalTo(48);
    }];
    
    [self.addrView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleView.mas_bottom).mas_offset(8);
        make.width.mas_equalTo(self.detailView).multipliedBy(0.8);
        make.height.mas_equalTo(88);
        make.centerX.mas_equalTo(self.detailView);
    }];
    
    [self.telView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.addrView.mas_bottom).mas_offset(8);
        make.width.mas_equalTo(self.detailView).multipliedBy(0.8);
        make.height.mas_equalTo(38);
        make.centerX.mas_equalTo(self.detailView);
    }];
    
    [self.uncertaintyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.detailView).mas_offset(12);
        make.width.mas_equalTo(self.detailView).multipliedBy(0.38);
       make.height.mas_equalTo(40); make.bottom.mas_equalTo(self.detailView.mas_bottom).mas_offset(-12);
    }];
    
    [self.certaintyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.detailView).mas_offset(-12);
        make.width.mas_equalTo(self.detailView).multipliedBy(0.38);
        make.height.mas_equalTo(40);
        make.bottom.mas_equalTo(self.detailView.mas_bottom).mas_offset(-12);
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(operationCompleted:) name:@"InsertCompletedNotification" object:nil];
}

- (void)initRAC {
    [[self.uncertaintyBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        [self setHidden:YES];
    }];
    
    [[self.certaintyBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"SaveMerchantNotification" object:nil userInfo:self.transDic];
        
    }];
}

- (void)closeAction {
    [self setHidden:YES];
    
}

- (void)setTitle:(NSString *)title addr:(NSString *)addr tel:(NSString *)tel {
    [self.titleView setText:title];
    [self.addrView setText:addr];
    [self.telView setText:tel];
    [self setHidden:NO];
    
}

- (void)setContentWithDic:(NSDictionary *)dic {
    self.transDic = dic;
    [self.titleView setText:dic[@"name"]];
    [self.addrView setText:dic[@"addr"]];
    [self.telView setText:dic[@"phone"]];
    [self setHidden:NO];
}

- (void)operationCompleted:(NSNotification *)notification {
    NSDictionary *userInfo = [notification userInfo];
    if ([userInfo[@"flag"] integerValue] == 1) {
        UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"收藏出错" message:@"请杀掉App再重试" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"了解" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [controller addAction:action];
        UIViewController *vc = [UIViewController new];
        vc.view = self;
        [vc presentViewController:controller animated:YES completion:nil];
        return;
    }
    [self setHidden:YES];
    
}

@end
