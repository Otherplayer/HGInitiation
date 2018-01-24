//
//  HGConfiguration.h
//  HGInitiation
//
//  Created by __无邪_ on 2018/1/23.
//  Copyright © 2018年 __无邪_. All rights reserved.
//

#import <Foundation/Foundation.h>

#define HGConfigurationInstance [HGConfiguration sharedInstance]


@interface HGConfiguration : NSObject

+ (instancetype _Nullable )sharedInstance;

NS_ASSUME_NONNULL_BEGIN

#pragma mark - Global Color

@property(nonatomic, strong) UIColor            *linkColor;
@property(nonatomic, strong) UIColor            *disabledColor;
@property(nonatomic, strong, nullable) UIColor  *backgroundColor;
@property(nonatomic, strong) UIColor            *maskDarkColor;
@property(nonatomic, strong) UIColor            *maskLightColor;
@property(nonatomic, strong) UIColor            *separatorColor;
@property(nonatomic, strong) UIColor            *separatorDashedColor;
@property(nonatomic, strong) UIColor            *placeholderColor;


#pragma mark - NavigationBar

@property(nonatomic, strong, nullable) UIColor  *navBarBarTintColor;
@property(nonatomic, strong, nullable) UIColor  *navBarTintColor;
@property(nonatomic, strong, nullable) UIColor  *navBarTitleColor;
@property(nonatomic, strong, nullable) UIFont   *navBarTitleFont;
@property(nonatomic, strong, nullable) UIColor  *navBarLargeTitleColor;
@property(nonatomic, strong, nullable) UIFont   *navBarLargeTitleFont;
@property(nonatomic, strong, nullable) UIImage  *navBarBackgroundImage;
@property(nonatomic, strong, nullable) UIImage  *navBarShadowImage;

NS_ASSUME_NONNULL_END

@end
