//
//  LoginController.m
//  IFoundU
//
//  Created by Tom-Li on 2019/3/25.
//  Copyright © 2019 litong. All rights reserved.
//

#import "LoginController.h"
#import "HomeController.h"

#import "LoginView.h"


#import <Masonry/Masonry.h>
#import <ReactiveObjC/ReactiveObjC.h>


@interface LoginController ()

@property (nonatomic, strong) LoginView *loginView;

@end

@implementation LoginController

- (void)loadView {
    [super loadView];
   
    @weakify(self);
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"LoginSuccessNotification" object:nil] subscribeNext:^(NSNotification * _Nullable x) {
        HomeController *homeController = [[HomeController alloc]init];
        @strongify(self);
        [self presentViewController:homeController animated:YES completion:nil];
        
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
     [self initViewFrame];
}

- (void)initViewFrame {
    self.loginView = [[LoginView alloc]initWithLoginFrame:UIScreen.mainScreen.bounds];
    [self.view addSubview:self.loginView];
    
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(superviewTap:)]];
}

- (void)superviewTap:(UITapGestureRecognizer *)gesture {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"TapLoginController" object:nil];
    
}



@end
