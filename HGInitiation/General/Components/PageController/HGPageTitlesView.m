//
//  HGPageMenuView.m
//  HGInitiation
//
//  Created by __无邪_ on 2018/6/4.
//  Copyright © 2018年 __无邪_. All rights reserved.
//

#import "HGPageTitlesView.h"
#import "HGPageTitleItem.h"

@interface HGPageTitlesView ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property(nonatomic, strong)UICollectionView *collectionView;

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
        if (@available(iOS 11, *)) {
            _collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        _collectionView;
    });
    
    [self registerClass:HGPageTitleItem.class];
    [self addSubview:self.collectionView];
}

#pragma mark - public

- (void)registerClass:(nullable Class)cellClass{
    [self.collectionView registerClass:cellClass forCellWithReuseIdentifier:NSStringFromClass(cellClass)];
}

- (void)updateConfiguration {
    [self.collectionView reloadData];
}
- (void)reloadData {
    [self.collectionView reloadData];
}
- (void)scrollToItemAtIndex:(NSInteger)index {
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:0];
    [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    [self selectItemAtIndex:index];
}
- (void)selectItemAtIndex:(NSInteger)index {
    if (index != self.selectedIndex) {
        self.selectedIndex = index;
        [self.collectionView reloadData];
    }
}

#pragma mark - UICollectionViewDataSource & UICollectionViewDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.titles.count;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    HGPageTitleItem *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(HGPageTitleItem.class) forIndexPath:indexPath];
    NSString *title = self.titles[indexPath.item];
    [cell.labTitle setTitle:title forState:UIControlStateNormal];
    [cell.labTitle setSelected:(indexPath.item == self.selectedIndex)];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger pageIndex = indexPath.item;
    [self.delegate pageTitles:self didSelectItemAtIndex:pageIndex];
    [collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *title = self.titles[indexPath.item];
    CGFloat width = [title widthForFont:[UIFont systemFontOfSize:17]] + 30;
    return CGSizeMake(width, 44);
}

@end
