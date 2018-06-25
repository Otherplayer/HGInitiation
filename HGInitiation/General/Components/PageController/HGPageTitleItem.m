//
//  HGPageTitleItem.m
//  HGInitiation
//
//  Created by __无邪_ on 2018/6/4.
//  Copyright © 2018年 __无邪_. All rights reserved.
//

#import "HGPageTitleItem.h"

@interface HGPageTitleItem (){
    CGFloat _selectedRed, _selectedGreen, _selectedBlue, _selectedAlpha;
    CGFloat _normalRed, _normalGreen, _normalBlue, _normalAlpha;
}
@end


@implementation HGPageTitleItem

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.normalSize = 16;
        self.selectedSize = 16;
        self.normalColor = [UIColor colorWithRGB:0x666666];
        self.selectedColor = UIColor.blackColor;
        
        self.labTitle = ({
            _labTitle = [UILabel.alloc initWithFrame:CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame))];
            [_labTitle setFont:[UIFont systemFontOfSize:self.normalSize]];
            [_labTitle setTextColor:self.normalColor];
            [_labTitle setTextAlignment:NSTextAlignmentCenter];
            _labTitle;
        });
        
        [self.contentView addSubview:self.labTitle];
    }
    return self;
}

- (void)setRate:(CGFloat)rate {
    if (rate < 0.0 || rate > 1.0) return;
    
    _rate = rate;
    CGFloat r = _normalRed + (_selectedRed - _normalRed) * rate;
    CGFloat g = _normalGreen + (_selectedGreen - _normalGreen) * rate;
    CGFloat b = _normalBlue + (_selectedBlue - _normalBlue) * rate;
    CGFloat a = _normalAlpha + (_selectedAlpha - _normalAlpha) * rate;
    
    [self.labTitle setTextColor:[UIColor colorWithRed:r green:g blue:b alpha:a]];
    
//    CGFloat minScale = self.normalSize / self.selectedSize;
//    CGFloat trueScale = minScale + (1 - minScale)*rate;
//    self.labTitle.transform = CGAffineTransformMakeScale(trueScale, trueScale);
    
}

- (void)setSelected:(BOOL)selected {
    if (selected) {
        [self.labTitle setFont:[UIFont systemFontOfSize:self.selectedSize]];
        [self.labTitle setTextColor:self.selectedColor];
    }else{
        [self.labTitle setFont:[UIFont systemFontOfSize:self.normalSize]];
        [self.labTitle setTextColor:self.normalColor];
    }
}

- (void)setSelectedColor:(UIColor *)selectedColor {
    _selectedColor = selectedColor;
    [selectedColor getRed:&_selectedRed green:&_selectedGreen blue:&_selectedBlue alpha:&_selectedAlpha];
}

- (void)setNormalColor:(UIColor *)normalColor {
    _normalColor = normalColor;
    [normalColor getRed:&_normalRed green:&_normalGreen blue:&_normalBlue alpha:&_normalAlpha];
}


@end
