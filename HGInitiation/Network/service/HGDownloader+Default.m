//
//  HGDownloader+Default.m
//  HGInitiation
//
//  Created by __无邪_ on 2018/3/29.
//  Copyright © 2018年 __无邪_. All rights reserved.
//

#import "HGDownloader+Default.h"

@implementation HGDownloader (Default)


#pragma mark - SHARED INSTANCE

+ (instancetype)defaultInstance{
    static HGDownloader *downloader;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        downloader = [[HGDownloader alloc] initWithIdentifier:HGDownloaderDefaultIdentifier allowsCellularAccess:YES completed:^(HGDownloader *downloader, id<HGDownloadItem>item, NSURL *location) {
            NSLog(@"------------%@ %@",item.progress,location.path);
        }];
    });
    return downloader;
}


@end
