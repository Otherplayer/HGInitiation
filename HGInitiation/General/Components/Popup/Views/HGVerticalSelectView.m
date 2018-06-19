//
//  HGMutilVerticalScrollView.m
//  HGInitiation
//
//  Created by __无邪_ on 2018/6/7.
//  Copyright © 2018年 __无邪_. All rights reserved.
//

#import "HGVerticalSelectView.h"
#import "HGSelectAdditionalView.h"
#import "HGHorizontalSelectTCell.h"

CGFloat const kHGVerticalSelectViewCellHeight = 50.f;


@interface HGVerticalSelectView ()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDataSource,UICollectionViewDelegate>
@property(nonatomic, strong)UICollectionView *collectionView;
@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, strong)HGSelectViewHeader *headerView;
@property(nonatomic, strong)HGSelectViewFooter *footerView;
@property(nonatomic, strong)UICollectionViewFlowLayout *layout;
@property(nonatomic, strong)NSArray *items;
@end

@implementation HGVerticalSelectView

- (instancetype)initWithItems:(NSArray *)items{
    self = [super init];
    if (self) {
        self.items = items;
        [self initiateTableViews];
    }
    return self;
}
- (instancetype)initWithItems:(NSArray *)items title:(NSString *)title type:(HGVerticalSelectType)type{
    self = [super init];
    if (self) {
        
        self.items = items;
        
        if (type == HGVerticalSelectType9) {
            [self initiateCollectionView];
        }else{
            [self initiateTableViews];
        }
        
        __weak typeof(self) weakSelf = self;
        [self.headerView.labTitle setText:title];
        [self.footerView setDidTapCancelHandler:^{
            if (weakSelf.didTapCancelHandler) {
                weakSelf.didTapCancelHandler();
            }
        }];
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:HGIdentifier forIndexPath:indexPath];
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
    return kHGVerticalSelectViewCellHeight;
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

#pragma mark - <UICollectionViewDataSource>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.items.count;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    HGHorizontalSelectCCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:HGIdentifier forIndexPath:indexPath];
    NSDictionary *info = self.items[indexPath.item];
    [cell.btnIcon setImage:[UIImage imageNamed:info[@"icon"]] forState:UIControlStateNormal];
    cell.labTitle.text = info[@"title"];
    __weak typeof(self) weakSelf = self;
    [cell setDidTapHandler:^{
        if (weakSelf.didTapItemHandler) {
            weakSelf.didTapItemHandler(indexPath.item);
        }
    }];
    
    return cell;
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
        _tableView.separatorColor = [UIColor groupTableViewBackgroundColor];
        _tableView.backgroundColor = [UIColor clearColor];
    }
    return _tableView;
}
- (UICollectionViewFlowLayout *)layout {
    if (!_layout) {
        _layout = [[UICollectionViewFlowLayout alloc] init];
        _layout.sectionInset = UIEdgeInsetsMake(10, 16, 0, 16);
        _layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _layout.minimumLineSpacing = 12.f;
        _layout.minimumInteritemSpacing = 7.f;
        _layout.itemSize = CGSizeMake(kHGHorizontalSCCellWidth, kHGHorizontalSCCellHeight - 10);
        _layout.headerReferenceSize = CGSizeMake(SCREEN_WIDTH, 32);
        _layout.footerReferenceSize = CGSizeMake(SCREEN_WIDTH, DANGER_BOTTOM_AREA_HEIGHT + kHGSelectViewCancelHeight);
    }
    return _layout;
}
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = [UICollectionView.alloc initWithFrame:CGRectZero collectionViewLayout:self.layout];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = UIColor.clearColor;
        _collectionView.directionalLockEnabled = YES;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.bounces = YES;
        _collectionView.contentInset = UIEdgeInsetsZero;
    }
    return _collectionView;
}
- (void)initiateCollectionView {
    
    CGFloat minimumInteritemSpacing = self.layout.minimumInteritemSpacing;
    UIEdgeInsets sectionInset = self.layout.sectionInset;
    
    NSInteger rows = (SCREEN_WIDTH - sectionInset.left - sectionInset.right + minimumInteritemSpacing) / (minimumInteritemSpacing + kHGHorizontalSCCellWidth);
    NSInteger columns = self.items.count / rows + (self.items.count % rows > 0 ? 1:0);
    
    [self.collectionView registerClass:HGHorizontalSelectCCell.class forCellWithReuseIdentifier:HGIdentifier];
    
    CGFloat height = kHGHorizontalSCCellHeight * columns + self.headerView.height + self.footerView.height;
    if (height > (SCREEN_HEIGHT - NAVandSTATUS_BAR_HEIHGT) * 3 / 5.0) {
        height = (SCREEN_HEIGHT - NAVandSTATUS_BAR_HEIHGT) * 3 / 5.0;
    }
    CGRect frame = CGRectMake(0, 0, SCREEN_WIDTH, height);
    [self setFrame:frame];
    [self.collectionView setFrame:frame];
    
    self.footerView.top = self.collectionView.height - self.footerView.height;
    
    [self addSubview:self.headerView];
    [self addSubview:self.collectionView];
    [self addSubview:self.footerView];
    
}
- (void)initiateTableViews {
    
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
    [self.headerView setBackgroundColor:[UIColor whiteColor]];
    [self.tableView registerClass:UITableViewCell.class forCellReuseIdentifier:HGIdentifier];
    [self.tableView setTableHeaderView:self.headerView];
    [self.tableView setTableFooterView:self.footerView];
    [self addSubview:self.tableView];
    
    CGRect frame = CGRectMake(0, 0, SCREEN_WIDTH, kHGVerticalSelectViewCellHeight * self.items.count + self.headerView.height + self.footerView.height + 5);
    [self setFrame:frame];
    [self.tableView setFrame:frame];
    
}


@end
