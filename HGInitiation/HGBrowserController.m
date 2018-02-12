//
//  HGBrowserController.m
//  HGInitiation
//
//  Created by __无邪_ on 2018/1/8.
//  Copyright © 2018年 __无邪_. All rights reserved.
//

#import "HGBrowserController.h"
#import "HGPhotoBrowser.h"
@interface HGBrowserController ()
@property (nonatomic, strong)UIImageView *imageView;
@end

@implementation HGBrowserController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.imageView = ({
        _imageView = [UIImageView.alloc initWithFrame:CGRectMake(100, 100, 288, 180)];//2880 1800
        _imageView.image = [UIImage imageNamed:@"1.jpg"];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.userInteractionEnabled = YES;
        _imageView;
    });
    
    [self.view addSubview:self.imageView];
    
    
    UITapGestureRecognizer *tapGesture = [UITapGestureRecognizer.alloc initWithTarget:self action:@selector(showBrowserAction:)];
    [self.imageView addGestureRecognizer:tapGesture];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -
- (void)showBrowserAction:(UITapGestureRecognizer *)gesture {
    
    
    NSMutableArray *photos = [NSMutableArray.alloc init];
    for (int i = 0; i < 50; i++) {
        HGPhotoModel *model1 = [HGPhotoModel.alloc initWithUrlString:@"https://ipfs.io/ipfs/QmNj85qnifLMZD6vJFmJeK6LUnHHfsbUvEPhJFdMnVHqz5"];
        HGPhotoModel *model2 = [HGPhotoModel.alloc initWithUrlString:@"https://ipfs.io/ipfs/QmNj85qnifLMZD6vJFmJeK6LUnHHfsbUvEPhJFdMnVHqz5"];
        [photos addObject:model1];
        [photos addObject:model2];
    }
    
    
    HGPhotoBrowser *browser = [HGPhotoBrowser.alloc initWithPhotos:photos index:1 animatedFromView:self.imageView];
    [self presentViewController:browser animated:YES completion:nil];
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
