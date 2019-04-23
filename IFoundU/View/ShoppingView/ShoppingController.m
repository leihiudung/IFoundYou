//
//  ShoppingController.m
//  IFoundU
//
//  Created by Tom-Li on 2019/4/15.
//  Copyright © 2019 litong. All rights reserved.
//

#import "ShoppingController.h"
#import "Setting/SettingController.h"
#import "ShoppingView.h"

#import "SQLiteManager.h"
#import "DistanceCommon.h"

//#import "MerchantController.h"
#import <CoreLocation/CoreLocation.h>
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>

@interface ShoppingController () <CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;

@end

@implementation ShoppingController

- (void)loadView {
    [super loadView];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    ShoppingView *shoppingView = [[ShoppingView alloc]initWithFrame:self.view.frame];
    [self.view addSubview:shoppingView];
    
    self.locationManager = [[CLLocationManager alloc]init];
    self.locationManager.delegate = self;
    self.locationManager.distanceFilter = 200;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(merchantNofitication:) name:@"MerchantNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(settingNofitication:) name:@"SettingNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(operationNofitication:) name:@"OperationNotification" object:nil];
    
}

- (void)merchantNofitication:(NSNotification *)notification {
    MerchantController *merchantController = [[MerchantController alloc]init];
    [self.navigationController pushViewController:merchantController animated:YES];
    
}

- (void)settingNofitication:(NSNotification *)notification {
//    Class destination = (Class)([notification userInfo][@"class"]);
    SettingController *settingController = [[SettingController alloc]init];
    [self.navigationController pushViewController:settingController animated:YES];
    
}

- (void)operationNofitication:(NSNotification *)notification {
    
    if ([notification.userInfo[@"isOperating"] integerValue]) {
        [self.locationManager startUpdatingLocation];
    } else {
        [self.locationManager stopUpdatingLocation];
    }
    
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    
    CLLocation *location = locations.firstObject;
    NSLog(@"转换前 %lf, %f", location.coordinate.latitude, location.coordinate.longitude);
    CLLocationCoordinate2D oriCoord = location.coordinate;
    CLLocationCoordinate2D gcj02Coord = CLLocationCoordinate2DMake(22.7123022305, 113.7896919250);
    CLLocationCoordinate2D bd09Coord = BMKCoordTrans(oriCoord, BMK_COORDTYPE_COMMON, BMK_COORDTYPE_BD09LL);
    NSLog(@"转换后 %f, %f", bd09Coord.latitude, bd09Coord.longitude);
    [self calculateMerchantDistance:bd09Coord];
    
}

- (void)calculateMerchantDistance:(CLLocationCoordinate2D)coordinate {
    SQLiteManager *sqliteManager = [SQLiteManager share];
    [sqliteManager getData];
    
    NSDictionary *resultDic = [DistanceCommon calculateRangeOfRadius:0.5 centerLat:coordinate.latitude centerLong:coordinate.longitude];
    
    NSArray *resultArray = [[SQLiteManager share] getDataWidhCondition:resultDic];
}

@end
