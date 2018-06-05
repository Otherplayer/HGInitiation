//
//  HGPageTitleItem.h
//  HGInitiation
//
//  Created by __无邪_ on 2018/6/4.
//  Copyright © 2018年 __无邪_. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HGPageTitleItem : UICollectionViewCell
@property(nonatomic, strong) UILabel *labTitle;

@property(nonatomic, assign) CGFloat rate;
@property(nonatomic, assign) CGFloat normalSize;     /// default 16
@property(nonatomic, assign) CGFloat selectedSize;   /// default 17
@property(nonatomic, strong) UIColor *normalColor;   /// default darkGrayColor
@property(nonatomic, strong) UIColor *selectedColor; /// default blackColor

@end
