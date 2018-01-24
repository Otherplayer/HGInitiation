//
//  HGThemeManager.m
//  HGInitiation
//
//  Created by __无邪_ on 2018/1/23.
//  Copyright © 2018年 __无邪_. All rights reserved.
//

#import "HGThemeManager.h"

NSNotificationName const HGThemeChangedNotification = @"HGThemeChangedNotification";
NSString *const HGThemeBeforeChangedName = @"HGThemeBeforeChangedName";
NSString *const HGThemeAfterChangedName = @"HGThemeAfterChangedName";
NSString *const HGSelectedThemeClassName = @"HGSelectedThemeClassName";


@implementation HGThemeManager

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static HGThemeManager *instance = nil;
    dispatch_once(&onceToken,^{
        instance = [[super allocWithZone:NULL] init];
    });
    return instance;
}

/**
 * 重写 +allocWithZone 方法，使得在给对象分配内存空间的时候，就指向同一份数据
 */

+ (id)allocWithZone:(struct _NSZone *)zone{
    return [self sharedInstance];
}


- (void)setCurrentTheme:(NSObject<HGThemeProtocol> *)currentTheme {
    BOOL isThemeChanged = _currentTheme != currentTheme;
    if (currentTheme) {
        NSObject<HGThemeProtocol> *themeBeforeChanged = nil;
        if (isThemeChanged) {
            themeBeforeChanged = _currentTheme;
        }
        _currentTheme = currentTheme;
        if (isThemeChanged) {
            [currentTheme setupConfigurationTemplate];
            [[NSNotificationCenter defaultCenter] postNotificationName:HGThemeChangedNotification
                                                                object:self
                                                              userInfo:@{HGThemeBeforeChangedName: themeBeforeChanged ?: [NSNull null], HGThemeAfterChangedName: currentTheme ?: [NSNull null]}];
            [[NSUserDefaults standardUserDefaults] setObject:NSStringFromClass(currentTheme.class) forKey:HGSelectedThemeClassName];
        }
    }else{
        NSString *themeClassName = NSStringFromClass([HGThemeDefault class]);
        [self setCurrentTheme:[[NSClassFromString(themeClassName) alloc] init]];
    }
    
    
}


@end
