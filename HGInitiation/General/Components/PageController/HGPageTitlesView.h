//
//  HGPageMenuView.h
//  HGInitiation
//
//  Created by __无邪_ on 2018/6/4.
//  Copyright © 2018年 __无邪_. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HGPageProgressView.h"

@class HGPageTitlesView;
@protocol HGPageTitlesDelegate <NSObject>
@required
- (void)pageTitles:(HGPageTitlesView *)titlesView shouldSelectItemAtIndex:(NSInteger)index;
@end

typedef NS_ENUM(NSUInteger, HGPageTitlesShowType) {
    HGPageTitlesShowTypeNormal,
    HGPageTitlesShowTypeCenter
};
typedef NS_ENUM(NSUInteger, HGPageProgressViewAnimatedType) {
    HGPageProgressViewAnimatedTypeNone,
    HGPageProgressViewAnimatedTypePanning,
    HGPageProgressViewAnimatedTypeTransition
};


@interface HGPageTitlesView : UIView

@property(nonatomic, strong)HGPageProgressView *progressView;
@property(nonatomic, strong)NSArray *titles;
@property(nonatomic, assign)NSInteger selectedIndex;
@property(nonatomic, assign)HGPageTitlesShowType showType;
@property(nonatomic, assign)HGPageProgressViewAnimatedType animatedType;
@property(nonatomic, weak) id<HGPageTitlesDelegate>delegate;


- (void)reloadData;
- (void)scrollToItemInProgress:(CGFloat)progress;

//- (void)scrollToItemAtIndex:(NSInteger)index;



@end
