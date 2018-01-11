//
//  GlobalMacro.h
//  HGInitiation
//
//  Created by __无邪_ on 2017/12/29.
//  Copyright © 2017年 __无邪_. All rights reserved.
//

#ifndef GlobalMacro_h
#define GlobalMacro_h


// 只代表屏幕尺寸大小，不代表具体设备
#define IS_IPHONE4      ((int)[UIScreen mainScreen].bounds.size.height == 480)//320w
#define IS_IPHONE5      ((int)[UIScreen mainScreen].bounds.size.height == 568)//320w
#define IS_IPHONE6      ((int)[UIScreen mainScreen].bounds.size.height == 667)//375w
#define IS_IPHONE_PLUS  ((int)[UIScreen mainScreen].bounds.size.height == 736)//414w
#define IS_IPHONEX      ((int)[UIScreen mainScreen].bounds.size.height == 812)//375w

// 是否横竖屏
// 用户界面横屏了才会返回YES
#define IS_LANDSCAPE UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation])
// 无论支不支持横屏，只要设备横屏了，就会返回YES
#define IS_DEVICE_LANDSCAPE UIDeviceOrientationIsLandscape([[UIDevice currentDevice] orientation])

// 屏幕宽度，会根据横竖屏的变化而变化
#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)

// 屏幕宽度，跟横竖屏无关
#define DEVICE_WIDTH (IS_LANDSCAPE ? [[UIScreen mainScreen] bounds].size.height : [[UIScreen mainScreen] bounds].size.width)
#define DEVICE_HEIGHT (IS_LANDSCAPE ? [[UIScreen mainScreen] bounds].size.width : [[UIScreen mainScreen] bounds].size.height)


// 状态栏高度(来电等情况下，状态栏高度会发生变化，所以应该实时计算)
#define STATUS_BAR_HEIGHT ([[UIApplication sharedApplication] statusBarFrame].size.height)
// navigationBar相关frame
#define NAV_BAR_HEIGHT (IS_LANDSCAPE ? 32 : 44)
#define NAVandSTATUS_BAR_HEIHGT (STATUS_BAR_HEIGHT + NAV_BAR_HEIGHT)
#define TAB_BAR_HEIGHT ((IS_IPHONEX ? (IS_LANDSCAPE ? 53 : 83) : (IS_LANDSCAPE ? 32 : 44)))


#define HGPixelOne (1 / [[UIScreen mainScreen] scale])

#define UIFontMake(size) [UIFont systemFontOfSize:size]
#define UIFontItalicMake(size) [UIFont italicSystemFontOfSize:size] // 斜体只对数字和字母有效，中文无效
#define UIFontBoldMake(size) [UIFont boldSystemFontOfSize:size]
#define UIFontBoldWithFont(_font) [UIFont boldSystemFontOfSize:_font.pointSize]



#endif /* GlobalMacro_h */
