//
//  HGPageControllerDemo.m
//  HGInitiation
//
//  Created by __无邪_ on 2018/6/4.
//  Copyright © 2018年 __无邪_. All rights reserved.
//

#import "HGPageControllerDemo.h"
#import "HGFeaturedController.h"
#import "HGPageContentController.h"
#import "HGPageContent2Controller.h"

@interface HGPageControllerDemo (){
    UIImageView *navBarBottonLineImageView;
}
@end

@implementation HGPageControllerDemo

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    navBarBottonLineImageView = [self findBarBottomLineImageView:self.navigationController.navigationBar];
    navBarBottonLineImageView.hidden = YES;//隐藏
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    navBarBottonLineImageView.hidden = YES;//隐藏
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    navBarBottonLineImageView.hidden = NO;
}

// 找到横线视图
- (UIImageView *)findBarBottomLineImageView:(UIView *)view {
    if ([view isKindOfClass:[UIImageView class]] && view.bounds.size.height <= 1.0) {
        return (UIImageView *)view;
    }
    for (UIView *subView in view.subviews) {
        UIImageView *imageView = [self findBarBottomLineImageView:subView];// 递归
        if (imageView) {
            return imageView;
        }
    }
    return nil;
}
#pragma mark - <HGPageControllerDataSource>

- (NSInteger)numbersOfChildControllersInPageController:(HGPageController *)pageController {
    return 10;
}
- (__kindof UIViewController *)pageController:(HGPageController *)pageController viewControllerAtIndex:(NSInteger)index {
    switch (index  % 3) {
        case 0:
            return [HGPageContent2Controller.alloc init];
            break;
        case 1:
            return [HGPageContentController.alloc init];
        default:
            break;
    }
    HGFeaturedController *controller = [HGFeaturedController.alloc init];
    controller.view.backgroundColor = [UIColor randomColor];
    return controller;
}
- (NSString *)pageController:(HGPageController *)pageController titleAtIndex:(NSInteger)index {
    NSArray *titles = @[@"泰国",@"新加坡",@"马拉西亚",@"斯德哥尔摩"];
    return titles[index%titles.count];
}
- (CGFloat)heightForHeaderOfPageController:(HGPageController *)pageController {
    return 50.0f;
}

@end
