//
//  HGPhotoPreviewCell.m
//  HGInitiation
//
//  Created by __无邪_ on 2018/1/3.
//  Copyright © 2018年 __无邪_. All rights reserved.
//

#import "HGImagePreviewCell.h"

@interface HGImagePreviewCell ()

@end

@implementation HGImagePreviewCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.zoomImageView = [HGZoomImageView.alloc initWithFrame:self.bounds];
        self.zoomImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:self.zoomImageView];
    }
    return self;
}


@end
