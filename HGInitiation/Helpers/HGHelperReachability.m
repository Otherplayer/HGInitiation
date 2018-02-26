//
//  HYQHelperReachibility.m
//  HYQark
//
//  Created by __无邪_ on 15/5/5.
//  Copyright (c) 2015年 __无邪_. All rights reserved.
//

#import "HGHelperReachability.h"
#import <AFNetworking.h>
#import <netinet/in.h>
#import <netinet6/in6.h>

@interface HGHelperReachability ()
@property(nonatomic, readwrite, assign) BOOL isReachable;
@property(nonatomic, readwrite, assign) BOOL isReachableWifi;
@end

@implementation HGHelperReachability

+ (HGHelperReachability *)sharedInstance{
    static HGHelperReachability *reachability = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        reachability = [[HGHelperReachability alloc] init];
    });
    return reachability;
}

- (instancetype)init{
    self = [super init];
    if (self) {
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
            _isReachable = NO;
            _isReachableWifi = NO;
        }else {
            _isReachable = YES;
            _isReachableWifi = YES;
        }
    }
    return self;
}

- (void)checkStates:(AFNetworkReachabilityStatus)status{
    BOOL isCan = NO;
    BOOL isCanWifi = NO;
    switch (status) {
        case AFNetworkReachabilityStatusNotReachable:
            break;
        case AFNetworkReachabilityStatusReachableViaWWAN:{
            isCan = YES;
            isCanWifi = NO;
        }
            break;
        case AFNetworkReachabilityStatusReachableViaWiFi:{
            isCan = YES;
            isCanWifi = YES;
        }
            break;
        default:
            break;
    }
    
    _isReachable = isCan;
    _isReachableWifi = isCanWifi;
    
//    [[NSNotificationCenter defaultCenter] postNotificationName:HYQ_NET_CHANGE_NOTIFICATION object:@(status)];
    
    NSLog(@"【Reachability: %@】", AFStringFromNetworkReachabilityStatus(status));
}

- (BOOL)isReachable {
    
    if (_isReachable) {
        return YES;
    }
    HGNetWorkType status = [self netWorkType];
    if (status) {
        _isReachable = YES;
        if (status == HGNetWorkTypeWiFi) {
            _isReachableWifi = YES;
        }
    }
    return _isReachable;
}

- (void)startMonitoring{
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        [self checkStates:status];
    }];
}

- (HGNetWorkType)netWorkType{
    UIView *statusBar = [[UIApplication sharedApplication] valueForKeyPath:@"statusBar"];
    UIView *foregroundView = [statusBar valueForKeyPath:@"foregroundView"];
    
    UIView *networkView = nil;
    UIView *signalStrengthView = nil;
    
    for (UIView *childView in foregroundView.subviews) {
        if ([childView isKindOfClass:NSClassFromString(@"UIStatusBarDataNetworkItemView")]) {
            networkView = childView;
        }
        if ([childView isKindOfClass:NSClassFromString(@"UIStatusBarSignalStrengthItemView")]) {
            signalStrengthView = childView;
        }
    }
    
    HGNetWorkType status = HGNetWorkTypeNoService;
    if (networkView) {
//        NSLog(@"%@",[networkView ivarList]);
        int netType = [[networkView valueForKeyPath:@"_dataNetworkType"] intValue];
//        NSLog(@"%@",@([[networkView valueForKeyPath:@"_wifiStrengthRaw"] intValue]));
//        NSLog(@"%@",@([[networkView valueForKeyPath:@"_wifiStrengthBars"] intValue]));
//        NSLog(@"%@",@([[signalStrengthView valueForKeyPath:@"_signalStrengthBars"] intValue]));
        status = (HGNetWorkType)netType;
    }
    NSLog("========HGNetWorkType=======%d",status)
    return status;
}


@end
