//
//  LingTextField.m
//  IFoundU
//
//  Created by Tom-Li on 2019/4/16.
//  Copyright © 2019 litong. All rights reserved.
//

#import "LingTextField.h"
@interface LingTextField() <UITextFieldDelegate>

@end

@implementation LingTextField

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
        
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initView];
    }
    return self;
}

- (void)initView {
    [self setBackgroundColor:[UIColor lightGrayColor]];
    [self setValue:[UIFont boldSystemFontOfSize:18] forKeyPath:@"_placeholderLabel.font"];
    // 设置文字左边距的距离
    self.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 8, 0)];
    self.leftViewMode = UITextFieldViewModeAlways;
    
    // 设置圆角边框
    CALayer *layer = self.layer;
    layer.cornerRadius = 5;
    layer.masksToBounds = YES;
    
}

@end
