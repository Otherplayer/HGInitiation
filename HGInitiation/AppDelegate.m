//
//  AppDelegate.m
//  HGInitiation
//
//  Created by __无邪_ on 2017/12/25.
//  Copyright © 2017年 __无邪_. All rights reserved.
//  http://www.wtfpl.net/txt/copying/

#import "AppDelegate.h"
#import "HGThemeManager.h"
#import "HGThemeDefault.h"
#import "SystemConfiguration/SCNetworkReachability.h"
#import "HGHelperReachability.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
//    [self checkReachability];
    [[HGHelperReachability sharedInstance] startMonitoringInternetStates];
    NSLog(@"%@",@([[HGHelperReachability sharedInstance] isReachable]));
    NSLog(@"%@",@([[HGHelperReachability sharedInstance] netWorkType]));
    // 应用皮肤
    NSString *themeClassName = [[NSUserDefaults standardUserDefaults] objectForKey:HGSelectedThemeClassName];
    [HGThemeManager sharedInstance].currentTheme = [[NSClassFromString(themeClassName) alloc] init];
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)checkReachability {
    // Create a reachability object for the desired host
    NSString *hostName = @"https://www.baidu.com";
    SCNetworkReachabilityRef reachability = SCNetworkReachabilityCreateWithName(NULL, [hostName UTF8String]);
    // Create a place in memory for reachability flags
    SCNetworkReachabilityFlags flags;
    // Check the reachability of the host
    SCNetworkReachabilityGetFlags(reachability, &flags);
    // Release the reachability object
    CFRelease(reachability);
    // Check to see if the reachable flag is set
    if ((flags & kSCNetworkReachabilityFlagsReachable) == 0) {
        // The target host is not reachable
        // Alert the user or defer the activity
        NSLog(@"not available");
    }else {
        NSLog(@"is reachable");
    }
}


@end
