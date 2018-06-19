//
//  HGMutilVerticalScrollView.m
//  HGInitiation
//
//  Created by __无邪_ on 2018/6/7.
//  Copyright © 2018年 __无邪_. All rights reserved.
//

#import "HGVerticalSelectView.h"
#import "HGSelectAdditionalView.h"

static NSString *HGMutilVerticalIdentifier = @"Identifier";

@interface HGVerticalSelectView ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, strong)HGSelectViewHeader *headerView;
@property(nonatomic, strong)HGSelectViewFooter *footerView;
@property(nonatomic, strong)NSArray *items;
@end

@implementation HGVerticalSelectView

- (instancetype)initWithItems:(NSArray *)items{
    self = [super init];
    if (self) {
        self.items = items;
        [self initiateViews];
    }
    return self;
}

#pragma mark - Action
- (void)didTapCancelAction:(UIButton *)sender {
    if (self.didTapCancelHandler) {
        self.didTapCancelHandler();
    }
}

#pragma mark - <UITableViewDataSource>

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.items.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:HGMutilVerticalIdentifier forIndexPath:indexPath];
    NSDictionary *info = self.items[indexPath.row];
    cell.textLabel.text = info[@"title"];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.backgroundColor = [UIColor whiteColor];
    
    UIBlurEffect *blurEffectPopup = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
    UIVisualEffectView *blurEffectViewPopup = [[UIVisualEffectView alloc] initWithEffect:blurEffectPopup];
    blurEffectViewPopup.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    cell.selectedBackgroundView = blurEffectViewPopup;
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 5;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [UIView.alloc initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 5)];
    view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    return view;
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
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//    cell.backgroundColor = [UIColor clearColor];
    if (self.didTapItemHandler) {
        self.didTapItemHandler(indexPath.row);
    }
}
//- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
//    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//    cell.backgroundColor = [UIColor whiteColor];
//}


#pragma mark - Initiate

- (HGSelectViewHeader *)headerView {
    if (!_headerView) {
        _headerView = [HGSelectViewHeader.alloc initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 32)];
        _headerView.backgroundColor = [UIColor whiteColor];
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
        _tableView.separatorColor = [UIColor groupTableViewBackgroundColor];
        _tableView.backgroundColor = [UIColor clearColor];
    }
    return _tableView;
}

- (void)initiateViews {
    
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
    [self.tableView registerClass:UITableViewCell.class forCellReuseIdentifier:HGMutilVerticalIdentifier];
    [self.tableView setTableHeaderView:self.headerView];
    [self.tableView setTableFooterView:self.footerView];
    [self addSubview:self.tableView];
    
    CGRect frame = CGRectMake(0, 0, SCREEN_WIDTH, 50 * self.items.count + self.headerView.height + self.footerView.height + 5);
    [self setFrame:frame];
    [self.tableView setFrame:frame];
    
}


@end
