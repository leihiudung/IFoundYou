//
//  DistanceCommon.m
//  IFoundU
//
//  Created by Tom-Li on 2019/4/18.
//  Copyright © 2019 litong. All rights reserved.
//

#import "DistanceCommon.h"

@implementation DistanceCommon

+ (NSDictionary *)calculateRangeOfRadius:(double)distance centerLat:(double)centerLat centerLong:(double)centerLong {
    double worldRadius = 6371.004; // 地球半径
    
    double dlng = asin(sin(distance/(2 * worldRadius)) / cos(centerLat * M_PI / 180));
    dlng = dlng * 180 / M_PI; // 最大经度
    
    double dlat = distance / worldRadius * 180 / M_PI; // 最大维度
    
    double minLat = centerLat - dlat;
    double minLong = fabs(centerLong) - dlng;
    
    double maxLat = centerLat + dlat;
    double maxLong = fabs(centerLong) + dlng;
    
    return @{@"minLat": @(minLat), @"minLong": @(minLong), @"maxLat": @(maxLat), @"maxLong": @(maxLong)};
    
}
@end
