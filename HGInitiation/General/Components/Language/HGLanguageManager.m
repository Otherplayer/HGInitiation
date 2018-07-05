//
//  HGLanguageManager.m
//  HGInitiation
//
//  Created by __无邪_ on 2018/7/5.
//  Copyright © 2018年 __无邪_. All rights reserved.
//

//zh_Hans
//zh_Hans_HK
//zh_Hans_MO
//zh_Hans_CN
//zh_Hans_SG

//zh_Hant
//zh_Hant_TW
//zh_Hant_MO
//zh_Hant_HK
//zh

#import "HGLanguageManager.h"

NSString *const HGLanguageChangedNotification = @"HGLanguageChangedNotification";

@implementation HGLanguageManager

+ (instancetype)shared {
    static HGLanguageManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[HGLanguageManager alloc] init];
    });
    return manager;
}

- (void)setAppLanguage:(NSString *)appLanguage {
    
    if ([appLanguage isEqualToString:self.appLanguage]) {
        return;
    }
    if (appLanguage.length == 0) {
        appLanguage = [self systemLanguage];
    }
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:appLanguage forKey:HGAppLanguage];
    [userDefaults synchronize];
}

- (NSString *)appLanguage {
    
    NSString *localLang = [[NSUserDefaults standardUserDefaults] objectForKey:HGAppLanguage];
    if (localLang.length == 0) {
        return [self systemLanguage];
    }
    return localLang;
}

- (NSArray *)supportLanguages {
    
    return @[@{@"title":@"简体中文",@"flag":@"zh-Hans"},
             @{@"title":@"繁體中文",@"flag":@"zh-Hant"},
             @{@"title":@"English",@"flag":@"en"}];
}

- (NSString *)systemLanguage {
    
    NSString *lang = [NSLocale preferredLanguages].firstObject;
    if ([lang hasPrefix:@"zh"]) {
        if ([lang rangeOfString:@"Hans"].location != NSNotFound) {
            lang = @"zh-Hans"; // 简体中文
        }else { // zh-Hant\zh-HK\zh-TW
            lang = @"zh-Hant"; // 繁體中文
        }
    }else {
        lang = @"en";
    }
    return lang;
}


@end
