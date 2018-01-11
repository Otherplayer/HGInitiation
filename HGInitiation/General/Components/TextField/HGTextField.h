//
//  HGTextField.h
//  HGInitiation
//
//  Created by __无邪_ on 2018/1/2.
//  Copyright © 2018年 __无邪_. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HGTextField;
@protocol HGTextFieldDelegate <UITextFieldDelegate>

@optional
- (void)textFieldDidChange:(HGTextField *)textField;

@end

@interface HGTextField : UITextField

@property(nonatomic, weak) id<HGTextFieldDelegate> delegate;

@property (nonatomic, assign) UIEdgeInsets textContainerInset;
@property (nonatomic, strong) UIColor *placeholderColor;
@property (nonatomic) NSInteger maxLimitedLength;

@end
