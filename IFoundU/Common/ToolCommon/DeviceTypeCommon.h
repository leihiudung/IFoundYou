//
//  DeviceTypeCommon.h
//  IFoundU
//
//  Created by Tom-Li on 2019/4/3.
//  Copyright © 2019 litong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    LessThan4s = 0,
    EqualTo4S = 1 << 0,
    GreaterThan4s = 1 << 1,
    
    LessThan5s = 1 << 2,
    EqualTo5s = 1 << 3,
    GreaterThan5s = 1 << 4,
    
    LessThan6s = 1 << 5,
    EqualTo6s = 1 << 6,
    GreaterThan6s = 1 << 7,
    
    LessThan7 = 1 << 8,
    EqualTo7 = 1 << 9,
    GreaterThan7 = 1 << 10,
    
    LessThanX = 1 << 11,
    EqualToX = 1 << 12,
    GreaterThanX = 1 << 13,
    
} PhoneModelType;

@interface DeviceTypeCommon : NSObject

+ (NSString *)deviceModelName;
+ (NSUInteger *)deviceModelDivideByType:(PhoneModelType)phoneModelType;
+ (CGFloat)fileSystemSize;
+ (CGFloat)freeFileSystemSize;

+ (NSString *)getCPUKind;
+ (NSUInteger)deviceModelDivideByIphoneX;
+ (BOOL)divideByiP6s;
+ (NSUInteger)divideByiP5;

@end

NS_ASSUME_NONNULL_END
