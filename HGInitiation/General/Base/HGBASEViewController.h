//
//  HGBASEViewController.h
//  HGInitiation
//
//  Created by __无邪_ on 2017/12/25.
//  Copyright © 2017年 __无邪_. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HGBASEViewController : UIViewController


#pragma mark - HUD

- (void)showTip:(NSString *)tip;
- (void)showTip:(NSString *)tip dealy:(CGFloat)dealy;
- (void)showProgressTip:(NSString *)tip;
- (void)showProgressTip:(NSString *)tip dealy:(CGFloat)dealy;
- (void)hideTip;

@end
