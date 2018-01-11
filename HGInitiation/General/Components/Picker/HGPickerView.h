//
//  HGPickerView.h
//  HGInitiation
//
//  Created by __无邪_ on 2017/12/29.
//  Copyright © 2017年 __无邪_. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HGPickerView : UIView

@property (nonatomic, strong)UIColor *lineColor;
@property (nonatomic, strong)UIColor *doneTitleColor;
@property (nonatomic, strong)UIColor *cancelTitleColor;

- (void)showInView:(UIView *)superView
             items:(NSArray *)items       //@[@{@"title":@"中国",@"value":@"id000"}]
      selectedIdxs:(NSArray *)indexs      //@0
           showKey:(NSString *)showKey    //title
 separatedByString:(NSString *)separatedString      // -
     resultHandler:(void (^)(NSArray *selectedIdxs,
                             NSArray *orgItems,
                             NSString *showTitle
                             ))resultBlock;

@end
