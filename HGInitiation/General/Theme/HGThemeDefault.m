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
    
    HGConfigurationInstance.navBarTintColor = [UIColor redColor];
    HGConfigurationInstance.navBarBarTintColor = [UIColor redColor];
    
    HGConfigurationInstance.navBarTitleColor = [UIColor blackColor];
    HGConfigurationInstance.navBarLargeTitleColor = [UIColor blackColor];
    
    HGConfigurationInstance.navBarBackgroundImage = [UIImage imageWithColor:[UIColor whiteColor]];
    HGConfigurationInstance.navBarShadowImage = [UIImage imageWithColor:UIColorHex(0xf7f7f7)];
    
}

- (UIColor *)themeTintColor {
    return [UIColor whiteColor];
}

- (NSString *)themeName {
    return @"Default";
}

@end
