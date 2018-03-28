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
@property (nonatomic, strong) HGDownloader *downloader;
@property (nonatomic, strong) UILabel *labInfor;

@end

@implementation HGDownloadController

- (void)loadView {
    [super loadView];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"Download";
    
    UIButton *btn = ({
        btn = [UIButton.alloc initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 200, SCREEN_WIDTH, 100)];
        [btn setTitle:@"START" forState:UIControlStateNormal];
        [btn setTitle:@"PAUSE" forState:UIControlStateSelected];
        [btn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(downloadAction:) forControlEvents:UIControlEventTouchUpInside];
        btn;
    });
    [self.view addSubview:btn];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.labInfor = ({
        _labInfor = [UILabel.alloc initWithFrame:CGRectMake(0, 100, SCREEN_WIDTH, 200)];
        _labInfor.textColor = [UIColor blueColor];
        _labInfor.textAlignment = NSTextAlignmentCenter;
        _labInfor.numberOfLines = 0;
        _labInfor;
    });
    [self.view addSubview:self.labInfor];
    
    
    NSString *url = @"http://appldnld.apple.com/ios11.3seed/091-73590-20180316-E1B2451A-27AA-11E8-8D8B-C323A798A6CA/iPhone10,3,iPhone10,6_11.3_15E5216a_Restore.ipsw";//大文件
//    url = @"http://dldir1.qq.com/qqfile/QQforMac/QQ_V5.4.0.dmg";//小文件
    
    __weak typeof(self) weakSelf = self;
    self.downloader = [HGDownloader.alloc init];
    [self.downloader download:url config:^(NSDictionary *configInfo) {
        NSLog(@"%@",configInfo);
    } progress:^(NSProgress *progress) {
        NSString *info = [NSString stringWithFormat:@"[1]当前下载进度:%.4f%%",100.0 * progress.completedUnitCount / progress.totalUnitCount];
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.labInfor setText:info];
        });
    } completed:^(BOOL success, NSString *errDesc, NSString *path) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (success) {
                [weakSelf.labInfor setText:[NSString stringWithFormat:@"下载完成：%@",path]];
            }else {
                [HGShowTip showTipTextOnly:errDesc dealy:2];
            }
        });
    }];
    
    
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.downloader stop];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - action

- (void)downloadAction:(UIButton *)sender {
    [sender setSelected:!sender.isSelected];
    if (sender.isSelected) {
        [self.downloader start];
    }else{
        [self.downloader stop];
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
