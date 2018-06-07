//
//  HGPayController.m
//  HGInitiation
//
//  Created by __无邪_ on 2018/6/6.
//  Copyright © 2018年 __无邪_. All rights reserved.
//

#import "HGPayController.h"
#import "HGPopupManager.h"
@interface HGPayController ()
@property(nonatomic, strong)HGPopupManager *popupManager;
@end

@implementation HGPayController

#pragma mark - LifeCircle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    [self.view setBackgroundColor:[UIColor cyanColor]];
    
    UIImageView *imageView = [UIImageView.alloc initWithFrame:self.view.bounds];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.image = [UIImage imageNamed:@"large_leaves_70mp.jpg"];
    [self.view addSubview:imageView];
    
    
    [self addRightBarButtonItemWithTitle:@"Share"];
    
    self.popupManager = [HGPopupManager.alloc init];
    
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
    [self.popupManager showShareViewWithHandler:^(NSInteger section, NSInteger row) {
        NSLog(@"%@ - %@",@(section),@(row));
    }];
//    [self.popupManager showPayViewWithHandler:^(NSInteger section, NSInteger row) {
//        NSLog(@"%@ - %@",@(section),@(row));
//    }];
}                         


@end
