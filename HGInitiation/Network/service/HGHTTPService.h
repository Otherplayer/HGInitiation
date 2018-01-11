//
//  HGHTTPService.h
//  HGInitiation
//
//  Created by __无邪_ on 2017/12/25.
//  Copyright © 2017年 __无邪_. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol HGHTTPServiceProtocol

typedef void (^HGHTTPResultHandler)(BOOL success, NSString *errDesc, id responseData);
typedef void (^HGHTTPProgressHandler)(NSProgress *uploadProgress);

/// POST 请求
- (NSURLSessionDataTask *)POST:(NSString *)URLString
                        params:(id)parameters
                     completed:(HGHTTPResultHandler)completed;
/// GET 请求
- (NSURLSessionDataTask *)GET:(NSString *)URLString
                       params:(id)parameters
                    completed:(HGHTTPResultHandler)completed;
/// DELETE 请求
- (NSURLSessionDataTask *)DELETE:(NSString *)URLString
                          params:(id)parameters
                       completed:(HGHTTPResultHandler)completed;
/// FORM 请求
- (NSURLSessionDataTask *)POSTForm:(NSString *)URLString
                            params:(id)parameters
                         completed:(HGHTTPResultHandler)completed;
/// 上传文件
- (NSURLSessionDataTask *)UPLOAD:(NSString *)URLString
                            file:(NSString *)file //服务端标识eg:file
                            data:(NSData *)data   //要上传的数据
                            name:(NSString *)name //上传文件名称 如果不存在会自动生成一个
                            type:(NSString *)type //上传文件类型eg:jpg
                        progress:(HGHTTPProgressHandler)progress
                       completed:(HGHTTPResultHandler)completed;
- (void)abort;


@end
