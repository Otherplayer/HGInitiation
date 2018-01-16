//
//  UIAlertAction+HGCustom.m
//  HGInitiation
//
//  Created by __无邪_ on 2018/1/16.
//  Copyright © 2018年 __无邪_. All rights reserved.
//

#import "UIAlertAction+HGCustom.h"

static NSString * kTitleTextColor = @"_titleTextColor";//不要修改此变量内容 _titleTextColor 是通过runtime方式获取到的

@implementation UIAlertAction (HGCustom)

- (UIColor *)titleColor {
    return [self associatedObjectForKey:kTitleTextColor];
}

- (void)setTitleColor:(UIColor *)color {
    if ([UIAlertAction propertyIsExist:kTitleTextColor]) {
        [self setValue:color forKey:kTitleTextColor];
        [self setAssociatedObject:color forKey:kTitleTextColor];
    }
}

@end
