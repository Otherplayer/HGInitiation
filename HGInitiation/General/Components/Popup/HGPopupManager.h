//
//  HGPopupManager.h
//  HGInitiation
//
//  Created by __无邪_ on 2018/6/7.
//  Copyright © 2018年 __无邪_. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CNPPopupController.h"

@interface HGPopupManager : NSObject

@property (nonatomic, strong) CNPPopupController *popupController;

- (void)showShareViewWithHandler:(void(^)(NSInteger section,NSInteger row))handler;
- (void)showPayViewWithHandler:(void(^)(NSInteger section,NSInteger row))handler;

@end
