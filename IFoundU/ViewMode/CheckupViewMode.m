//
//  CheckupViewMode.m
//  IFoundU
//
//  Created by Tom-Li on 2019/4/3.
//  Copyright © 2019 litong. All rights reserved.
//

#import "CheckupViewMode.h"
//#import "SensorCommon.h"
#import "DeviceTypeCommon.h"

#import "LightCheckupViewMode.h"

#import <ReactiveObjC/ReactiveObjC.h>

@interface CheckupViewMode()

//@property (nonatomic, assign) TestItem testItem;

@property (nonatomic, strong) RACCommand *command;

@end

@implementation CheckupViewMode

- (instancetype)initViewMode {
    if (self = [super init]) {
        
        [self initWaitForTesedItem];
    }
    return self;
}

- (void)excuteing {
//    self.testItem = CellFunction;
    
    self.command = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
    
        // 开始测试
        // 测试结果
        return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            
            [subscriber sendNext:@1];
            [subscriber sendCompleted];
            
            return nil;
        }];
    }];
    
    [self.command execute:nil];
    
}

- (void)resultAfterExecute {
    
}


/**
 初始化待测试的item数量
 */
- (void)initWaitForTesedItem {
    NSMutableDictionary *tempDic = [NSMutableDictionary dictionary];
    NSMutableArray *tempArray = [NSMutableArray array];
    [tempArray addObjectsFromArray:@[@{@"CellFunction": NSLocalizedStringFromTable(@"CellFunction", @"IFoundU", @"")},
                                     @{@"Memory": NSLocalizedStringFromTable(@"Memory", @"IFoundU", @"")},
                                     @{@"Storage": NSLocalizedStringFromTable(@"Storage", @"IFoundU", @"")},
                                     @{@"Flash": NSLocalizedStringFromTable(@"Flash", @"IFoundU", @"")},
                                     @{@"Barometer": NSLocalizedStringFromTable(@"Barometer", @"IFoundU", @"")},
                                     @{@"GPS": NSLocalizedStringFromTable(@"GPS", @"IFoundU", nil)},
                                     @{@"WiFiConnection": NSLocalizedStringFromTable(@"WiFiConnection", @"IFoundU", nil)},
                                     @{@"CellularNetwork": NSLocalizedStringFromTable(@"CellularNetwork", @"IFoundU", nil)},
                                     @{@"Vibrator": NSLocalizedStringFromTable(@"Vibrator", @"IFoundU", nil)},
                                     @{@"Bluetooth": NSLocalizedStringFromTable(@"Bluetooth", @"IFoundU", nil)},
                                     @{@"SpeakerAndMic": NSLocalizedStringFromTable(@"SpeakerAndMic", @"IFoundU", nil)},
                                     @{@"ReceiverAndMic": NSLocalizedStringFromTable(@"ReceiverAndMic", @"IFoundU", nil)},
                                     @{@"EarphonesAndMic": NSLocalizedStringFromTable(@"EarphonesAndMic", @"IFoundU", nil)},
                                     @{@"ProximitySensor": NSLocalizedStringFromTable(@"ProximitySensor", @"IFoundU", nil)},
                                     @{@"Accelerometer": NSLocalizedStringFromTable(@"Accelerometer", @"IFoundU", nil)},
                                     @{@"Gyroscope": NSLocalizedStringFromTable(@"Gyroscope", @"IFoundU", nil)},
                                     @{@"Compass": NSLocalizedStringFromTable(@"Compass", @"IFoundU", nil)},
                                     @{@"HomeButton": NSLocalizedStringFromTable(@"HomeButton", @"IFoundU", nil)},
                                     @{@"VolumeControl": NSLocalizedStringFromTable(@"VolumeControl", @"IFoundU", nil)},
                                     @{@"SleepAndWakeButton": NSLocalizedStringFromTable(@"SleepAndWakeButton", @"IFoundU", nil)},
                                     @{@"Camera": NSLocalizedStringFromTable(@"Camera", @"IFoundU", nil)},
                                     @{@"3DTouch": NSLocalizedStringFromTable(@"3DTouch", @"IFoundU", nil)}]];
    
    self.testItemArray = tempArray.copy;
    NSLog(@"done");
}

@end
