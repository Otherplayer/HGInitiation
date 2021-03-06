//
//  HGHorizontalSelectCCell.m
//  HGInitiation
//
//  Created by __无邪_ on 2018/6/19.
//  Copyright © 2018年 __无邪_. All rights reserved.
//

#import "HGHorizontalSelectCCell.h"

CGFloat const kHGHorizontalSCCellHeight = 110.f;
CGFloat const kHGHorizontalSCCellWidth = 60.f;

@implementation HGHorizontalSelectCCell
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.btnIcon = ({
            _btnIcon = [UIButton.alloc initWithFrame:CGRectMake(0, 0, kHGHorizontalSCCellWidth, kHGHorizontalSCCellWidth)];
            _btnIcon.imageView.contentMode = UIViewContentModeCenter;
            [_btnIcon setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
            [_btnIcon setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithWhite:0 alpha:0.5]] forState:UIControlStateHighlighted];
            [_btnIcon setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithWhite:0 alpha:0.5]] forState:UIControlStateSelected];
            _btnIcon.layer.cornerRadius = 16;
            _btnIcon.layer.masksToBounds = YES;
            [_btnIcon addTarget:self action:@selector(didTapAction:) forControlEvents:UIControlEventTouchUpInside];
            _btnIcon;
        });
        
        self.labTitle = ({
            _labTitle = [UILabel.alloc initWithFrame:CGRectMake(0, kHGHorizontalSCCellWidth, kHGHorizontalSCCellWidth, kHGHorizontalSCCellHeight - kHGHorizontalSCCellWidth - 10)];
            _labTitle.font = [UIFont systemFontOfSize:13];
            _labTitle.textColor = [UIColor blackColor];
            _labTitle.textAlignment = NSTextAlignmentCenter;
            _labTitle.adjustsFontSizeToFitWidth = YES;
            _labTitle;
        });
        
        [self.contentView addSubview:self.btnIcon];
        [self.contentView addSubview:self.labTitle];
    }
    return self;
}


- (void)didTapAction:(UIButton *)sender {
    if (self.didTapHandler) {
        self.didTapHandler();
    }
}
@end
