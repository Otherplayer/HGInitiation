//
//  HGHelperPush.h
//  HGInitiation
//
//  Created by __无邪_ on 2018/1/11.
//  Copyright © 2018年 __无邪_. All rights reserved.
//

#import <Foundation/Foundation.h>

UIKIT_EXTERN NSString *const HGPushClassName;
UIKIT_EXTERN NSString *const HGPushParams;


@interface HGHelperPush : NSObject

+ (void)push:(NSDictionary *)params;
+ (void)pushWithClassName:(NSString *)className parameters:(NSDictionary *)parameters animated:(BOOL)animated;


+ (UIViewController *)topViewController;

@end
