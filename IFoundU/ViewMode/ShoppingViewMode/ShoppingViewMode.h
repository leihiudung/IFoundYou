//
//  ShoppingViewMode.h
//  IFoundU
//
//  Created by Tom-Li on 2019/4/17.
//  Copyright © 2019 litong. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ShoppingViewMode : NSObject

@property (nonatomic, strong) NSString *storeString;
@property (nonatomic, strong) NSString *districtString;
@property (nonatomic, strong) NSString *coordinateString;

@property (nonatomic, strong) NSMutableArray *resultArray;

+ (instancetype)share;

- (void)poiSearchInCity;
- (void)poiResearchInCity:(NSInteger)pageIndex;
@end

NS_ASSUME_NONNULL_END
