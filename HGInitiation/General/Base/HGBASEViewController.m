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

#pragma mark - life circle

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        [self didInitialized];
    }
    return self;
}
- (instancetype)initWithCoder:(NSCoder *)coder{
    self = [super initWithCoder:coder];
    if (self) {
        [self didInitialized];
    }
    return self;
}

- (void)didInitialized {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleThemeChangedNotification:) name:HGThemeChangedNotification object:nil];
}

#pragma mark - notification
- (void)handleThemeChangedNotification:(NSNotification *)notification {
    NSObject<HGThemeProtocol> *themeBeforeChanged = notification.userInfo[HGThemeBeforeChangedName];
    NSObject<HGThemeProtocol> *themeAfterChanged = notification.userInfo[HGThemeAfterChangedName];
    [self themeBeforeChanged:themeBeforeChanged afterChanged:themeAfterChanged];
}

#pragma mark - HGChangingThemeDelegate

- (void)themeBeforeChanged:(NSObject<HGThemeProtocol> *)themeBeforeChanged afterChanged:(NSObject<HGThemeProtocol> *)themeAfterChanged {
    
}


#pragma mark - HUD
- (void)showTip:(NSString *)tip{
    [self showTip:tip dealy:1.2];
}
- (void)showTip:(NSString *)tip dealy:(CGFloat)dealy{
    [HGShowTip showHUD:self.view title:tip hideAfterDelay:dealy];
}
- (void)showProgressTip:(NSString *)tip{
    [HGShowTip showProgressHUD:self.view title:tip hideAfterDelay:60];
}
- (void)showProgressTip:(NSString *)tip dealy:(CGFloat)dealy{
    [HGShowTip showProgressHUD:self.view title:tip hideAfterDelay:dealy];
}
- (void)hideTip{
    [HGShowTip hideProgressHUD];
}

@end
