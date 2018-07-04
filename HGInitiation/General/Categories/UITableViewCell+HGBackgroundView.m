//
//  UITableViewCell+HGBackgroundView.m
//  HGInitiation
//
//  Created by __无邪_ on 2018/7/2.
//  Copyright © 2018年 __无邪_. All rights reserved.
//

#import "UITableViewCell+HGBackgroundView.h"

@implementation UITableViewCell (HGBackgroundView)

- (void)customSelectedBackgroundView {
    self.selectedBackgroundView = [UIView new];
    self.selectedBackgroundView.backgroundColor = [[UIColor systemBlue] colorWithAlphaComponent:0.1f];
}

@end
