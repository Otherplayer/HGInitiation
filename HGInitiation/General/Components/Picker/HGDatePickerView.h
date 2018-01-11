//
//  HGDatePickerView.h
//  HGInitiation
//
//  Created by __无邪_ on 2017/12/29.
//  Copyright © 2017年 __无邪_. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HGDatePickerView : UIView

@property (nonatomic, strong)UIDatePicker *datePicker;
@property (nonatomic, strong)UIColor *lineColor;
@property (nonatomic, strong)UIColor *doneTitleColor;
@property (nonatomic, strong)UIColor *cancelTitleColor;

- (void)showInView:(UIView *)superView
      selectedDate:(NSDate *)selectedDate
            format:(NSString *)format
     resultHandler:(void (^)(NSDate *selectedDate,NSString *dateStr))resultBlock;


@end
