//
//  HGPageControl.h
//  HGInitiation
//
//  Created by __无邪_ on 2018/1/10.
//  Copyright © 2018年 __无邪_. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSUInteger, HGPageControlPosition) {
    HGPageControlPositionBottomLeft,
    HGPageControlPositionBottomCenter,
    HGPageControlPositionBottomRight,
};

@interface HGPageControl : UIPageControl
@property(nonatomic) HGPageControlPosition position;

@end
