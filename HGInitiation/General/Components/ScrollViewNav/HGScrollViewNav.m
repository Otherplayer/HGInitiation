//
//  HGScrollViewNav.m
//  HGInitiation
//
//  Created by __无邪_ on 2018/5/18.
//  Copyright © 2018年 __无邪_. All rights reserved.
//

#import "HGScrollViewNav.h"
#import <CHTCollectionViewWaterfallLayout.h>

@interface HGScrollViewNav ()<UICollectionViewDataSource,UICollectionViewDelegate,UIScrollViewDelegate,UICollectionViewDelegateFlowLayout>
@property(nonatomic, strong)UICollectionView *collectionView;
@property(nonatomic, strong)NSMutableArray *datas;
@property(nonatomic, strong)UIView *lineView;
@end

@implementation HGScrollViewNav

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initiateViews];
    }
    return self;
    
}
- (void)dealloc {
    NSLog(@"dealloc");
}

- (void)initiateViews {
    
    UICollectionViewFlowLayout *layout = ({
        layout = [[UICollectionViewFlowLayout alloc] init];
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout;
    });
    
    self.collectionView = ({
        _collectionView = [UICollectionView.alloc initWithFrame:self.bounds collectionViewLayout:layout];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = UIColor.groupTableViewBackgroundColor;
        _collectionView.directionalLockEnabled = YES;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.bounces = YES;
        _collectionView.contentInset = UIEdgeInsetsZero;
        _collectionView.delaysContentTouches = NO;
        _collectionView.decelerationRate = UIScrollViewDecelerationRateFast;
        if (@available(iOS 11, *)) {
            _collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        _collectionView;
    });
    
    [self registerClass:UICollectionViewCell.class];
    [self addSubview:self.collectionView];
    
    CGFloat lineHeight = 4;
    self.lineView = ({
        _lineView = [UIView.alloc initWithFrame:CGRectMake(0, self.height - lineHeight, 0, lineHeight)];
        _lineView.backgroundColor = [UIColor redColor];
        _lineView;
    });
    [self addSubview:self.lineView];
    
    self.datas = [NSMutableArray.alloc init];
}

#pragma mark - public

- (void)registerClass:(nullable Class)cellClass{
    [self.collectionView registerClass:cellClass forCellWithReuseIdentifier:NSStringFromClass(cellClass)];
}

- (void)setDatas:(NSArray *)datas key:(NSString *)key{
    [self.datas removeAllObjects];
    [self.datas addObjectsFromArray:datas];
    [self.collectionView reloadData];
}

- (void)updateConfiguration {
    [self.collectionView reloadData];
}
- (void)reloadData {
    [self.collectionView reloadData];
}

#pragma mark - UICollectionViewDataSource & UICollectionViewDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.datas.count;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    id obj = self.datas[indexPath.item];
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(UICollectionViewCell.class) forIndexPath:indexPath];
    cell.backgroundColor = [UIColor randomColor];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger pageIndex = indexPath.item;
    pageIndex = pageIndex % self.datas.count;
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *obj = self.datas[indexPath.item];
    NSString *title = obj[@"title"];
    CGFloat width = [title widthForFont:[UIFont systemFontOfSize:17]] + 80;
    
    if (self.lineView.width < 1) {
        self.lineView.width = width;
    }
    
    return CGSizeMake(width, 50);
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
}
// called on finger up if the user dragged. decelerate is true if it will continue moving afterwards
// when user scrolls manually, stop timer and start timer again to avoid next scroll immediatelly
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
}

#pragma mark - private


@end
