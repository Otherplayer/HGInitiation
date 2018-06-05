//
//  HGPageMenuView.h
//  HGInitiation
//
//  Created by __无邪_ on 2018/6/4.
//  Copyright © 2018年 __无邪_. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HGPageTitlesView;
@protocol HGPageTitlesDelegate <NSObject>
@required
- (void)pageTitles:(HGPageTitlesView *)titlesView didSelectItemAtIndex:(NSInteger)index;
@end


@interface HGPageTitlesView : UIView

@property(nonatomic, strong)NSArray *titles;
@property(nonatomic, assign)NSInteger selectedIndex;
@property(nonatomic, weak) id<HGPageTitlesDelegate>delegate;

- (void)reloadData;
- (void)scrollToItemAtIndex:(NSInteger)index;
- (void)selectItemAtIndex:(NSInteger)index;



@end
