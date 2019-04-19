//
//  DistanceCommon.h
//  IFoundU
//
//  Created by Tom-Li on 2019/4/18.
//  Copyright © 2019 litong. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DistanceCommon : NSObject

+ (NSDictionary *)calculateRangeOfRadius:(double)distance centerLat:(double)centerLat centerLong:(double)centerLong;
@end

NS_ASSUME_NONNULL_END
