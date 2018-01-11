//
//  HGBASEViewController.m
//  HGInitiation
//
//  Created by __无邪_ on 2017/12/25.
//  Copyright © 2017年 __无邪_. All rights reserved.
//

#import "HGBASEViewController.h"

@interface HGBASEViewController ()

@end

@implementation HGBASEViewController




#pragma mark - HUD
- (void)showTip:(NSString *)tip{
    [self showTip:tip dealy:1.2];
}
- (void)showTip:(NSString *)tip dealy:(CGFloat)dealy{
    [HGShowTip showTipInView:self.view tip:tip dealy:dealy];
}
- (void)showProgressTip:(NSString *)tip{
    [self showProgressTip:tip dealy:60];
}
- (void)showProgressTip:(NSString *)tip dealy:(CGFloat)dealy{
    [HGShowTip showProgressInView:self.view tip:tip afterDelay:dealy];
}
- (void)hideTip{
    [HGShowTip hideHud];
}

@end
