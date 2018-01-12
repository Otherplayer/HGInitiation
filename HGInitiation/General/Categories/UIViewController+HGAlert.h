//
//  UIViewController+HGAlert.h
//  HGInitiation
//
//  Created by __无邪_ on 2018/1/12.
//  Copyright © 2018年 __无邪_. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (HGAlert)

- (void)showAlertMessage:(NSString *)message
               withTitle:(NSString *)title
            confirmTitle:(NSString *)confirmTitle
             cancelTitle:(NSString *)cancelTitle
          confirmHandler:(void (^)(void))confirmHandler
           cancelHandler:(void (^)(void))cancelHandler;

- (void)showAlertMessage:(NSString *)message //默认title是提示、按钮是确定
       completionHandler:(void (^)(void))completionHandler;



@end
