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

@interface HGPageControllerDemo ()

@end

@implementation HGPageControllerDemo

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.titlesView.backgroundColor = [UIColor whiteColor];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    return [NSString stringWithFormat:@"中国[%@]",@(index)];
}
- (CGFloat)heightForHeaderOfPageController:(HGPageController *)pageController {
    return 50.0f;
}

@end
