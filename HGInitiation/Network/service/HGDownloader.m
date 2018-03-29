//
//  HGDownloadManager.m
//  HGInitiation
//
//  Created by __无邪_ on 2018/3/27.
//  Copyright © 2018年 __无邪_. All rights reserved.
//

#import "HGDownloader.h"
#import <AFNetworking.h>

NSString *const HGDownloaderDefaultIdentifier = @"HGDownloaderDefaultIdentifier";

@interface HGDownloader()
@property(nonatomic, strong) NSURLSessionDownloadTask *downloadTask;
@property(nonatomic, strong) AFHTTPSessionManager *httpManager;
@property(nonatomic, strong) NSMutableDictionary *tasks;
@property(nonatomic, copy) HGDownloadProgressHandler progressHandler;
@property(nonatomic, copy) HGDownloadCompletedHandler completedHandler;

@end

@implementation HGDownloader

// https://forums.developer.apple.com/thread/14854

- (instancetype)initWithIdentifier:(NSString *)identifier allowsCellularAccess:(BOOL)allowsCellularAccess completed:(HGDownloadCompletedHandler)completed {
    
    self = [super init];
    
    if (self) {
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:identifier];
        configuration.timeoutIntervalForRequest = DBL_MAX;
        self.httpManager = [AFHTTPSessionManager.alloc initWithSessionConfiguration:configuration];
        self.httpManager.requestSerializer.allowsCellularAccess = allowsCellularAccess;
        self.tasks = [NSMutableDictionary.alloc init];
        self.completedHandler = completed;
    }
    return self;
}

- (void)setDidFinishEventsForBackgroundURLSessionBlock:(void (^)(NSURLSession *session))block {
    [self.httpManager setDidFinishEventsForBackgroundURLSessionBlock:block];
}



#pragma mark -

- (void)startDownloadWithItem:(id<HGDownloadItem>)downloadItem {
    
//    NSURLSessionDownloadTask *downloadTask = [self downloadTaskForItem:downloadItem];
//    if (downloadTask) {
//        [self resumeDownloadWithItem:downloadItem];
//        return;
//    }
    
    NSURLSessionDownloadTask *downloadTask = nil;
    
    __weak typeof(self) weakSelf = self;
    
    NSURL *url = downloadItem.URL;
    
    [self.httpManager setDownloadTaskDidFinishDownloadingBlock:^NSURL * _Nullable(NSURLSession * _Nonnull session, NSURLSessionDownloadTask * _Nonnull downloadTask, NSURL * _Nonnull location) {
        NSString *path = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:url.lastPathComponent];
        return path.url;
    }];
    void (^downloadProgressBlock)(NSProgress *downloadProgress) = ^(NSProgress *downloadProgress) {
        downloadItem.progress = downloadProgress;
        NSLog(@"%@",[downloadItem description]);
    };
    void (^completionHandler)(NSURLResponse *response, NSURL *filePath, NSError *error) = ^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (error) {
            if (![error.userInfo objectForKey:NSURLSessionDownloadTaskResumeData]) {
                NSLog(@"------下载失败");
            }
        }else{
            strongSelf.completedHandler(strongSelf,downloadItem,filePath);
            [strongSelf removeDownloadTaskForItem:downloadItem];
        }
    };
    
    NSData *resumeData = [self resumeDataForItem:downloadItem];
    if (resumeData) {
        downloadTask = [self.httpManager downloadTaskWithResumeData:resumeData progress:downloadProgressBlock destination:nil completionHandler:completionHandler];
    }else {
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        downloadTask = [self.httpManager downloadTaskWithRequest:request progress:downloadProgressBlock destination:nil completionHandler:completionHandler];
    }
    
    UIApplication *application = [UIApplication sharedApplication];
    __block UIBackgroundTaskIdentifier taskId = [application beginBackgroundTaskWithExpirationHandler:^{
        [application endBackgroundTask:taskId];
        taskId = UIBackgroundTaskInvalid;
    }];
    
    NSString *key = [self cacheKeyForURL:downloadItem.URL];
    self.tasks[key] = downloadTask;
    [downloadTask resume];
    
    if (taskId != UIBackgroundTaskInvalid) {
        [application endBackgroundTask:taskId];
        taskId = UIBackgroundTaskInvalid;
    }
}

- (void)resumeDownloadWithItem:(id<HGDownloadItem>)downloadItem {
    NSString *key = [self cacheKeyForURL:downloadItem.URL];
    NSURLSessionDownloadTask *downloadTask = self.tasks[key];
    [downloadTask resume];
}
- (void)stopDownloadWithItem:(id<HGDownloadItem>)downloadItem {
    NSURLSessionDownloadTask *downloadTask = [self downloadTaskForItem:downloadItem];
    __weak typeof(self) weakSelf = self;
    [downloadTask cancelByProducingResumeData:^(NSData * _Nullable resumeData) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if ([strongSelf isValidResumeData:resumeData]) {
            [strongSelf saveResumeData:resumeData forItem:downloadItem];
        }
    }];
}

- (NSURLSessionDownloadTask *)downloadTaskForItem:(id<HGDownloadItem>)downloadItem {
    NSString *key = [self cacheKeyForURL:downloadItem.URL];
    return self.tasks[key];
}
- (void)removeDownloadTaskForItem:(id<HGDownloadItem>)downloadItem {
    NSString *key = [self cacheKeyForURL:downloadItem.URL];
    [self.tasks removeObjectForKey:key];
}

- (void)saveResumeData:(NSData *)data forItem:(id <HGDownloadItem>)downloadItem {
    NSString *key = [self cacheKeyForURL:downloadItem.URL];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (NSData *)resumeDataForItem:(id <HGDownloadItem>)downloadItem {
    NSString *key = [self cacheKeyForURL:downloadItem.URL];
    NSData *resumeData = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    if ([self isValidResumeData:resumeData]) {
        return resumeData;
    }
    return nil;
}
- (BOOL)isValidResumeData:(NSData *)data{
    if (!data || [data length] < 1) return NO;
    
    NSError *error;
    NSDictionary *resumeDictionary = [NSPropertyListSerialization propertyListWithData:data options:NSPropertyListImmutable format:NULL error:&error];
    if (!resumeDictionary || error) return NO;
    
    return YES;
    
    //    NSString *localFilePath = [resumeDictionary objectForKey:@"NSURLSessionResumeInfoLocalPath"];
    //    if ([localFilePath length] < 1) return NO;
    //
    //    return [[NSFileManager defaultManager] fileExistsAtPath:localFilePath];
}

#pragma mark - Private

- (NSString *)cacheKeyForURL:(NSURL *)url {
    if (!url) { return nil; }
    return [url.absoluteString hgMD5HexLower];
}


@end
