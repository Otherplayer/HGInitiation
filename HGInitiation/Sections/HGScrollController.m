//
//  HGScrollController.m
//  HGInitiation
//
//  Created by __无邪_ on 2018/1/9.
//  Copyright © 2018年 __无邪_. All rights reserved.
//

#import "HGScrollController.h"
#import "HGScrollView.h"
#import "HGScrollDefaultImage.h"

@interface HGScrollController ()<HGScrollViewDelegate>

@property(nonatomic, strong)NSArray *datas;

@end

@implementation HGScrollController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    self.datas = @[
                   @{@"title":@"JAY",
                     @"url":@"http://a.hiphotos.baidu.com/baike/pic/item/8ad4b31c8701a18b4f7365d3942f07082938fe96.jpg"},//周杰伦
                   @{@"title":@"MEIZI",
                     @"url":@"https://gss1.bdstatic.com/9vo3dSag_xI4khGkpoWK1HF6hhy/baike/s%3D500/sign=73a1583510d5ad6eaef964eab1ca39a3/8326cffc1e178a8218bb1c51fd03738da877e8b8.jpg"},//美女
                   @{@"title":@"HEIGUAFU",
                     @"url":@"https://gss3.bdstatic.com/-Po3dSag_xI4khGkpoWK1HF6hhy/baike/c0%3Dbaike92%2C5%2C5%2C92%2C30/sign=ed1ae15f007b020818c437b303b099b6/d4628535e5dde71113f38a0cadefce1b9d166123.jpg"}];
    
    
    CGFloat height = (SCREEN_HEIGHT - NAVandSTATUS_BAR_HEIHGT) / 4.0f;
    
    HGScrollView *scrollView = [HGScrollView.alloc initWithFrame:CGRectMake(0, NAVandSTATUS_BAR_HEIHGT, SCREEN_WIDTH, height) type:HGScrollViewContentTypeImage];
    [scrollView setPageControlPosition:HGPageControlPositionBottomRight];
    [self.view addSubview:scrollView];
    [scrollView setDatas:self.datas key:@"url" titleKey:@"title"];

    HGScrollView *scrollView2 = [HGScrollView.alloc initWithFrame:CGRectMake(0, scrollView.bottom, SCREEN_WIDTH, height) type:HGScrollViewContentTypeImage];
    [scrollView2 setPageControlPosition:HGPageControlPositionBottomCenter];
    [scrollView2 setAutoScroll:NO];
    [scrollView2 setLoopScroll:NO];
    [self.view addSubview:scrollView2];
    [scrollView2 setDatas:self.datas key:@"url" titleKey:nil];

    HGScrollView *scrollView3 = [HGScrollView.alloc initWithFrame:CGRectMake(0, scrollView2.bottom, SCREEN_WIDTH, height) type:HGScrollViewContentTypeImage direction:HGScrollDirectionVertical];
    [scrollView3 setPageControlPosition:HGPageControlPositionBottomRight];
    [self.view addSubview:scrollView3];
    [scrollView3 setDelegate:self];
    [scrollView3 setDatas:self.datas key:@"url" titleKey:nil];
    
    HGScrollView *scrollView4 = [HGScrollView.alloc initWithFrame:CGRectMake(0, scrollView3.bottom, SCREEN_WIDTH, height) type:HGScrollViewContentTypeImage direction:HGScrollDirectionVertical];
    [scrollView4 setPageControlPosition:HGPageControlPositionNone];
    [self.view addSubview:scrollView4];
    [scrollView4 setAutoScroll:NO];
    [scrollView4 setLoopScroll:NO];
    [scrollView4 setDatas:self.datas key:@"url" titleKey:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -

- (void)scrollView:(HGScrollView *)scrollView didSelectItemAtIndex:(NSInteger)index {
    NSLog(@"---点击了PAGE:%@",@(index));
}
- (void)scrollView:(HGScrollView *)scrollView didScroll2Index:(NSInteger)index {
    NSLog(@"滚动到了PAGE:%@  当前页%@",@(index),@(scrollView.currentPage));
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
