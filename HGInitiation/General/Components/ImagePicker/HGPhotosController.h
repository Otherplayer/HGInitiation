//
//  HGPhotoPickerController.h
//  HGInitiation
//
//  Created by __无邪_ on 2017/12/26.
//  Copyright © 2017年 __无邪_. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HGAssetManager.h"

extern NSNotificationName const HGNotificationDonePicker;

@interface HGPhotosController : UIViewController

@property(nonatomic, strong) HGAssetAlbum *album;
@property(nonatomic)HGAssetPickerType pickerType;
@property(nonatomic)NSInteger maxSelectCount;


@end
