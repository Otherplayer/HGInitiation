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

- (id)init{
    
    if(self=[super init]){
        struct sockaddr_in address;
        bzero(&address, sizeof(address));
        address.sin_len = sizeof(address);
        address.sin_family = AF_INET;
        
        const void *address1=&address;
        
        SCNetworkReachabilityRef reachability = SCNetworkReachabilityCreateWithAddress(kCFAllocatorDefault, (const struct sockaddr *)address1);
        SCNetworkReachabilityFlags flags;
        SCNetworkReachabilityGetFlags(reachability, &flags);
        AFNetworkReachabilityStatus status = AFNetworkReachabilityStatusForFlags(flags);
        [self checkStates:status];
    }
    return self;
}


static AFNetworkReachabilityStatus AFNetworkReachabilityStatusForFlags(SCNetworkReachabilityFlags flags) {
    BOOL isReachable = ((flags & kSCNetworkReachabilityFlagsReachable) != 0);
    BOOL needsConnection = ((flags & kSCNetworkReachabilityFlagsConnectionRequired) != 0);
    BOOL canConnectionAutomatically = (((flags & kSCNetworkReachabilityFlagsConnectionOnDemand ) != 0) || ((flags & kSCNetworkReachabilityFlagsConnectionOnTraffic) != 0));
    BOOL canConnectWithoutUserInteraction = (canConnectionAutomatically && (flags & kSCNetworkReachabilityFlagsInterventionRequired) == 0);
    BOOL isNetworkReachable = (isReachable && (!needsConnection || canConnectWithoutUserInteraction));
    
    AFNetworkReachabilityStatus status = AFNetworkReachabilityStatusUnknown;
    if (isNetworkReachable == NO) {
        status = AFNetworkReachabilityStatusNotReachable;
    }
#if	TARGET_OS_IPHONE
    else if ((flags & kSCNetworkReachabilityFlagsIsWWAN) != 0) {
        status = AFNetworkReachabilityStatusReachableViaWWAN;
    }
#endif
    else {
        status = AFNetworkReachabilityStatusReachableViaWiFi;
    }
    
    return status;
}


-(void)checkStates:(AFNetworkReachabilityStatus )status{
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
    
    if (!isCan) { //监测到网络不可用的时候，有可能这时候网络可用
        HGNetWorkType status = [self netWorkType];
        if (status) {
            isCan = YES;
            if (status == HGNetWorkTypeWiFi) {
                isCanWifi = YES;
            }
        }
    }
    
    _isReachable = isCan;
    _isReachableWifi = isCanWifi;
    
//    [[NSNotificationCenter defaultCenter] postNotificationName:HYQ_NET_CHANGE_NOTIFICATION object:@(status)];
    
    NSLog(@"【Reachability: %@】", AFStringFromNetworkReachabilityStatus(status));
}

- (void)startMonitoringInternetStates{
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        [self checkStates:status];
    }];
}

- (BOOL)reachable
{
    if (self.isReachable) {
        return YES;
    }
//    [ShowTip showTipTextOnly:NETWORK_TIMEOUT dealy:2];
    return self.isReachable;
}


- (HGNetWorkType)netWorkType{
    UIApplication *app = [UIApplication sharedApplication];
    UIView *statusBar = [app valueForKeyPath:@"statusBar"];
    UIView *foregroundView = [statusBar valueForKeyPath:@"foregroundView"];
    
    UIView *networkView = nil;
    
    for (UIView *childView in foregroundView.subviews) {
        if ([childView isKindOfClass:NSClassFromString(@"UIStatusBarDataNetworkItemView")]) {
            networkView = childView;
        }
    }
    
    HGNetWorkType status = HGNetWorkTypeNONE;
    
    if (networkView) {
        int netType = [[networkView valueForKeyPath:@"dataNetworkType"] intValue];
        switch (netType) {
            case 0:
                status = HGNetWorkTypeNONE;
                break;
            case 1://实际上是2G
                status = HGNetWorkType2G;
                break;
            case 2:
                status = HGNetWorkType3G;
                break;
            case 3:
                status = HGNetWorkType4G;
                break;
            case 5:
                status = HGNetWorkTypeWiFi;
                break;
            default:
                status = HGNetWorkTypeUnkonow;
                break;
        }
    }
    
    NSLog("========HGNetWorkType=======%d",status)
    return status;
}


@end
