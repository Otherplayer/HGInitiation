//
//  HGPageScrollController.m
//  HGInitiation
//
//  Created by __无邪_ on 2018/3/12.
//  Copyright © 2018年 __无邪_. All rights reserved.
//

#import "HGPagesController.h"
#import "HGPageContentController.h"

@interface HGPagesController ()<UIScrollViewDelegate>
@property(nonatomic,strong)UIView *headerView;
@property(nonatomic,strong)UIScrollView *scrollView;
@property(nonatomic,strong)NSMutableArray *items;
@end

@implementation HGPagesController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    self.headerView = ({
        _headerView = [UIView.alloc initWithFrame:CGRectMake(0, NAVandSTATUS_BAR_HEIHGT, SCREEN_WIDTH, SCREEN_WIDTH * 9 / 16.0)];
        _headerView.backgroundColor = [UIColor cyanColor];
        _headerView;
    });
    
    self.scrollView = ({
        _scrollView = [UIScrollView.alloc initWithFrame:CGRectMake(0, NAVandSTATUS_BAR_HEIHGT, self.view.width, SCREEN_HEIGHT - NAVandSTATUS_BAR_HEIHGT)];
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.delegate = self;
        _scrollView.bounces = NO;
        _scrollView.pagingEnabled = YES;
        _scrollView.directionalLockEnabled = YES;
        _scrollView;
    });
    
    
    [self.view addSubview:self.scrollView];
    [self.view addSubview:self.headerView];
    
    self.items = [NSMutableArray.alloc init];
    [self.items addObject:@""];
    [self.items addObject:@""];
    
    [self.scrollView setContentSize:CGSizeMake(self.scrollView.width * self.items.count, self.scrollView.height)];
    
    for (int i = 0; i < self.items.count; i++) {
        HGPageContentController *controller = [HGPageContentController.alloc init];
        controller.view.frame = CGRectMake(SCREEN_WIDTH * i, 0, SCREEN_WIDTH, self.scrollView.height);
        [self addChildViewController:controller];
        [self.scrollView addSubview:controller.view];
        [controller.tableView addObserver:self
                            forKeyPath:@"contentOffset"
                               options:NSKeyValueObservingOptionNew
                               context:nil];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    for (UITableViewController *controller in self.childViewControllers) {
        [controller.tableView removeObserver:self forKeyPath:@"contentOffset"];
    }
}

#pragma amrk -
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"contentOffset"]) {
        CGFloat headerViewScrollStopY = self.headerView.height - 50;
        UITableView *tableView = object;
        CGFloat contentOffsetY = tableView.contentOffset.y;
        
        if (contentOffsetY < headerViewScrollStopY) {
            self.headerView.top = - tableView.contentOffset.y + NAVandSTATUS_BAR_HEIHGT;
            // Sync contentOffset
            for (UITableViewController *controller in self.childViewControllers) {
                if (controller.tableView.contentOffset.y != tableView.contentOffset.y) {
                    controller.tableView.contentOffset = tableView.contentOffset;
                }
            }
        } else {
            self.headerView.top = - headerViewScrollStopY + NAVandSTATUS_BAR_HEIHGT;
            for (UITableViewController *controller in self.childViewControllers) {
                if (controller.tableView.contentOffset.y < headerViewScrollStopY) {
                    CGPoint contentOffset = controller.tableView.contentOffset;
                    contentOffset.y = headerViewScrollStopY;
                    controller.tableView.contentOffset = contentOffset;
                }
            }
        }
    }
}
#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.scrollView) {
        
    }
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
