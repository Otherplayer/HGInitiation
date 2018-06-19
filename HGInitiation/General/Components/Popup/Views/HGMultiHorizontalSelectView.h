//
//  HGMutilHorizontalScrollView.h
//  HGInitiation
//
//  Created by __无邪_ on 2018/6/6.
//  Copyright © 2018年 __无邪_. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface HGMultiHorizontalSelectView : UIView

@property(nonatomic, copy)void(^didTapCancelHandler)(void);
@property(nonatomic, copy)void(^didTapItemHandler)(NSInteger section, NSInteger row);

- (instancetype)initWithItems:(NSArray *)items;

@end
