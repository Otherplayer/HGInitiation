//
//  UIAlertController+HGCustom.h
//  HGInitiation
//
//  Created by __无邪_ on 2018/1/16.
//  Copyright © 2018年 __无邪_. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIAlertController (HGCustom)

@property(nonatomic, strong)NSDictionary *titleAttributes;//先设置title，再设置此属性
@property(nonatomic, strong)NSDictionary *messageAttributes;//先设置message，再设置此属性

@end
