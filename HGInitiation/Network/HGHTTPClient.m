//
//  HGHTTPClient.m
//  HGInitiation
//
//  Created by __无邪_ on 2017/12/25.
//  Copyright © 2017年 __无邪_. All rights reserved.
//

#import "HGHTTPClient.h"

@interface HGHTTPClient ()
@property (nonatomic, strong) id<HGHTTPServiceProtocol> service;
@end

@implementation HGHTTPClient
- (NSURLSessionDataTask *)fetchEmojies:(HGHTTPResultHandler)completed {
    NSURLSessionDataTask *dataTask = [self.service GET:[self urlGithub:@"emojis"] params:nil completed:completed];
    return dataTask;
}
- (NSURLSessionDataTask *)fetchMovies:(HGHTTPResultHandler)completed {
    return [self.service GET:@"https://raw.githubusercontent.com/facebook/react-native/0.51-stable/docs/MoviesExample.json" params:nil completed:completed];
}
#pragma mark - symbol
- (NSURLSessionDataTask *)fetchSymbols:(HGHTTPResultHandler)completed {
    NSURLSessionDataTask *dataTask = [self.service GET:[self urlDefault:@"public/symbol"]
                                                params:nil
                                             completed:completed];
    return dataTask;
}
- (NSURLSessionDataTask *)fetchSymbolInfo:(NSString *)symbolId completed:(HGHTTPResultHandler)completed {
    NSURLSessionDataTask *dataTask = [self.service GET:[self urlDefault:[@"public/symbol/" stringByAppendingString:symbolId]]
                                                params:nil
                                             completed:completed];
    return dataTask;
}
#pragma mark - currency
- (NSURLSessionDataTask *)fetchCurrencies:(HGHTTPResultHandler)completed {
    NSURLSessionDataTask *dataTask = [self.service GET:[self urlDefault:@"public/currency"]
                                                params:nil
                                             completed:completed];
    return dataTask;
}
- (NSURLSessionDataTask *)fetchCurrencyInfo:(NSString *)currencyId completed:(HGHTTPResultHandler)completed {
    NSURLSessionDataTask *dataTask = [self.service GET:[self urlDefault:[@"public/currency/" stringByAppendingString:currencyId]]
                                                params:nil
                                             completed:completed];
    return dataTask;
}
#pragma mark - ticker
- (NSURLSessionDataTask *)fetchTickers:(HGHTTPResultHandler)completed {
    NSURLSessionDataTask *dataTask = [self.service GET:[self urlDefault:@"public/ticker"]
                                                params:nil
                                             completed:completed];
    return dataTask;
}
- (NSURLSessionDataTask *)fetchTicker4Symbol:(NSString *)symbolId completed:(HGHTTPResultHandler)completed {
    NSURLSessionDataTask *dataTask = [self.service GET:[self urlDefault:[@"public/ticker/" stringByAppendingString:symbolId]]
                                                params:nil
                                             completed:completed];
    return dataTask;
}
#pragma mark - trades
- (NSURLSessionDataTask *)fetchTrades:(NSString *)symbolId completed:(HGHTTPResultHandler)completed {
    NSURLSessionDataTask *dataTask = [self.service GET:[self urlDefault:[@"public/trades/" stringByAppendingString:symbolId]]
                                                params:nil
                                             completed:completed];
    return dataTask;
}
#pragma mark - orderbook
- (NSURLSessionDataTask *)fetchOrderbook:(NSString *)symbolId completed:(HGHTTPResultHandler)completed {
    NSURLSessionDataTask *dataTask = [self.service GET:[self urlDefault:[@"public/orderbook/" stringByAppendingString:symbolId]]
                                                params:nil
                                             completed:completed];
    return dataTask;
}
#pragma mark - candles
- (NSURLSessionDataTask *)fetchCandles:(NSString *)symbolId completed:(HGHTTPResultHandler)completed {
    NSURLSessionDataTask *dataTask = [self.service GET:[self urlDefault:[@"public/candles/" stringByAppendingString:symbolId]]
                                                params:nil
                                             completed:completed];
    return dataTask;
}
#pragma mark - BASE URL

- (NSString *)urlDefault:(NSString *)target {
    return [NSString stringWithFormat:@"%@%@",BASE_API_URL,target];
}
- (NSString *)urlGithub:(NSString *)target {
    return [NSString stringWithFormat:@"%@%@",BASE_GITHUB_URL,target];
}

#pragma mark - SHARED INSTANCE
+ (instancetype)sharedInstance{
    static HGHTTPClient *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[HGHTTPClient alloc] init];
        manager.service = [[HGDefaultHTTPService alloc] init];
    });
    return manager;
}
@end
