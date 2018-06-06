//
//  HGPageController.h
//  HGInitiation
//
//  Created by __无邪_ on 2018/5/21.
//  Copyright © 2018年 __无邪_. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HGPageTitlesView.h"
#import "HGPageContentsView.h"


@class HGPageController;
@protocol HGPageControllerDataSource <NSObject>
@required
- (NSInteger)numbersOfChildControllersInPageController:(HGPageController *)pageController;
- (__kindof UIViewController *)pageController:(HGPageController *)pageController viewControllerAtIndex:(NSInteger)index;
- (NSString *)pageController:(HGPageController *)pageController titleAtIndex:(NSInteger)index;
@optional
- (CGFloat)heightForHeaderOfPageController:(HGPageController *)pageController;
@end


@interface HGPageController : UIViewController<UIScrollViewDelegate,HGPageControllerDataSource>

/** 顶部导航 */
@property(nonatomic, strong)HGPageTitlesView *titlesView;
/** 内部容器 */
@property(nonatomic, strong)HGPageContentsView *contentsView;


@property(nonatomic, weak)id<HGPageControllerDataSource>dataSource;


@end
