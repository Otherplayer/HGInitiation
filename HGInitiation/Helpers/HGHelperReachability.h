//
//  HYQHelperReachibility.h
//  HYQark
//
//  Created by __无邪_ on 15/5/5.
//  Copyright (c) 2015年 __无邪_. All rights reserved.
//

#import <Foundation/Foundation.h>


#define Internet [HGHelperReachability sharedInstance]

@interface HGHelperReachability : NSObject

@property(nonatomic,readonly,assign) BOOL isReachable;
@property(nonatomic,readonly,assign) BOOL isReachableWifi;

+ (HGHelperReachability *)sharedInstance;
- (void)startMonitoring;



@end
