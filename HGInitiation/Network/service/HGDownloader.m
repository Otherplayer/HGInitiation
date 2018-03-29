//
//  HGDownloadManager.m
//  HGInitiation
//
//  Created by __无邪_ on 2018/3/27.
//  Copyright © 2018年 __无邪_. All rights reserved.
//

#import "HGDownloader.h"
#import <AFNetworking.h>

NSString *const HGURLSessionResumeBytesTotalUnitCount = @"NSURLSessionResumeBytesTotalUnitCount";
NSString *const HGURLSessionResumeBytesCompletedUnitCount = @"NSURLSessionResumeBytesReceived";

@interface HGDownloader()
@property(nonatomic, strong) NSURLSessionDownloadTask *downloadTask;
@property(nonatomic, strong) AFURLSessionManager *manager;
@property(nonatomic, copy) NSString *targetUrl;
@property(nonatomic, copy) HGDownloadProgressHandler progressHandler;
@property(nonatomic, copy) HGDownloadCompletedHandler completedHandler;
@property(nonatomic, assign) int64_t totalUnitCount;

@end

@implementation HGDownloader

//https://www.jianshu.com/p/1211cf99dfc3
//https://blog.csdn.net/u012361288/article/details/54615919

- (void)downloadWithUrlString:(NSString *)URLString localInfo:(HGDownloadStartHandler)localInfoHandler progress:(HGDownloadProgressHandler)progress completed:(HGDownloadCompletedHandler)completed{
    [self downloadWithUrlString:URLString coverLocal:NO localInfo:localInfoHandler progress:progress completed:completed];
}
- (void)downloadWithUrlString:(NSString *)URLString coverLocal:(BOOL)coverLocal localInfo:(HGDownloadStartHandler)localInfoHandler progress:(HGDownloadProgressHandler)progress completed:(HGDownloadCompletedHandler)completed {
    self.targetUrl = URLString;
    self.progressHandler = progress;
    self.completedHandler = completed;
    
    __weak typeof(self) weakSelf = self;
    
    NSString *fileName = URLString.lastPathComponent;
    NSString *targetPath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:fileName];
    
    
    NSString *key = [self cacheKeyForUrlString:self.targetUrl];
    
    if (coverLocal) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
    }
    if (localInfoHandler) {
        NSMutableDictionary *resumeDictionary;
        NSError *error;
        NSData *resumeData = [[NSUserDefaults standardUserDefaults] objectForKey:key];
        if (resumeData) {
            resumeDictionary = [NSPropertyListSerialization propertyListWithData:resumeData options:NSPropertyListImmutable format:NULL error:&error];
        }
        if (resumeDictionary && !error) {
            localInfoHandler(resumeDictionary);
        }else {
            localInfoHandler(nil);
        }
    }
    
    [self.manager setDownloadTaskDidWriteDataBlock:^(NSURLSession * _Nonnull session, NSURLSessionDownloadTask * _Nonnull downloadTask, int64_t bytesWritten, int64_t totalBytesWritten, int64_t totalBytesExpectedToWrite) {
        if (!weakSelf.downloadTask) {
            weakSelf.downloadTask = downloadTask;
        }
    }];
    [self.manager setDownloadTaskDidFinishDownloadingBlock:^NSURL * _Nullable(NSURLSession * _Nonnull session, NSURLSessionDownloadTask * _Nonnull downloadTask, NSURL * _Nonnull location) {
        return targetPath.url;
    }];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:URLString.url];
    self.downloadTask = [self.manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        [weakSelf downloadProgress:downloadProgress];
    } destination:nil completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        [weakSelf downloadCompleted:response path:filePath error:error];
    }];
}


- (void)start {
    
    __weak typeof(self) weakSelf = self;
    NSString *key = [self cacheKeyForUrlString:self.targetUrl];
    NSData *resumeData = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    
    if (resumeData) {
        self.downloadTask = [self.manager downloadTaskWithResumeData:resumeData progress:^(NSProgress * _Nonnull downloadProgress) {
            [weakSelf downloadProgress:downloadProgress];
        } destination:nil completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
            [weakSelf downloadCompleted:response path:filePath error:error];
        }];
        [self.downloadTask resume];
    }else{
        [self.downloadTask resume];
        self.downloadTask = nil;
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
    }
}

- (void)stop {
    __weak typeof(self) weakSelf = self;
    NSString *key = [self cacheKeyForUrlString:self.targetUrl];
    [self.downloadTask cancelByProducingResumeData:^(NSData * _Nullable resumeData) {
        if (!resumeData) {
            return ;
        }
        NSError *error;
        NSMutableDictionary *resumeDictionary = [NSPropertyListSerialization propertyListWithData:resumeData options:NSPropertyListImmutable format:NULL error:&error];
        [resumeDictionary setObject:@(weakSelf.totalUnitCount) forKey:HGURLSessionResumeBytesTotalUnitCount];
        if (error) {
            return;
        }
        NSData *data = [NSPropertyListSerialization dataWithPropertyList:resumeDictionary format:NSPropertyListXMLFormat_v1_0 options:NSPropertyListImmutable error:&error];
        if (error) {
            return;
        }
        
        [[NSUserDefaults standardUserDefaults] setObject:data forKey:key];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }];
}

- (void)cancel {
    [self.downloadTask cancel];
    self.downloadTask = nil;
    self.totalUnitCount = 0;
    NSString *key = [self cacheKeyForUrlString:self.targetUrl];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark -
- (void)downloadProgress:(NSProgress *)downloadProgress {
    self.totalUnitCount = downloadProgress.totalUnitCount;
    self.progressHandler(downloadProgress);
}
- (void)downloadCompleted:(NSURLResponse *)response path:(NSURL *)filePath error:(NSError *)error {
    NSString *key = [self cacheKeyForUrlString:self.targetUrl];
    if (error) {
        if (![error.userInfo objectForKey:NSURLSessionDownloadTaskResumeData]) {
            self.completedHandler(NO, error.localizedDescription, filePath.path);
        }
    }else{
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
        self.downloadTask = nil;
        self.completedHandler(YES, error.localizedDescription, filePath.path);
    }
}

#pragma mark - Private

- (NSString *)cacheKeyForUrlString:(NSString *)urlStr {
    if (!urlStr) { return nil; }
    return [urlStr.url.absoluteString hgMD5HexLower];
}
- (BOOL)__isValidResumeData:(NSData *)data{
    return YES;
//    if (!data || [data length] < 1) return NO;
//
//    NSError *error;
//    NSDictionary *resumeDictionary = [NSPropertyListSerialization propertyListWithData:data options:NSPropertyListImmutable format:NULL error:&error];
//    if (!resumeDictionary || error) return NO;
//
//    NSString *localFilePath = [resumeDictionary objectForKey:@"NSURLSessionResumeInfoLocalPath"];
//    if ([localFilePath length] < 1) return NO;
//
//    return [[NSFileManager defaultManager] fileExistsAtPath:localFilePath];
}

- (AFURLSessionManager *)manager {
    if (!_manager) {
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        configuration.timeoutIntervalForRequest = DBL_MAX;
        _manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    }
    return _manager;
}

@end
