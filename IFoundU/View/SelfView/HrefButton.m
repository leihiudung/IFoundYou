//
//  HrefButton.m
//  IFoundU
//
//  Created by Tom-Li on 2019/4/16.
//  Copyright © 2019 litong. All rights reserved.
//

#import "HrefButton.h"

@implementation HrefButton

- (instancetype)initWithTitle:(NSString *)title {
    self = [super init];
    if (self) {
        [self initViewWith:title];
    }
    return self;
}

- (void)initViewWith:(NSString *)title {
    // 加下划线
    NSMutableAttributedString *importString = [[NSMutableAttributedString alloc]initWithString:title];
    
    [importString addAttributes:@{NSUnderlineStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle], NSForegroundColorAttributeName: [UIColor blueColor]} range:NSMakeRange(0, title.length)];
    
    [self setAttributedTitle:importString forState:UIControlStateNormal];
    
    // 计算宽度
    NSDictionary *dic = @{NSFontAttributeName : [UIFont systemFontOfSize:17.f ]};
    CGRect titleRect = [title boundingRectWithSize:CGSizeMake(UIScreen.mainScreen.bounds.size.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:dic context:nil];
    [self setFrame:CGRectMake(0, 0, titleRect.size.width, titleRect.size.height)];
    
    
}

@end
