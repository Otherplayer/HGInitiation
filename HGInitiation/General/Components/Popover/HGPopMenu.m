//
//  HGPopMenu.m
//  HGInitiation
//
//  Created by __无邪_ on 2018/6/22.
//  Copyright © 2018年 __无邪_. All rights reserved.
//

#import "HGPopMenu.h"

@implementation HGPopMenu

+ (instancetype)sharedInstance {
    static HGPopMenu *shared;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[HGPopMenu alloc] init];
    });
    return shared;
}

+ (void)showForViewController:(UIViewController *)sourceViewController
            fromBarButtonItem:(UIBarButtonItem *)barButtonItem
                    menuArray:(NSArray<NSString *> *)menuArray
                        theme:(HGPopTableViewTheme)theme
                    doneBlock:(void(^)(NSInteger selectedIndex))doneBlock
                  cancelBlock:(void(^)(void))cancelBlock {
    [[self sharedInstance] showForViewController:sourceViewController
                               fromBarButtonItem:barButtonItem
                                      senderView:nil
                                           title:nil
                                       menuArray:menuArray
                                      imageArray:nil
                                           theme:theme
                                       doneBlock:doneBlock
                                     cancelBlock:cancelBlock];
}


- (void)showForViewController:(UIViewController *)sourceViewController
           fromBarButtonItem:(UIBarButtonItem *)barButtonItem
                  senderView:(UIView *)sender
                       title:(NSString *)title
                   menuArray:(NSArray<NSString *> *)menuArray
                   imageArray:(NSArray<NSString *> *)imageArray
                        theme:(HGPopTableViewTheme)theme
                   doneBlock:(void(^)(NSInteger selectedIndex))doneBlock
                 cancelBlock:(void(^)(void))cancelBlock {
    HGPopTableViewController *ctrl = [[HGPopTableViewController alloc] initWithTheme:theme];
    ctrl.barButtonItem = barButtonItem;
    ctrl.sourceView = sender;
    ctrl.titleStr = title;
    ctrl.menuArray = menuArray;
    ctrl.imageArray = imageArray;
    ctrl.doneBlock = doneBlock;
    ctrl.cancelBlock = cancelBlock;
    [sourceViewController presentViewController:ctrl animated:YES completion:nil];
}


@end
