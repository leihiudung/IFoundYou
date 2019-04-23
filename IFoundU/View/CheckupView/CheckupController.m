//
//  CheckupController.m
//  IFoundU
//
//  Created by Tom-Li on 2019/4/2.
//  Copyright © 2019 litong. All rights reserved.
//

#import "CheckupController.h"

#import "CheckupTableView.h"

@interface CheckupController ()
@property (nonatomic, strong) CheckupTableView *checkupTableView;
@end

@implementation CheckupController

- (void)loadView {
    [super loadView];
    
    self.checkupTableView = [[CheckupTableView alloc]initWithFrame:UIScreen.mainScreen.bounds];
    [self.view addSubview:self.checkupTableView];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
//    self.navigationController.title =  NSLocalizedStringFromTable(@"Check", @"IFoundU", @"");
    [self.navigationController.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor redColor]} forState:UIControlStateNormal];
    
    [self.navigationController.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor blackColor]} forState:UIControlStateSelected];
    
}

@end
