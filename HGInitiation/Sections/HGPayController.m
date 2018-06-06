//
//  HGPayController.m
//  HGInitiation
//
//  Created by __无邪_ on 2018/6/6.
//  Copyright © 2018年 __无邪_. All rights reserved.
//

#import "HGPayController.h"
#import "CNPPopupController.h"
#import "HGMutilHorizontalScrollView.h"

@interface HGPayController ()
@property (nonatomic, strong) CNPPopupController *popupController;
@end

@implementation HGPayController

#pragma mark - LifeCircle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self addRightBarButtonItemWithTitle:@"Pay"];
    
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self rightBarButtonPressed:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




#pragma mark - Action

- (void)rightBarButtonPressed:(id)rightBarButtonPressed{
    [self showPopupWithStyle:CNPPopupStyleActionSheet];
}

- (void)showPopupWithStyle:(CNPPopupStyle)popupStyle{
    HGMutilHorizontalScrollView *customView = [[HGMutilHorizontalScrollView alloc] initWithItems:@[
                                                                                                   @[
  @{@"title":@"微信",@"icon":@"sharekit_icon_wx",@"icon_disabled":@"sharekit_icon_wx_disable",@"enabled":@0},
  @{@"title":@"微信",@"icon":@"sharekit_icon_wx",@"icon_disabled":@"sharekit_icon_wx_disable",@"enabled":@0},
  @{@"title":@"微信",@"icon":@"sharekit_icon_wx",@"icon_disabled":@"sharekit_icon_wx_disable",@"enabled":@0},
  @{@"title":@"微信",@"icon":@"sharekit_icon_wx",@"icon_disabled":@"sharekit_icon_wx_disable",@"enabled":@0},
  @{@"title":@"微信",@"icon":@"sharekit_icon_wx",@"icon_disabled":@"sharekit_icon_wx_disable",@"enabled":@0},
  @{@"title":@"微信",@"icon":@"sharekit_icon_wx",@"icon_disabled":@"sharekit_icon_wx_disable",@"enabled":@0},
  @{@"title":@"微信",@"icon":@"sharekit_icon_wx",@"icon_disabled":@"sharekit_icon_wx_disable",@"enabled":@0},
  @{@"title":@"微信",@"icon":@"sharekit_icon_wx",@"icon_disabled":@"sharekit_icon_wx_disable",@"enabled":@0},
  @{@"title":@"微信",@"icon":@"sharekit_icon_wx",@"icon_disabled":@"sharekit_icon_wx_disable",@"enabled":@0},
  @{@"title":@"微信",@"icon":@"sharekit_icon_wx",@"icon_disabled":@"sharekit_icon_wx_disable",@"enabled":@0}
  ],
                                                                                                   @[
                                                                                                       @{@"title":@"微信",@"icon":@"sharekit_icon_wx",@"icon_disabled":@"sharekit_icon_wx",@"enabled":@1}]
                                                                                                   ]];
    customView.backgroundColor = [UIColor cyanColor];
    
    @weakify(self);
    [customView setDidTapCancelHandler:^{
        @strongify(self);
        if (!self) {return;}
        [self.popupController dismissPopupControllerAnimated:YES];
    }];
    
    self.popupController = [[CNPPopupController alloc] initWithContents:@[customView]];
    self.popupController.theme = [CNPPopupTheme defaultTheme];
    self.popupController.theme.popupStyle = popupStyle;
    [self.popupController presentPopupControllerAnimated:YES];
}


@end
