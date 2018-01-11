//
//  HGPhotoPreviewController.h
//  HGInitiation
//
//  Created by __无邪_ on 2017/12/26.
//  Copyright © 2017年 __无邪_. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HGPhotoModel.h"

@class HGImagePreviewController;

@protocol HGImagePreviewDelegate <NSObject>
- (void)previewController:(HGImagePreviewController *)controller didChangeSelected:(HGPhotoModel *)model;

@end

@interface HGImagePreviewController : UIViewController
@property(nonatomic, weak) id <HGImagePreviewDelegate>delegate;
@property(nonatomic, strong)NSMutableArray<HGPhotoModel *> *photos;
@property(nonatomic)NSInteger currentIndex;
@property(nonatomic)NSInteger maxSelectCount;

@end
