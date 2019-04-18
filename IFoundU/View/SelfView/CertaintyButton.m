//
//  CertaintyButton.m
//  IFoundU
//
//  Created by Tom-Li on 2019/4/16.
//  Copyright © 2019 litong. All rights reserved.
//

#import "CertaintyButton.h"

@implementation CertaintyButton

- (instancetype)initWithTitle:(NSString *)title {
    if (self = [super init]) {
        [self initViewWith:title];
    }
    return self;
}

- (void)initViewWith:(NSString *)title {
    
    // 背景和字体颜色
    [self setBackgroundColor:[UIColor blueColor]];
    
    // 字体
    NSMutableAttributedString *titleString = [[NSMutableAttributedString alloc]initWithString:title];
    [titleString addAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor], NSFontAttributeName : [UIFont systemFontOfSize:18]} range:NSMakeRange(0, titleString.length)];
    [self setAttributedTitle:titleString.copy forState:UIControlStateNormal];
    
    // 设置圆角边框
    CALayer *layer = self.layer;
    layer.cornerRadius = 5;
    layer.masksToBounds = YES;
    
}
@end
