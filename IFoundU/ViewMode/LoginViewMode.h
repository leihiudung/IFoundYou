//
//  LoginViewMode.h
//  IFoundU
//
//  Created by Tom-Li on 2019/3/26.
//  Copyright © 2019 litong. All rights reserved.
//

#import <Foundation/Foundation.h>

//@class ReactiveObjC;
#import <ReactiveObjC/ReactiveObjC.h>

NS_ASSUME_NONNULL_BEGIN

@interface LoginViewMode : NSObject
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *password;

- (RACSignal *)bindInputView;
- (void)loginRequest;
@end

NS_ASSUME_NONNULL_END
