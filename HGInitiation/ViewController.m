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
#import "HGHelperPush.h"
#import "HGThemeWhatever.h"

static NSString *Identifier = @"Identifier";

NSString *const TITLE = @"title";
NSString *const TYPE = @"type";
NSString *const PARAMS = @"params";


CGFloat threshold = 0.7;
CGFloat itemPerPage = 10;
CGFloat currentPage = 0;


@interface ViewController ()<UITableViewDataSource,UITableViewDelegate,HGImagePickerDelegate,HGAvatarClipperDelegate>
@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, strong)NSArray *items;
@property(nonatomic, strong)NSMutableArray *datas;
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
//    [HGHelperPush push:@{HGPushClassName:@"HGScrollController"}];
    
    
    self.datas = [NSMutableArray.alloc init];
    NSMutableDictionary *info = [@{@"isSelected":@0,@"items":@[[@{@"666":@1} mutableCopy]]} mutableCopy];
    [self.datas addObject:info];
    NSMutableDictionary *item = self.datas[0];
    [item setValue:@1 forKey:@"isSelected"];
    
    NSMutableArray *items = [item objectForKey:@"items"];
//    NSMutableDictionary *t666 = [items lastObject];
//    [t666 setValue:@0 forKey:@"666"];
    [items enumerateObjectsUsingBlock:^(NSMutableDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj setValue:@0 forKey:@"666"];
    }];
    
    
    NSLog(@"%@",self.datas);
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
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setSelected:NO animated:YES];
    
    NSDictionary *item = self.items[indexPath.row];
    NSDictionary *params = [item objectForKey:PARAMS];
    if (params) {
        [HGHelperPush push:params];
    }else{
        NSNumber *type = [item objectForKey:TYPE];
        [self showFunction:type.integerValue];
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (void)showFunction:(HGDataType)type {
    switch (type) {
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
        case HGDataType_Theme:{
            [self functionTheme];
        }
            break;
            
        default:
            break;
    }
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
        NSLog("Request page \(currentPage) from server.");
    }
}

- (void)functionTheme {
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
                   @{TITLE:@"WebView",
                     PARAMS:@{HGPushClassName:@"HGWebViewController",HGPushParams:@{@"urlStr":@"http://www.rabbitpre.com/template/preview/3762446b-0b8c-4f4b-aa17-46a0df19c53c"}}},
                   @{TITLE:@"TextField",
                     PARAMS:@{HGPushClassName:@"HGTextFieldController"}},
                   @{TITLE:@"TextView",
                     PARAMS:@{HGPushClassName:@"HGTextViewController"}},
                   @{TITLE:@"ScrollView",
                     PARAMS:@{HGPushClassName:@"HGScrollController"}},
                   @{TITLE:@"ZoomImage",
                     PARAMS:@{HGPushClassName:@"HGZoomImageController"}},
                   @{TITLE:@"图片浏览",
                     PARAMS:@{HGPushClassName:@"HGBrowserController"}},
                   @{TITLE:@"瀑布流",
                     PARAMS:@{HGPushClassName:@"HGWaterfallController"}},
                   @{TITLE:@"Picker",
                     TYPE:@(HGDataType_Picker)},
                   @{TITLE:@"Datepicker",
                     TYPE:@(HGDataType_DatePicker)},
                   @{TITLE:@"相册选择",
                     TYPE:@(HGDataType_ImagePicker)},//https://github.com/QMUI/QMUI_iOS
                   @{TITLE:@"头像截取",
                     TYPE:@(HGDataType_AvatarCut)},//https://github.com/itouch2/PhotoTweaks
                   @{TITLE:@"主题",
                     TYPE:@(HGDataType_Theme)},
                   @{TITLE:@"其它",
                     TYPE:@(HGDataType_Other)},
                   ];
}
- (void)initiateViews {
    self.title = @"功能";
    self.tableView = ({
        _tableView = [UITableView.alloc initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView;
    });
    [self.tableView registerClass:UITableViewCell.class forCellReuseIdentifier:Identifier];
    [self.tableView setTableFooterView:[UIView new]];
    [self.view addSubview:self.tableView];
    
//    if (@available(iOS 11.0, *)) {
//        self.navigationController.navigationBar.prefersLargeTitles = YES;
//        [self.navigationController.navigationItem setLargeTitleDisplayMode:UINavigationItemLargeTitleDisplayModeAutomatic];
//    } else {
//        // Fallback on earlier versions
//    }
    
    
}


#pragma mark - HGChangingThemeDelegate

- (void)themeBeforeChanged:(NSObject<HGThemeProtocol> *)themeBeforeChanged afterChanged:(NSObject<HGThemeProtocol> *)themeAfterChanged {
    [super themeBeforeChanged:themeBeforeChanged afterChanged:themeAfterChanged];
    NSLog(@"%@ %@",themeAfterChanged,themeBeforeChanged);
    
}

@end
