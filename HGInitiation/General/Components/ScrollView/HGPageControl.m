//
//  HGPageControl.m
//  HGInitiation
//
//  Created by __无邪_ on 2018/1/10.
//  Copyright © 2018年 __无邪_. All rights reserved.
//

#import "HGPageControl.h"

const CGFloat HGPageControlDefaultSize = (37.f);
const CGFloat HGPageControlMargin = (10.f);

@interface HGPageControl ()
@property(nonatomic) CGFloat originalWidth;
@property(nonatomic) CGFloat originalHeight;
@end

@implementation HGPageControl

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        _position = HGPageControlPositionBottomCenter;
        self.originalWidth = CGRectGetWidth(frame);
        self.originalHeight = CGRectGetHeight(frame);
    }
    return self;
}


- (void)setPosition:(HGPageControlPosition)position {
    _position = position;
    
    CGSize pointSize = [self sizeForNumberOfPages:self.numberOfPages];
    CGFloat pointHeight = pointSize.height > 0 ? pointSize.height : HGPageControlDefaultSize;
    
    switch (position) {
        case HGPageControlPositionBottomLeft:{
            [self setFrame:CGRectMake(HGPageControlMargin, self.originalHeight - pointHeight, pointSize.width, pointHeight)];
        }
            break;
        case HGPageControlPositionBottomCenter:{
            [self setFrame:CGRectMake(0, self.originalHeight - pointHeight, self.originalWidth, pointHeight)];
        }
            break;
        case HGPageControlPositionBottomRight:{
            [self setFrame:CGRectMake(self.originalWidth - HGPageControlMargin - pointSize.width, self.originalHeight - pointHeight, pointSize.width, pointHeight)];
        }
            break;
            
        default:
            
            break;
    }
}

- (void)setNumberOfPages:(NSInteger)numberOfPages {
    [super setNumberOfPages:numberOfPages];
    [self setPosition:self.position];
}


@end
