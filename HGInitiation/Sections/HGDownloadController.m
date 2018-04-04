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
@property (nonatomic, strong) CALayer *layerProgress;
@property (nonatomic, strong) UILabel *labInfor;
@property (nonatomic, strong) UIButton *btnDownloader;
@property (nonatomic, strong) NSURL *url;

@end

@implementation HGDownloadController

- (void)loadView {
    [super loadView];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"Download";
    
    NSString *urlStr = @"http://appldnld.apple.com/ios11.3seed/091-73590-20180316-E1B2451A-27AA-11E8-8D8B-C323A798A6CA/iPhone10,3,iPhone10,6_11.3_15E5216a_Restore.ipsw";//大文件
//    urlStr = @"http://sw.bos.baidu.com/sw-search-sp/software/5e77ab765868f/NeteaseMusic_mac_1.5.9.622.dmg";////小文件
    self.url = urlStr.url;
    
    
    self.layerProgress = ({
        _layerProgress = [CALayer.alloc init];
        _layerProgress.backgroundColor = [UIColor cyanColor].CGColor;
        _layerProgress;
    });
    [self.layerProgress setFrame:CGRectMake(0, NAVandSTATUS_BAR_HEIHGT, kScreenWidth, 0)];
    [self.view.layer addSublayer:self.layerProgress];
    
    
    self.btnDownloader = ({
        _btnDownloader = [UIButton.alloc initWithFrame:CGRectMake((kScreenWidth - 120)/2.0, SCREEN_HEIGHT - 200, 120, 50)];
        [_btnDownloader setTitle:@"START" forState:UIControlStateNormal];
        [_btnDownloader setTitle:@"PAUSE" forState:UIControlStateSelected];
        [_btnDownloader setTitle:@"DONE" forState:UIControlStateDisabled];
        [_btnDownloader setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_btnDownloader setAdjustsImageWhenDisabled:YES];
        [_btnDownloader addTarget:self action:@selector(downloadAction:) forControlEvents:UIControlEventTouchUpInside];
        _btnDownloader;
    });
    [self.view addSubview:self.btnDownloader];
    
    self.labInfor = ({
        _labInfor = [UILabel.alloc initWithFrame:CGRectMake(0, 100, SCREEN_WIDTH, 200)];
        _labInfor.textColor = [UIColor orangeColor];
        _labInfor.textAlignment = NSTextAlignmentCenter;
        _labInfor.font = [UIFont systemFontOfSize:40 weight:UIFontWeightMedium];
        _labInfor.numberOfLines = 0;
        _labInfor.text = @"0%";
        _labInfor;
    });
    [self.view addSubview:self.labInfor];
    
    
    NSDictionary *localInfo = [[HGDownloader defaultInstance] localDownloadInfoForURL:self.url];
    if (localInfo) {
        NSNumber *received = localInfo[HGDownloadCompletedUnitCount];
        NSNumber *total = localInfo[HGDownloadTotalUnitCount];
        if (total) {
            [self updateProgress:received.doubleValue / total.doubleValue];
        }
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveDownloadProgressNotification:) name:HGNotificationDefaultDownloadProgress object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveDownloadDoneNotification:) name:HGNotificationDefaultDownloadDone object:nil];
    
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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

#pragma mark -

- (void)updateProgress:(double)fractionCompleted {
    [self.labInfor setText:[NSString stringWithFormat:@"%.2f%%",100 * fractionCompleted]];
    [self.layerProgress setFrame:CGRectMake(0, NAVandSTATUS_BAR_HEIHGT, kScreenWidth, (kScreenHeight - NAV_BAR_HEIGHT) * fractionCompleted)];
    if (!self.btnDownloader.isSelected) {
        [self.btnDownloader setSelected:YES];
    }
}

#pragma mark - notification

- (void)didReceiveDownloadProgressNotification:(NSNotification *)noti {
    NSProgress *progress = noti.object;
    [self updateProgress:progress.fractionCompleted];
}
- (void)didReceiveDownloadDoneNotification:(NSNotification *)noti {
    NSDictionary *downloadInfo = noti.object;
    NSLog(@"%@",downloadInfo);
    [self.btnDownloader setEnabled:NO];
    [self.btnDownloader setTitle:@"DONE" forState:UIControlStateNormal];
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
