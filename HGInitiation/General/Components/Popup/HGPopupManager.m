//
//  HGPopupManager.m
//  HGInitiation
//
//  Created by __无邪_ on 2018/6/7.
//  Copyright © 2018年 __无邪_. All rights reserved.
//

#import "HGPopupManager.h"
#import "HGMutilHorizontalScrollView.h"
#import "HGMutilVerticalScrollView.h"

@implementation HGPopupManager

- (instancetype)init{
    self = [super init];
    if (self) {
        
    }
    return self;
}


- (void)showShareViewWithHandler:(void(^)(NSInteger section,NSInteger row))handler {
    NSArray *shareVendors = @[
                              @{@"title":@"微信",@"icon":@"sharekit_icon_wx",@"icon_disabled":@"sharekit_icon_wx_disable",@"enabled":@1},
                              @{@"title":@"朋友圈",@"icon":@"sharekit_icon_wxgroup",@"icon_disabled":@"sharekit_icon_wxgroup_disable",@"enabled":@1},
                              @{@"title":@"微博",@"icon":@"sharekit_icon_sina",@"icon_disabled":@"sharekit_icon_sina_disable",@"enabled":@0},
                              @{@"title":@"QQ",@"icon":@"sharekit_icon_qq",@"icon_disabled":@"sharekit_icon_qq_disable",@"enabled":@0},
                              @{@"title":@"QQ空间",@"icon":@"sharekit_icon_qq",@"icon_disabled":@"sharekit_icon_qq_disable",@"enabled":@0},
                            ];
    
    NSArray *shareSystem = @[
                             @{@"title":@"短信",@"icon":@"sharekit_icon_wx",@"icon_disabled":@"sharekit_icon_wx",@"enabled":@1}];
    
    
    HGMutilHorizontalScrollView *horizontalScrollView = [[HGMutilHorizontalScrollView alloc] initWithItems:@[shareVendors,shareSystem]];
    
    @weakify(self);
    [horizontalScrollView setDidTapCancelHandler:^{
        @strongify(self);
        if (!self) {return;}
        [self.popupController dismissPopupControllerAnimated:YES];
    }];
    [horizontalScrollView setDidTapItemHandler:^(NSInteger section, NSInteger row) {
        if (handler) {
            handler(section, row);
        }
        @strongify(self);
        if (!self) {return;}
        [self.popupController dismissPopupControllerAnimated:YES];
    }];
    [self showPopupWithStyle:CNPPopupStyleActionSheet view:horizontalScrollView];
}

- (void)showPayViewWithHandler:(void(^)(NSInteger section,NSInteger row))handler {
    NSArray *pays = @[@{@"title":@"微信",@"icon":@"sharekit_icon_wx"},@{@"title":@"支付宝",@"icon":@"sharekit_icon_wx"}];
    HGMutilVerticalScrollView *verticalScrollView = [HGMutilVerticalScrollView.alloc initWithItems:pays];
    @weakify(self);
    [verticalScrollView setDidTapCancelHandler:^{
        @strongify(self);
        if (!self) {return;}
        [self.popupController dismissPopupControllerAnimated:YES];
    }];
    [verticalScrollView setDidTapItemHandler:^(NSInteger section, NSInteger row) {
        if (handler) {
            handler(section, row);
        }
        @strongify(self);
        if (!self) {return;}
        [self.popupController dismissPopupControllerAnimated:YES];
    }];
    [self showPopupWithStyle:CNPPopupStyleActionSheet view:verticalScrollView];
}


- (void)showPopupWithStyle:(CNPPopupStyle)popupStyle view:(UIView *)view{
    self.popupController = [[CNPPopupController alloc] initWithContents:@[view]];
    self.popupController.theme = [CNPPopupTheme defaultTheme];
    self.popupController.theme.popupStyle = popupStyle;
    [self.popupController presentPopupControllerAnimated:YES];
}

@end
