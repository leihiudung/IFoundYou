//
//  CheckupTableViewCell.m
//  IFoundU
//
//  Created by Tom-Li on 2019/4/2.
//  Copyright © 2019 litong. All rights reserved.
//

#import "CheckupTableViewCell.h"

@interface CheckupTableViewCell()
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIActivityIndicatorView *indicatorView;
@property (nonatomic, strong) UIImageView *resultImageView;

@end

@implementation CheckupTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, (self.frame.size.height - self.frame.size.height * 0.8)/2, self.frame.size.width * 0.2, self.frame.size.height * 0.8)];
        self.indicatorView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [self.indicatorView setFrame:CGRectMake(200, 0, 30, 30)];
        [self.indicatorView setHidden:NO];
        [self.contentView addSubview:self.indicatorView];
    }
    return self;
    
}

@end
