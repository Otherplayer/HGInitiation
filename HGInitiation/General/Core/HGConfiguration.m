//
//  HGConfiguration.m
//  HGInitiation
//
//  Created by __无邪_ on 2018/1/23.
//  Copyright © 2018年 __无邪_. All rights reserved.
//

#import "HGConfiguration.h"

@implementation HGConfiguration

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static HGConfiguration *instance = nil;
    dispatch_once(&onceToken,^{
        instance = [HGConfiguration.alloc init];
    });
    return instance;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        [self initDefaultConfiguration];
    }
    return self;
}


#pragma mark Init Default Config

- (void)initDefaultConfiguration {
    
    #pragma mark - Global Color
    
    self.tintColor = UIColorMake(255, 0, 0);
    self.linkColor = UIColorMake(56, 116, 171);
    self.disabledColor = UIColorMake(0xcc, 0xcc, 0xcc);
    self.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.maskDarkColor = UIColorMakeWithRGBA(0, 0, 0, .35f);
    self.maskLightColor = UIColorMakeWithRGBA(255, 255, 255, .5f);
    self.separatorColor = UIColorMake(222, 224, 226);
    self.separatorDashedColor = UIColorMake(17, 17, 17);
    self.placeholderColor = UIColorMake(196, 200, 208);
    
    
    #pragma mark - NavigationBar
    
    self.navBarBarTintColor = nil;
    self.navBarTintColor = nil;
    self.navBarTitleColor = nil;
    self.navBarTitleFont = nil;
    self.navBarLargeTitleColor = nil;
    self.navBarLargeTitleFont = nil;
    
    
}

#pragma mark - GlobalColor

- (void)setTintColor:(UIColor *)tintColor {
    _tintColor = tintColor;
    if (tintColor) {
        [[UIApplication sharedApplication] keyWindow].tintColor = _tintColor;
    }
}

#pragma mark - NavigationBar

- (void)setNavBarTintColor:(UIColor *)navBarTintColor {
    _navBarTintColor = navBarTintColor;
    if (navBarTintColor) {
        [UIViewController visibleViewController].navigationController.navigationBar.tintColor = _navBarTintColor;
    }
}

- (void)setNavBarBarTintColor:(UIColor *)navBarBarTintColor {
    _navBarBarTintColor = navBarBarTintColor;
    if (navBarBarTintColor) {
        [UINavigationBar appearance].barTintColor = _navBarBarTintColor;
        [UIViewController visibleViewController].navigationController.navigationBar.barTintColor = _navBarBarTintColor;
    }
}

- (void)setNavBarShadowImage:(UIImage *)navBarShadowImage {
    _navBarShadowImage = navBarShadowImage;
    if (navBarShadowImage) {
        [UINavigationBar appearance].shadowImage = _navBarShadowImage;
        [UIViewController visibleViewController].navigationController.navigationBar.shadowImage = _navBarShadowImage;
    }
}

- (void)setNavBarBackgroundImage:(UIImage *)navBarBackgroundImage {
    _navBarBackgroundImage = navBarBackgroundImage;
    if (navBarBackgroundImage) {
        [[UINavigationBar appearance] setBackgroundImage:_navBarBackgroundImage forBarMetrics:UIBarMetricsDefault];
        [[UIViewController visibleViewController].navigationController.navigationBar setBackgroundImage:_navBarBackgroundImage forBarMetrics:UIBarMetricsDefault];
    }
}

- (void)setNavBarTitleFont:(UIFont *)navBarTitleFont {
    _navBarTitleFont = navBarTitleFont;
    [self updateNavigationBarTitleAttributesIfNeeded];
}

- (void)setNavBarTitleColor:(UIColor *)navBarTitleColor {
    _navBarTitleColor = navBarTitleColor;
    [self updateNavigationBarTitleAttributesIfNeeded];
}

- (void)updateNavigationBarTitleAttributesIfNeeded {
    if (self.navBarTitleFont || self.navBarTitleColor) {
        NSMutableDictionary<NSString *, id> *titleTextAttributes = [[NSMutableDictionary alloc] init];
        if (self.navBarTitleFont) {
            [titleTextAttributes setValue:self.navBarTitleFont forKey:NSFontAttributeName];
        }
        if (self.navBarTitleColor) {
            [titleTextAttributes setValue:self.navBarTitleColor forKey:NSForegroundColorAttributeName];
        }
        [UINavigationBar appearance].titleTextAttributes = titleTextAttributes;
        [UIViewController visibleViewController].navigationController.navigationBar.titleTextAttributes = titleTextAttributes;
    }
}

- (void)setNavBarLargeTitleFont:(UIFont *)navBarLargeTitleFont {
    _navBarLargeTitleFont = navBarLargeTitleFont;
    [self updateNavigationBarLargeTitleTextAttributesIfNeeded];
}

- (void)setNavBarLargeTitleColor:(UIColor *)navBarLargeTitleColor {
    _navBarLargeTitleColor = navBarLargeTitleColor;
    [self updateNavigationBarLargeTitleTextAttributesIfNeeded];
}

- (void)updateNavigationBarLargeTitleTextAttributesIfNeeded {
    if (@available(iOS 11, *)) {
        if (self.navBarLargeTitleFont || self.navBarLargeTitleColor) {
            NSMutableDictionary<NSString *, id> *largeTitleTextAttributes = [[NSMutableDictionary alloc] init];
            if (self.navBarLargeTitleFont) {
                largeTitleTextAttributes[NSFontAttributeName] = self.navBarLargeTitleFont;
            }
            if (self.navBarLargeTitleColor) {
                largeTitleTextAttributes[NSForegroundColorAttributeName] = self.navBarLargeTitleColor;
            }
            [UINavigationBar appearance].largeTitleTextAttributes = largeTitleTextAttributes;
            [UIViewController visibleViewController].navigationController.navigationBar.largeTitleTextAttributes = largeTitleTextAttributes;
        }
    }
}

#pragma mark - TabBar

- (void)setTabBarTintColor:(UIColor *)tabBarTintColor {
    _tabBarTintColor = tabBarTintColor;
    if (tabBarTintColor) {
        [UIViewController visibleViewController].tabBarController.tabBar.tintColor = _tabBarTintColor;
    }
}

- (void)setTabBarBarTintColor:(UIColor *)tabBarBarTintColor {
    _tabBarBarTintColor = tabBarBarTintColor;
    if (tabBarBarTintColor) {
        [UITabBar appearance].barTintColor = _tabBarBarTintColor;
        [UIViewController visibleViewController].tabBarController.tabBar.barTintColor = _tabBarBarTintColor;
    }
}

- (void)setTabBarBackgroundImage:(UIImage *)tabBarBackgroundImage {
    _tabBarBackgroundImage = tabBarBackgroundImage;
    if (tabBarBackgroundImage) {
        [UITabBar appearance].backgroundImage = _tabBarBackgroundImage;
        [UIViewController visibleViewController].tabBarController.tabBar.backgroundImage = _tabBarBackgroundImage;
    }
}

- (void)setTabBarShadowImageColor:(UIColor *)tabBarShadowImageColor {
    _tabBarShadowImageColor = tabBarShadowImageColor;
    if (_tabBarShadowImageColor) {
        UIImage *shadowImage = [UIImage imageWithColor:tabBarShadowImageColor];
        [[UITabBar appearance] setShadowImage:shadowImage];
        [UIViewController visibleViewController].tabBarController.tabBar.shadowImage = shadowImage;
    }
}

- (void)setTabBarItemTitleColor:(UIColor *)tabBarItemTitleColor {
    _tabBarItemTitleColor = tabBarItemTitleColor;
    if (_tabBarItemTitleColor) {
        NSMutableDictionary<NSString *, id> *textAttributes = [[NSMutableDictionary alloc] initWithDictionary:[[UITabBarItem appearance] titleTextAttributesForState:UIControlStateNormal]];
        textAttributes[NSForegroundColorAttributeName] = _tabBarItemTitleColor;
        [[UITabBarItem appearance] setTitleTextAttributes:textAttributes forState:UIControlStateNormal];
        [[UIViewController visibleViewController].tabBarController.tabBar.items enumerateObjectsUsingBlock:^(UITabBarItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj setTitleTextAttributes:textAttributes forState:UIControlStateNormal];
        }];
    }
}

- (void)setTabBarItemTitleFont:(UIFont *)tabBarItemTitleFont {
    _tabBarItemTitleFont = tabBarItemTitleFont;
    if (_tabBarItemTitleFont) {
        NSMutableDictionary<NSString *, id> *textAttributes = [[NSMutableDictionary alloc] initWithDictionary:[[UITabBarItem appearance] titleTextAttributesForState:UIControlStateNormal]];
        textAttributes[NSFontAttributeName] = _tabBarItemTitleFont;
        [[UITabBarItem appearance] setTitleTextAttributes:textAttributes forState:UIControlStateNormal];
        [[UIViewController visibleViewController].tabBarController.tabBar.items enumerateObjectsUsingBlock:^(UITabBarItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj setTitleTextAttributes:textAttributes forState:UIControlStateNormal];
        }];
    }
}

- (void)setTabBarItemTitleColorSelected:(UIColor *)tabBarItemTitleColorSelected {
    _tabBarItemTitleColorSelected = tabBarItemTitleColorSelected;
    if (_tabBarItemTitleColorSelected) {
        NSMutableDictionary<NSString *, id> *textAttributes = [[NSMutableDictionary alloc] initWithDictionary:[[UITabBarItem appearance] titleTextAttributesForState:UIControlStateSelected]];
        textAttributes[NSForegroundColorAttributeName] = _tabBarItemTitleColorSelected;
        [[UITabBarItem appearance] setTitleTextAttributes:textAttributes forState:UIControlStateSelected];
        [[UIViewController visibleViewController].tabBarController.tabBar.items enumerateObjectsUsingBlock:^(UITabBarItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj setTitleTextAttributes:textAttributes forState:UIControlStateSelected];
        }];
    }
}

@end
