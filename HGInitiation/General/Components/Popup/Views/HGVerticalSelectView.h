//
//  HGMutilVerticalScrollView.h
//  HGInitiation
//
//  Created by __无邪_ on 2018/6/7.
//  Copyright © 2018年 __无邪_. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HGVerticalSelectView : UIView
@property(nonatomic, copy)void(^didTapCancelHandler)(void);
@property(nonatomic, copy)void(^didTapItemHandler)(NSInteger row);

- (instancetype)initWithItems:(NSArray *)items;

@end
