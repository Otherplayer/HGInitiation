//
//  HGScrollView.h
//  HGInitiation
//
//  Created by __无邪_ on 2018/1/9.
//  Copyright © 2018年 __无邪_. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HGPageControl.h"
#import "HGScrollDefaultImage.h"
#import "HGScrollCustomCell.h"

@class HGScrollView;

typedef NS_ENUM(NSUInteger, HGScrollViewContentType) {
    HGScrollViewContentTypeImage,
    HGScrollViewContentTypeCustom //需要继承 HGScrollCustomCell 并实现代理方法 cellClassForScrollView
};
typedef NS_ENUM(NSUInteger, HGScrollDirection) {
    HGScrollDirectionVertical,
    HGScrollDirectionHorizontal
};

@protocol HGScrollViewDelegate <NSObject>
@optional
- (void)scrollView:(HGScrollView *)scrollView didSelectItemAtIndex:(NSInteger)index;
- (void)scrollView:(HGScrollView *)scrollView didScroll2Index:(NSInteger)index;

- (Class)cellClassForScrollView:(HGScrollView *)scrollView;

@end

@interface HGScrollView : UIView
@property (nonatomic, weak) id <HGScrollViewDelegate>delegate;
@property (nonatomic,strong) UIColor *pageIndicatorTintColor;
@property (nonatomic,strong) UIColor *currentPageIndicatorTintColor;
@property (nonatomic) HGPageControlPosition pageControlPosition;//default HGPageControlPositionBottomRight
@property (nonatomic) float scrollIntervalTime;//default 3s
@property (nonatomic) BOOL loopScroll;//default YES
@property (nonatomic) BOOL autoScroll;//default YES
@property (nonatomic,readonly) NSInteger currentPage;


- (instancetype)initWithFrame:(CGRect)frame; //default HGScrollViewContentTypeImage HGScrollDirectionHorizontal
- (instancetype)initWithFrame:(CGRect)frame type:(HGScrollViewContentType)type;
- (instancetype)initWithFrame:(CGRect)frame type:(HGScrollViewContentType)type direction:(HGScrollDirection)scrollDirection;

- (void)setDatas:(NSArray *)datas key:(NSString *)key;
- (void)setDatas:(NSArray *)datas key:(NSString *)key titleKey:(NSString *)titleKey;
- (void)invalidateTimer;

- (void)reloadData;

@end


