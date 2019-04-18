//
//  MerchantController.m
//  IFoundU
//
//  Created by Tom-Li on 2019/4/15.
//  Copyright © 2019 litong. All rights reserved.
//

#import "MerchantController.h"
#import "MerchantView.h"

#import "SQLiteManager.h"

#import "OperationFlagCommon.h"

@interface MerchantController ()

@end

@implementation MerchantController

- (void)loadView {
    [super loadView];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    [self.view addSubview:[[MerchantView alloc]initWithFrame:self.view.bounds]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveMerchantNotification:) name:@"SaveMerchantNotification" object:nil];
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (void)saveMerchantNotification:(NSNotification *)notification {
    NSDictionary *dic = notification.userInfo;
    SQLiteManager *sqliteManager = [SQLiteManager share];
    [sqliteManager insertData:dic];
    
    
}

- (void)operationSetting {
    
}


@end
