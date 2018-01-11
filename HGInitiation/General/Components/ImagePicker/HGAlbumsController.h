//
//  HGPhotoAlbumController.h
//  HGInitiation
//
//  Created by __无邪_ on 2017/12/26.
//  Copyright © 2017年 __无邪_. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HGAssetManager.h"
#import "HGPhotosController.h"

@interface HGAlbumsController : UIViewController
@property(nonatomic)HGAssetPickerType pickerType;
@property(nonatomic)NSInteger maxSelectCount;

- (void)showEmptyWithMessage:(NSString *)message;


@end
