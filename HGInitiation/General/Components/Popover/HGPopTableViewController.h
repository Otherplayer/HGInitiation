//
//  HGPopTableViewController.h
//  HGInitiation
//
//  Created by __无邪_ on 2018/6/22.
//  Copyright © 2018年 __无邪_. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^HGPopMenuDoneBlock)(NSInteger selectedIndex);
typedef void(^HGPopMenuCancelBlock)(void);

typedef NS_ENUM(NSUInteger, HGPopTableViewTheme) {
    HGPopTableViewThemeDefault,
    HGPopTableViewThemeDark,
    HGPopTableViewThemeWhite,
};


@interface HGPopTableViewController : UITableViewController

- (instancetype)initWithTheme:(HGPopTableViewTheme)theme;

@property (nonatomic, assign)UIBarButtonItem *barButtonItem;
@property (nonatomic, assign)UIView *sourceView;
@property (nonatomic, strong)NSString *titleStr;
@property (nonatomic, strong)NSArray<NSString *>* menuArray;
@property (nonatomic, strong)NSArray<NSString *>* imageArray;

@property (nonatomic, assign)NSInteger selectedIndex;
@property (nonatomic, strong)HGPopMenuDoneBlock doneBlock;
@property (nonatomic, strong)HGPopMenuCancelBlock cancelBlock;

@end
