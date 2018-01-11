//
//  HGZoomImageView.m
//  HGInitiation
//
//  Created by __无邪_ on 2018/1/3.
//  Copyright © 2018年 __无邪_. All rights reserved.
//

#import "HGZoomImageView.h"

@interface HGZoomImageView ()<UIGestureRecognizerDelegate,UIScrollViewDelegate>
@property(nonatomic, strong) UIImageView *imageView;
@property(nonatomic, assign) CGFloat maximumZoomScale;

@end

@implementation HGZoomImageView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initiateViews];
        [self initiateGestures];
    }
    return self;
}

- (void)initiateViews {
    self.contentMode = UIViewContentModeCenter;
    self.maximumZoomScale = 2.0;
    
    self.imageView = [[UIImageView alloc] init];
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.minimumZoomScale = 0;
    self.scrollView.maximumZoomScale = self.maximumZoomScale;
    self.scrollView.panGestureRecognizer.enabled = YES;
    self.scrollView.pinchGestureRecognizer.enabled = YES;
    self.scrollView.delegate = self;
    if (@available(iOS 11, *)) {
        self.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    [self.scrollView addSubview:self.imageView];
    [self addSubview:self.scrollView];
}
- (void)initiateGestures {
    UITapGestureRecognizer *singleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapGestureWithPoint:)];
    singleTapGesture.delegate = self;
    singleTapGesture.numberOfTapsRequired = 1;
    singleTapGesture.numberOfTouchesRequired = 1;
    [self addGestureRecognizer:singleTapGesture];
    
    UITapGestureRecognizer *doubleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTapGestureWithPoint:)];
    doubleTapGesture.numberOfTapsRequired = 2;
    doubleTapGesture.numberOfTouchesRequired = 1;
    [self addGestureRecognizer:doubleTapGesture];
    
    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPressGesture:)];
    [self addGestureRecognizer:longPressGesture];
    
    [singleTapGesture requireGestureRecognizerToFail:doubleTapGesture];
}

#pragma mark - setter

- (void)setImage:(UIImage *)image {
    _image = image;
    if (!image) {
        _imageView.image = nil;
        return;
    }
    self.imageView.image = image;
    self.imageView.frame = CGRectApplyAffineTransform(CGRectMake(0, 0, image.size.width, image.size.height), self.imageView.transform);
    
    [self revertZooming];
}

- (void)setContentMode:(UIViewContentMode)contentMode {
    BOOL isContentModeChanged = self.contentMode != contentMode;
    [super setContentMode:contentMode];
    if (isContentModeChanged) {
        [self revertZooming];
    }
}

#pragma mark - getter

- (CGRect)imageViewRectInZoomImageView {
    UIView *imageView = [self currentContentView];
    return [self convertRect:imageView.frame fromView:imageView.superview];
}


#pragma mark - action

- (void)handleSingleTapGestureWithPoint:(UITapGestureRecognizer *)gestureRecognizer {
    CGPoint gesturePoint = [gestureRecognizer locationInView:gestureRecognizer.view];
    if ([self.delegate respondsToSelector:@selector(singleTouchInZoomImageView:location:)]) {
        [self.delegate singleTouchInZoomImageView:self location:gesturePoint];
    }
}
- (void)handleDoubleTapGestureWithPoint:(UITapGestureRecognizer *)gestureRecognizer {
    CGPoint gesturePoint = [gestureRecognizer locationInView:gestureRecognizer.view];
    if ([self.delegate respondsToSelector:@selector(doubleTouchInZoomImageView:location:)]) {
        [self.delegate doubleTouchInZoomImageView:self location:gesturePoint];
    }
    // 如果图片被压缩了，则第一次放大到原图大小，第二次放大到最大倍数
    // 在这里只放大一次到原图
    if (self.scrollView.zoomScale >= 1) {
        [self setZoomScale:self.scrollView.minimumZoomScale animated:YES];
    } else {
        CGFloat newZoomScale = 0;
        if (self.scrollView.zoomScale < 1) {
            // 如果目前显示的大小比原图小，则放大到原图
            newZoomScale = 1;
        }
//        else {
//            // 如果当前显示原图，则放大到最大的大小
//            newZoomScale = self.scrollView.maximumZoomScale;
//        }
        
        CGRect zoomRect = CGRectZero;
        CGPoint tapPoint = [[self currentContentView] convertPoint:gesturePoint fromView:gestureRecognizer.view];
        zoomRect.size.width = CGRectGetWidth(self.bounds) / newZoomScale;
        zoomRect.size.height = CGRectGetHeight(self.bounds) / newZoomScale;
        zoomRect.origin.x = tapPoint.x - CGRectGetWidth(zoomRect) / 2;
        zoomRect.origin.y = tapPoint.y - CGRectGetHeight(zoomRect) / 2;
        [self zoomToRect:zoomRect animated:YES];
    }
}
- (void)handleLongPressGesture:(UITapGestureRecognizer *)gestureRecognizer {
    if ([self.delegate respondsToSelector:@selector(longPressInZoomImageView:)]) {
        [self.delegate longPressInZoomImageView:self];
    }
}


#pragma mark - UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return [self currentContentView];
}
- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    [self handleDidEndZooming];
}


#pragma mark -
- (CGFloat)minimumZoomScale {
    if (!self.image) {
        return 1;
    }
    
    CGRect viewport = [self finalViewportRect];
    CGSize mediaSize = CGSizeZero;
    if (self.image) {
        mediaSize = self.image.size;
    }
    
    CGFloat minScale = 1;
    CGFloat scaleX = CGRectGetWidth(viewport) / mediaSize.width;
    CGFloat scaleY = CGRectGetHeight(viewport) / mediaSize.height;
    if (self.contentMode == UIViewContentModeScaleAspectFit) {
        minScale = fmin(scaleX, scaleY);
    } else if (self.contentMode == UIViewContentModeScaleAspectFill) {
        minScale = fmax(scaleX, scaleY);
    } else if (self.contentMode == UIViewContentModeCenter) {
        if (scaleX >= 1 && scaleY >= 1) {
            minScale = 1;
        } else {
            minScale = fmin(scaleX, scaleY);
        }
    }
    return minScale;
}

- (void)revertZooming {
    if (CGRectIsEmpty(self.bounds)) {
        return;
    }
    
    CGFloat minimumZoomScale = [self minimumZoomScale];
    CGFloat maximumZoomScale = [self maximumZoomScale];
    maximumZoomScale = fmax(minimumZoomScale, maximumZoomScale);// 可能外部通过 contentMode = UIViewContentModeScaleAspectFit 的方式来让小图片撑满当前的 zoomImageView，所以算出来 minimumZoomScale 会很大（至少比 maximumZoomScale 大），所以这里要做一个保护
    CGFloat zoomScale = minimumZoomScale;
    BOOL shouldFireDidZoomingManual = (zoomScale == self.scrollView.zoomScale);
    self.scrollView.minimumZoomScale = minimumZoomScale;
    self.scrollView.maximumZoomScale = maximumZoomScale;
    [self setZoomScale:zoomScale animated:NO];
    
    // 只有前后的 zoomScale 不相等，才会触发 UIScrollViewDelegate scrollViewDidZoom:，因此对于相等的情况要自己手动触发
    if (shouldFireDidZoomingManual) {
        [self handleDidEndZooming];
    }
    
    // 当内容比 viewport 的区域更大时，要把内容放在 viewport 正中间
    self.scrollView.contentOffset = ({
        CGFloat x = self.scrollView.contentOffset.x;
        CGFloat y = self.scrollView.contentOffset.y;
        CGRect viewport = [self finalViewportRect];
        if (!CGRectIsEmpty(viewport)) {
            UIView *contentView = [self currentContentView];
            if (CGRectGetWidth(viewport) < CGRectGetWidth(contentView.frame)) {
                x = (CGRectGetWidth(contentView.frame) / 2 - CGRectGetWidth(viewport) / 2) - CGRectGetMinX(viewport);
            }
            if (CGRectGetHeight(viewport) < CGRectGetHeight(contentView.frame)) {
                y = (CGRectGetHeight(contentView.frame) / 2 - CGRectGetHeight(viewport) / 2) - CGRectGetMinY(viewport);
            }
        }
        CGPointMake(x, y);
    });
}

- (void)handleDidEndZooming {
    CGRect viewport = [self finalViewportRect];
    
    UIView *contentView = [self currentContentView];
    CGRect contentViewFrame = contentView ? [self convertRect:contentView.frame fromView:contentView.superview] : CGRectZero;
    UIEdgeInsets contentInset = UIEdgeInsetsZero;
    
    contentInset.top = CGRectGetMinY(viewport);
    contentInset.left = CGRectGetMinX(viewport);
    contentInset.right = CGRectGetWidth(self.bounds) - CGRectGetMaxX(viewport);
    contentInset.bottom = CGRectGetHeight(self.bounds) - CGRectGetMaxY(viewport);
    
    // 图片 height 比选图框(viewport)的 height 小，这时应该把图片纵向摆放在选图框中间，且不允许上下移动
    if (CGRectGetHeight(viewport) > CGRectGetHeight(contentViewFrame)) {
        // 用 floor 而不是 flat，是因为 flat 本质上是向上取整，会导致 top + bottom 比实际的大，然后 scrollView 就认为可滚动了
        contentInset.top = floor(CGRectGetMidY(viewport) - CGRectGetHeight(contentViewFrame) / 2.0);
        contentInset.bottom = floor(CGRectGetHeight(self.bounds) - CGRectGetMidY(viewport) - CGRectGetHeight(contentViewFrame) / 2.0);
    }
    
    // 图片 width 比选图框的 width 小，这时应该把图片横向摆放在选图框中间，且不允许左右移动
    if (CGRectGetWidth(viewport) > CGRectGetWidth(contentViewFrame)) {
        contentInset.left = floor(CGRectGetMidX(viewport) - CGRectGetWidth(contentViewFrame) / 2.0);
        contentInset.right = floor(CGRectGetWidth(self.bounds) - CGRectGetMidX(viewport) - CGRectGetWidth(contentViewFrame) / 2.0);
    }
    
    self.scrollView.contentInset = contentInset;
    self.scrollView.contentSize = contentView.frame.size;
    
}

- (CGRect)finalViewportRect {
    CGRect rect = CGRectMake(0, 0, self.scrollView.bounds.size.width, self.scrollView.bounds.size.height);
    return rect;
}
- (UIView *)currentContentView {
    if (_imageView) {
        return _imageView;
    }
    return nil;
}

- (void)setZoomScale:(CGFloat)zoomScale animated:(BOOL)animated {
    if (animated) {
        [UIView animateWithDuration:.25 delay:0.0 options:(7<<16) animations:^{
            self.scrollView.zoomScale = zoomScale;
        } completion:nil];
    } else {
        self.scrollView.zoomScale = zoomScale;
    }
}
- (void)zoomToRect:(CGRect)rect animated:(BOOL)animated {
    if (animated) {
        [UIView animateWithDuration:.25 delay:0.0 options:(8<<16) animations:^{
            [self.scrollView zoomToRect:rect animated:NO];
        } completion:nil];
    } else {
        [self.scrollView zoomToRect:rect animated:NO];
    }
}

@end
