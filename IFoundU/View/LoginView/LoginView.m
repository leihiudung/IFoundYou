//
//  LoginView.m
//  IFoundU
//
//  Created by Tom-Li on 2019/3/25.
//  Copyright © 2019 litong. All rights reserved.
//

#import "LoginView.h"
#import "ColorInCommon.h"
#import "LoginViewMode.h"



#import <Masonry/Masonry.h>
#import <ReactiveObjC/ReactiveObjC.h>

@interface LoginView()
@property (nonatomic, strong) UITextField *nameField;
@property (nonatomic, strong) UITextField *passwordField;

@property (nonatomic, strong) UIButton *loginButton;

@property (nonatomic, assign) CGRect bigFrame;

@property (nonatomic, strong) LoginViewMode *loginViewMode;

@property (nonatomic, strong) UIView *loadingView;
@end

@implementation LoginView

- (instancetype)initWithLoginFrame:(CGRect)frame {
    if (self = [super init]) {
        [self initWithView:frame];
        self.bigFrame = frame;
        [self addNotification];
        
        [self initWithReactive];
    }
    return self;
}

- (void)addNotification {
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIKeyboardWillShowNotification object:nil] subscribeNext:^(NSNotification * _Nullable notification) {
        
        NSDictionary *info = [notification userInfo];
        //获取改变尺寸后的键盘的frame
        CGRect endKeyboardRect = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
        
        CGFloat diffY = (kScreenHeight - endKeyboardRect.size.height) - CGRectGetMaxY(self.frame);
        CGRect originFrame = self.frame;
        originFrame.origin.y -= fabs(diffY);
        self.frame = originFrame;

    }];
    
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIKeyboardWillHideNotification object:nil] subscribeNext:^(NSNotification * _Nullable notification) {

        NSDictionary *info = [notification userInfo];
        //获取改变尺寸后的键盘的frame
        CGRect endKeyboardRect = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];

        CGRect originFrame = self.frame;
        originFrame.origin.y = (self.bigFrame.size.height - 300)/2;
        self.frame = originFrame;
    }];
    
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"TapLoginController" object:nil] subscribeNext:^(NSNotification * _Nullable x) {
        [self superviewTap];
    }];
  
}

- (void)superviewTap {
    [self.nameField resignFirstResponder];
    [self.passwordField resignFirstResponder];
    
}

- (void)initWithView:(CGRect)frame {
    self.backgroundColor = UIColorOfRGB(0xF0FFF0);
    
    self.loadingView = [[UIView alloc]initWithFrame:UIScreen.mainScreen.bounds];
//    self.loadingView setBackgroundColor:
//    [self.loadingView setHidden:YES];
//    [self insertSubview:self.loadingView atIndex:0];
    
    self.nameField = [[UITextField alloc]init];
    self.passwordField = [[UITextField alloc]init];
    self.loginButton = [[UIButton alloc]init];

    self.nameField.backgroundColor = [UIColor whiteColor];
    self.passwordField.backgroundColor = [UIColor whiteColor];
    [self.loginButton setBackgroundColor:[UIColor whiteColor]];
    [self.loginButton setTitle:@"Login" forState:UIControlStateNormal];
    [self.loginButton setEnabled:NO];
    [self.loginButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [self addSubview:self.nameField];
    [self addSubview:self.passwordField];
    [self addSubview:self.loginButton];
    
    [self setFrame:CGRectMake(0, (frame.size.height - 300)/2, frame.size.width, 300)];
    
    [self.nameField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.centerY.mas_equalTo(self.mas_centerY).mas_offset(-60);
        make.width.mas_equalTo(self.mas_width).multipliedBy(0.7);
        make.height.mas_equalTo(60);
    }];
    
    [self.passwordField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.centerY.mas_equalTo(self).mas_offset(20);
        make.width.mas_equalTo(self.nameField);
        make.height.mas_equalTo(60);
    }];
    
    [self.loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.top.mas_equalTo(self.passwordField.mas_bottom).mas_offset(20);
        make.left.mas_equalTo(self.passwordField.mas_left);
        make.width.mas_equalTo(self.passwordField);
        make.height.mas_equalTo(60);
    }];
    
}

/**
 初始化RAC监听对象
 */
- (void)initWithReactive {
    self.loginViewMode = [[LoginViewMode alloc]init];
    RAC(self.loginViewMode, userName) = self.nameField.rac_textSignal;
    RAC(self.loginViewMode, password) = self.passwordField.rac_textSignal;
    RAC(self.loginButton, enabled) = [self.loginViewMode bindInputView];
    [self loginAction]; // button的点击事件
    NSLog(@"%@", self.loginViewMode.userName);
}

- (void)loginAction {
    @weakify(self);
    [[self.loginButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        [self.loginViewMode loginRequest];
        
    }];
}


@end
