//
//  HYQHelperReachibility.h
//  HYQark
//
//  Created by __无邪_ on 15/5/5.
//  Copyright (c) 2015年 __无邪_. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    HGNetWorkTypeNoService = 0,
    HGNetWorkType2G = 1,
    HGNetWorkType3G = 2,
    HGNetWorkType4G = 3,
    HGNetWorkTypeWiFi = 5,
    HGNetWorkTypeUnknow
} HGNetWorkType;


#define Internet [HGHelperReachability sharedInstance]

@interface HGHelperReachability : NSObject

@property(nonatomic,readonly,assign) BOOL isReachable;
@property(nonatomic,readonly,assign) BOOL isReachableWifi;

@property(nonatomic,readonly,assign) HGNetWorkType netWorkType;


//@property (nonatomic, strong) NSString *wifiName;

+ (HGHelperReachability *)sharedInstance;
- (void)startMonitoring;



@end
