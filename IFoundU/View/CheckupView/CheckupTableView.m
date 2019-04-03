//
//  CheckupTableView.m
//  IFoundU
//
//  Created by Tom-Li on 2019/4/2.
//  Copyright © 2019 litong. All rights reserved.
//

#import "CheckupTableView.h"
#import "M13ProgressViewRing.h"
#import "CheckupTableViewCell.h"
#import "CheckupViewMode.h"

#import <Masonry/Masonry.h>
#import <ReactiveObjC/ReactiveObjC.h>

@interface CheckupTableView() <UITableViewDataSource> {
    NSArray *_testItemKeyArray;
}

@property (nonatomic, strong) M13ProgressViewRing *progressViewRing;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UIImageView *progressImageView;

@property (nonatomic, strong) CheckupViewMode *checkupViewMode;
@end

@implementation CheckupTableView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.checkupViewMode = [[CheckupViewMode alloc]initViewMode];
        [self initView];
        [self initRac];
    }
    return self;
}


- (void)initView {
    self.progressViewRing = [[M13ProgressViewRing alloc]initWithFrame:CGRectMake((self.bounds.size.width - self.bounds.size.width * 0.66)/2, 66, self.bounds.size.width * 0.66, self.bounds.size.width * 0.66)];
    [self addSubview:self.progressViewRing];
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.progressViewRing.frame) + 60, self.bounds.size.width, self.bounds.size.height - CGRectGetMaxY(self.progressViewRing.frame) - 60) style:UITableViewStylePlain];
    
    [self.tableView setDataSource:self];
    [self addSubview:self.tableView];
    [self.tableView registerClass:[CheckupTableViewCell class] forCellReuseIdentifier:@"CellId"];
    
    self.progressImageView = [[UIImageView alloc]initWithFrame:CGRectMake((self.progressViewRing.frame.size.width - self.progressViewRing.frame.size.width * 0.2)/2, self.progressViewRing.frame.size.height - self.progressViewRing.frame.size.height * 0.3, self.progressViewRing.frame.size.width * 0.2, self.progressViewRing.frame.size.height * 0.2)];
    self.progressImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.progressImageView.image = [UIImage imageNamed:@"onetap_start_btn"];
    self.progressImageView.image.accessibilityIdentifier = @"onetap_start_btn";
    self.progressImageView.userInteractionEnabled = YES;
    
    [_progressViewRing addSubview:self.progressImageView];
    [self.progressImageView setUserInteractionEnabled:YES];
    [self.checkupViewMode.testItemDic allKeys];
    _testItemKeyArray = [self.checkupViewMode.testItemDic allKeys];
}

- (void)initRac {
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]init];

    [self.progressImageView addGestureRecognizer:tapGesture];
    @weakify(self)
    [[tapGesture rac_gestureSignal] subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {
        @strongify(self);
        [self.checkupViewMode excuteing];
        
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.checkupViewMode.testItemDic.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellId"];
    cell.textLabel.text = _testItemKeyArray[indexPath.row];
    return cell;
    
}

- (void)startChecking {
    NSLog(@"done");
}

@end
