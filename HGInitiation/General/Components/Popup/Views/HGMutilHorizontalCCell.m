//
//  HGMutilHorizontalCCell.m
//  HGInitiation
//
//  Created by __无邪_ on 2018/6/6.
//  Copyright © 2018年 __无邪_. All rights reserved.
//

#import "HGMutilHorizontalCCell.h"

CGFloat const kHGMHCellMargin  = 5.f;

@implementation HGMutilHorizontalCCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.imageView = ({
            _imageView = [UIImageView.alloc initWithFrame:CGRectMake(kHGMHCellMargin, kHGMHCellMargin, CGRectGetWidth(frame) - kHGMHCellMargin * 2, CGRectGetHeight(frame) - 20 - kHGMHCellMargin * 2)];
            _imageView.contentMode = UIViewContentModeCenter;
            _imageView;
        });
        
        self.labTitle = ({
            _labTitle = [UILabel.alloc initWithFrame:CGRectMake(kHGMHCellMargin, CGRectGetHeight(frame) - 20 - kHGMHCellMargin, CGRectGetWidth(frame) - kHGMHCellMargin * 2, 20)];
            _labTitle.font = [UIFont systemFontOfSize:15];
            _labTitle.textColor = [UIColor blackColor];
            _labTitle.textAlignment = NSTextAlignmentCenter;
            _labTitle;
        });
        
        UIView *bgView = ({
            bgView = [UIView.alloc initWithFrame:CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame))];
            bgView.backgroundColor = [UIColor whiteColor];
            bgView.layer.cornerRadius = 10;
            bgView.layer.masksToBounds = YES;
            bgView;
        });
        
        UIView *sbgView = ({
            sbgView = [UIView.alloc initWithFrame:CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame))];
            sbgView.backgroundColor = [UIColor groupTableViewBackgroundColor];
            sbgView.layer.cornerRadius = 10;
            sbgView.layer.masksToBounds = YES;
            sbgView;
        });
        
        UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
        UIVisualEffectView *effectview = [[UIVisualEffectView alloc] initWithEffect:blur];
        effectview.frame = bgView.bounds;
        [sbgView addSubview:effectview];
        
        self.backgroundView = bgView;
        self.selectedBackgroundView = sbgView;
        
        [self.contentView addSubview:self.imageView];
        [self.contentView addSubview:self.labTitle];
    }
    return self;
}

@end
