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
    
#pragma mark - NavigationBar
    
    HGConfigurationInstance.navBarTintColor = [UIColor randomColor];
    HGConfigurationInstance.navBarBarTintColor = [UIColor randomColor];
    HGConfigurationInstance.navBarTitleColor = [UIColor randomColor];
    
}

- (UIColor *)themeTintColor {
    return HGConfigurationInstance.navBarTintColor;
}

- (NSString *)themeName {
    return @"Whatever";
}
@end
