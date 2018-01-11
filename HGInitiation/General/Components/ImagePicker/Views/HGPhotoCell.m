//
//  HGPhotoCell.m
//  HGInitiation
//
//  Created by __无邪_ on 2017/12/26.
//  Copyright © 2017年 __无邪_. All rights reserved.
//

#import "HGPhotoCell.h"

@interface HGPhotoCell ()
@property(nonatomic, strong)UIImageView *imageView;
@end

@implementation HGPhotoCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        CGFloat btnWidth = 30;
        self.imageView = ({
            _imageView = [UIImageView.alloc initWithFrame:self.bounds];
            _imageView.contentMode = UIViewContentModeScaleAspectFill;
            _imageView.clipsToBounds = YES;
            _imageView;
        });
        self.btnSelectStatus = ({
            _btnSelectStatus = [UIButton.alloc initWithFrame:CGRectMake(self.width - btnWidth, 0, btnWidth, btnWidth)];
            [_btnSelectStatus setImage:[UIImage imageNamed:@"photo_unselect"] forState:UIControlStateNormal];
            [_btnSelectStatus setImage:[UIImage imageNamed:@"photo_select"] forState:UIControlStateSelected];
            [_btnSelectStatus addTarget:self action:@selector(didClickSelectAction:) forControlEvents:UIControlEventTouchUpInside];
            _btnSelectStatus;
        });
        [self.contentView addSubview:self.imageView];
        [self.contentView addSubview:self.btnSelectStatus];
    }
    return self;
}

- (void)setModel:(HGPhotoModel *)model {
    _model = model;
    self.imageView.image = [model.asset thumbnailWithSize:CGSizeMake(self.height, self.height)];
    [self refreshStatus];
}

- (void)refreshStatus{
    self.btnSelectStatus.selected = self.model.isSelected;
}


- (void)didClickSelectAction:(UIButton *)sender {
    if (self.callbackHandler) {
        self.callbackHandler(self);
    }
}



@end
