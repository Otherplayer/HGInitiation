//
//  HGThemeManager.h
//  HGInitiation
//
//  Created by __无邪_ on 2018/1/23.
//  Copyright © 2018年 __无邪_. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HGThemeProtocol.h"
#import "HGThemeDefault.h"


/// 当主题发生变化时，会发送这个通知
UIKIT_EXTERN NSNotificationName const HGThemeChangedNotification;

/// 主题发生改变前的值，类型为 NSObject<HGThemeProtocol>，可能为 NSNull
UIKIT_EXTERN NSString *const HGThemeBeforeChangedName;

/// 主题发生改变后的值，类型为 NSObject<HGThemeProtocol>，可能为 NSNull
UIKIT_EXTERN NSString *const HGThemeAfterChangedName;

UIKIT_EXTERN NSString *const HGSelectedThemeClassName;

@interface HGThemeManager : NSObject

+ (instancetype)sharedInstance;
@property(nonatomic, strong) NSObject<HGThemeProtocol> *currentTheme;


@end
