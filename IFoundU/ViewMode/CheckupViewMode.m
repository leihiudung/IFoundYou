//
//  CheckupViewMode.m
//  IFoundU
//
//  Created by Tom-Li on 2019/4/3.
//  Copyright © 2019 litong. All rights reserved.
//

#import "CheckupViewMode.h"
#import "SensorCommon.h"
#import "DeviceTypeCommon.h"

@interface CheckupViewMode()

@property (nonatomic, assign) TestItem testItem;


@end

@implementation CheckupViewMode

- (instancetype)initViewMode {
    if (self = [super init]) {
        
        [self initWaitForTesedItem];
    }
    return self;
}

- (void)excuteing {
    self.testItem = CellFunction;
    
    
}


/**
 初始化待测试的item数量
 */
- (void)initWaitForTesedItem {
    NSMutableDictionary *tempDic = [NSMutableDictionary dictionary];
    [tempDic addEntriesFromDictionary:@{@"CellFunction": @(CellFunction),
                                        @"Memory": @(Memory),
                                        @"CPU": @(CPU),
                                        @"Storage": @(Storage),
                                        @"Flash": @(Flash)}];
    
    [DeviceTypeCommon divideByiP5] == GreaterThan5s ? [tempDic addEntriesFromDictionary:@{@"Barometer": @(Barometer)}] : nil;
    
    [tempDic addEntriesFromDictionary:@{@"GPS": @(GPS),
                                        @"WiFiConnection": @(WiFiConnection),
                                        @"CellularNetwork": @(CellularNetwork),
                                        @"Vibrator": @(Vibrator),
                                        @"Bluetooth": @(Bluetooth),
                                        @"SpeakerAndMic": @(SpeakerAndMic),
                                        @"ReceiverAndMic": @(ReceiverAndMic),
                                        @"EarphonesAndMic": @(EarphonesAndMic),
                                        @"ProximitySensor": @(ProximitySensor),
                                        @"Accelerometer": @(Accelerometer),
                                        @"Gyroscope": @(Gyroscope),
                                        @"Compass": @(Compass),
                                        @"HomeButton": @(HomeButton),
                                        @"VolumeControl": @(VolumeControl),
                                        @"SleepAndWakeButton": @(SleepAndWakeButton),
                                        @"Camera": @(Camera)}];
    
    [DeviceTypeCommon divideByiP6s] == YES ? [tempDic addEntriesFromDictionary:@{@"3DTouch": @(ThreeDTouch)}] : nil;
    self.testItemDic = tempDic.copy;
    
}

@end
