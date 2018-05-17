//
//  HGScrollView.m
//  HGInitiation
//
//  Created by __无邪_ on 2018/1/9.
//  Copyright © 2018年 __无邪_. All rights reserved.
//

#import "HGScrollView.h"

@interface HGScrollView ()<UICollectionViewDataSource,UICollectionViewDelegate,UIScrollViewDelegate>
@property(nonatomic, strong)UICollectionView *collectionView;
@property(nonatomic, strong)HGPageControl *pageControl;
@property(nonatomic, strong)NSMutableArray *datas;
@property(nonatomic, copy)NSString *hgKey;
@property(nonatomic, copy)NSString *hgKeyTitle;
@property(nonatomic,readwrite) NSInteger currentPage;
@property(nonatomic) HGScrollDirection scrollDirection; //default HGScrollDirectionHorizontal
@property(nonatomic) HGScrollViewContentType contentType;

@property(nonatomic, strong)dispatch_source_t timer;

@end

@implementation HGScrollView

- (instancetype)initWithFrame:(CGRect)frame{
    return [self initWithFrame:frame type:HGScrollViewContentTypeImage];
}
- (instancetype)initWithFrame:(CGRect)frame type:(HGScrollViewContentType)type{
    return [self initWithFrame:frame type:HGScrollViewContentTypeImage direction:HGScrollDirectionHorizontal];
}
- (instancetype)initWithFrame:(CGRect)frame type:(HGScrollViewContentType)type direction:(HGScrollDirection)scrollDirection {
    self = [super initWithFrame:frame];
    if (self) {
        _hgKey = @"url";
        _hgKeyTitle = @"title";
        _scrollIntervalTime = 3.0;
        _currentPage = 0;
        _contentType = type;
        _pageControlPosition = HGPageControlPositionBottomRight;
        _pageIndicatorTintColor = [UIColor colorWithWhite:1 alpha:0.5];
        _currentPageIndicatorTintColor = [UIColor whiteColor];
        _scrollDirection = scrollDirection;
        
        [self initiateViews];
        [self initTimer];
        [self setAutoScroll:YES];
        [self setLoopScroll:YES];
    }
    return self;
    
}
- (void)dealloc {
    NSLog(@"dealloc");
    [self invalidateTimer];
}

- (void)initiateViews {
    
    UICollectionViewFlowLayout *layout = ({
        layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(self.width, self.height);
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        layout.scrollDirection = (self.scrollDirection == HGScrollDirectionHorizontal)? UICollectionViewScrollDirectionHorizontal : UICollectionViewScrollDirectionVertical;
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout;
    });
    
    self.collectionView = ({
        _collectionView = [UICollectionView.alloc initWithFrame:self.bounds collectionViewLayout:layout];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = UIColor.groupTableViewBackgroundColor;
        _collectionView.pagingEnabled = YES;
        _collectionView.directionalLockEnabled = YES;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.scrollsToTop = NO;
        _collectionView.bounces = YES;
        _collectionView.contentInset = UIEdgeInsetsZero;
        _collectionView.delaysContentTouches = NO;
        _collectionView.decelerationRate = UIScrollViewDecelerationRateFast;
        if (@available(iOS 11, *)) {
            _collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        _collectionView;
    });
    
    [self.collectionView registerClass:HGScrollDefaultImage.class forCellWithReuseIdentifier:HGScrollCellIdentifier];
    [self addSubview:self.collectionView];
    
    
    self.pageControl = ({
        _pageControl = [HGPageControl.alloc initWithFrame:self.collectionView.bounds];
        _pageControl.pageIndicatorTintColor = self.pageIndicatorTintColor;
        _pageControl.currentPageIndicatorTintColor = self.currentPageIndicatorTintColor;
        _pageControl.hidesForSinglePage = YES;
        _pageControl.userInteractionEnabled = NO;
        _pageControl.position = self.pageControlPosition;
        _pageControl;
    });
    [self addSubview:self.pageControl];
    
    self.datas = [NSMutableArray.alloc init];
}
- (void)initTimer {
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER,
                                    0,
                                    0,
                                    dispatch_get_main_queue());
    dispatch_source_set_timer(_timer,
                              dispatch_time(DISPATCH_TIME_NOW, _scrollIntervalTime * NSEC_PER_SEC),
                              (uint64_t)(_scrollIntervalTime * NSEC_PER_SEC),
                              0);
    dispatch_source_set_event_handler(_timer, ^{
        if (self.datas.count == 0) return;
        
        CGPoint offset = CGPointMake(self.collectionView.contentOffset.x + self.collectionView.width, 0);
        if (self.scrollDirection == HGScrollDirectionVertical) {
            offset = CGPointMake(0, self.collectionView.contentOffset.y + self.collectionView.height);
        }
        [self.collectionView setContentOffset:offset animated:YES];
        
    });
    
    // 启动定时器
    dispatch_resume(_timer);
}
#pragma mark - public
- (void)setDatas:(NSArray *)datas key:(NSString *)key titleKey:(NSString *)titleKey {
    [self setHgKey:key];
    [self setHgKeyTitle:titleKey];
    [self.datas removeAllObjects];
    
    if (datas.count) {
        
        if (datas.count == 1 || self.loopScroll == NO) {
            self.loopScroll = NO;
            [self.datas addObjectsFromArray:datas];
            [self.collectionView reloadData];
        }else{
            [self.datas addObject:[datas lastObject]];
            [self.datas addObjectsFromArray:datas];
            [self.datas addObject:[datas firstObject]];
            [self.collectionView reloadData];
            if (self.loopScroll) {
                [self scrollToPage:1 animated:YES];
            }
        }
        if ([self.delegate respondsToSelector:@selector(scrollView:didScroll2Index:)]) {
            [self.delegate scrollView:self didScroll2Index:self.currentPage];
        }
        
    }
    
    [self updateConfiguration];
}
- (void)setDatas:(NSArray *)datas key:(NSString *)key {
    [self setDatas:datas key:key titleKey:self.hgKeyTitle];
}

- (void)updateConfiguration {
    self.pageControl.numberOfPages = self.loopScroll ? (self.datas.count - 2) : self.datas.count;
    [self.collectionView reloadData];
    
    if (self.autoScroll) {
        _loopScroll = YES;
    }else{
        dispatch_suspend(_timer);
    }
}

- (void)setPageIndicatorTintColor:(UIColor *)pageIndicatorTintColor {
    _pageIndicatorTintColor = pageIndicatorTintColor;
    self.pageControl.pageIndicatorTintColor = pageIndicatorTintColor;
}

- (void)setCurrentPageIndicatorTintColor:(UIColor *)currentPageIndicatorTintColor {
    _currentPageIndicatorTintColor = currentPageIndicatorTintColor;
    self.pageControl.currentPageIndicatorTintColor = currentPageIndicatorTintColor;
}

- (void)setPageControlPosition:(HGPageControlPosition)pageControlPosition {
    _pageControlPosition = pageControlPosition;
    [self.pageControl setPosition:pageControlPosition];
}

- (void)setAutoScroll:(BOOL)autoScroll {
    _autoScroll = autoScroll;
    [self updateConfiguration];
}

- (void)setLoopScroll:(BOOL)loopScroll {
    _loopScroll = loopScroll;
    [self updateConfiguration];
}

- (void)setScrollIntervalTime:(float)scrollIntervalTime {
    _scrollIntervalTime = scrollIntervalTime;
    dispatch_source_set_timer(_timer,
                              dispatch_time(DISPATCH_TIME_NOW, _scrollIntervalTime * NSEC_PER_SEC),
                              (uint64_t)(_scrollIntervalTime * NSEC_PER_SEC),
                              0);
}

- (void)reloadData {
    [self.collectionView reloadData];
}

- (void)invalidateTimer {
    if (_timer) _timer = nil;
}

#pragma mark - UICollectionViewDataSource & UICollectionViewDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.datas.count;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.contentType == HGScrollViewContentTypeImage) {
        HGScrollDefaultImage *cell = [collectionView dequeueReusableCellWithReuseIdentifier:HGScrollCellIdentifier forIndexPath:indexPath];
        id obj = self.datas[indexPath.item];
        if ([obj isKindOfClass:[NSString class]]) {
            [cell.imageView sd_setImageWithURL:[NSURL URLWithString:(NSString *)obj] placeholderImage:nil];
        }else if ([obj isKindOfClass:[NSDictionary class]]) {
            NSString *urlStr = [(NSDictionary *)obj objectForKey:self.hgKey];
            NSString *title = [(NSDictionary *)obj objectForKey:self.hgKeyTitle];
            [cell setImageUrl:urlStr placeholderImage:nil title:title];
        }
        return cell;
    }else if (self.contentType == HGScrollViewContentTypeText) {
        
    }else {
        
    }
    return nil;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger pageIndex = self.loopScroll ? (indexPath.item - 1) : indexPath.item;
    pageIndex = pageIndex % (self.loopScroll? (self.datas.count - 2) : self.datas.count);
    
    if ([self.delegate respondsToSelector:@selector(scrollView:didSelectItemAtIndex:)]) {
        [self.delegate scrollView:self didSelectItemAtIndex:pageIndex];
    }
}
- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
}
- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
}



#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (_timer) dispatch_suspend(_timer);
}
// called on finger up if the user dragged. decelerate is true if it will continue moving afterwards
// when user scrolls manually, stop timer and start timer again to avoid next scroll immediatelly
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!_autoScroll) return;
    dispatch_source_set_timer(_timer,
                              dispatch_time(DISPATCH_TIME_NOW, _scrollIntervalTime * NSEC_PER_SEC),
                              (uint64_t)(_scrollIntervalTime * NSEC_PER_SEC),
                              0);
    dispatch_resume(_timer);
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (self.loopScroll) {
        
        CGFloat offset = scrollView.contentOffset.x;
        CGFloat scrollSize = scrollView.width;
        if (self.scrollDirection == HGScrollDirectionVertical) {
            offset = scrollView.contentOffset.y;
            scrollSize = scrollView.height;
        }
        if (offset >= (self.datas.count - 1) * scrollSize) {
            [self scrollToPage:1 animated:NO];
        }else if (offset <= 0.0){
            [self scrollToPage:(self.datas.count - 2) animated:NO];
        }
        
    }
    
    NSInteger realPage = scrollView.contentOffset.x / scrollView.width;
    if (self.scrollDirection == HGScrollDirectionVertical) {
        realPage = (int)round(scrollView.contentOffset.y / (CGFloat)scrollView.height);
    }
    NSInteger page = ( self.loopScroll ? (realPage - 1) : (realPage) );
    page = self.loopScroll ? (page % (self.datas.count - 2)) : page;
    
    if (page != self.currentPage) {
        self.currentPage = page;
        self.pageControl.currentPage = self.currentPage;
        if ([self.delegate respondsToSelector:@selector(scrollView:didScroll2Index:)]) {
            [self.delegate scrollView:self didScroll2Index:self.currentPage];
        }
    }
    
}

#pragma mark - private
/**
 * 当looScroll为真时，数据内容是 31231 形似的，首尾数据3、1都是虚的。所以page为 1 时才是真正的第一个内容
 */
- (void)scrollToPage:(NSInteger)page animated:(BOOL)animated{
    [self scrollToPage:page direction:self.scrollDirection animated:animated];
}
- (void)scrollToPage:(NSInteger)page direction:(HGScrollDirection)direction animated:(BOOL)animated{
    CGPoint offset = CGPointMake(self.collectionView.width * page, 0);
    if (direction == HGScrollDirectionVertical) {
        offset = CGPointMake(0, self.collectionView.height * page);
    }
    [self.collectionView setContentOffset:offset animated:animated];
}


//- (NSInteger)currentPage{
//    CGFloat pageWidth = self.collectionView.width;
//    NSInteger currentPage = floor((self.collectionView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
//    return currentPage;
//}


@end
