//
//  CheckupViewMode.h
//  IFoundU
//
//  Created by Tom-Li on 2019/4/3.
//  Copyright © 2019 litong. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CheckupViewMode : NSObject

@property (nonatomic, strong) NSDictionary<NSString *, NSNumber *> *testItemDic;

- (instancetype)initViewMode;
- (void)excuteing;
@end

NS_ASSUME_NONNULL_END
