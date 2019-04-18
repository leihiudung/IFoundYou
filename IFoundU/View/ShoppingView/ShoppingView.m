//
//  ShoppingView.m
//  IFoundU
//
//  Created by Tom-Li on 2019/4/15.
//  Copyright © 2019 litong. All rights reserved.
//

#import "ShoppingView.h"



#import <Masonry/Masonry.h>
#import <ReactiveObjC/ReactiveObjC.h>

@interface ShoppingView()
@property (nonatomic, strong) UIButton *merchantBtn;
@property (nonatomic, strong) UIButton *settingBtn;
@property (nonatomic, strong) UIButton *operationBtn;
@end

@implementation ShoppingView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

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
    self.merchantBtn = [[UIButton alloc]init];
    self.settingBtn = [[UIButton alloc]init];
    self.operationBtn = [[UIButton alloc]init];
    [self addSubview:self.merchantBtn];
    [self addSubview:self.settingBtn];
    [self addSubview:self.operationBtn];
    
    
    [self.merchantBtn setTitle:@"商家列表" forState:UIControlStateNormal];
    [self.merchantBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [self.settingBtn setTitle:@"定位参数" forState:UIControlStateNormal];
    [self.settingBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [self.operationBtn setTitle:@"开始" forState:UIControlStateNormal];
    [self.operationBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [self.merchantBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self).mas_offset(-90);
        make.centerX.mas_equalTo(self);
        make.height.mas_equalTo(60);
        make.width.mas_equalTo(120);
    }];
    
    [self.settingBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self).mas_offset(-30);
        make.centerX.mas_equalTo(self);
        make.height.mas_equalTo(self.merchantBtn);
        make.width.mas_equalTo(self.merchantBtn);
    }];
    
    [self.operationBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self).mas_offset(30);
        make.centerX.mas_equalTo(self);
        make.height.mas_equalTo(self.merchantBtn);
        make.width.mas_equalTo(self.merchantBtn);
    }];
}

- (void)initRAC {

   
    __block typeof(self) weakself = self;
    [[self.merchantBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"MerchantNotification" object:nil userInfo:@{}];
    }];
    
    [[self.settingBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"SettingNotification" object:nil userInfo:@{@"class" : [MerchantController class]}];
    }];
}

@end
