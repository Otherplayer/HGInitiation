//
//  UIColor+HG.h
//  HGInitiation
//
//  Created by __无邪_ on 2018/1/3.
//  Copyright © 2018年 __无邪_. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (HG)

+ (UIColor *)randomColor;
+ (UIColor *)disabledColor;
+ (UIColor *)placeholderColor;


+ (UIColor *)gradientColorFrom:(UIColor *)colorFrom to:(UIColor *)colorTo height:(int)height;
+ (UIColor *)gradientColorFrom:(UIColor *)colorFrom to:(UIColor *)colorTo width:(int)width;
+ (UIColor *)gradientColors:(NSArray *)colors size:(CGSize)size;

@end
