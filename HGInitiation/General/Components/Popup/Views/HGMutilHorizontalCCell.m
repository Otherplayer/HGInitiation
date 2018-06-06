//
//  HGMutilHorizontalCCell.m
//  HGInitiation
//
//  Created by __无邪_ on 2018/6/6.
//  Copyright © 2018年 __无邪_. All rights reserved.
//

#import "HGMutilHorizontalCCell.h"

@implementation HGMutilHorizontalCCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.imageView = ({
            _imageView = [UIImageView.alloc initWithFrame:CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame) * 2/ 3.f)];
            _imageView.contentMode = UIViewContentModeCenter;
            _imageView;
        });
        
        self.labTitle = ({
            _labTitle = [UILabel.alloc initWithFrame:CGRectMake(0, CGRectGetHeight(frame) * 2 / 3.f, CGRectGetWidth(frame), CGRectGetHeight(frame) / 3.f)];
            _labTitle.font = [UIFont systemFontOfSize:18];
            _labTitle.textColor = [UIColor blackColor];
            _labTitle.textAlignment = NSTextAlignmentCenter;
            _labTitle;
        });
        
        [self.contentView addSubview:self.imageView];
        [self.contentView addSubview:self.labTitle];
    }
    return self;
}

@end
