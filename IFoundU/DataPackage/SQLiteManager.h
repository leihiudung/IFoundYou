//
//  SQLiteManager.h
//  IFoundU
//
//  Created by Tom-Li on 2019/4/17.
//  Copyright © 2019 litong. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "OperationFlagCommon.h"

NS_ASSUME_NONNULL_BEGIN

@protocol SQLiteManagerDelegate <NSObject>

- (void)insertCompleted:(OperationFlag)flag;

@end

@interface SQLiteManager : NSObject
+ (instancetype)share;
@property (nonatomic, assign) id<SQLiteManagerDelegate> delegate;
- (void)insertData:(NSDictionary *)dic;
- (NSArray<NSDictionary<NSString *, NSString *> *> *)getData;
- (NSArray<NSDictionary<NSString *, NSString *> *> *)getDataWidhCondition:(NSDictionary *)dic;
@end

NS_ASSUME_NONNULL_END
