//
//  HGPhotoPreviewCell.h
//  HGInitiation
//
//  Created by __无邪_ on 2018/1/3.
//  Copyright © 2018年 __无邪_. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HGZoomImageView.h"

@interface HGImagePreviewCell : UICollectionViewCell
@property(nonatomic, strong)HGZoomImageView *zoomImageView;
@property(nonatomic) BOOL isLoading;

@end
