//
//  HGMutilHorizontalCCell.h
//  HGInitiation
//
//  Created by __无邪_ on 2018/6/6.
//  Copyright © 2018年 __无邪_. All rights reserved.
//

#import <UIKit/UIKit.h>

extern CGFloat const kHGMutilHorizontalCCellHeight;
extern CGFloat const kHGMutilHorizontalCCellWidth;

@interface HGMutilHorizontalCCell : UICollectionViewCell

@property(nonatomic, copy)void(^didTapHandler)(void);
@property(nonatomic, strong) UIButton *btnIcon;
@property(nonatomic, strong) UILabel *labTitle;

@end
