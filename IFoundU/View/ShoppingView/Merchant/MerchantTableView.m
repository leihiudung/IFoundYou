//
//  MerchantTableView.m
//  IFoundU
//
//  Created by Tom-Li on 2019/4/16.
//  Copyright © 2019 litong. All rights reserved.
//

#import "MerchantTableView.h"
@interface MerchantTableView() <UITableViewDelegate>
@property (nonatomic, strong) UIView *detailView;
@property (nonatomic, strong) UIButton *closeBtn;
@end

@implementation MerchantTableView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initView];
    }
    return self;
}

- (void)initView {

}


@end
