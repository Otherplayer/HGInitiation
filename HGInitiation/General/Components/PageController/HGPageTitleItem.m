//
//  HGPageTitleItem.m
//  HGInitiation
//
//  Created by __无邪_ on 2018/6/4.
//  Copyright © 2018年 __无邪_. All rights reserved.
//

#import "HGPageTitleItem.h"

@interface HGPageTitleItem ()

@end

@implementation HGPageTitleItem

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        CGFloat margin = 10;
        self.labTitle = ({
            _labTitle = [UIButton.alloc initWithFrame:CGRectMake(margin, 0, CGRectGetWidth(frame) - margin * 2, CGRectGetHeight(frame))];
            [_labTitle setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
            [_labTitle setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
            _labTitle;
        });
        [self.contentView addSubview:self.labTitle];
    }
    return self;
}


@end
