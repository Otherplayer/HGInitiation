//
//  HGPhotoBrowserController.h
//  HGInitiation
//
//  Created by __无邪_ on 2017/12/26.
//  Copyright © 2017年 __无邪_. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HGAssetManager.h"
#import "HGPhotoModel.h"
@class HGImagePickerController;

#define kHGPhotoBrowserMaxSelectedCountDefault 9

@protocol HGImagePickerDelegate <NSObject>
- (void)imagePickerController:(HGImagePickerController *)picker didFinishPickingPhotos:(NSArray<HGPhotoModel *> *)photos;

@end

@interface HGImagePickerController : UINavigationController

- (instancetype)initWithMaxSelectCount:(NSInteger)count
                                  type:(HGAssetPickerType)type
                              delegate:(id<HGImagePickerDelegate>)delegate
                        showAlbumFirst:(BOOL)showAlbumFirst;


@end
