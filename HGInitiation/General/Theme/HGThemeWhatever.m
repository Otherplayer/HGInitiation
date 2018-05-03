//
//  HGThemeBlack.m
//  HGInitiation
//
//  Created by __无邪_ on 2018/1/23.
//  Copyright © 2018年 __无邪_. All rights reserved.
//

#import "HGThemeWhatever.h"

@implementation HGThemeWhatever
- (void)setupConfigurationTemplate {
    
    
    #pragma mark - Global Color
    
    HGConfigurationInstance.tintColor = [UIColor randomColor];
    
    #pragma mark - NavigationBar
    
    HGConfigurationInstance.navBarTintColor = [UIColor randomColor];
    HGConfigurationInstance.navBarBarTintColor = [UIColor randomColor];
    HGConfigurationInstance.navBarTitleColor = [UIColor randomColor];
    HGConfigurationInstance.navBarLargeTitleColor = [UIColor randomColor];
    HGConfigurationInstance.navBarBackgroundImage = [UIImage imageWithColor:[UIColor randomColor]];
    HGConfigurationInstance.navBarShadowImage = [UIImage imageWithColor:[UIColor randomColor]];
    
}

- (UIColor *)tintColor {
    return [UIColor randomColor];
}

- (NSString *)themeName {
    return @"Whatever";
}
@end
