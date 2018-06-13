//
//  HGPagesWithHeaderDemo.m
//  HGInitiation
//
//  Created by __无邪_ on 2018/6/12.
//  Copyright © 2018年 __无邪_. All rights reserved.
//

#import "HGPagesWithHeaderDemo.h"
#import "HGPagesScrollView.h"

@interface HGPagesWithHeaderDemo ()
@property(nonatomic, strong)HGPagesScrollView *pagesScrollView;
@end

@implementation HGPagesWithHeaderDemo

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.pagesScrollView = ({
        _pagesScrollView = [HGPagesScrollView.alloc initWithFrame:self.view.bounds];
        _pagesScrollView;
    });
    [self.view addSubview:self.pagesScrollView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
