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
    self.popupManager = [HGPopupManager.alloc init];
    
    UIImageView *imageView = [UIImageView.alloc initWithFrame:self.view.bounds];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.image = [UIImage imageNamed:@"large_leaves_70mp.jpg"];
    [self.view addSubview:imageView];
    
    
    
    
    UIBarButtonItem *shareItem = [UIBarButtonItem.alloc initWithTitle:@"Share" style:UIBarButtonItemStylePlain target:self action:@selector(showShare)];
    UIBarButtonItem *shareItem2 = [UIBarButtonItem.alloc initWithTitle:@"Share2" style:UIBarButtonItemStylePlain target:self action:@selector(showShare2)];
    UIBarButtonItem *payItem = [UIBarButtonItem.alloc initWithTitle:@"Pay" style:UIBarButtonItemStylePlain target:self action:@selector(showPay)];
    self.navigationItem.rightBarButtonItems = @[shareItem2,shareItem,payItem];
    
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




#pragma mark - Action

- (void)showPay {
    [self.popupManager showPayViewWithHandler:^(NSInteger row) {
        NSLog(@"%@",@(row));
    }];
}
- (void)showShare {
    [self.popupManager showShareViewWithHandler:^(NSInteger section, NSInteger row) {
        NSLog(@"%@ - %@",@(section),@(row));
    }];
}
- (void)showShare2 {
    [self.popupManager showShare9ViewWithHandler:^(NSInteger row) {
        NSLog(@"%@",@(row));
    }];
}
@end
