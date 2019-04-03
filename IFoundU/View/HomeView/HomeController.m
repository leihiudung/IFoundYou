//
//  HomeController.m
//  IFoundU
//
//  Created by Tom-Li on 2019/3/26.
//  Copyright © 2019 litong. All rights reserved.
//

#import "HomeController.h"
#import "CheckupController.h"
#import "StatusController.h"
#import "ShareController.h"

@interface HomeController ()
@property (nonatomic, strong) UITabBar *tabBar;

@property (nonatomic, strong) CheckupController *checkupController;
@end

@implementation HomeController

- (void)loadView {
    [super loadView];
    
    StatusController *statusControllre = [[StatusController alloc]init];
    CheckupController *checkController = [[CheckupController alloc]init];
    ShareController *shareController = [[ShareController alloc]init];
    
    UINavigationController *statusNavigationController = [[UINavigationController alloc]initWithRootViewController:statusControllre];
    
    UINavigationController *checkNavigationController = [[UINavigationController alloc]initWithRootViewController:checkController];
    
    UINavigationController *shareNavigationController = [[UINavigationController alloc]initWithRootViewController:shareController];

    self.viewControllers = @[statusNavigationController, checkNavigationController, shareNavigationController];
    [self setSelectedIndex:1];
    
    self.tabBar.tintColor = UIColor.redColor;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}


@end
