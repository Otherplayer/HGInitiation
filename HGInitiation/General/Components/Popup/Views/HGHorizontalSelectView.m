//
//  HGMutilHorizontalScrollView.m
//  HGInitiation
//
//  Created by __无邪_ on 2018/6/6.
//  Copyright © 2018年 __无邪_. All rights reserved.
//

#import "HGHorizontalSelectView.h"
#import "HGHorizontalSelectTCell.h"
#import "HGSelectAdditionalView.h"

@interface HGHorizontalSelectView ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, strong)HGSelectViewHeader *headerView;
@property(nonatomic, strong)HGSelectViewFooter *footerView;
@property(nonatomic, strong)NSArray *items;
@end

@implementation HGHorizontalSelectView


- (instancetype)initWithItems:(NSArray *)items{
    self = [super init];
    if (self) {
        self.items = items;
        [self initiateTableViews];
    }
    return self;
}

#pragma mark - <UITableViewDataSource>

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.items.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *subItems = self.items[section];
    return subItems.count > 0 ? 1:0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HGHorizontalSelectTCell *cell = [tableView dequeueReusableCellWithIdentifier:HGIdentifier forIndexPath:indexPath];
    cell.items = self.items[indexPath.section];
    __weak typeof(self) weakSelf = self;
    [cell setDidTapHandler:^(NSInteger row) {
        if (weakSelf.didTapItemHandler) {
            weakSelf.didTapItemHandler(indexPath.section, row);
        }
    }];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kHGHorizontalSCCellHeight;
}
//设置分割线的位置
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

#pragma mark - Initiate

- (HGSelectViewHeader *)headerView {
    if (!_headerView) {
        _headerView = [HGSelectViewHeader.alloc initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 32)];
    }
    return _headerView;
}
- (HGSelectViewFooter *)footerView {
    if (!_footerView) {
        _footerView = [HGSelectViewFooter.alloc initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50 + DANGER_BOTTOM_AREA_HEIGHT)];
    }
    return _footerView;
}
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [UITableView.alloc initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.bounces = NO;
        _tableView.scrollEnabled = NO;
        _tableView.separatorColor = [UIColor whiteColor];
        _tableView.backgroundColor = [UIColor clearColor];
    }
    return _tableView;
}

- (void)initiateTableViews {
    
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
    [self.tableView registerClass:HGHorizontalSelectTCell.class forCellReuseIdentifier:HGIdentifier];
    [self.tableView setTableHeaderView:self.headerView];
    [self.tableView setTableFooterView:self.footerView];
    [self addSubview:self.tableView];
    
    
    CGFloat height = kHGHorizontalSCCellHeight * self.items.count + self.footerView.height + self.headerView.height;
    CGRect frame = CGRectMake(0, 0, SCREEN_WIDTH, height);
    [self setFrame:frame];
    [self.tableView setFrame:frame];
    
}


@end
