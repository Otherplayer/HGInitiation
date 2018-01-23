//
//  HGPhotoBrowserController.m
//  HGInitiation
//
//  Created by __无邪_ on 2017/12/26.
//  Copyright © 2017年 __无邪_. All rights reserved.
//

#import "HGImagePickerController.h"
#import "HGAlbumsController.h"
#import "HGPhotosController.h"

@interface HGImagePickerController ()
@property(nonatomic)HGAssetPickerType pickerType;
@property(nonatomic)NSInteger maxSelectCount;
@property(nonatomic, weak)id <HGImagePickerDelegate>pickerDelegate;

@end

@implementation HGImagePickerController

#pragma mark - life

- (instancetype)init{
    self = [super init];
    if (self) {
        self = [self initWithMaxSelectCount:kHGPhotoBrowserMaxSelectedCountDefault type:HGAssetPickerTypeImage delegate:nil showAlbumFirst:NO];
    }
    return self;
}

- (instancetype)initWithMaxSelectCount:(NSInteger)count type:(HGAssetPickerType)type delegate:(id<HGImagePickerDelegate>)delegate showAlbumFirst:(BOOL)showAlbumFirst{
    HGAlbumsController *albumViewController = [[HGAlbumsController alloc] init];
    albumViewController.maxSelectCount = count;
    albumViewController.pickerType = type;
    self = [super initWithRootViewController:albumViewController];
    if (self) {
        
        [[HGAssetManager sharedManager].selectedPhotos removeAllObjects];
        
        self.pickerType = type;
        self.pickerDelegate = delegate;
        self.maxSelectCount = count;
        
        PHAuthorizationStatus status = [[HGAssetManager sharedManager] authorizationStatus];
        if (status == PHAuthorizationStatusAuthorized) {
            [self decideWhereViewController2Go:showAlbumFirst];
        }else if (status == PHAuthorizationStatusNotDetermined){
            [[HGAssetManager sharedManager] requestAuthorization:^(PHAuthorizationStatus status) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (status == PHAuthorizationStatusAuthorized) {
                        [self decideWhereViewController2Go:showAlbumFirst];
                    }else {
                        [albumViewController showEmptyWithMessage:@"请在设置中开启相册访问权限"];
                    }
                });
            }];
        }else{
            [albumViewController showEmptyWithMessage:@"请在设置中开启相册访问权限"];
        }
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(donePicker:) name:HGNotificationDonePicker object:nil];
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initiateViews];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark -
- (void)donePicker:(NSNotification *)notification{
    
    NSMutableArray *results = [NSMutableArray.alloc initWithArray:[HGAssetManager sharedManager].selectedPhotos];
    
    if (self.pickerDelegate && [self.pickerDelegate respondsToSelector:@selector(imagePickerController:didFinishPickingPhotos:)]) {
        [self.pickerDelegate imagePickerController:self didFinishPickingPhotos:[results copy]];
    }
    [[HGAssetManager sharedManager] removeAllSelectedPhotos];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - push

- (void)decideWhereViewController2Go:(BOOL)showAlbumFirst {
    if (showAlbumFirst) {
        
    }else {
        HGPhotosController *controller = [HGPhotosController.alloc init];
        controller.album = nil;
        controller.pickerType = self.pickerType;
        controller.maxSelectCount = self.maxSelectCount;
        [self pushViewController:controller animated:NO];
    }
}

#pragma mark - private

- (void)showAlert:(NSString *)message {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:okAction];
    [[[[[UIApplication sharedApplication] delegate] window] rootViewController] presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - initiate

- (void)initiateViews {
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationBar.barStyle = UIBarStyleBlack;
    self.navigationBar.translucent = YES;
    
}

@end
