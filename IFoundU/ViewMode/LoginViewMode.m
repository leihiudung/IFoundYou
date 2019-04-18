//
//  LoginViewMode.m
//  IFoundU
//
//  Created by Tom-Li on 2019/3/26.
//  Copyright © 2019 litong. All rights reserved.
//

#import "LoginViewMode.h"

#import "UserObject.h"

//#import <ReactiveObjC/ReactiveObjC.h>

@interface LoginViewMode()

@property (nonatomic, strong) RACSignal *userNameSignal;
@property (nonatomic, strong) RACSignal *passwordSignal;
@property (nonatomic, strong) RACSignal *combineSignal;

@end
@implementation LoginViewMode

- (instancetype)init {
    if (self = [super init]) {
        [self initialize];
    }
    
    return self;
}

- (void)initialize {
    self.userNameSignal = RACObserve(self, userName);
    self.passwordSignal = RACObserve(self, password);
    
}

- (RACSignal *)bindInputView {
    RACSignal *combineSignal = [RACSignal combineLatest:@[self.userNameSignal, self.passwordSignal] reduce:^id(NSString *userName, NSString *password){
        
        NSLog(@"done");
        return @(userName.length >=3 && password.length >= 3);
    }];
    return combineSignal;
    
}

- (void)loginRequest {
    NSArray *requestParams = @[self.userName, self.password];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"LoginSuccessNotification" object:nil userInfo:@{}];
    
}
@end
