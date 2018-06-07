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
                              @{@"title":@"微信",@"icon":@"sns_icon_22"},
                              @{@"title":@"朋友圈",@"icon":@"sns_icon_23"},
                              @{@"title":@"微信收藏",@"icon":@"sns_icon_37"},
                              @{@"title":@"微博",@"icon":@"sns_icon_1"},
                              @{@"title":@"QQ",@"icon":@"sns_icon_24"},
                              @{@"title":@"QQ空间",@"icon":@"sns_icon_6"},
                              @{@"title":@"Fackbook",@"icon":@"sns_icon_10"},
                              @{@"title":@"Messager",@"icon":@"sns_icon_46"},
                              @{@"title":@"Twitter",@"icon":@"sns_icon_11"},
                              @{@"title":@"WhatsApp",@"icon":@"sns_icon_43"}
                            ];
    
    NSArray *shareSystem = @[
                             @{@"title":@"短信",@"icon":@"sharekit_icon_wx"}];
    
    
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

- (void)showPayViewWithHandler:(void(^)(NSInteger row))handler {
    NSArray *pays = @[@{@"title":@"微信",@"icon":@"sharekit_icon_wx"},@{@"title":@"支付宝",@"icon":@"sharekit_icon_wx"}];
    HGMutilVerticalScrollView *verticalScrollView = [HGMutilVerticalScrollView.alloc initWithItems:pays];
    @weakify(self);
    [verticalScrollView setDidTapCancelHandler:^{
        @strongify(self);
        if (!self) {return;}
        [self.popupController dismissPopupControllerAnimated:YES];
    }];
    [verticalScrollView setDidTapItemHandler:^(NSInteger row) {
        if (handler) {
            handler(row);
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