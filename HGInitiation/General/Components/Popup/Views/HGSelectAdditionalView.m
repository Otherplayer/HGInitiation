//
//  HGSelectAdditionalView.m
//  HGInitiation
//
//  Created by __无邪_ on 2018/6/19.
//  Copyright © 2018年 __无邪_. All rights reserved.
//

#import "HGSelectAdditionalView.h"

@implementation HGSelectViewHeader
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.labTitle = ({
            _labTitle = [UILabel.alloc initWithFrame:CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame))];
            _labTitle.text = @"HGInitiation";
            _labTitle.textAlignment = NSTextAlignmentCenter;
            _labTitle.textColor = UIColor.darkGrayColor;
            _labTitle.font = [UIFont systemFontOfSize:14];
            _labTitle;
        });
        [self addSubview:self.labTitle];
    }
    return self;
}
@end


@implementation HGSelectViewFooter
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.container = ({
            _container = [UIButton.alloc initWithFrame:CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame))];
            _container.backgroundColor = [UIColor whiteColor];
            [_container setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
            [_container setBackgroundImage:[[UIImage imageWithColor:[UIColor whiteColor]] imageByBlurExtraLight] forState:UIControlStateHighlighted];
            [_container addTarget:self action:@selector(didTapCancelAction:) forControlEvents:UIControlEventTouchUpInside];
            _container;
        });
        
        UILabel *labCancel = ({
            labCancel = [UILabel.alloc initWithFrame:CGRectMake(0, 0, CGRectGetWidth(frame), 50)];
            [labCancel setTextColor:[UIColor blackColor]];
            [labCancel setFont:[UIFont systemFontOfSize:16]];
            [labCancel setTextAlignment:NSTextAlignmentCenter];
            [labCancel setText:NSLocalizedString(@"取消", @"cancel")];
            labCancel;
        });
        [_container addSubview:labCancel];
        [self addSubview:self.container];
    }
    return self;
}
- (void)didTapCancelAction:(UIButton *)sender {
    if (self.didTapCancelHandler) {
        self.didTapCancelHandler();
    }
}
@end
