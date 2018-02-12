//
//  HGHTTPClient.h
//  HGInitiation
//
//  Created by __无邪_ on 2017/12/25.
//  Copyright © 2017年 __无邪_. All rights reserved.
//

#import "HGDefaultHTTPService.h"

@interface HGHTTPClient : NSObject
+ (instancetype)sharedInstance;

// 获取emojies
- (NSURLSessionDataTask *)fetchEmojies:(HGHTTPResultHandler)completed;
// 获取电影列表，可能需要翻墙才能访问
- (NSURLSessionDataTask *)fetchMovies:(HGHTTPResultHandler)completed;

/// Available Currency Symbols & Get symbol info
- (NSURLSessionDataTask *)fetchSymbols:(HGHTTPResultHandler)completed;
- (NSURLSessionDataTask *)fetchSymbolInfo:(NSString *)symbolId completed:(HGHTTPResultHandler)completed;
/// Available Currencies & Get currency info
- (NSURLSessionDataTask *)fetchCurrencies:(HGHTTPResultHandler)completed;
- (NSURLSessionDataTask *)fetchCurrencyInfo:(NSString *)currencyId completed:(HGHTTPResultHandler)completed;
/// Ticker list for all symbols & Ticker for symbol
/// The Ticker endpoint returns last 24H information about symbol.
- (NSURLSessionDataTask *)fetchTickers:(HGHTTPResultHandler)completed;
- (NSURLSessionDataTask *)fetchTicker4Symbol:(NSString *)symbolId completed:(HGHTTPResultHandler)completed;
/// Trades
- (NSURLSessionDataTask *)fetchTrades:(NSString *)symbolId completed:(HGHTTPResultHandler)completed;
/// Orderbook
- (NSURLSessionDataTask *)fetchOrderbook:(NSString *)symbolId completed:(HGHTTPResultHandler)completed;
/// Candles
- (NSURLSessionDataTask *)fetchCandles:(NSString *)symbolId completed:(HGHTTPResultHandler)completed;


@end
