//
//  HGWebViewProgressView.h
//  HGInitiation
//
//  Created by __无邪_ on 2018/1/5.
//  Copyright © 2018年 __无邪_. All rights reserved.
//  From https://github.com/ninjinkun/NJKWebViewProgress

#import <UIKit/UIKit.h>

@interface HGWebViewProgressView : UIView
@property (nonatomic) float progress;

@property (nonatomic) UIView *progressBarView;
@property (nonatomic) NSTimeInterval barAnimationDuration; // default 0.1
@property (nonatomic) NSTimeInterval fadeAnimationDuration; // default 0.27
@property (nonatomic) NSTimeInterval fadeOutDelay; // default 0.1

- (void)setProgress:(float)progress animated:(BOOL)animated;

@end
