//
//  HGDownloadController.m
//  HGInitiation
//
//  Created by __无邪_ on 2018/3/27.
//  Copyright © 2018年 __无邪_. All rights reserved.
//

#import "HGDownloadController.h"
#import "HGDownloader.h"


@interface HGDownloadController ()
/** 下载任务 */
@property (nonatomic, strong) UILabel *labInfor;
@property (nonatomic, strong) NSURL *url;

@end

@implementation HGDownloadController

- (void)loadView {
    [super loadView];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"Download";
    
    NSString *urlStr = @"http://appldnld.apple.com/ios11.3seed/091-73590-20180316-E1B2451A-27AA-11E8-8D8B-C323A798A6CA/iPhone10,3,iPhone10,6_11.3_15E5216a_Restore.ipsw";//大文件
    urlStr = @"http://dldir1.qq.com/qqfile/QQforMac/QQ_V5.4.0.dmg";//小文件
//    urlStr = @"http://sw.bos.baidu.com/sw-search-sp/software/5e77ab765868f/NeteaseMusic_mac_1.5.9.622.dmg";
    self.url = urlStr.url;
    
    
    UIButton *btn = ({
        btn = [UIButton.alloc initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 200, SCREEN_WIDTH, 100)];
        [btn setTitle:@"START" forState:UIControlStateNormal];
        [btn setTitle:@"PAUSE" forState:UIControlStateSelected];
        [btn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(downloadAction:) forControlEvents:UIControlEventTouchUpInside];
        btn;
    });
    [self.view addSubview:btn];
    
    self.labInfor = ({
        _labInfor = [UILabel.alloc initWithFrame:CGRectMake(0, 100, SCREEN_WIDTH, 200)];
        _labInfor.textColor = [UIColor blueColor];
        _labInfor.textAlignment = NSTextAlignmentCenter;
        _labInfor.numberOfLines = 0;
        _labInfor.text = @"0%";
        _labInfor;
    });
    [self.view addSubview:self.labInfor];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    __weak typeof(self) weakSelf = self;
    
    
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - action

- (void)downloadAction:(UIButton *)sender {
    [sender setSelected:!sender.isSelected];
    if (sender.isSelected) {
        [[HGDownloader defaultInstance] startDownloadWithURL:self.url];
    }else{
        [[HGDownloader defaultInstance] stopDownloadWithURL:self.url];
    }
    
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
