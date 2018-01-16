//
//  HGAlertAction.m
//  HGInitiation
//
//  Created by __无邪_ on 2018/1/16.
//  Copyright © 2018年 __无邪_. All rights reserved.
//

#import "HGAlertAction.h"

@implementation HGAlertAction
//            let iconImage = UIImage(named:"tick")?.withRenderingMode(.alwaysOriginal)
//            action.setValue(iconImage, forKey: "image")
- (void)setTitleColor:(UIColor *)color {
    if (self.title.length == 0) return;
    if ([UIAlertAction propertyIsExist:@"_titleTextColor"]) {
        [self setValue:color forKey:@"_titleTextColor"];
    }
}

@end
