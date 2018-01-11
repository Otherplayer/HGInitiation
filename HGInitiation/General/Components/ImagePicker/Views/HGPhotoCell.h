//
//  HGPhotoCell.h
//  HGInitiation
//
//  Created by __无邪_ on 2017/12/26.
//  Copyright © 2017年 __无邪_. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HGPhotoModel.h"
#import "HGAssetManager.h"

@interface HGPhotoCell : UICollectionViewCell
@property(nonatomic, strong)HGPhotoModel *model;
@property(nonatomic, copy) void(^callbackHandler)(HGPhotoCell *pCell);
@property(nonatomic, strong)UIButton *btnSelectStatus;

@end
