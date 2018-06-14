//
//  GGProgressHUD.h
//  GGProgressHUD
//
//  Created by __无邪_ on 15/5/1.
//  Copyright (c) 2015年 __无邪_. All rights reserved.
//

#import "MBProgressHUD.h"

#define HGShowTip [HGHelperHUD sharedInstance]

typedef NS_ENUM(NSUInteger, HGHUDMaskType) {
    HGHUDMaskTypeNone = 1,  // allow user interactions while HUD is displayed
    HGHUDMaskTypeClear = 2, // don't allow user interactions
};

typedef NS_ENUM(NSInteger, HGHUDPosition) {
    HGHUDPosition_top,     // show Top
    HGHUDPosition_center,
    HGHUDPosition_bottom
};

@interface HGHelperHUD : MBProgressHUD
@property (nonatomic, unsafe_unretained) HGHUDMaskType maskType;

+ (instancetype)sharedInstance;
+ (instancetype)showTip:(NSString *)text afterDelay:(NSTimeInterval)delay; //自定义view
- (void)hideImmediately;

// 在当前页面显示提示
- (void)showTipInView:(UIView *)view tip:(NSString *)text dealy:(NSTimeInterval)dealy;
- (void)showProgressInView:(UIView *)view tip:(NSString *)text afterDelay:(NSTimeInterval)delay;
- (void)hideHud;

- (void)showTipDealy:(NSTimeInterval)dealy format:(NSString *)format arg:(NSString*)arg ,...;
- (void)showTipDealy:(NSTimeInterval)dealy position:(HGHUDPosition)position format:(NSString *)format arg:(NSString*)arg ,...;


- (void)showTipTextOnly:(NSString *)text dealy:(NSTimeInterval)dealy;
- (void)showProgressWithText:(NSString *)text dealy:(NSTimeInterval)dealy;
- (void)showHProgressWithText:(NSString *)text dealy:(NSTimeInterval)dealy;
- (void)showProgress:(NSString*)progress;
- (void)showTipTextOnly:(NSString *)text dealy:(NSTimeInterval)dealy position:(HGHUDPosition)position;


@end
