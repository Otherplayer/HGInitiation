//
//  HGProgressHUDManager.h
//  HGInitiation
//
//  Created by __无邪_ on 2018/6/27.
//  Copyright © 2018年 __无邪_. All rights reserved.
//

#import <Foundation/Foundation.h>

#define HGShowTip [HGProgressHUDManager shared]

typedef NS_ENUM(NSUInteger, HGProgressHUDTheme) {
    HGProgressHUDThemeLight,
    HGProgressHUDThemeDark
};

NS_ASSUME_NONNULL_BEGIN

@interface HGProgressHUDManager : NSObject

+ (instancetype)shared;

- (void)showLoadingIn:(UIView *)view msg:(nullable NSString *)msg hideAfterDealy:(CGFloat)dealy;
- (void)showLoadingIn:(UIView *)view msg:(nullable NSString *)msg theme:(HGProgressHUDTheme)theme hideAfterDealy:(CGFloat)dealy;
- (void)showMSGIn:(UIView *)view msg:(nullable NSString *)msg hideAfterDealy:(CGFloat)dealy;

- (void)hideProgressHUD;

@end

NS_ASSUME_NONNULL_END
