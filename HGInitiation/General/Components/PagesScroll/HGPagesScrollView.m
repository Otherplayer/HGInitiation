//
//  HGPagesScrollView.m
//  HGInitiation
//
//  Created by __无邪_ on 2018/6/12.
//  Copyright © 2018年 __无邪_. All rights reserved.
//

#import "HGPagesScrollView.h"
#import "HGPageTitlesView.h"

const CGFloat kHGPagesScrollViewHeaderHeight = 200.0f;
const CGFloat kHGPagesScrollViewHeaderTitle = 50.0f;

@interface HGPagesScrollView ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,HGPageTitlesDelegate>
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSMutableArray *datas;
@property (nonatomic, strong) NSMutableArray<UITableView *> *tableViews;
@property (nonatomic, strong) NSMutableArray *gestures;
@property (nonatomic, assign) NSInteger pageCurrent;
@property (nonatomic, strong) HGPageTitlesView *titlesView;
@end

@implementation HGPagesScrollView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        NSArray *titles = @[@"北京",@"上海",@"香港"];

        self.datas = [NSMutableArray.alloc init];
        self.tableViews = [NSMutableArray.alloc init];
        self.gestures = [NSMutableArray.alloc init];
        self.pageCurrent = 0;
        
        CGFloat width = CGRectGetWidth(frame);
        CGFloat height = CGRectGetHeight(frame);

        for (int i = 0; i < 20; i++) {
            [self.datas addObject:@(i)];
        }

        self.scrollView = ({
            _scrollView = [UIScrollView.alloc initWithFrame:CGRectMake(0, 0, width, height)];
            _scrollView.delegate = self;
            _scrollView.pagingEnabled = YES;
            _scrollView.contentSize = CGSizeMake(width * titles.count, 0);
            _scrollView;
        });

        self.headerView = ({
            _headerView = [UIView.alloc initWithFrame:CGRectMake(0, 0, width, kHGPagesScrollViewHeaderHeight + kHGPagesScrollViewHeaderTitle)];
            _headerView.backgroundColor = [UIColor orangeColor];
            _headerView;
        });
        
        self.titlesView = ({
            _titlesView = [HGPageTitlesView.alloc initWithFrame:CGRectMake(0, kHGPagesScrollViewHeaderHeight, width, kHGPagesScrollViewHeaderTitle)];
            _titlesView.backgroundColor = [UIColor whiteColor];
            _titlesView.showType = HGPageTitlesShowTypeCenter;
            _titlesView.animatedType = HGPageProgressViewAnimatedTypePanning;
            _titlesView.pageTitlesDelegate = self;
            _titlesView;
        });
        
        [self.headerView addSubview:self.titlesView];
        self.titlesView.titles = titles;
        [self.titlesView reloadData];
        
        for (int i = 0; i < titles.count; i++) {
            UITableView *tableView = ({
                tableView = [UITableView.alloc initWithFrame:CGRectMake(width * i, kHGPagesScrollViewHeaderTitle, width, height - kHGPagesScrollViewHeaderTitle - NAVandSTATUS_BAR_HEIHGT) style:UITableViewStylePlain];
                tableView.delegate = self;
                tableView.dataSource = self;
                tableView.scrollIndicatorInsets = UIEdgeInsetsMake(kHGPagesScrollViewHeaderHeight, 0, 0, 0);
                tableView.contentInset = UIEdgeInsetsMake(kHGPagesScrollViewHeaderHeight, 0, 0, 0);
                [tableView registerClass:UITableViewCell.class forCellReuseIdentifier:NSStringFromClass(UITableViewCell.class)];
                [tableView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
                tableView;
            });
            [self.tableViews addObject:tableView];
            [self.scrollView addSubview:tableView];
            [self.gestures addObject:tableView.gestureRecognizers];
        }
        
        [self addSubview:self.scrollView];
        [self addSubview:self.headerView];
        
        [self transitionScrollViewGestures:self.gestures[0]];
        
    }
    return self;
}

- (void)dealloc {
    for (UITableView *tableView in self.tableViews) {
        [tableView removeObserver:self forKeyPath:@"contentOffset" context:nil];
    }
}

#pragma mark -

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"contentOffset"] && change[@"new"]) {
        CGPoint point = [(NSValue *)change[@"new"] CGPointValue];
        CGFloat contentOffSetY = point.y;
        if (contentOffSetY <= -kHGPagesScrollViewHeaderHeight) {
            self.headerView.top = 0;
        }else if (contentOffSetY >= 0) {
            self.headerView.top = -kHGPagesScrollViewHeaderHeight;
        }else {
            self.headerView.top = -kHGPagesScrollViewHeaderHeight - contentOffSetY;
        }
    }
}

- (void)transitionScrollViewGestures:(NSArray *)gestureRecognizers {
    for (UIGestureRecognizer *gestureRecognizer in self.gestureRecognizers) {
        [self removeGestureRecognizer:gestureRecognizer];
    }
    for (UIGestureRecognizer *gestureRecognizer in gestureRecognizers) {
        [self addGestureRecognizer:gestureRecognizer];
    }
}

#pragma mark - <UIScrollViewDelegate>

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.scrollView) {
        CGFloat contentOffset = scrollView.contentOffset.x / scrollView.frame.size.width;
        if (contentOffset < 0 || contentOffset > self.tableViews.count - 1) {
            return;
        }
        
        NSInteger index = (NSInteger)contentOffset;
        
        CGFloat progress = contentOffset - index;
        if (progress == 0.0) {
            self.pageCurrent = index;
            [self transitionScrollViewGestures:self.gestures[self.pageCurrent]];
        }
        
        
        CGFloat contentOffsetX = scrollView.contentOffset.x;
        if (contentOffsetX < 0) {
            contentOffsetX = 0;
        }
        if (contentOffsetX > scrollView.contentSize.width - scrollView.frame.size.width) {
            contentOffsetX = scrollView.contentSize.width - scrollView.frame.size.width;
        }
        CGFloat rate = contentOffsetX / scrollView.size.width;
        
        [self.titlesView scrollToItemInProgress:rate];
        
    }
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (scrollView == self.scrollView) {
        
        if (_headerView.frame.origin.y == 0.0) {
            //1，header在底部
            for (UITableView *tableView in self.tableViews) {
                if (tableView == self.tableViews[self.pageCurrent]) {
                    continue;
                }
                tableView.contentOffset = CGPointMake(0, -kHGPagesScrollViewHeaderHeight);
            }
        }else if (_headerView.frame.origin.y == -kHGPagesScrollViewHeaderHeight) {
            //2，header悬停在顶部
            for (UITableView *tableView in self.tableViews) {
                if (tableView == self.tableViews[self.pageCurrent]) {
                    continue;
                }
                if (tableView.contentOffset.y < 0) {
                    tableView.contentOffset = CGPointMake(0, 0);
                }
            }
        }else {
            //3，header在中间状态的时候
            for (UITableView *tableView in self.tableViews) {
                if (tableView == self.tableViews[self.pageCurrent]) {
                    continue;
                }
                CGFloat contentOffsetY = self.tableViews[self.pageCurrent].contentOffset.y;
                if (contentOffsetY < 0) {
                    tableView.contentOffset = CGPointMake(0, contentOffsetY);
                }
            }
        }
        
    }
}
#pragma mark -

#pragma mark - <HGPageTitlesDelegate>
- (void)pageTitles:(HGPageTitlesView *)titlesView shouldSelectItemAtIndex:(NSInteger)index {
    [self scrollViewWillBeginDragging:self.scrollView];
    if (self.pageCurrent >= index - 1 && self.pageCurrent <= index + 1) {
        [self.scrollView setContentOffset:CGPointMake(SCREEN_WIDTH * index, 0) animated:YES];
    }else{
        [self.scrollView setContentOffset:CGPointMake(SCREEN_WIDTH * index, 0) animated:NO];
    }
}


#pragma mark - <UITableViewDataSource & UITableViewDelegate>

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datas.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class]) forIndexPath:indexPath];
    cell.textLabel.text = [NSString stringWithFormat:@"%ld", indexPath.row];
    cell.backgroundColor = [UIColor randomWarmColor];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}






@end
