//
//  HGDefaultHTTPService.m
//  HGInitiation
//
//  Created by __无邪_ on 2017/12/25.
//  Copyright © 2017年 __无邪_. All rights reserved.
//

#import "HGDefaultHTTPService.h"
#import "AFNetworking.h"

@interface HGDefaultHTTPService ()
@property (nonatomic, strong) AFHTTPSessionManager *httpManager;

@end

@implementation HGDefaultHTTPService

#pragma mark -
- (instancetype)init{
    self = [super init];
    if (self) {
        
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        configuration.timeoutIntervalForRequest = kHTTPTimeoutIntervalForRequest;
        
        self.httpManager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:configuration];
        self.httpManager.securityPolicy.validatesDomainName = NO;
        self.httpManager.requestSerializer = [AFJSONRequestSerializer serializer];
        [self.httpManager.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        //((AFJSONResponseSerializer *)self.httpManager.responseSerializer).removesKeysWithNullValues = YES;
        
    }
    return self;
}



#pragma mark - Public
/// post 请求
- (NSURLSessionDataTask *)POST:(NSString *)URLString params:(id)parameters completed:(HGHTTPResultHandler)completed{
    return [self.httpManager POST:URLString parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self handleResponse:responseObject task:task completedHandler:completed];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self handleError:error task:task completedHandler:completed];
    }];
}

/// get 请求
- (NSURLSessionDataTask *)GET:(NSString *)URLString params:(id)parameters completed:(HGHTTPResultHandler)completed{
    NSMutableDictionary *allparameters = [[NSMutableDictionary alloc] initWithDictionary:parameters];
    return [self.httpManager GET:URLString parameters:allparameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self handleResponse:responseObject task:task completedHandler:completed];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self handleError:error task:task completedHandler:completed];
    }];
    
}

/// delete 请求
- (NSURLSessionDataTask *)DELETE:(NSString *)URLString params:(id)parameters completed:(HGHTTPResultHandler)completed{
    return [self.httpManager DELETE:URLString parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self handleResponse:responseObject task:task completedHandler:completed];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self handleError:error task:task completedHandler:completed];
    }];
    
}
/// form 请求
- (NSURLSessionDataTask *)POSTForm:(NSString *)URLString params:(id)parameters completed:(HGHTTPResultHandler)completed{
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:parameters options:NSJSONWritingPrettyPrinted error:nil];
    return [self.httpManager POST:URLString parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFormData:jsonData name:@"data"];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self handleResponse:responseObject task:task completedHandler:completed];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self handleError:error task:task completedHandler:completed];
    }];
}
/// 上传小文件
- (NSURLSessionDataTask *)UPLOAD:(NSString *)URLString file:(NSString *)file data:(NSData *)data name:(NSString *)name type:(NSString *)type progress:(HGHTTPProgressHandler)progress completed:(HGHTTPResultHandler)completed{
    NSParameterAssert(type);
    return [self.httpManager POST:URLString parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSString *fileName = name;
        if (!fileName) {
            fileName =  [NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]];
        }
        fileName = [NSString stringWithFormat:@"%@.%@",fileName,type];
        [formData appendPartWithFileData:data name:file fileName:fileName mimeType:@"multipart/form-data"];
    } progress:progress success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self handleResponse:responseObject task:task completedHandler:completed];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self handleError:error task:task completedHandler:completed];
    }];
}



- (void)abort {
    if ([self canAbort]) {
        for (NSURLSessionTask *task in self.httpManager.dataTasks) {
            [task cancel];
        }
    }
}

- (BOOL)canAbort {
    if (self.httpManager.tasks) {
        for (NSURLSessionTask *task in self.httpManager.dataTasks) {
            if (task.state == NSURLSessionTaskStateRunning) {
                return YES;
            }
        }
    }
    return NO;
}

#pragma mark - Deal data methods

- (void)handleResponse:(id)response task:(NSURLSessionDataTask *)task completedHandler:(HGHTTPResultHandler)completed{
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
    NSInteger statusCode = httpResponse.statusCode;
    if (statusCode >= 200 && statusCode < 300 && response) {
        completed(YES,nil,[response copy]);
    }else{
        completed(NO,[NSHTTPURLResponse localizedStringForStatusCode:statusCode],nil);
    }
    
}
- (void)handleError:(NSError *)Error task:(NSURLSessionDataTask *)task completedHandler:(HGHTTPResultHandler)completed{
    NSLog(@"【$$$$ERROR!!】%@",Error);
    completed(NO,Error.localizedDescription,nil);
}



@end
