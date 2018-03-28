//
//  HGDownloadManager.m
//  HGInitiation
//
//  Created by __无邪_ on 2018/3/27.
//  Copyright © 2018年 __无邪_. All rights reserved.
//

#import "HGDownloader.h"
#import <AFNetworking.h>
#import "HGHTTPConfiguration.h"

@interface HGDownloader()
@property(nonatomic, strong) NSURLSessionDownloadTask *downloadTask;
@property(nonatomic, strong) AFURLSessionManager *manager;
@property(nonatomic, strong) NSUserDefaults *userDefaults;
@property(nonatomic, copy) NSString *targetUrl;
@property(nonatomic, copy) HGDownloadProgressHandler progressHandler;
@property(nonatomic, copy) HGDownloadCompletedHandler completedHandler;

@end

@implementation HGDownloader

//https://www.jianshu.com/p/1211cf99dfc3
//https://blog.csdn.net/u012361288/article/details/54615919

- (void)download:(NSString *)URLString config:(HGDownloadStartHandler)configHandler progress:(HGDownloadProgressHandler)progress completed:(HGDownloadCompletedHandler)completed{
    
    self.targetUrl = URLString;
    self.progressHandler = progress;
    self.completedHandler = completed;
    
    __weak typeof(self) weakSelf = self;
    
    NSString *fileName = URLString.lastPathComponent;
    NSString *targetPath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:fileName];
    
    
    NSString *key = [self cacheKeyForURL:self.targetUrl];
    NSData *resumeData = [self.userDefaults objectForKey:key];
    if (resumeData) {
        NSString *info = [NSString.alloc initWithData:resumeData encoding:NSUTF8StringEncoding];
        if (configHandler) {
            configHandler(@{@"info":info});
        }
    }
    
    
    [self.manager setDownloadTaskDidWriteDataBlock:^(NSURLSession * _Nonnull session, NSURLSessionDownloadTask * _Nonnull downloadTask, int64_t bytesWritten, int64_t totalBytesWritten, int64_t totalBytesExpectedToWrite) {
        if (!weakSelf.downloadTask) {
            weakSelf.downloadTask = downloadTask;
        }
        [weakSelf.userDefaults setObject:@(totalBytesExpectedToWrite) forKey:[weakSelf cacheKeyForTotalFileSize:key]];
    }];
    [self.manager setDownloadTaskDidFinishDownloadingBlock:^NSURL * _Nullable(NSURLSession * _Nonnull session, NSURLSessionDownloadTask * _Nonnull downloadTask, NSURL * _Nonnull location) {
        return targetPath.url;
    }];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:URLString.url];
    self.downloadTask = [self.manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        self.progressHandler(downloadProgress);
    } destination:nil completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        
        if (error) {
            // check if resume data are available
            if ([error.userInfo objectForKey:NSURLSessionDownloadTaskResumeData]) {
                
            }else {
                self.completedHandler(NO, error.localizedDescription, filePath.path);
            }
        }else{
            self.completedHandler(YES, error.localizedDescription, filePath.path);
        }
    }];
    
}

- (void)start {
    
    NSString *key = [self cacheKeyForURL:self.targetUrl];
    NSData *resumeData = [self.userDefaults objectForKey:key];
    if (resumeData) {
        self.downloadTask = [self.manager downloadTaskWithResumeData:resumeData progress:^(NSProgress * _Nonnull downloadProgress) {
            self.progressHandler(downloadProgress);
        } destination:nil completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
            if (error) {
                // check if resume data are available
                if ([error.userInfo objectForKey:NSURLSessionDownloadTaskResumeData]) {
                    
                }else {
                    self.completedHandler(NO, error.localizedDescription, filePath.path);
                }
            }else{
                self.completedHandler(YES, error.localizedDescription, filePath.path);
            }
        }];
        [self.downloadTask resume];
    }else{
        [self.downloadTask resume];
        self.downloadTask = nil;
        [self.userDefaults removeObjectForKey:key];
    }
}

- (void)stop {
//    [self.downloadTask suspend];
    __weak typeof(self) weakSelf = self;
    NSString *key = [self cacheKeyForURL:self.targetUrl];
    [self.downloadTask cancelByProducingResumeData:^(NSData * _Nullable resumeData) {
        if (resumeData && [weakSelf __isValidResumeData:resumeData]) {
            [weakSelf.userDefaults setObject:resumeData forKey:key];
            [weakSelf.userDefaults synchronize];
        }
    }];
}

#pragma mark - Private

- (NSString *)cacheKeyForURL:(NSString *)urlStr {
    if (!urlStr) { return nil; }
    return [urlStr.url.absoluteString hgMD5HexLower];
}
- (NSString *)cacheKeyForTotalFileSize:(NSString *)key {
    return [key stringByAppendingString:@"-size"];
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
- (NSUserDefaults *)userDefaults {
    if (!_userDefaults) {
        _userDefaults = [NSUserDefaults standardUserDefaults];
    }
    return _userDefaults;
}

@end
