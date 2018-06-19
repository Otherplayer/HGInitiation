//
//  HGMutilHorizontalScrollView.h
//  HGInitiation
//
//  Created by __无邪_ on 2018/6/6.
//  Copyright © 2018年 __无邪_. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, HGMutilHorizontalScrollType) {
    HGMutilHorizontalScrollTypeNormal,//多行，每行可单独滑动
    HGMutilHorizontalScrollType9 //九宫格
};

@interface HGMultiHorizontalSelectView : UIView

@property(nonatomic, copy)void(^didTapCancelHandler)(void);
@property(nonatomic, copy)void(^didTapItemHandler)(NSInteger section, NSInteger row);

- (instancetype)initWithItems:(NSArray *)items;
- (instancetype)initWithItems:(NSArray *)items title:(NSString *)title type:(HGMutilHorizontalScrollType)type;

@end
