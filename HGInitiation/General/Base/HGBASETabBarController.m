//
//  HGBASETabBarController.m
//  HGInitiation
//
//  Created by __无邪_ on 2018/1/24.
//  Copyright © 2018年 __无邪_. All rights reserved.
//

#import "HGBASETabBarController.h"
#import "HGFunctionsController.h"
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
    
    // navigation
    HGBASENavigationController *nav1 = [HGBASENavigationController.alloc initWithRootViewController:controller1];
    HGBASENavigationController *nav2 = [HGBASENavigationController.alloc initWithRootViewController:controller2];
    
    // item
    UITabBarItem *item1 = [[UITabBarItem alloc] initWithTitle:@"功能" image:[UIImage imageNamed:@"tab_funtion"] selectedImage:[[UIImage imageNamed:@"tab_funtion"] imageByTintColor:HGConfigurationInstance.tabBarTintColor]];
    UITabBarItem *item2 = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemFeatured tag:1];
    
    nav1.tabBarItem = item1;
    nav2.tabBarItem = item2;
    
    self.viewControllers = @[nav1,nav2];
    
}

#pragma mark - UITabBarDelegate

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    NSInteger index = [self.tabBar.items indexOfObject:item];
    
    if (index == 0) {
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
    imageView.animationImages = [self imageNamesWithPrefix:@"tab_funtion_frame" startIndex:1 endIndex:10];
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
