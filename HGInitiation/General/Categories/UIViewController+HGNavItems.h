//
//  UIViewController+HGNavItems.h
//  HGInitiation
//
//  Created by __无邪_ on 2018/5/24.
//  Copyright © 2018年 __无邪_. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (HGNavItems)

- (void)addBackButton;
- (void)addLeftBarButtonItemWithTitle:(NSString *)title;
- (void)addRightBarButtonItemWithTitle:(NSString *)title;
- (void)addBarButtonItemWithTitle:(NSString *)title action:(SEL)action left:(BOOL)isLeft;


#pragma mark - action

- (void)backBarButtonPressed:(id)backBarButtonPressed;
- (void)leftBarButtonPressed:(id)leftBarButtonPressed;
- (void)rightBarButtonPressed:(id)rightBarButtonPressed;


@end
