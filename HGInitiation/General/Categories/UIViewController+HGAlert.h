//
//  UIViewController+HGAlert.h
//  HGInitiation
//
//  Created by __无邪_ on 2018/1/12.
//  Copyright © 2018年 __无邪_. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (HGAlert)

- (void)showAlertMessage:(NSString *_Nullable)message
               withTitle:(NSString *_Nullable)title
            confirmTitle:(NSString *_Nullable)confirmTitle
             cancelTitle:(NSString *_Nullable)cancelTitle
          confirmHandler:(void (^_Nullable)(void))confirmHandler
           cancelHandler:(void (^_Nullable)(void))cancelHandler;

- (void)showAlertMessage:(NSString *_Nullable)message ///默认title是提示、按钮是确定
       completionHandler:(void (^_Nullable)(void))completionHandler;


- (BOOL)isPresented;///当前 viewController 是否是被以 present 的方式显示的
+ (nullable UIViewController *)visibleViewController; ///获取当前应用里最顶层的可见viewController

@end
