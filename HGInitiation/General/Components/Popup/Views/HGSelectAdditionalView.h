//
//  HGSelectAdditionalView.h
//  HGInitiation
//
//  Created by __无邪_ on 2018/6/19.
//  Copyright © 2018年 __无邪_. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HGSelectAdditionalView : UICollectionReusableView

@end


@interface HGSelectViewHeader : UICollectionReusableView
@property(nonatomic, strong) UILabel *labTitle;
@end

@interface HGSelectViewFooter : UICollectionReusableView
@property(nonatomic, strong)UIButton *container;
@property(nonatomic, copy)void(^didTapCancelHandler)(void);
@end
