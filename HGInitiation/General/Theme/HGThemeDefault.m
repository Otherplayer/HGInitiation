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
    
    HGConfigurationInstance.tintColor = [UIColor colorWithRGB:0x409EFF];
    
    
    #pragma mark - NavigationBar

    HGConfigurationInstance.navBarTitleColor = [UIColor blackColor];
    HGConfigurationInstance.navBarTitleFont = [UIFont systemFontOfSize:18 weight:UIFontWeightMedium];
    
    HGConfigurationInstance.navBarTintColor = [UIColor colorWithRGB:0x409EFF];
    HGConfigurationInstance.navBarBarTintColor = [UIColor whiteColor];
    HGConfigurationInstance.navBarBackgroundImage = [UIImage imageWithColor:[UIColor whiteColor]];
    HGConfigurationInstance.navBarShadowImage = [UIImage imageWithColor:[UIColor groupTableViewBackgroundColor]];
    
    #pragma mark - TabBar
    
    HGConfigurationInstance.tabBarTintColor = [self tintColor];
    
    
}

- (UIColor *)tintColor {
    return [UIColor colorWithRGB:0x409EFF];
}

- (NSString *)themeName {
    return @"Default";
}

@end
