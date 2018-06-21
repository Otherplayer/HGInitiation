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
        _imageView = [UIImageView.alloc initWithFrame:CGRectMake(20, 100, 288, 180)];//2880 1800
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
        HGPhotoModel *model1 = [HGPhotoModel.alloc initWithUrlString:@"https://gss3.bdstatic.com/-Po3dSag_xI4khGkpoWK1HF6hhy/baike/c0%3Dbaike92%2C5%2C5%2C92%2C30/sign=ed1ae15f007b020818c437b303b099b6/d4628535e5dde71113f38a0cadefce1b9d166123.jpg"];
        HGPhotoModel *model2 = [HGPhotoModel.alloc initWithUrlString:@"https://gss3.bdstatic.com/-Po3dSag_xI4khGkpoWK1HF6hhy/baike/c0%3Dbaike92%2C5%2C5%2C92%2C30/sign=ed1ae15f007b020818c437b303b099b6/d4628535e5dde71113f38a0cadefce1b9d166123.jpg"];
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
