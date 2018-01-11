//
//  HGTextView.h
//  HGInitiation
//
//  Created by __无邪_ on 2018/1/2.
//  Copyright © 2018年 __无邪_. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HGTextView;
@protocol HGTextViewDelegate <UITextViewDelegate>

@optional

- (void)textView:(HGTextView *)textView newHeightAfterTextChanged:(CGFloat)height;
/**
 *  用户点击键盘的 return 按钮时的回调（return 按钮本质上是输入换行符“\n”）
 *  @return 返回 YES 表示程序认为当前的点击是为了进行类似“发送”之类的操作，所以最终“\n”并不会被输入到文本框里。返回 NO 表示程序认为当前的点击只是普通的输入
 */
- (BOOL)textViewShouldReturn:(HGTextView *)textView;
/**
 * 当textViewShouldReturn返回YES时，点击 return 会触发下面方法
 */
- (void)textViewDidReturn:(HGTextView *)textView;

@end

@interface HGTextView : UITextView

@property(nonatomic,weak) id<HGTextViewDelegate> delegate;
@property(nonatomic,copy)IBInspectable NSString *placeholder;
@property(nonatomic,strong)IBInspectable UIColor *placeholderColor;
@property(nonatomic)BOOL autoResizable;//自动计算行高 default NO
@property(nonatomic)NSInteger maxLimitedLength;


@end
