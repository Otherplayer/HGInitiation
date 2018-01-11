//
//  HGPhotoBrowser.h
//  HGInitiation
//
//  Created by __无邪_ on 2018/1/8.
//  Copyright © 2018年 __无邪_. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HGPhotoModel.h"

@interface HGPhotoBrowser : UIViewController

- (instancetype)initWithPhotos:(NSArray <HGPhotoModel *> *)photosArray index:(NSInteger)index animatedFromView:(UIView *)view;

@end
