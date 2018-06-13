//
//  HGPageMenuView.m
//  HGInitiation
//
//  Created by __无邪_ on 2018/6/4.
//  Copyright © 2018年 __无邪_. All rights reserved.
//

#import "HGPageTitlesView.h"
#import "HGPageTitleItem.h"
#import "HGPageProgressView.h"

const CGFloat HGPageProgressViewWidth = 20.f;
const CGFloat HGPageProgressViewHeight = 2.f;

@interface HGPageTitlesView ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property(nonatomic, strong)UICollectionView *collectionView;
@property(nonatomic, strong)HGPageProgressView *progressView;
@property(nonatomic, strong)NSMutableArray *frames;
@property(nonatomic, assign)CGFloat margin;
@end

@implementation HGPageTitlesView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initiateViews];
    }
    return self;
}
- (instancetype)init{
    self = [super init];
    if (self) {
        [self initiateViews];
    }
    return self;
}
- (void)dealloc {
    NSLog(@"dealloc HGPageTitlesView");
}

- (void)initiateViews {
    
    self.selectedIndex = 0;
    self.margin = 0;
    self.showType = HGPageTitlesShowTypeCenter;
    self.frames = [NSMutableArray.alloc init];
    
    UICollectionViewFlowLayout *layout = ({
        layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout;
    });
    
    self.collectionView = ({
        _collectionView = [UICollectionView.alloc initWithFrame:self.bounds collectionViewLayout:layout];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = UIColor.clearColor;
        _collectionView.directionalLockEnabled = YES;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.bounces = YES;
        _collectionView.contentInset = UIEdgeInsetsZero;
//        if (@available(iOS 11, *)) {
//            _collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
//        }
        _collectionView;
    });
    
    self.progressView = ({
        _progressView = [HGPageProgressView.alloc initWithFrame:CGRectMake(0, CGRectGetHeight(self.bounds) - HGPageProgressViewHeight, HGPageProgressViewWidth, HGPageProgressViewHeight)];
        _progressView.backgroundColor = [UIColor redColor];
//        _progressView.layer.cornerRadius = HGPageProgressViewHeight/2.f;
//        _progressView.layer.masksToBounds = YES;
        _progressView;
    });
    
    [self.collectionView addSubview:self.progressView];
    [self registerClass:HGPageTitleItem.class];
    [self addSubview:self.collectionView];
}

#pragma mark - public

- (void)registerClass:(nullable Class)cellClass{
    [self.collectionView registerClass:cellClass forCellWithReuseIdentifier:NSStringFromClass(cellClass)];
}

- (void)reloadData {
    [self.collectionView reloadData];
}

- (void)scrollToItemInProgress:(CGFloat)progress {
    
    NSInteger tag = (NSInteger)progress;
    CGFloat rate = progress - tag;
    
    if (rate == 0.0) {
        [self scrollToItemAtIndex:tag];
        return;
    }
    
    HGPageTitleItem *itemCurrent = (HGPageTitleItem *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:tag inSection:0]];
    HGPageTitleItem *itemNext = (HGPageTitleItem *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:tag + 1 inSection:0]];
    itemCurrent.rate = 1 - rate;
    itemNext.rate = rate;
    
}
- (void)scrollToItemAtIndex:(NSInteger)index {
    self.selectedIndex = index;
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:0];
    [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    [self.collectionView reloadData];
    [self scrollProgressViewToIndex:index];
}

#pragma mark -

- (void)setTitles:(NSArray *)titles {
    _titles = titles;
    [self.frames removeAllObjects];
    for (NSString *title in titles) {
        CGFloat width = [self widthForTitle:title];
        [self.frames addObject:@(width)];
    }
    CGFloat totalWidth = [[self.frames valueForKeyPath:@"@sum.floatValue"] floatValue];
    if (self.showType == HGPageTitlesShowTypeCenter && totalWidth < CGRectGetWidth(self.bounds)) {
        self.margin = (CGRectGetWidth(self.bounds) - totalWidth) / 2.0f;
    }
    [self scrollProgressViewToIndex:self.selectedIndex];
    [self reloadData];
}

- (void)scrollProgressViewToIndex:(NSInteger)index {
    CGFloat left = self.margin;
    for (int i = 0; i < index; i++) {
        left += [self.frames[i] floatValue];
    }
    left += ([self.frames[index] floatValue] - HGPageProgressViewWidth)/2.0;
    [UIView animateWithDuration:0.25 animations:^{
        self.progressView.left = left;
    }];
}

#pragma mark - UICollectionViewDataSource & UICollectionViewDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.titles.count;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    HGPageTitleItem *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(HGPageTitleItem.class) forIndexPath:indexPath];
    NSString *title = self.titles[indexPath.item];
    cell.labTitle.width = [self widthForTitle:title];
    [cell.labTitle setText:title];
    [cell setSelected:(indexPath.item == self.selectedIndex)];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger pageIndex = indexPath.item;
    [self.delegate pageTitles:self didSelectItemAtIndex:pageIndex];
    [self scrollToItemAtIndex:indexPath.item];
    [collectionView reloadData];
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *title = self.titles[indexPath.item];
    CGFloat width = [self widthForTitle:title];
    return CGSizeMake(width, collectionView.frame.size.height);
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, self.margin, 0, self.margin);
}

- (CGFloat)widthForTitle:(NSString *)title {
    return [title widthForFont:[UIFont systemFontOfSize:17]] + 30;
}

@end
