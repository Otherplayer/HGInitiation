//
//  HGBASETabBarController.m
//  HGInitiation
//
//  Created by __无邪_ on 2018/1/24.
//  Copyright © 2018年 __无邪_. All rights reserved.
//

#import "HGBASETabBarController.h"
#import "HGFunctionsController.h"
#import "HGFeaturedController.h"
#import "HGSettingsController.h"

@interface HGBASETabBarController ()

@end

@implementation HGBASETabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - init

- (void)setDefaultViewControllers {
    
    // controller
    HGFunctionsController *controller1 = [HGFunctionsController.alloc init];
    HGSettingsController *controller2 = [HGSettingsController.alloc init];
    HGFeaturedController *controller3 = [HGFeaturedController.alloc init];
    
    // navigation
    HGBASENavigationController *nav1 = [HGBASENavigationController.alloc initWithRootViewController:controller1];
    HGBASENavigationController *nav2 = [HGBASENavigationController.alloc initWithRootViewController:controller2];
    HGBASENavigationController *nav3 = [HGBASENavigationController.alloc initWithRootViewController:controller3];
    
    // item
    UITabBarItem *item1 = [[UITabBarItem alloc] initWithTitle:@"Functions" image:[UIImage imageNamed:@"tab_funtion"] selectedImage:[[UIImage imageNamed:@"tab_funtion"] imageByTintColor:HGConfigurationInstance.tabBarTintColor]];
    UITabBarItem *item2 = [[UITabBarItem alloc] initWithTitle:@"Whatever" image:[UIImage imageNamed:@"tab_num_frame_0"] selectedImage:[[UIImage imageNamed:@"tab_num_frame_9"] imageByTintColor:HGConfigurationInstance.tabBarTintColor]];
    UITabBarItem *item3 = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemFeatured tag:2];
    
    nav1.tabBarItem = item1;
    nav2.tabBarItem = item2;
    nav3.tabBarItem = item3;
    
    self.viewControllers = @[nav1,nav2,nav3];
    
}

#pragma mark - UITabBarDelegate

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    NSInteger index = [self.tabBar.items indexOfObject:item];
    
    if (index == 0 || index == 1) {
        [self animationWithIndex:index];
    }
    
}


#pragma mark - private

- (void)animationWithIndex:(NSInteger) index {
    NSMutableArray * tabbarbuttonArray = [NSMutableArray array];
    for (UIView *tabBarButton in self.tabBar.subviews) {
        if ([tabBarButton isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
            [tabbarbuttonArray addObject:tabBarButton];
        }
    }
    
    UIButton *btn = tabbarbuttonArray[index];
    UIImageView *imageView = [btn valueForKey:@"info"];

    NSString *imageNamePrefix;
    NSInteger startIndex = 0;
    NSInteger endIndex = 0;
    if (index == 0) {
        startIndex = 1;
        endIndex = 10;
        imageNamePrefix = @"tab_funtion_frame";
    }else if (index == 1) {
        startIndex = 0;
        endIndex = 9;
        imageNamePrefix = @"tab_num_frame";
    }
    
    imageView.animationImages = [self imageNamesWithPrefix:imageNamePrefix startIndex:startIndex endIndex:endIndex];
    imageView.animationRepeatCount = 1;
    imageView.animationDuration = 0.35;
    [imageView startAnimating];
}

- (NSArray <UIImage *> *)imageNamesWithPrefix:(NSString *)prefix startIndex:(NSInteger)startIndex endIndex:(NSInteger)endIndex {
    NSMutableArray *images = [NSMutableArray arrayWithCapacity:endIndex - startIndex + 1];
    for (NSInteger index = startIndex; index <= endIndex; index ++) {
        NSString *imageName = [prefix stringByAppendingFormat:@"_%ld", (long)index];
        UIImage *image = [[UIImage imageNamed:imageName] imageWithTintColor:HGConfigurationInstance.tabBarTintColor];
        if (image != nil) {
            [images addObject:image];
        }
    }
    return [images copy];
}

@end
