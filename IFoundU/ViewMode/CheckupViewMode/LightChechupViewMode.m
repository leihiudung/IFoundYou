//
//  LightChechupViewMode.m
//  IFoundU
//
//  Created by Tom-Li on 2019/4/3.
//  Copyright © 2019 litong. All rights reserved.
//

#import "LightChechupViewMode.h"
#import <AVFoundation/AVFoundation.h>

@interface LightChechupViewMode() <AVCaptureVideoDataOutputSampleBufferDelegate> {
    int _count;
}

@property (nonatomic, strong) AVCaptureSession *session;
@property (nonatomic, strong) AVCaptureDevice *device;
@property (nonatomic, strong) dispatch_source_t timer;

@property (nonatomic, strong) NSMutableArray *lightOnArray;
@property (nonatomic, strong) NSMutableArray *lightOffArray;
@property (nonatomic, assign) BOOL lightOn;

@property (nonatomic, strong) NSMutableArray *resultArray;

@end

@implementation LightChechupViewMode


+ (instancetype)share {
    static dispatch_once_t onceToken;
    static LightChechupViewMode *lightCheck;
    dispatch_once(&onceToken, ^{
        lightCheck = [[LightChechupViewMode alloc]init];
        
    });
    return lightCheck;
}

// MARK: -开启闪光灯
- (void)flashLightCheck{
#if (TARGET_IPHONE_SIMULATOR)
    
    // 在模拟器的情况下
//    toolBlock(Fault);
#else
    _count = 4;
    _resultArray = [NSMutableArray array];
    self.lightOn = NO;
    self.lightOnArray = [NSMutableArray array];
    self.lightOffArray = [NSMutableArray array];
    // 在真机情况下
    Class captureDeviceClass = NSClassFromString(@"AVCaptureDevice");
    
    // 1.获取硬件设备
    self.device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    // 2.创建输入流
    AVCaptureDeviceInput *input = [[AVCaptureDeviceInput alloc]initWithDevice:self.device error:nil];
    
    // 3.创建设备输出流
    AVCaptureVideoDataOutput *output = [[AVCaptureVideoDataOutput alloc] init];
    [output setSampleBufferDelegate:self queue:dispatch_get_main_queue()];
    
    
    // AVCaptureSession属性
    self.session = [[AVCaptureSession alloc]init];
    // 设置为高质量采集率
    [self.session setSessionPreset:AVCaptureSessionPresetHigh];
    // 添加会话输入和输出
    if ([self.session canAddInput:input]) {
        [self.session addInput:input];
    }
    if ([self.session canAddOutput:output]) {
        [self.session addOutput:output];
    }
    [self.session startRunning];
    if (captureDeviceClass !=nil) {
        
        if ([self.device hasTorch] && [self.device hasFlash]){
            //            if (on) {
            __block BOOL lightOn = self.lightOn;
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
            dispatch_source_set_timer(self.timer, DISPATCH_TIME_NOW, 3.3 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
            dispatch_source_set_event_handler(self.timer, ^{
                
                if (self->_count == 0) {
                    [_session stopRunning];
                    
                    int tempCount = 0;
                    for (int i = 0; i < _lightOnArray.count; i++) {
                        if ([_lightOnArray[i] floatValue] - [_lightOffArray[i] floatValue] > 1) {
                            tempCount++;
                        }
                    }
                    [_resultArray addObject:@(tempCount > 5)];
                    
                    [self.lightOnArray removeAllObjects];
                    [self.lightOffArray removeAllObjects];
                    
                    dispatch_source_cancel(self.timer);
                    HardStatus status = Normal;
                    if ([_resultArray[0] boolValue]) {
//                        toolBlock(status);
                    } else  {
                        status = Fault;
//                        toolBlock(status);
                        
                    }
                    [self stopTorch];
                    return ;
                }
                
                if (self->_count % 2 == 0) {
                    [self.lightOnArray removeAllObjects];
                    
                    lightOn = YES;
                    [self.device lockForConfiguration:nil];
                    [self.device setTorchMode:AVCaptureTorchModeOn];
                    [self.device unlockForConfiguration];
                    NSLog(@"时间1%@", [NSDate date]);
                } else {
                    [self.lightOffArray removeAllObjects];
                    lightOn = NO;
                    [self.device lockForConfiguration:nil];
                    [self.device setTorchMode:AVCaptureTorchModeOff];
                    [self.device unlockForConfiguration];
                    NSLog(@"时间2%@", [NSDate date]);
                }
                
                self->_count--;
                
            });
            dispatch_resume(self.timer);
            
        }else{
            
            NSLog(@"初始化失败");
            
        }
        
    }else{
        NSLog(@"没有闪光设备");
        
    }
#endif
    
    
}

#pragma mark- AVCaptureVideoDataOutputSampleBufferDelegate的方法
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection {
    
    CFDictionaryRef metadataDict = CMCopyDictionaryOfAttachments(NULL,sampleBuffer, kCMAttachmentMode_ShouldPropagate);
    NSDictionary *metadata = [[NSMutableDictionary alloc] initWithDictionary:(__bridge NSDictionary*)metadataDict];
    CFRelease(metadataDict);
    NSDictionary *exifMetadata = [[metadata objectForKey:(NSString *)kCGImagePropertyExifDictionary] mutableCopy];
    float brightnessValue = [[exifMetadata objectForKey:(NSString *)kCGImagePropertyExifBrightnessValue] floatValue];
    
    NSLog(@"%f",brightnessValue);
    
    NSLog(@"时间3%d 开启与关闭%d 亮度值%f", self.lightOn, self.device.isTorchActive, brightnessValue);
    
    if (self.device.isTorchActive) {
        if (self.lightOnArray.count <= 20) {
            [self.lightOnArray addObject:@(brightnessValue)];
        }
        
    } else {
        if (self.lightOffArray.count <= 20) {
            [self.lightOffArray addObject:@(brightnessValue)];
        }
        
    }
    
}


- (void)stopTorch {
    dispatch_source_cancel(self.timer);
    [self.session stopRunning];
    
}

@end
