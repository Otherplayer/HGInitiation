//
//  HGDownloadManager.h
//  HGInitiation
//
//  Created by __无邪_ on 2018/3/27.
//  Copyright © 2018年 __无邪_. All rights reserved.
//

#import <Foundation/Foundation.h>
@class HGDownloader;

extern NSString *const HGDownloaderDefaultIdentifier;

typedef void (^HGDownloadProgressHandler)(NSProgress *progress);
typedef void (^HGDownloadCompletedHandler)(HGDownloader *downloader, NSURL *url, NSURL *location);

@interface HGDownloader : NSObject

- (void)setDidFinishEventsForBackgroundURLSessionBlock:(void (^)(NSURLSession *session))block;
- (instancetype)initWithIdentifier:(NSString *)identifier
              allowsCellularAccess:(BOOL)allowsCellularAccess
                          progress:(HGDownloadProgressHandler)progress completed:(HGDownloadCompletedHandler)completed;

- (void)startDownloadWithURL:(NSURL *)url; /// 开始或者恢复
- (void)stopDownloadWithURL:(NSURL *)url;  /// 暂停

@end


@interface HGDownloader (Default)

+ (instancetype)defaultInstance;

@end

