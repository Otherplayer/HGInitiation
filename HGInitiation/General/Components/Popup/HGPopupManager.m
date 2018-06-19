//
//  HGPopupManager.m
//  HGInitiation
//
//  Created by __无邪_ on 2018/6/7.
//  Copyright © 2018年 __无邪_. All rights reserved.
//

#import "HGPopupManager.h"
#import "HGMultiHorizontalSelectView.h"
#import "HGVerticalSelectView.h"

@implementation HGPopupManager

#pragma mark - public

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
                             @{@"title":@"短信",@"icon":@"sharekit_icon_wx"},
                             @{@"title":@"邮件",@"icon":@"sharekit_icon_wx"},
                             @{@"title":@"系统",@"icon":@"sharekit_icon_wx"}];
    
    
    HGMultiHorizontalSelectView *horizontalScrollView = [[HGMultiHorizontalSelectView alloc] initWithItems:@[shareVendors,shareSystem]];
    
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

- (void)showShare9ViewWithHandler:(void(^)(NSInteger section,NSInteger row))handler {
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
                              @{@"title":@"微信",@"icon":@"sns_icon_22"},
                              @{@"title":@"朋友圈",@"icon":@"sns_icon_23"},
                              @{@"title":@"微信收藏",@"icon":@"sns_icon_37"},
                              @{@"title":@"微博",@"icon":@"sns_icon_1"},
                              @{@"title":@"QQ",@"icon":@"sns_icon_24"},
                              @{@"title":@"QQ空间",@"icon":@"sns_icon_6"},
                              @{@"title":@"Fackbook",@"icon":@"sns_icon_10"},
                              @{@"title":@"Messager",@"icon":@"sns_icon_46"},
                              @{@"title":@"Twitter",@"icon":@"sns_icon_11"},
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
    HGMultiHorizontalSelectView *horizontalScrollView = [[HGMultiHorizontalSelectView alloc] initWithItems:shareVendors title:@"分享" type:HGMutilHorizontalScrollType9];
    
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
    HGVerticalSelectView *verticalScrollView = [HGVerticalSelectView.alloc initWithItems:pays];
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




#pragma mark - private

- (void)showPopupWithStyle:(CNPPopupStyle)popupStyle view:(UIView *)view{
    self.popupController = [[CNPPopupController alloc] initWithContents:@[view]];
    self.popupController.theme = [CNPPopupTheme defaultTheme];
    self.popupController.theme.popupStyle = popupStyle;
    [self.popupController presentPopupControllerAnimated:YES];
}

@end
