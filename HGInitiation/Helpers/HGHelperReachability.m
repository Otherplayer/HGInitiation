//
//  HYQHelperReachibility.m
//  HYQark
//
//  Created by __无邪_ on 15/5/5.
//  Copyright (c) 2015年 __无邪_. All rights reserved.
//

#import "HGHelperReachability.h"
#import "Reachability.h"

NSString *HGReachabilityChangedNotification = @"HGReachabilityChangedNotification";

@interface HGHelperReachability ()
@property(nonatomic, readwrite, assign) BOOL isReachable;
@property(nonatomic, readwrite, assign) BOOL isReachableWifi;
@property(nonatomic, strong) Reachability *internetReachability;
@end

@implementation HGHelperReachability
- (instancetype)init {
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(reachabilityChanged:)
                                                     name:kReachabilityChangedNotification
                                                   object:nil];
        self.internetReachability = [Reachability reachabilityForInternetConnection];
    }
    return self;
}

#pragma mark - Public

+ (HGHelperReachability *)sharedInstance {
    static HGHelperReachability *reachability = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        reachability = [[HGHelperReachability alloc] init];
    });
    return reachability;
}

- (BOOL)isReachable {
    NetworkStatus status = [self.internetReachability currentReachabilityStatus];
    if (status == NotReachable) {
        NSLog(@"【Attention】无网络连接❗️❗️❗️❗️❗️❗️❗️❗️❗️");
        return NO;
    }
    NSLog(@"【Good Job!】网络连接正常🌴🌴🌴🌴🌴🌴🌴🌴");
    return YES;
}
- (BOOL)isReachableWifi {
    NetworkStatus status = [self.internetReachability currentReachabilityStatus];
    if (status == ReachableViaWiFi) {
        return YES;
    }
    return NO;
}

- (void)startNotifier{
    [self.internetReachability startNotifier];
}

#pragma mark - Private

/*!
 * Called by Reachability whenever status changes.
 */
- (void)reachabilityChanged:(NSNotification *)note{
    Reachability *curReach = [note object];
    NSParameterAssert([curReach isKindOfClass:[Reachability class]]);
    
    NetworkStatus status = [curReach currentReachabilityStatus];
    [[NSNotificationCenter defaultCenter] postNotificationName:HGReachabilityChangedNotification object:@(status)];
    
    if (status == NotReachable) {
        NSLog(@"【Attention】网络连接已断开❗️❗️❗️❗️❗️❗️❗️❗️❗️");
    }else {
        NSLog(@"【Good Job!】网络已联通🌴🌴🌴🌴🌴🌴🌴🌴");
    }
}


@end
