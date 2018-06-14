//
//  UIScrollView+HGRefresh.m
//  HGInitiation
//
//  Created by __无邪_ on 2018/1/11.
//  Copyright © 2018年 __无邪_. All rights reserved.
//

#import "UIScrollView+HGRefresh.h"
#import "MJRefresh.h"

@implementation UIScrollView (HGRefresh)
- (void)addRefreshingHeader:(HGRefreshComponentRefreshingBlock)refreshingBlock{
    
    if (!self.mj_header) {
        MJRefreshStateHeader *header = [MJRefreshStateHeader headerWithRefreshingBlock:^{
            refreshingBlock();
        }];
        // 隐藏时间
        header.lastUpdatedTimeLabel.hidden = YES;
        // 隐藏状态
        //        header.stateLabel.hidden = YES;
        header.mj_h = 40;
        header.pullingPercent = 0.7;
        
        [header setTitle:@"下拉刷新数据" forState:MJRefreshStateIdle];
        [header setTitle:@"松开开始刷新" forState:MJRefreshStatePulling];
        [header setTitle:@"拼命刷新中 ..." forState:MJRefreshStateRefreshing];
        
        header.stateLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightThin];
        header.stateLabel.textColor = [UIColor colorWithWhite:1 alpha:0.75];
        
        self.mj_header = header;
        self.mj_header.backgroundColor = [UIColor redColor];
        
        self.mj_header.automaticallyChangeAlpha = YES;
    }
}

- (void)addRefreshingFooter:(HGRefreshComponentRefreshingBlock)refreshingBlock{
    
    if (!self.mj_footer) {
        MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:refreshingBlock];
        [footer setTitle:@"上拉加载更多" forState:MJRefreshStateIdle];
        [footer setTitle:@"拼命加载中 ..." forState:MJRefreshStateRefreshing];
        [footer setTitle:@"看，灰机~" forState:MJRefreshStateNoMoreData];
        
        footer.stateLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightThin];
        
        self.mj_footer = footer;
    }
}

- (void)beginRefreshing{
    if (self.mj_header) {
        [self.mj_header beginRefreshing];
    }
}

- (void)endRefreshing{
    [self endHeaderRefreshing];
    [self endFooterRefreshing];
}

- (void)removeRefreshingHeader{
    if (self.mj_header) {
        [self.mj_header removeFromSuperview];
        self.mj_header = nil;
    }
}
- (void)removeRefreshingFooter{
    if (self.mj_footer) {
        [self.mj_footer removeFromSuperview];
        self.mj_footer = nil;
    }
}
- (void)endHeaderRefreshing{
    if (self.mj_header.isRefreshing) {
        [self.mj_header endRefreshing];
    }
    [self resetNoMoreData];
}
- (void)endFooterRefreshing{
    if (self.mj_footer.isRefreshing) {
        [self.mj_footer endRefreshing];
    }
}
- (void)endRefreshingWithNoMoreData{
    if (self.mj_footer) {
        [self.mj_footer endRefreshingWithNoMoreData];
    }
}
- (void)resetNoMoreData{
    if (self.mj_footer) {
        [self.mj_footer resetNoMoreData];
    }
}
@end
