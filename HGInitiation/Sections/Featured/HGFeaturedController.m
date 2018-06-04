//
//  HGFeaturedController.m
//  HGInitiation
//
//  Created by __无邪_ on 2018/5/16.
//  Copyright © 2018年 __无邪_. All rights reserved.
//

#import "HGFeaturedController.h"

@interface HGFeaturedController ()

@end

@implementation HGFeaturedController

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
    self.navigationItem.title = @"Featured";
    UIImageView *imageview = [[UIImageView alloc] init];
    
    imageview.frame = CGRectMake(10, 100, 300, 300);
    
    imageview.image = [UIImage imageNamed:@"1.jpg"];
    
    imageview.contentMode = UIViewContentModeScaleAspectFit;
    
    imageview.userInteractionEnabled = YES;
    
    [self.view addSubview:imageview];
    
    
    
    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
    
    UIVisualEffectView *effectview = [[UIVisualEffectView alloc] initWithEffect:blur];
    
    effectview.frame = CGRectMake(0, 0, imageview.size.width/2, 300);
    
    
    
    [imageview addSubview:effectview];
    
    
    
    
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];

    btn.frame = CGRectMake(10, 50, 100, 40);

    [btn setTitle:@"btn" forState:UIControlStateNormal];

    [effectview.contentView addSubview:btn];
    
    [self addRightBarButtonItemWithTitle:@"完成"];
    
    
    
}

@end
