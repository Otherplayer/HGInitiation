//
//  HGDemoController.m
//  HGInitiation
//
//  Created by __无邪_ on 2018/7/4.
//  Copyright © 2018年 __无邪_. All rights reserved.
//

#import "HGDemoController.h"
#import "HGHTTPClient.h"
#import "HGAssetManager.h"
#import "HGImagePickerController.h"
#import "HGAvatarClipperController.h"
#import "HGOtherController.h"
#import "HGPickerView.h"
#import "HGDatePickerView.h"
#import "HGHelperPush.h"
#import "HGThemeWhatever.h"
#import <LocalAuthentication/LocalAuthentication.h>
#import "HGBASENavigationController.h"

#import "HGInitiation-Swift.h"

NSString *const TITLE = @"title";
NSString *const TYPE = @"type";
NSString *const FUN = @"function";
NSString *const PARAMS = @"params";


CGFloat threshold = 0.7;
CGFloat itemPerPage = 10;
CGFloat currentPage = 0;

@interface HGDemoController ()<UITableViewDataSource,UITableViewDelegate,HGImagePickerDelegate,HGAvatarClipperDelegate>
@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, strong)NSArray *items;
@property(nonatomic, strong)NSMutableArray *datas;

@end

@implementation HGDemoController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initiateDatas];
    [self initiateViews];
    [self addNotifications];
    
    perform_block_after_delay(1.f, ^{
        [HGHelperPush push:@{HGPushClassName:@"HGLanguagesTest"}];
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)backBarButtonPressed:(id)backBarButtonPressed{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)dealloc {
    NSLog(@"YES-HGDemoController-dealloc");
    [self removeNotifications];
}

#pragma mark - event response

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.items.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:HGIdentifier forIndexPath:indexPath];
    
    NSDictionary *item = self.items[indexPath.row];
    NSString *title = [item objectForKey:TITLE];
    
    cell.imageView.image = [[UIImage imageWithColor:[UIColor randomWarmColor] size:CGSizeMake(30, 30)] imageByBlurLight];
    cell.imageView.layer.cornerRadius = 6;
    cell.imageView.layer.masksToBounds = YES;
    
    cell.textLabel.text = title;
    
    [cell customSelectedBackgroundView];
    
    if (indexPath.row == self.items.count - 1) {
        cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, SCREEN_WIDTH);
    }else{
        cell.separatorInset = UIEdgeInsetsMake(0, 60, 0, 0);
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setSelected:NO animated:YES];
    
    NSDictionary *item = self.items[indexPath.row];
    NSDictionary *params = [item objectForKey:PARAMS];
    if (params) {
        [HGHelperPush push:params];
    }else{
        NSNumber *type = [item objectForKey:TYPE];
        switch (type.integerValue) {
            case HGDataTypeFunction:
            {
                NSString *funName = [item objectForKey:FUN];
                SEL funSel = NSSelectorFromString(funName);
                
                HGBeginIgnoreClangWarning("-Warc-performSelector-leaks")
                [self performSelector:funSel];
                HGEndIgnoreClangWarning
                
            }
                break;
                
            default:
                break;
        }
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

#pragma mark - funcs

- (void)funPicker {
    NSArray *items = @[
                       @[@{@"title":@"a",@"value":@"a"},@{@"title":@"b",@"value":@"b"}],
                       @[@{@"title":@"c",@"value":@"c"},@{@"title":@"d",@"value":@"d"}],
                       ];
    HGPickerView *pickerView = [HGPickerView.alloc init];
    [pickerView showInView:self.view
                     items:items
              selectedIdxs:nil
                   showKey:@"title"
         separatedByString:@","
             resultHandler:^(NSArray *selectedIdxs, NSArray *orgItems, NSString *showTitle) {
                 [self showTip:showTitle];
             }];
}

- (void)funDatePicker {
    HGDatePickerView *datePickerView = [HGDatePickerView.alloc init];
    datePickerView.datePicker.datePickerMode = UIDatePickerModeDate;
    [datePickerView showInView:self.view selectedDate:nil format:@"yyyy/MM/dd" resultHandler:^(NSDate *selectedDate, NSString *dateStr) {
        [self showTip:dateStr];
    }];
}

- (void)funBiometrics {
    LAContext *context = [[LAContext alloc] init];
    NSError *error = nil;
    if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error]){
        [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics
                localizedReason:NSLocalizedString(@"...", nil)
                          reply:^(BOOL success, NSError *error) {
                              dispatch_async(dispatch_get_main_queue(), ^{
                                  if (success) {
                                      // ...
                                      [self showAlertMessage:@"验证成功" completionHandler:nil];
                                  } else {
                                      NSLog(@"%@", error);
                                      [self showTip:error.localizedDescription];
                                  }
                              });
                          }];
    } else {
        NSLog(@"%@", error);
        [self showAlertMessage:error.localizedDescription completionHandler:nil];
    }
}

- (void)funChangeTheme {
    NSDictionary *titleAttributesInfo =  @{NSFontAttributeName:[UIFont systemFontOfSize:20],
                                           NSForegroundColorAttributeName:[UIColor purpleColor]};
    UIFontDescriptor *messageFontDescriptor = [UIFontDescriptor.alloc initWithFontAttributes:@{UIFontDescriptorNameAttribute:@"Arial-ItalicMT",UIFontDescriptorFamilyAttribute:@"Arial"}];
    NSDictionary *messageAttributesInfo = @{NSFontAttributeName:[UIFont fontWithDescriptor:messageFontDescriptor size:19.0],
                                            NSForegroundColorAttributeName:[UIColor orangeColor]};
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"主题" message:@"Which theme do you like! 请选择" preferredStyle:UIAlertControllerStyleAlert];
    [alertController setTitleAttributes:titleAttributesInfo];
    [alertController setMessageAttributes:messageAttributesInfo];
    
    HGThemeWhatever *themeWhatever = [HGThemeWhatever.alloc init];
    UIAlertAction *themeBlackAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"随机 Whatever", @"black") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [HGThemeManager sharedInstance].currentTheme = themeWhatever;
    }];
    [themeBlackAction setTitleColor:[UIColor redColor]];
    
    UIAlertAction *themeDefaultAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"白色 white", @"white") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [HGThemeManager sharedInstance].currentTheme = nil;
    }];
    [themeDefaultAction setTitleColor:[UIColor blackColor]];
    
    [alertController addAction:themeBlackAction];
    [alertController addAction:themeDefaultAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)funImagePicker {
    HGImagePickerController *controller = [HGImagePickerController.alloc initWithMaxSelectCount:9 type:HGAssetPickerTypeAll delegate:nil showAlbumFirst:NO];
    [self presentViewController:controller animated:YES completion:nil];
}

- (void)funAvatarCut {
    HGImagePickerController *controller = [HGImagePickerController.alloc initWithMaxSelectCount:1 type:HGAssetPickerTypeImage delegate:self showAlbumFirst:NO];
    [self presentViewController:controller animated:YES completion:nil];
}
- (void)funLanguage {
    
}
- (void)funLogin {
    HGBASENavigationController *controller = (HGBASENavigationController *)[UIStoryboard loginController];
    [self presentViewController:controller animated:YES completion:nil];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat current = scrollView.contentOffset.y + scrollView.frame.size.height;
    CGFloat total = scrollView.contentSize.height;
    CGFloat ratio = current / total;
    
    CGFloat needRead = itemPerPage * threshold + currentPage * itemPerPage;
    CGFloat totalItem = itemPerPage * (currentPage + 1);
    CGFloat newThreshold = needRead / totalItem;
    
    if (ratio >= newThreshold) {
        currentPage += 1;
        //        NSLog("Request page \(currentPage) from server.");
    }
}



#pragma mark - HGImagePickerDelegate

- (void)imagePickerController:(HGImagePickerController *)picker didFinishPickingPhotos:(NSArray<HGPhotoModel *> *)photos {
    NSLog(@"%@",photos);
    HGPhotoModel *model = [photos lastObject];
    if (model) {
        [model.asset requestPreviewImageWithCompletion:^(UIImage *result, NSDictionary<NSString *,id> *info) {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"%@",info);
                BOOL isDegraded = [[info objectForKey:PHImageResultIsDegradedKey] boolValue];
                if (result && !isDegraded) {
                    HGAvatarClipperController *controller = [HGAvatarClipperController.alloc initWithImage:result];
                    controller.delegate = self;
                    controller.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:controller animated:YES];
                }
            });
        } withProgressHandler:^(double progress, NSError * _Nullable error, BOOL * _Nonnull stop, NSDictionary * _Nullable info) {
            NSLog(@"%@",@(progress));
        }];
    }
    
}

#pragma mark - HGAvatarClipperDelegate

- (void)avatarClipperController:(HGAvatarClipperController *)controller didFinishWithCroppedImage:(UIImage *)croppedImage {
    //    NSLog(@"croppedImage == %@",croppedImage);
    [controller.navigationController popViewControllerAnimated:YES];
}
- (void)avatarClipperControllerDidCancel:(HGAvatarClipperController *)controller {
    [controller.navigationController popViewControllerAnimated:YES];
}

#pragma mark - HGChangingThemeDelegate

- (void)themeBeforeChanged:(NSObject<HGThemeProtocol> *)themeBeforeChanged afterChanged:(NSObject<HGThemeProtocol> *)themeAfterChanged {
    [super themeBeforeChanged:themeBeforeChanged afterChanged:themeAfterChanged];
    //    NSLog(@"%@ %@",themeAfterChanged,themeBeforeChanged);
    
}

#pragma mark - private method

#pragma mark - initiate

- (void)initiateDatas {
    self.items = @[
                   @{TITLE:@"WebView",
                     PARAMS:@{HGPushClassName:@"HGWebViewController",HGPushParams:@{@"urlStr":@"http://www.rabbitpre.com/template/preview/3762446b-0b8c-4f4b-aa17-46a0df19c53c"}}},
                   @{TITLE:@"TextField",
                     PARAMS:@{HGPushClassName:@"HGTextFieldController"}},
                   @{TITLE:@"TextView",
                     PARAMS:@{HGPushClassName:@"HGTextViewController"}},
                   @{TITLE:@"轮播图",
                     PARAMS:@{HGPushClassName:@"HGScrollController"}},
                   @{TITLE:@"图片缩放",
                     PARAMS:@{HGPushClassName:@"HGZoomImageController"}},
                   @{TITLE:@"图片浏览",
                     PARAMS:@{HGPushClassName:@"HGBrowserController"}},
                   @{TITLE:@"瀑布流",
                     PARAMS:@{HGPushClassName:@"HGWaterfallController"}},
                   @{TITLE:@"Pay",
                     PARAMS:@{HGPushClassName:@"HGPayController"}},
                   @{TITLE:@"Pages",
                     PARAMS:@{HGPushClassName:@"HGPageControllerDemo"}},
                   @{TITLE:@"PagesScroll",
                     PARAMS:@{HGPushClassName:@"HGPagesWithHeaderDemo"}},
                   @{TITLE:@"Download",
                     PARAMS:@{HGPushClassName:@"HGDownloadController"}},
                   @{TITLE:@"HUD",
                     PARAMS:@{HGPushClassName:@"HGProgressHUDTest"}},
                   @{TITLE:@"语言",
                     PARAMS:@{HGPushClassName:@"HGLanguagesTest"}},
                   //                   @{TITLE:@"Picker",FUN:@"funPicker",TYPE:@(HGDataTypeFunction)},
                   //                   @{TITLE:@"Datepicker",FUN:@"funDatePicker",TYPE:@(HGDataTypeFunction)},
                   @{TITLE:@"登录",FUN:@"funLogin",TYPE:@(HGDataTypeFunction)},
                   @{TITLE:@"生物识别",FUN:@"funBiometrics",TYPE:@(HGDataTypeFunction)},
                   @{TITLE:@"相册选择",FUN:@"funImagePicker",TYPE:@(HGDataTypeFunction)},//https://github.com/QMUI/QMUI_iOS
                   @{TITLE:@"头像截取",FUN:@"funAvatarCut",TYPE:@(HGDataTypeFunction)},//https://github.com/itouch2/PhotoTweaks
                   @{TITLE:@"主题",FUN:@"funChangeTheme",TYPE:@(HGDataTypeFunction)},
                   @{TITLE:@"其它",FUN:@"funBiometrics",PARAMS:@{HGPushClassName:@"HGOtherController"}},
                   ];
}
- (void)initiateViews {
    self.navigationItem.title = i18n_Text(@"app_name");
    if ([self respondsToSelector:@selector(automaticallyAdjustsScrollViewInsets)]) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.tableView = ({
        _tableView = [UITableView.alloc initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        _tableView;
    });
    
    [self.tableView registerClass:UITableViewCell.class forCellReuseIdentifier:HGIdentifier];
    [self.tableView setTableFooterView:[UIView new]];
    [self.view addSubview:self.tableView];
    
}
- (void)addNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(backBarButtonPressed:) name:HGHelperFPSDidTapedNotification object:nil];
}
- (void)removeNotifications {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
