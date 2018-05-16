//
//  HGSettingsController.m
//  HGInitiation
//
//  Created by __无邪_ on 2018/5/3.
//  Copyright © 2018年 __无邪_. All rights reserved.
//

#import "HGSettingsController.h"

@interface HGSettingsController ()

@end

@implementation HGSettingsController

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self initiateDatas];
    [self initiateViews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - private method

#pragma mark - initiate

- (void)initiateDatas {
    
}
- (void)initiateViews {
    self.navigationItem.title = @"Settings";
}

@end
