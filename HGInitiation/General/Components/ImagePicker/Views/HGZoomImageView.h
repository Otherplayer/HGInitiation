//
//  HGZoomImageView.h
//  HGInitiation
//
//  Created by __无邪_ on 2018/1/3.
//  Copyright © 2018年 __无邪_. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HGZoomImageView;

@protocol HGZoomImageViewDelegate <NSObject>
@optional
- (void)singleTouchInZoomImageView:(HGZoomImageView *)zoomImageView location:(CGPoint)location;
- (void)doubleTouchInZoomImageView:(HGZoomImageView *)zoomImageView location:(CGPoint)location;
- (void)longPressInZoomImageView:(HGZoomImageView *)zoomImageView;
@end



@interface HGZoomImageView : UIView

@property(nonatomic, weak) id<HGZoomImageViewDelegate> delegate;
@property(nonatomic, strong) UIScrollView *scrollView;
@property(nonatomic, weak) UIImage *image;

/**
 *  重置图片或视频的大小
 */
- (void)revertZooming;

/**
 *  获取当前正在显示的图片/视频在整个 HGZoomImageView 坐标系里的 rect（会按照当前的缩放状态来计算）
 */
- (CGRect)imageViewRectInZoomImageView;

@end
