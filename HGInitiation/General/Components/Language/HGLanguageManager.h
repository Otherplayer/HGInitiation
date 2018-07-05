//
//  HGLanguageManager.h
//  HGInitiation
//
//  Created by __无邪_ on 2018/7/5.
//  Copyright © 2018年 __无邪_. All rights reserved.
//

#import <Foundation/Foundation.h>

FOUNDATION_EXTERN NSString *const HGLanguageChangedNotification;

@interface HGLanguageManager : NSObject

+ (instancetype)shared;

@property (nonatomic, strong) NSString *appLanguage;

- (NSArray *)supportLanguages;
- (NSString *)systemLanguage;

@end
