//
//  HGThemeProtocol.h
//  HGInitiation
//
//  Created by __无邪_ on 2018/1/23.
//  Copyright © 2018年 __无邪_. All rights reserved.
//

#import <Foundation/Foundation.h>

/// 所有主题均应实现这个协议，规定关键外观属性
@protocol HGThemeProtocol <NSObject>

@required

- (void)setupConfigurationTemplate;

- (UIColor *)themeTintColor;

- (NSString *)themeName;

@end

/// 所有能响应主题变化的对象均应实现这个协议
@protocol HGChangingThemeDelegate <NSObject>

@required

- (void)themeBeforeChanged:(NSObject<HGThemeProtocol> *)themeBeforeChanged afterChanged:(NSObject<HGThemeProtocol> *)themeAfterChanged;

@end


