//
//  HGPhotoPreviewCell.m
//  HGInitiation
//
//  Created by __无邪_ on 2018/1/3.
//  Copyright © 2018年 __无邪_. All rights reserved.
//

#import "HGImagePreviewCell.h"

@interface HGImagePreviewCell ()
@property (nonatomic, strong)UIActivityIndicatorView *indicatorView;
@end

@implementation HGImagePreviewCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.zoomImageView = [HGZoomImageView.alloc initWithFrame:self.bounds];
        self.zoomImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:self.zoomImageView];
        
        self.indicatorView = [UIActivityIndicatorView.alloc initWithFrame:self.bounds];
        self.indicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
        self.indicatorView.hidesWhenStopped = YES;
        [self.contentView addSubview:self.indicatorView];
    }
    return self;
}
- (void)setIsLoading:(BOOL)isLoading {
    _isLoading = isLoading;
    if (isLoading && !self.indicatorView.isAnimating) {
        [self.indicatorView startAnimating];
    }else{
        [self.indicatorView stopAnimating];
    }
}

@end
