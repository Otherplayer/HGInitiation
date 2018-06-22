//
//  HGPopMenu.h
//  HGInitiation
//
//  Created by __无邪_ on 2018/6/22.
//  Copyright © 2018年 __无邪_. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HGPopTableViewController.h"

@interface HGPopMenu : NSObject

+ (void)showForViewController:(UIViewController *)sourceViewController
            fromBarButtonItem:(UIBarButtonItem *)barButtonItem
                    menuArray:(NSArray<NSString *> *)menuArray
                        theme:(HGPopTableViewTheme)theme
                    doneBlock:(void(^)(NSInteger selectedIndex))doneBlock
                  cancelBlock:(void(^)(void))cancelBlock;

- (void)showForViewController:(UIViewController *)sourceViewController
            fromBarButtonItem:(UIBarButtonItem *)barButtonItem
                   senderView:(UIView *)sender
                        title:(NSString *)title
                    menuArray:(NSArray<NSString *> *)menuArray
                   imageArray:(NSArray<NSString *> *)imageArray
                        theme:(HGPopTableViewTheme)theme
                    doneBlock:(void(^)(NSInteger selectedIndex))doneBlock
                  cancelBlock:(void(^)(void))cancelBlock;

@end
