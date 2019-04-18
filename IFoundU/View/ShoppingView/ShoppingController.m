//
//  ShoppingController.m
//  IFoundU
//
//  Created by Tom-Li on 2019/4/15.
//  Copyright © 2019 litong. All rights reserved.
//

#import "ShoppingController.h"
#import "ShoppingView.h"

//#import "MerchantController.h"



@interface ShoppingController ()

@end

@implementation ShoppingController

- (void)loadView {
    [super loadView];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    ShoppingView *shoppingView = [[ShoppingView alloc]initWithFrame:self.view.frame];
    [self.view addSubview:shoppingView];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(merchantNofitication:) name:@"MerchantNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(merchantNofitication:) name:@"SettingNotification" object:nil];
}

- (void)merchantNofitication:(NSNotification *)notification {
    MerchantController *merchantController = [[MerchantController alloc]init];
    [self.navigationController pushViewController:merchantController animated:YES];
    
}

- (void)settingNofitication:(NSNotification *)notification {
    Class destination = (Class)([notification userInfo][@"class"]);
    SettingController *settingController = [[SettingController alloc]init];
    [self.navigationController pushViewController:settingController animated:YES];
    
}

@end
