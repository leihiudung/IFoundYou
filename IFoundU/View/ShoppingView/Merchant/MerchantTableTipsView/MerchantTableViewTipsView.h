//
//  MerchantTableViewTipsView.h
//  IFoundU
//
//  Created by Tom-Li on 2019/4/17.
//  Copyright © 2019 litong. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MerchantTableViewTipsView : UIView

- (void)setTitle:(NSString *)title addr:(NSString *)addr tel:(NSString *)tel;
- (void)setContentWithDic:(NSDictionary *)dic;
@end

NS_ASSUME_NONNULL_END
