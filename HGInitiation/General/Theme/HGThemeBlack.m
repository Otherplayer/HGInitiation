//
//  HGThemeBlack.m
//  HGInitiation
//
//  Created by __无邪_ on 2018/1/23.
//  Copyright © 2018年 __无邪_. All rights reserved.
//

#import "HGThemeBlack.h"

@implementation HGThemeBlack
- (void)setupConfigurationTemplate {
    
#pragma mark - NavigationBar
    
    HGConfigurationInstance.navBarTintColor = [UIColor whiteColor];
    HGConfigurationInstance.navBarBarTintColor = [UIColor blackColor];
    HGConfigurationInstance.navBarTitleColor = [UIColor whiteColor];
    
}

- (UIColor *)themeTintColor {
    return [UIColor redColor];
}

- (NSString *)themeName {
    return @"Black";
}
@end
