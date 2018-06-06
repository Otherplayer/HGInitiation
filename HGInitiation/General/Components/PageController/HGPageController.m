//
//  HGPageController.m
//  HGInitiation
//
//  Created by __无邪_ on 2018/5/21.
//  Copyright © 2018年 __无邪_. All rights reserved.
//

#import "HGPageController.h"

@interface HGPageController ()<HGPageTitlesDelegate>

@property(nonatomic) NSInteger pageCount;
@property(nonatomic) NSInteger pageCurrent;
@property(nonatomic, strong) NSMutableDictionary *displayVCRecord;

@end

@implementation HGPageController

- (void)loadView {
    [super loadView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self install];
    self.pageCount = [self.dataSource numbersOfChildControllersInPageController:self];
    self.contentsView.contentSize = CGSizeMake(CGRectGetWidth(self.contentsView.frame) * self.pageCount, CGRectGetHeight(self.contentsView.frame));
    
    NSMutableArray *titles = [NSMutableArray.alloc init];
    for (int i = 0; i < self.pageCount; i++) {
        NSString *title = [self.dataSource pageController:self titleAtIndex:i];
        [titles addObject:title];
    }
    self.titlesView.titles = titles;
    [self.titlesView reloadData];
    
    [self addController:self.pageCurrent];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    for (int i = 0; i < self.pageCount; i++) {
        if (i != self.pageCurrent) {
            [self removeController:i];
        }
    }
    
}

#pragma mark -

- (void)addController:(NSInteger)index {
    UIViewController *controller = [self.dataSource pageController:self viewControllerAtIndex:index];
    [self addChildViewController:controller];
    controller.view.frame = CGRectMake(index * CGRectGetWidth(self.contentsView.frame), 0, CGRectGetWidth(self.contentsView.frame), CGRectGetHeight(self.contentsView.frame));
    [self.contentsView addSubview:controller.view];
    [controller didMoveToParentViewController:self];
    [self.displayVCRecord setObject:controller forKey:@(index)];
}
- (void)removeController:(NSInteger)index{
    UIViewController *controller = [self.displayVCRecord objectForKey:@(index)];
    [controller.view removeFromSuperview];
    [controller willMoveToParentViewController:nil];
    [controller removeFromParentViewController];
    [self.displayVCRecord removeObjectForKey:@(index)];
}
- (void)layoutChildViewController {
    int currentPage = (int)(self.contentsView.contentOffset.x / CGRectGetWidth(self.contentsView.frame));
    UIViewController *controller = [self.displayVCRecord objectForKey:@(currentPage)];
    if (!controller) {
        [self addController:currentPage];
    }
    if (currentPage > 0) {
        UIViewController *controllerPrev = [self.displayVCRecord objectForKey:@(currentPage - 1)];
        if (!controllerPrev) {
            [self addController:currentPage - 1];
        }
    }
    if (currentPage < self.pageCount - 1) {
        UIViewController *controllerNext = [self.displayVCRecord objectForKey:@(currentPage + 1)];
        if (!controllerNext) {
            [self addController:currentPage + 1];
        }
    }
}
#pragma mark - <HGPageTitlesDelegate>
- (void)pageTitles:(HGPageTitlesView *)titlesView didSelectItemAtIndex:(NSInteger)index {
    if (self.pageCurrent >= index - 1 && self.pageCurrent <= index + 1) {
        [self.contentsView setContentOffset:CGPointMake(SCREEN_WIDTH * index, 0) animated:YES];
    }else{
        [self.contentsView setContentOffset:CGPointMake(SCREEN_WIDTH * index, 0) animated:NO];
    }
}
#pragma mark - <UIScrollViewDelegate>
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (![scrollView isKindOfClass:HGPageContentsView.class]) return;
    [self layoutChildViewController];
    
    CGFloat contentOffsetX = scrollView.contentOffset.x;
    if (contentOffsetX < 0) {
        contentOffsetX = 0;
    }
    if (contentOffsetX > scrollView.contentSize.width - scrollView.size.width) {
        contentOffsetX = scrollView.contentSize.width - scrollView.size.width;
    }
    CGFloat rate = contentOffsetX / scrollView.size.width;
    
    [self.titlesView scrollToItemInProgress:rate];
    
}

#pragma mark - <HGPageControllerDataSource>

- (NSInteger)numbersOfChildControllersInPageController:(HGPageController *)pageController {
    return 0;
}
- (__kindof UIViewController *)pageController:(HGPageController *)pageController viewControllerAtIndex:(NSInteger)index {
    return [UIViewController.alloc init];
}
- (NSString *)pageController:(HGPageController *)pageController titleAtIndex:(NSInteger)index {
    return @"";
}

#pragma mark -

- (CGFloat)heightForHeader {
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(heightForHeaderOfPageController:)]) {
        return [self.dataSource heightForHeaderOfPageController:self];
    }
    return 44.f;
}

- (NSMutableDictionary *)displayVCRecord {
    if (!_displayVCRecord) {
        _displayVCRecord = [NSMutableDictionary.alloc init];
    }
    return _displayVCRecord;
}

#pragma mark - init

- (void)install {
    
    self.dataSource = self;
    self.pageCurrent = 0;
    
    CGFloat height = [self heightForHeader];
    
    self.titlesView = ({
        _titlesView = [HGPageTitlesView.alloc initWithFrame:CGRectMake(0, NAVandSTATUS_BAR_HEIHGT, SCREEN_WIDTH, height)];
        _titlesView.backgroundColor = [UIColor whiteColor];
        _titlesView.delegate = self;
        _titlesView;
    });
    self.contentsView = ({
        _contentsView = [HGPageContentsView.alloc initWithFrame:CGRectMake(0, self.titlesView.bottom, SCREEN_WIDTH, SCREEN_HEIGHT - self.titlesView.height - NAVandSTATUS_BAR_HEIHGT)];
        _contentsView.pagingEnabled = YES;
        _contentsView.directionalLockEnabled = YES;
        _contentsView.delegate = self;
        _contentsView.showsVerticalScrollIndicator = NO;
        _contentsView.showsHorizontalScrollIndicator = NO;
        _contentsView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        if (@available(iOS 11.0, *)) {
            _contentsView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        _contentsView;
    });
    
    if (self.navigationController) {
        for (UIGestureRecognizer *gestureRecognizer in _contentsView.gestureRecognizers) {
            [gestureRecognizer requireGestureRecognizerToFail:self.navigationController.interactivePopGestureRecognizer];
        }
    };
    
    [self.view addSubview:self.titlesView];
    [self.view addSubview:self.contentsView];
    
}




@end
