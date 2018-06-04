//
//  UIViewController+HGNavItems.m
//  HGInitiation
//
//  Created by __无邪_ on 2018/5/24.
//  Copyright © 2018年 __无邪_. All rights reserved.
//

#import "UIViewController+HGNavItems.h"

#define kNavigationItemButtonHeight 44.f
#define kNavigationItemButtonWidth 64.f
#define kNavigationItemImageWidth 22.f

@implementation UIViewController (HGNavItems)

- (void)addBackButton {
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem.alloc initWithImage:[UIImage imageNamed:@"shutdown_click"] style:UIBarButtonItemStylePlain target:self action:@selector(backBarButtonPressed:)];
}
- (void)addRightBarButtonItemWithTitle:(NSString *)title {
    [self addBarButtonItemWithTitle:title action:@selector(rightBarButtonPressed:) left:NO];
}
- (void)addLeftBarButtonItemWithTitle:(NSString *)title {
    [self addBarButtonItemWithTitle:title action:@selector(leftBarButtonPressed:) left:YES];
}
- (void)addBarButtonItemWithTitle:(NSString *)title action:(SEL)action left:(BOOL)isLeft{
    UIBarButtonItem *barButtonItem = [UIBarButtonItem.alloc initWithTitle:title style:UIBarButtonItemStylePlain target:self action:action];
    if (isLeft) {
        self.navigationItem.leftBarButtonItem = barButtonItem;
    }else{
        self.navigationItem.rightBarButtonItem = barButtonItem;
    }
}

#pragma mark -

- (void)backBarButtonPressed:(id)backBarButtonPressed{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)leftBarButtonPressed:(id)leftBarButtonPressed{
    
}
- (void)rightBarButtonPressed:(id)rightBarButtonPressed{
    
}



@end
