//
//  HGDownloadManager.h
//  HGInitiation
//
//  Created by __无邪_ on 2018/3/27.
//  Copyright © 2018年 __无邪_. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HGDownloadItem.h"
@class HGDownloader;

typedef void (^HGDownloadProgressHandler)(NSProgress *progress);
typedef void (^HGDownloadCompletedHandler)(HGDownloader *downloader, id<HGDownloadItem>item, NSURL *location);

extern NSString *const HGDownloaderDefaultIdentifier;
extern NSString *const HGURLSessionResumeBytesTotalUnitCount;
extern NSString *const HGURLSessionResumeBytesCompletedUnitCount;


@interface HGDownloader : NSObject

- (instancetype)initWithIdentifier:(NSString *)identifier
              allowsCellularAccess:(BOOL)allowsCellularAccess
                         completed:(HGDownloadCompletedHandler)completed;

- (void)setDidFinishEventsForBackgroundURLSessionBlock:(void (^)(NSURLSession *session))block;

- (void)startDownloadWithItem:(id<HGDownloadItem>)downloadItem; /// 开始或者恢复
- (void)stopDownloadWithItem:(id<HGDownloadItem>)downloadItem;  /// 暂停


@end



