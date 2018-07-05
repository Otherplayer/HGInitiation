//
//  HGFunController.m
//  HGInitiation
//
//  Created by __无邪_ on 2018/5/3.
//  Copyright © 2018年 __无邪_. All rights reserved.
//

#import "HGFunctionsController.h"

@interface HGFunctionsController ()

@end

@implementation HGFunctionsController


#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
//    double delayInSeconds = 0.8f;
//    dispatch_time_t delayInNanoSeconds = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
//    dispatch_after(delayInNanoSeconds, dispatch_get_main_queue(), ^(void){
//        [HGHelperPush push:@{HGPushClassName:@"HGProgressHUDTest"}];
////        HGBASENavigationController *controller = (HGBASENavigationController *)[UIStoryboard loginController];
////        [self presentViewController:controller animated:YES completion:nil];
//    });
    
    self.navigationItem.title = @"Functions";
    
    UILabel *labTip = [UILabel.alloc initWithFrame:self.view.bounds];
    [labTip setText:i18n_Text(@"test_tip")];
    [labTip setTextAlignment:NSTextAlignmentCenter];
    [labTip setTextColor:[UIColor systemRed]];
    [self.view addSubview:labTip];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
