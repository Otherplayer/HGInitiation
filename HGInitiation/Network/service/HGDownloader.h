//
//  HGDownloadManager.h
//  HGInitiation
//
//  Created by __无邪_ on 2018/3/27.
//  Copyright © 2018年 __无邪_. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^HGDownloadStartHandler)(NSDictionary *startInfo);
typedef void (^HGDownloadProgressHandler)(NSProgress *progress);
typedef void (^HGDownloadCompletedHandler)(BOOL success, NSString *errDesc, NSString *path);

extern NSString *const kNSURLSessionResumeBytesTotalUnitCount;
extern NSString *const kNSURLSessionResumeBytesCompletedUnitCount;

@interface HGDownloader : NSObject

- (void)downloadWithUrlString:(NSString *)URLString
                    localInfo:(HGDownloadStartHandler)localInfoHandler
                     progress:(HGDownloadProgressHandler)progress completed:(HGDownloadCompletedHandler)completed;
- (void)start;
- (void)stop;

@end
