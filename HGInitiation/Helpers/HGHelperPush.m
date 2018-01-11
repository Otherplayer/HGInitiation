//
//  HGHelperPush.m
//  HGInitiation
//
//  Created by __无邪_ on 2018/1/11.
//  Copyright © 2018年 __无邪_. All rights reserved.
//

#import "HGHelperPush.h"
#import "AppDelegate.h"


NSString *const HGPushClassName = @"actionName";//类名
NSString *const HGPushParams  = @"extra";//参数
NSString *const PUSH_APS  = @"aps";

@implementation HGHelperPush


+ (void)push:(NSDictionary *)params {
    if (![params isKindOfClass:[NSDictionary class]]) return;
    NSString *className = params[HGPushClassName];
    NSDictionary *parameters = params[HGPushParams];
    if (!className.length) return;
    
    [self pushWithClassName:className parameters:parameters animated:YES];
}
+ (void)pushWithClassName:(NSString *)className parameters:(NSDictionary *)parameters animated:(BOOL)animated{
    Class newClass = NSClassFromString(className);
    id viewController = [[newClass alloc] init];
    [self push2Controller:viewController parameters:parameters animated:animated];
}
+ (void)push2Controller:(UIViewController *)controller parameters:(NSDictionary *)parameters animated:(BOOL)animated {
    if (!controller) return;
    if ([parameters isKindOfClass:[NSDictionary class]]) {
        NSArray *allProperties = [controller propertyList];
        for (NSString *key in [parameters allKeys]) {
            if([allProperties containsObject:key]){
                if(parameters[key])
                    [controller setValue:parameters[key] forKey:key];
            }
            else{
                NSLog(@"[警告]%@ not contains the key '%@'\n",[controller class],key);
            }
        }
    }
    UIViewController *topVC = [self topViewController];
    if (topVC.navigationController) {
        [topVC.navigationController pushViewController:controller animated:animated];
    }else {
        NSLog(@"[错误]--------------未实现 %s",__FUNCTION__);
    }
}


#pragma mark -

+ (UIViewController *)topViewController {
    UIViewController *resultVC;
    resultVC = [self _topViewController:[[UIApplication sharedApplication].keyWindow rootViewController]];
    while (resultVC.presentedViewController) {
        resultVC = [self _topViewController:resultVC.presentedViewController];
    }
    return resultVC;
}

+ (UIViewController *)_topViewController:(UIViewController *)vc {
    if ([vc isKindOfClass:[UINavigationController class]]) {
        return [self _topViewController:[(UINavigationController *)vc topViewController]];
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        return [self _topViewController:[(UITabBarController *)vc selectedViewController]];
    } else {
        return vc;
    }
    return nil;
}

@end
