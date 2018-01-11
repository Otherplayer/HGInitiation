//
//  UIScrollView+HGRefresh.h
//  HGInitiation
//
//  Created by __无邪_ on 2018/1/11.
//  Copyright © 2018年 __无邪_. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void (^HGRefreshComponentRefreshingBlock)(void);

@interface UIScrollView (HGRefresh)

#pragma mark - 上拉加载，下拉刷新

- (void)addRefreshingHeader:(HGRefreshComponentRefreshingBlock)refreshingBlock;
- (void)addRefreshingFooter:(HGRefreshComponentRefreshingBlock)refreshingBlock;

- (void)beginRefreshing;//开始刷新
- (void)endRefreshing;//结束刷新
- (void)endRefreshingWithNoMoreData;//没有数据调用此方法

- (void)removeRefreshingHeader;
- (void)removeRefreshingFooter;

@end
