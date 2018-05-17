//
//  HGScrollDefaultContentImage.m
//  HGInitiation
//
//  Created by __无邪_ on 2018/1/9.
//  Copyright © 2018年 __无邪_. All rights reserved.
//

#import "HGScrollDefaultImage.h"


@interface HGScrollDefaultImage ()
@property(nonatomic, strong)UIView *labBgView;
@end

@implementation HGScrollDefaultImage

const CGFloat HGScrollDefaultTitleHeight = 40.f;
const CGFloat HGScrollDefaultTitleMargin = 10.f;


- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.imageView = ({
            _imageView = [UIImageView.alloc initWithFrame:self.bounds];
            _imageView.contentMode = UIViewContentModeScaleAspectFill;
            _imageView;
        });
        
        self.labBgView = ({
            _labBgView = [UIView.alloc initWithFrame:CGRectMake(0, self.height - HGScrollDefaultTitleHeight, self.width, HGScrollDefaultTitleHeight)];
            _labBgView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.35];
            _labBgView.hidden = YES;
            _labBgView;
        });

        self.labTitle = ({
            _labTitle = [UILabel.alloc initWithFrame:CGRectMake(HGScrollDefaultTitleMargin, 0, self.width - HGScrollDefaultTitleMargin * 2, HGScrollDefaultTitleHeight)];
            _labTitle.textColor = [UIColor whiteColor];
            _labTitle.font = [UIFont systemFontOfSize:16];
            _labTitle.text = @"中国";
            _labTitle;
        });
        [self.labBgView addSubview:self.labTitle];
        
        [self.contentView addSubview:self.imageView];
        [self.contentView addSubview:self.labBgView];
        [self setClipsToBounds:YES];
        
    }
    return self;
}


- (void)setImageUrl:(NSString *)imgUrl placeholderImage:(UIImage *)placeholderImage title:(NSString *)title {
    [self.imageView sd_setImageWithURL:imgUrl.url placeholderImage:placeholderImage];
    [self.labTitle setText:title];
    if (title.length > 0) {
        self.labBgView.hidden = NO;
    }else{
        self.labBgView.hidden = YES;
    }
    
}


@end
