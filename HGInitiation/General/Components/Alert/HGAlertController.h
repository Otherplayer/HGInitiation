//
//  HGAlertController.h
//  HGInitiation
//
//  Created by __无邪_ on 2018/1/16.
//  Copyright © 2018年 __无邪_. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HGAlertAction.h"

@interface HGAlertController : UIAlertController

- (void)setTitleAttributes:(NSDictionary *)attributes;
- (void)setMessageAttributes:(NSDictionary *)attributes;

@end
