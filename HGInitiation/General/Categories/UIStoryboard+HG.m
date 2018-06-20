//
//  UIStoryboard+HG.m
//  HGInitiation
//
//  Created by __无邪_ on 2018/6/19.
//  Copyright © 2018年 __无邪_. All rights reserved.
//

#import "UIStoryboard+HG.h"

@implementation UIStoryboard (HG)


+ (instancetype)mainStoryboard{
    return [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
}

+ (instancetype)loginStoryboard{
    return [UIStoryboard storyboardWithName:@"Login" bundle:[NSBundle mainBundle]];
}

////////////////////////////////////////////////////////////////////////////////
#pragma mark - Login
////////////////////////////////////////////////////////////////////////////////

+ (UINavigationController *)loginController{
    return [[UIStoryboard loginStoryboard] instantiateViewControllerWithIdentifier:@"HGBASENavigationController"];
}

//+ (UIViewController *)loginController{
//    return [[UIStoryboard loginStoryboard] instantiateViewControllerWithIdentifier:@"HGLoginController"];
//}
//
//+ (UIViewController *)registerController{
//    return [[UIStoryboard loginStoryboard] instantiateViewControllerWithIdentifier:@"HGRegisterController"];
//}


@end
