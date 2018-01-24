//
//  HGThemeDefault.m
//  HGInitiation
//
//  Created by __无邪_ on 2018/1/23.
//  Copyright © 2018年 __无邪_. All rights reserved.
//

#import "HGThemeDefault.h"

@implementation HGThemeDefault

- (void)setupConfigurationTemplate {
    
    #pragma mark - Global Color
    
    HGConfigurationInstance.tintColor = [UIColor blueColor];
    
    #pragma mark - NavigationBar
    
    HGConfigurationInstance.navBarTintColor = [UIColor whiteColor];
    HGConfigurationInstance.navBarBarTintColor = [UIColor whiteColor];
    HGConfigurationInstance.navBarTitleColor = [UIColor blackColor];
    HGConfigurationInstance.navBarLargeTitleColor = [UIColor blackColor];
    HGConfigurationInstance.navBarBackgroundImage = [UIImage imageWithColor:[UIColor whiteColor]];
    HGConfigurationInstance.navBarShadowImage = [UIImage imageWithColor:[UIColor lightTextColor]];
    
}

- (UIColor *)themeTintColor {
    return [UIColor whiteColor];
}

- (NSString *)themeName {
    return @"Default";
}

@end
