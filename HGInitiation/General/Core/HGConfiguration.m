//
//  HGConfiguration.m
//  HGInitiation
//
//  Created by __无邪_ on 2018/1/23.
//  Copyright © 2018年 __无邪_. All rights reserved.
//

#import "HGConfiguration.h"

@implementation HGConfiguration

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static HGConfiguration *instance = nil;
    dispatch_once(&onceToken,^{
        instance = [HGConfiguration.alloc init];
    });
    return instance;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        [self initDefaultConfiguration];
    }
    return self;
}


#pragma mark Init Default Config

- (void)initDefaultConfiguration {
    
    #pragma mark - Global Color
    
    self.linkColor = UIColorMake(56, 116, 171);
    self.disabledColor = UIColorMake(0xcc, 0xcc, 0xcc);
    self.backgroundColor = nil;
    self.maskDarkColor = UIColorMakeWithRGBA(0, 0, 0, .35f);
    self.maskLightColor = UIColorMakeWithRGBA(255, 255, 255, .5f);
    self.separatorColor = UIColorMake(222, 224, 226);
    self.separatorDashedColor = UIColorMake(17, 17, 17);
    self.placeholderColor = UIColorMake(196, 200, 208);
    
    
    #pragma mark - NavigationBar
    
    self.navBarBarTintColor = nil;
    self.navBarTintColor = nil;
    self.navBarTitleColor = nil;
    self.navBarTitleFont = nil;
    self.navBarLargeTitleColor = nil;
    self.navBarLargeTitleFont = nil;
    
    
    
    
}

@end
