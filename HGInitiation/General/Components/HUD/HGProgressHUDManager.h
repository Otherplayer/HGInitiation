//
//  HGProgressHUDManager.h
//  HGInitiation
//
//  Created by __无邪_ on 2018/6/27.
//  Copyright © 2018年 __无邪_. All rights reserved.
//

#import <Foundation/Foundation.h>

#define HGShowTip [HGProgressHUDManager shared]

NS_ASSUME_NONNULL_BEGIN

@interface HGProgressHUDManager : NSObject

+ (instancetype)shared;

- (void)showProgressHUD:(UIView *)view title:(nullable NSString *)title hideAfterDelay:(CGFloat)dealy;
- (void)showHUD:(UIView *)view title:(nonnull NSString *)title hideAfterDelay:(CGFloat)dealy;

- (void)hideProgressHUD;

@end

NS_ASSUME_NONNULL_END
