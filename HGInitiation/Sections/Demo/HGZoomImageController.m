//
//  HGZoomImageController.m
//  HGInitiation
//
//  Created by __无邪_ on 2018/1/3.
//  Copyright © 2018年 __无邪_. All rights reserved.
//

#import "HGZoomImageController.h"
#import "HGZoomImageView.h"

@interface HGZoomImageController ()

@property(nonatomic, strong)HGZoomImageView *zoomImageView;

@end

@implementation HGZoomImageController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.zoomImageView = ({
        _zoomImageView = [HGZoomImageView.alloc initWithFrame:self.view.bounds];
        _zoomImageView;
    });
    
    [self.zoomImageView setImage:[UIImage imageNamed:@"system-colors.jpeg"]];
    
    [self.view addSubview:self.zoomImageView];
    
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
