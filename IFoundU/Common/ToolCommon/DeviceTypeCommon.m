//
//  DeviceTypeCommon.m
//  IFoundU
//
//  Created by Tom-Li on 2019/4/3.
//  Copyright © 2019 litong. All rights reserved.
//

#import "DeviceTypeCommon.h"

#import <sys/utsname.h>
#import <sys/sysctl.h>
#include <mach/mach.h>

#define IPHONE_X \
({BOOL isPhoneX = NO;\
if (@available(iOS 11.0, *)) {\
isPhoneX = [[UIApplication sharedApplication] delegate].window.safeAreaInsets.bottom > 0.0;\
}\
(isPhoneX);})

@implementation DeviceTypeCommon

+ (NSString*)deviceModelName
{
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceModel = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    if ([deviceModel isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    if ([deviceModel isEqualToString:@"iPhone3,2"])    return @"iPhone 4";
    if ([deviceModel isEqualToString:@"iPhone3,3"])    return @"iPhone 4";
    if ([deviceModel isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([deviceModel isEqualToString:@"iPhone5,1"])    return @"iPhone 5";
    if ([deviceModel isEqualToString:@"iPhone5,2"])    return @"iPhone 5 (GSM+CDMA)";
    if ([deviceModel isEqualToString:@"iPhone5,3"])    return @"iPhone 5c (GSM)";
    if ([deviceModel isEqualToString:@"iPhone5,4"])    return @"iPhone 5c (GSM+CDMA)";
    if ([deviceModel isEqualToString:@"iPhone6,1"])    return @"iPhone 5s (GSM)";
    if ([deviceModel isEqualToString:@"iPhone6,2"])    return @"iPhone 5s (GSM+CDMA)";
    if ([deviceModel isEqualToString:@"iPhone7,1"])    return @"iPhone 6 Plus";
    if ([deviceModel isEqualToString:@"iPhone7,2"])    return @"iPhone 6";
    if ([deviceModel isEqualToString:@"iPhone8,1"])    return @"iPhone 6s";
    if ([deviceModel isEqualToString:@"iPhone8,2"])    return @"iPhone 6s Plus";
    if ([deviceModel isEqualToString:@"iPhone8,4"])    return @"iPhone SE";
    // 日行两款手机型号均为日本独占，可能使用索尼FeliCa支付方案而不是苹果支付
    if ([deviceModel isEqualToString:@"iPhone9,1"])    return @"iPhone 7";
    if ([deviceModel isEqualToString:@"iPhone9,2"])    return @"iPhone 7 Plus";
    if ([deviceModel isEqualToString:@"iPhone9,3"])    return @"iPhone 7";
    if ([deviceModel isEqualToString:@"iPhone9,4"])    return @"iPhone 7 Plus";
    if ([deviceModel isEqualToString:@"iPhone10,1"])   return @"iPhone 8";
    if ([deviceModel isEqualToString:@"iPhone10,4"])   return @"iPhone 8";
    if ([deviceModel isEqualToString:@"iPhone10,2"])   return @"iPhone 8 Plus";
    if ([deviceModel isEqualToString:@"iPhone10,5"])   return @"iPhone 8 Plus";
    if ([deviceModel isEqualToString:@"iPhone10,3"])   return @"iPhone X";
    if ([deviceModel isEqualToString:@"iPhone10,6"])   return @"iPhone X";
    if ([deviceModel isEqualToString:@"iPod1,1"])      return @"iPod Touch 1G";
    if ([deviceModel isEqualToString:@"iPod2,1"])      return @"iPod Touch 2G";
    if ([deviceModel isEqualToString:@"iPod3,1"])      return @"iPod Touch 3G";
    if ([deviceModel isEqualToString:@"iPod4,1"])      return @"iPod Touch 4G";
    if ([deviceModel isEqualToString:@"iPod5,1"])      return @"iPod Touch (5 Gen)";
    if ([deviceModel isEqualToString:@"iPad1,1"])      return @"iPad";
    if ([deviceModel isEqualToString:@"iPad1,2"])      return @"iPad 3G";
    if ([deviceModel isEqualToString:@"iPad2,1"])      return @"iPad 2 (WiFi)";
    if ([deviceModel isEqualToString:@"iPad2,2"])      return @"iPad 2";
    if ([deviceModel isEqualToString:@"iPad2,3"])      return @"iPad 2 (CDMA)";
    if ([deviceModel isEqualToString:@"iPad2,4"])      return @"iPad 2";
    if ([deviceModel isEqualToString:@"iPad2,5"])      return @"iPad Mini (WiFi)";
    if ([deviceModel isEqualToString:@"iPad2,6"])      return @"iPad Mini";
    if ([deviceModel isEqualToString:@"iPad2,7"])      return @"iPad Mini (GSM+CDMA)";
    if ([deviceModel isEqualToString:@"iPad3,1"])      return @"iPad 3 (WiFi)";
    if ([deviceModel isEqualToString:@"iPad3,2"])      return @"iPad 3 (GSM+CDMA)";
    if ([deviceModel isEqualToString:@"iPad3,3"])      return @"iPad 3";
    if ([deviceModel isEqualToString:@"iPad3,4"])      return @"iPad 4 (WiFi)";
    if ([deviceModel isEqualToString:@"iPad3,5"])      return @"iPad 4";
    if ([deviceModel isEqualToString:@"iPad3,6"])      return @"iPad 4 (GSM+CDMA)";
    if ([deviceModel isEqualToString:@"iPad4,1"])      return @"iPad Air (WiFi)";
    if ([deviceModel isEqualToString:@"iPad4,2"])      return @"iPad Air (Cellular)";
    if ([deviceModel isEqualToString:@"iPad4,4"])      return @"iPad Mini 2 (WiFi)";
    if ([deviceModel isEqualToString:@"iPad4,5"])      return @"iPad Mini 2 (Cellular)";
    if ([deviceModel isEqualToString:@"iPad4,6"])      return @"iPad Mini 2";
    if ([deviceModel isEqualToString:@"iPad4,7"])      return @"iPad Mini 3";
    if ([deviceModel isEqualToString:@"iPad4,8"])      return @"iPad Mini 3";
    if ([deviceModel isEqualToString:@"iPad4,9"])      return @"iPad Mini 3";
    if ([deviceModel isEqualToString:@"iPad5,1"])      return @"iPad Mini 4 (WiFi)";
    if ([deviceModel isEqualToString:@"iPad5,2"])      return @"iPad Mini 4 (LTE)";
    if ([deviceModel isEqualToString:@"iPad5,3"])      return @"iPad Air 2";
    if ([deviceModel isEqualToString:@"iPad5,4"])      return @"iPad Air 2";
    if ([deviceModel isEqualToString:@"iPad6,3"])      return @"iPad Pro 9.7";
    if ([deviceModel isEqualToString:@"iPad6,4"])      return @"iPad Pro 9.7";
    if ([deviceModel isEqualToString:@"iPad6,7"])      return @"iPad Pro 12.9";
    if ([deviceModel isEqualToString:@"iPad6,8"])      return @"iPad Pro 12.9";
    
    if ([deviceModel isEqualToString:@"AppleTV2,1"])      return @"Apple TV 2";
    if ([deviceModel isEqualToString:@"AppleTV3,1"])      return @"Apple TV 3";
    if ([deviceModel isEqualToString:@"AppleTV3,2"])      return @"Apple TV 3";
    if ([deviceModel isEqualToString:@"AppleTV5,3"])      return @"Apple TV 4";
    
    if ([deviceModel isEqualToString:@"i386"])         return @"Simulator";
    if ([deviceModel isEqualToString:@"x86_64"])       return @"Simulator";
    
    return deviceModel;
}

+ (NSUInteger)deviceModelDivideByIphoneX {
    return IPHONE_X ? LessThanX : EqualToX;
}

+ (NSUInteger)divideByiPX {
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceModel = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    if ([deviceModel isEqualToString:@"iPhone3,1"] || [deviceModel isEqualToString:@"iPhone3,2"] || [deviceModel isEqualToString:@"iPhone3,3"] || [deviceModel isEqualToString:@"iPhone4,1"]) {
        return EqualTo4S;
    }
    
    return GreaterThan4s;
}

+ (NSUInteger)deviceModelDivideByType:(PhoneModelType)phoneModelType {
    if (phoneModelType == EqualTo4S) {
        return [self divideByiP4];
    } else {
        return [self divideByiP5];
    }
    //    [UIScreen instancesRespondToSelector:@selector(currentMode)]
}

+ (NSUInteger)divideByiP4 {
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceModel = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    if ([deviceModel isEqualToString:@"iPhone3,1"] || [deviceModel isEqualToString:@"iPhone3,2"] || [deviceModel isEqualToString:@"iPhone3,3"] || [deviceModel isEqualToString:@"iPhone4,1"]) {
        return EqualTo4S;
    }
    
    return GreaterThan4s;
}

+ (NSUInteger)divideByiP5 {
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceModel = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    if ([deviceModel isEqualToString:@"iPhone3,1"] || [deviceModel isEqualToString:@"iPhone3,2"] || [deviceModel isEqualToString:@"iPhone3,3"] || [deviceModel isEqualToString:@"iPhone4,1"] || [deviceModel isEqualToString:@"iPhone5,1"] || [deviceModel isEqualToString:@"iPhone5,2"] || [deviceModel isEqualToString:@"iPhone5,3"] || [deviceModel isEqualToString:@"iPhone5,4"] || [deviceModel isEqualToString:@"iPhone6,1"] || [deviceModel isEqualToString:@"iPhone6,2"] || [deviceModel isEqualToString:@"iPhone8,4"]) {
        return EqualTo5s;
    }
    
    return GreaterThan5s;
}

+ (BOOL)divideByiP6s {
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceModel = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    if ([deviceModel isEqualToString:@"iPhone3,1"] || [deviceModel isEqualToString:@"iPhone3,2"] || [deviceModel isEqualToString:@"iPhone3,3"] || [deviceModel isEqualToString:@"iPhone4,1"] || [deviceModel isEqualToString:@"iPhone5,1"] || [deviceModel isEqualToString:@"iPhone5,2"] || [deviceModel isEqualToString:@"iPhone5,3"] || [deviceModel isEqualToString:@"iPhone5,4"] || [deviceModel isEqualToString:@"iPhone6,1"] || [deviceModel isEqualToString:@"iPhone6,2"] || [deviceModel isEqualToString:@"iPhone7,1"] || [deviceModel isEqualToString:@"iPhone7,2"] || [deviceModel isEqualToString:@"iPhone8,4"] ) {
        return NO;
    }
    
    return YES;
}

+ (NSUInteger)divideByiP7 {
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceModel = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    if ([deviceModel isEqualToString:@"iPhone3,1"] || [deviceModel isEqualToString:@"iPhone3,2"] || [deviceModel isEqualToString:@"iPhone3,3"] || [deviceModel isEqualToString:@"iPhone4,1"] || [deviceModel isEqualToString:@"iPhone5,1"] || [deviceModel isEqualToString:@"iPhone5,2"] || [deviceModel isEqualToString:@"iPhone5,3"] || [deviceModel isEqualToString:@"iPhone5,4"] || [deviceModel isEqualToString:@"iPhone6,1"] || [deviceModel isEqualToString:@"iPhone6,2"] ||[deviceModel isEqualToString:@"iPhone7,1"] || [deviceModel isEqualToString:@"iPhone7,2"] || [deviceModel isEqualToString:@"iPhone8,1"] || [deviceModel isEqualToString:@"iPhone8,2"] || [deviceModel isEqualToString:@"iPhone8,4"]) {
        return LessThan7;
    }
    
    return EqualTo7;
}

+ (CGFloat)fileSystemSize {
    float totalSpace;
    
    NSError *error = nil;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSDictionary *dictionary = [[NSFileManager defaultManager] attributesOfFileSystemForPath:[paths lastObject] error: &error];
    
    if (dictionary) {
        NSNumber *fileSystemSizeInBytes = [dictionary objectForKey: NSFileSystemSize];
        totalSpace = [fileSystemSizeInBytes floatValue]/1024.0f/1024.0f/1024.0f;
        
    } else {
        totalSpace = 0;
    }
    return totalSpace;
}

+ (CGFloat)freeFileSystemSize {
    float freeSpace;
    
    NSError *error = nil;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSDictionary *dictionary = [[NSFileManager defaultManager] attributesOfFileSystemForPath:[paths lastObject] error: &error];
    
    if (dictionary) {
        NSNumber *freeFileSystemSizeInBytes = [dictionary objectForKey:NSFileSystemFreeSize];
        
        freeSpace = [freeFileSystemSizeInBytes floatValue]/1024.0f/1024.0f;
        
    } else {
        freeSpace = 0;
        
    }
    return freeSpace;
}

#pragma mark - 获取CPU类型和核心数
+ (NSString *)getCPUKind {
    
    NSInteger cpuNumber = [self getCPUNum]; //CPU核心数
    NSString *cpuType = [self getCPUType]; //获取CPU类型
    
    NSString *cpuKind = [NSString stringWithFormat:@"CPU核心数：%ld,类型：%@",(long)cpuNumber,cpuType];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"CPUCompleteNotification" object:nil userInfo:nil];
    });
    return cpuKind;
}

//CPU核心数
+ (NSInteger)getCPUNum{
    unsigned int ncpu;
    size_t len = sizeof(ncpu);
    sysctlbyname("hw.ncpu", &ncpu, &len, NULL, 0);
    NSInteger cpuNum = ncpu;
    return cpuNum;
}

//获取CPU类型
+ (NSString *)getCPUType{
    host_basic_info_data_t hostInfo;
    mach_msg_type_number_t infoCount;
    
    infoCount = HOST_BASIC_INFO_COUNT;
    host_info(mach_host_self(), HOST_BASIC_INFO, (host_info_t)&hostInfo, &infoCount);
    
    switch (hostInfo.cpu_type) {
        case CPU_TYPE_ARM:
            return @"CPU_TYPE_ARM";
            break;
            
        case CPU_TYPE_ARM64:
            return @"CPU_TYPE_ARM64";
            break;
            
        case CPU_TYPE_X86:
            return @"CPU_TYPE_X86";
            break;
            
        case CPU_TYPE_X86_64:
            return @"CPU_TYPE_X86_64";
            break;
            
        default:
            return @"";
            break;
    }
}

@end
