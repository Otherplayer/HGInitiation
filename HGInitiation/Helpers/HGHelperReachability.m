//
//  HYQHelperReachibility.m
//  HYQark
//
//  Created by __无邪_ on 15/5/5.
//  Copyright (c) 2015年 __无邪_. All rights reserved.
//

#import "HGHelperReachability.h"
#import "Reachability.h"

@interface HGHelperReachability ()
@property(nonatomic, readwrite, assign) BOOL isReachable;
@property(nonatomic, readwrite, assign) BOOL isReachableWifi;
@property(nonatomic, strong) Reachability *internetReachability;
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

+ (id)sharedInstance2{
    static __weak HGHelperReachability *instance;
    HGHelperReachability *strongInstance = instance;
    @synchronized(self) {
        if (strongInstance == nil) {
            strongInstance = [[[self class] alloc] init];
            instance = strongInstance;
        }
    }
    return strongInstance;
}


- (instancetype)init{
    self = [super init];
    if (self) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
        
        self.internetReachability = [Reachability reachabilityForInternetConnection];
        
//        // Create a reachability object for the desired host
//        NSString *hostName = @"https://www.baidu.com";
//        SCNetworkReachabilityRef reachability = SCNetworkReachabilityCreateWithName(NULL, [hostName UTF8String]);
//        // Create a place in memory for reachability flags
//        SCNetworkReachabilityFlags flags;
//        // Check the reachability of the host
//        SCNetworkReachabilityGetFlags(reachability, &flags);
//        // Release the reachability object
//        CFRelease(reachability);
//        // Check to see if the reachable flag is set
//        if ((flags & kSCNetworkReachabilityFlagsReachable) == 0) {
//            // The target host is not reachable
//            _isReachable = NO;
//            _isReachableWifi = NO;
//        }else {
//            _isReachable = YES;
//            _isReachableWifi = YES;
//        }
    }
    return self;
}

- (BOOL)isReachable {
    
    NetworkStatus status = [self.internetReachability currentReachabilityStatus];
    
    if (status != NotReachable) {
        return YES;
    }
    
    HGNetWorkType type = [self netWorkType];//此处有可能是有网络，但是网络不通
    if (type != HGNetWorkTypeNoService) {
        _isReachable = YES;
        if (type == HGNetWorkTypeWiFi) {
            _isReachableWifi = YES;
        }
    }
    return _isReachable;
}
- (BOOL)isReachableWifi {
    NetworkStatus status = [self.internetReachability currentReachabilityStatus];
    if (status == ReachableViaWiFi) {
        return YES;
    }
    return NO;
}

- (void)startMonitoring{
    [self.internetReachability startNotifier];
}

/*!
 * Called by Reachability whenever status changes.
 */
- (void)reachabilityChanged:(NSNotification *)note{
    Reachability* curReach = [note object];
    NSParameterAssert([curReach isKindOfClass:[Reachability class]]);
//    NSLog(@"====%@",@([curReach currentReachabilityStatus]));
    
    NetworkStatus status = [curReach currentReachabilityStatus];
    if (status == ReachableViaWiFi) {
        _isReachable = YES;
        _isReachableWifi = YES;
    }else if (status == ReachableViaWWAN) {
        _isReachable = YES;
        _isReachableWifi = NO;
    }else {
        _isReachable = NO;
        _isReachableWifi = NO;
    }
    
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
