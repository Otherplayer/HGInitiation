//
//  HGHorizontalSelectCCell.h
//  HGInitiation
//
//  Created by __无邪_ on 2018/6/19.
//  Copyright © 2018年 __无邪_. All rights reserved.
//

#import <UIKit/UIKit.h>

extern CGFloat const kHGHorizontalSCCellHeight;
extern CGFloat const kHGHorizontalSCCellWidth;

@interface HGHorizontalSelectCCell : UICollectionViewCell

@property(nonatomic, copy)void(^didTapHandler)(void);
@property(nonatomic, strong) UIButton *btnIcon;
@property(nonatomic, strong) UILabel *labTitle;


@end
