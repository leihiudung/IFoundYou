//
//  CheckupViewMode.h
//  IFoundU
//
//  Created by Tom-Li on 2019/4/3.
//  Copyright © 2019 litong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SensorCommon.h"

NS_ASSUME_NONNULL_BEGIN

@interface CheckupViewMode : NSObject

//@property (nonatomic, strong) NSDictionary<NSString *, NSNumber *> *testItemDic;
@property (nonatomic, strong) NSArray<NSDictionary<NSString *, NSString *> *> *testItemArray;
@property (nonatomic, assign) TestItem testItem;

- (instancetype)initViewMode;
- (void)excuteing;
@end

NS_ASSUME_NONNULL_END
