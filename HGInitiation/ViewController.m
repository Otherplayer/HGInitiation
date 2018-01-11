//
//  ViewController.m
//  HGInitiation
//
//  Created by __无邪_ on 2017/12/25.
//  Copyright © 2017年 __无邪_. All rights reserved.
//

#import "ViewController.h"
#import "HGHTTPClient.h"
#import "HGAssetManager.h"
#import "HGImagePickerController.h"
#import "HGAvatarClipperController.h"
#import "HGPickerView.h"
#import "HGDatePickerView.h"
#import "HGTextFieldController.h"
#import "HGTextViewController.h"
#import "HGZoomImageController.h"
#import "HGWebViewController.h"
#import "HGBrowserController.h"
#import "HGScrollController.h"

static NSString *Identifier = @"Identifier";

NSString *const TITLE = @"title";
NSString *const TYPE = @"type";

@interface ViewController ()<UITableViewDataSource,UITableViewDelegate,HGImagePickerDelegate,HGAvatarClipperDelegate>
@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, strong)NSArray *items;

@end

@implementation ViewController

#pragma mark - life

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self initiateDatas];
    [self initiateViews];
    
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
//    [self showFunction:HGDataType_Scroll];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.items.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier forIndexPath:indexPath];
    
    NSDictionary *item = self.items[indexPath.row];
    NSString *title = [item objectForKey:TITLE];
    cell.textLabel.text = title;
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *item = self.items[indexPath.row];
    NSNumber *type = [item objectForKey:TYPE];
    [self showFunction:type.integerValue];
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (void)showFunction:(HGDataType)type {
    switch (type) {
        case HGDataType_Net:{
            [self showProgressTip:nil];
            [[HGHTTPClient sharedInstance] fetchEmojies:^(BOOL success, NSString *errDesc, id responseData) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (success) {
                        [self showTip:[responseData description] dealy:3];
                        NSLog(@"%@",responseData);
                    }else{
                        [self showTip:errDesc];
                    }
                });
            }];
        }
            break;
        case HGDataType_ImagePicker:{
            HGImagePickerController *controller = [HGImagePickerController.alloc initWithMaxSelectCount:9 type:HGAssetPickerTypeAll delegate:nil showAlbumFirst:NO];
            [self presentViewController:controller animated:YES completion:nil];
        }
            break;
        case HGDataType_AvatarCut:{
            HGImagePickerController *controller = [HGImagePickerController.alloc initWithMaxSelectCount:1 type:HGAssetPickerTypeImage delegate:self showAlbumFirst:NO];
            [self presentViewController:controller animated:YES completion:nil];
        }
            break;
        case HGDataType_Picker:{
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
            break;
        case HGDataType_DatePicker:{
            HGDatePickerView *datePickerView = [HGDatePickerView.alloc init];
            datePickerView.datePicker.datePickerMode = UIDatePickerModeDate;
            [datePickerView showInView:self.view selectedDate:nil format:@"yyyy/MM/dd" resultHandler:^(NSDate *selectedDate, NSString *dateStr) {
                [self showTip:dateStr];
            }];
        }
            break;
        case HGDataType_TextField:{
            HGTextFieldController *controller = [HGTextFieldController.alloc init];
            [self.navigationController pushViewController:controller animated:YES];
        }
            break;
        case HGDataType_TextView:{
            HGTextViewController *controller = [HGTextViewController.alloc init];
            [self.navigationController pushViewController:controller animated:YES];
        }
            break;
        case HGDataType_ZoomImage:{
            HGZoomImageController *controller = [HGZoomImageController.alloc init];
            [self.navigationController pushViewController:controller animated:YES];
        }
            break;
        case HGDataType_WebView:{
            HGWebViewController *controller = [HGWebViewController.alloc init];
            controller.urlStr = @"https://www.baidu.com";
            [self.navigationController pushViewController:controller animated:YES];
        }
            break;
        case HGDataType_Browser:{
            HGBrowserController *controller = [HGBrowserController.alloc init];
            [self.navigationController pushViewController:controller animated:YES];
        }
            break;
        case HGDataType_Scroll:{
            HGScrollController *controller = [HGScrollController.alloc init];
            [self.navigationController pushViewController:controller animated:YES];
        }
            break;
            
        default:
            break;
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
    NSLog(@"croppedImage == %@",croppedImage);
    [controller.navigationController popViewControllerAnimated:YES];
}
- (void)avatarClipperControllerDidCancel:(HGAvatarClipperController *)controller {
    [controller.navigationController popViewControllerAnimated:YES];
}

#pragma mark - initiate

- (void)initiateDatas {
    self.items = @[
                   @{TITLE:@"网络",TYPE:@(HGDataType_Net)},
                   @{TITLE:@"相册选择",TYPE:@(HGDataType_ImagePicker)},//https://github.com/QMUI/QMUI_iOS
                   @{TITLE:@"头像截取",TYPE:@(HGDataType_AvatarCut)},//https://github.com/itouch2/PhotoTweaks
                   @{TITLE:@"WebView",TYPE:@(HGDataType_WebView)},
                   @{TITLE:@"TextField",TYPE:@(HGDataType_TextField)},
                   @{TITLE:@"TextView",TYPE:@(HGDataType_TextView)},
                   @{TITLE:@"ScrollView",TYPE:@(HGDataType_Scroll)},
                   @{TITLE:@"动画",TYPE:@(HGDataType_AvatarCut)},
                   @{TITLE:@"Picker",TYPE:@(HGDataType_Picker)},
                   @{TITLE:@"Datepicker",TYPE:@(HGDataType_DatePicker)},
                   @{TITLE:@"ZoomImage",TYPE:@(HGDataType_ZoomImage)},
                   @{TITLE:@"图片浏览",TYPE:@(HGDataType_Browser)},
                   @{TITLE:@"其它",TYPE:@(HGDataType_Other)},
                   ];
}
- (void)initiateViews {
    self.tableView = ({
        _tableView = [UITableView.alloc initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView;
    });
    [self.tableView registerClass:UITableViewCell.class forCellReuseIdentifier:Identifier];
    [self.tableView setTableFooterView:[UIView new]];
    [self.view addSubview:self.tableView];
}


@end
