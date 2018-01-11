//
//  HGDatePickerView.m
//  HGInitiation
//
//  Created by __无邪_ on 2017/12/29.
//  Copyright © 2017年 __无邪_. All rights reserved.
//

#import "HGDatePickerView.h"
#import <objc/runtime.h>

static const char HGDidFinishPickerResult;

#define kPickerViewHeight 216
#define kToolBarHeight 44

@interface HGDatePickerView ()

@property (nonatomic, strong)UIView *containerView;
@property (nonatomic, strong)NSString *formatter;

@end

@implementation HGDatePickerView

- (instancetype)init{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)showInView:(UIView *)superView selectedDate:(NSDate *)selectedDate format:(NSString *)format resultHandler:(void (^)(NSDate *selectedDate,NSString *dateStr))resultBlock{
    [superView addSubview:self];
    
    self.formatter = format ?: @"yyyy-MM-dd HH:mm";
    
    objc_setAssociatedObject(self, &HGDidFinishPickerResult, resultBlock, OBJC_ASSOCIATION_COPY);
    
    [self initiateViews];
    
    if ([selectedDate isKindOfClass:[NSDate class]]) {
        [self.datePicker setDate:selectedDate animated:YES];
    }
    
    [UIView animateWithDuration:0.25 animations:^{
        [self.containerView setFrame:[self normalViewFrame]];
    }];
}




#pragma mark - Action

- (void)doneAction{
    
    NSDate *resultDate = self.datePicker.date;
    
    NSString *resultStr = HGStringFromDate(self.formatter, resultDate);
    
    void (^block)(NSDate *selectedDate,NSString *dateStr) = objc_getAssociatedObject(self, &HGDidFinishPickerResult);
    if (block) {
        block(resultDate,resultStr);
    }
    
    [self dissmissView];
}

- (void)dissmissView{
    [UIView animateWithDuration:0.25 animations:^{
        [self.containerView setFrame:[self hiddenViewFrame]];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma mark - private

- (CGRect)normalViewFrame{
    return CGRectMake(0, SCREEN_HEIGHT - (kToolBarHeight + kPickerViewHeight) - (IS_IPHONEX ? 38 : 0), SCREEN_WIDTH, (kToolBarHeight + kPickerViewHeight) + (IS_IPHONEX ? 38 : 0));
}
- (CGRect)hiddenViewFrame{
    return CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, (kToolBarHeight + kPickerViewHeight) + (IS_IPHONEX ? 38 : 0));
}

#pragma mark - initiate

- (void)initiateViews {
    [self setFrame:[[UIScreen mainScreen] bounds]];
    
    UIView *maskView = ({
        maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds))];
        maskView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
        UITapGestureRecognizer *dismissAction = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dissmissView)];
        [maskView addGestureRecognizer:dismissAction];
        maskView;
    });
    [self addSubview:maskView];
    
    self.containerView = ({
        _containerView = [UIView.alloc initWithFrame:[self hiddenViewFrame]];
        _containerView.backgroundColor = [UIColor whiteColor];
        _containerView;
    });
    [maskView addSubview:self.containerView];
    
    
    [self setUpToolBar];
    
    [self.containerView addSubview:self.datePicker];
    
    UIColor *bgColor = [UIColor lightGrayColor];
    UILabel *upline = [[UILabel alloc] initWithFrame:CGRectMake(0, 134.5, SCREEN_WIDTH, 0.5)];
    [upline setBackgroundColor:bgColor];
    UILabel *downLine = [[UILabel alloc] initWithFrame:CGRectMake(0, 169, SCREEN_WIDTH, 0.5)];
    [downLine setBackgroundColor:bgColor];
    [self.containerView addSubview:upline];
    [self.containerView addSubview:downLine];
    
}

- (void)setUpToolBar{
    
    UIToolbar *toolBar = ({
        toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kToolBarHeight)];
        
        UIButton *cancelButton = ({
            cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
            cancelButton.bounds = CGRectMake(0,0,50,40);
            [cancelButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
            [cancelButton.titleLabel setTextColor:[UIColor grayColor]];
            [cancelButton setTitleColor:self.cancelTitleColor forState:UIControlStateNormal];
            [cancelButton setTitle:NSLocalizedString(@"取消", @"cancel") forState:UIControlStateNormal];
            [cancelButton addTarget:self action:@selector(dissmissView) forControlEvents:UIControlEventTouchUpInside];
            cancelButton;
        });
        UIButton *okButton = ({
            okButton = [UIButton buttonWithType:UIButtonTypeCustom];
            okButton.bounds = CGRectMake(0,0,60,40);
            [okButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
            [okButton.titleLabel setTextColor:[UIColor grayColor]];
            [okButton setTitleColor:self.doneTitleColor forState:UIControlStateNormal];
            [okButton setTitle:NSLocalizedString(@"确认", @"confirm") forState:UIControlStateNormal];
            [okButton addTarget:self action:@selector(doneAction) forControlEvents:UIControlEventTouchUpInside];
            okButton;
        });
        
        UIBarButtonItem *cancelButtonItem = ({
            cancelButtonItem = [[UIBarButtonItem alloc]initWithCustomView:cancelButton];
            cancelButtonItem;
        });
        UIBarButtonItem *flexibleSpace = ({
            flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
            flexibleSpace;
        });
        UIBarButtonItem *okButtonItem = ({
            okButtonItem = [[UIBarButtonItem alloc]initWithCustomView:okButton];
            okButtonItem;
        });
        
        toolBar.items = [NSArray arrayWithObjects:cancelButtonItem,flexibleSpace,okButtonItem, nil];
        toolBar;
    });
    
    
    UILabel *lineLabel = ({
        lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, kToolBarHeight, SCREEN_WIDTH, 1)];
        lineLabel.backgroundColor = self.lineColor;
        lineLabel;
    });
    
    [self.containerView addSubview:toolBar];
    [self.containerView addSubview:lineLabel];
    
}

- (UIDatePicker *)datePicker {
    if (!_datePicker) {
        _datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, kToolBarHeight, SCREEN_WIDTH, kPickerViewHeight)];
    }
    return _datePicker;
}
- (UIColor *)lineColor {
    if (!_lineColor) {
        _lineColor = [UIColor redColor];
    }
    return _lineColor;
}
- (UIColor *)doneTitleColor {
    if (!_doneTitleColor) {
        _doneTitleColor = [UIColor darkGrayColor];
    }
    return _doneTitleColor;
}
- (UIColor *)cancelTitleColor {
    if (!_cancelTitleColor) {
        _cancelTitleColor = [UIColor darkGrayColor];
    }
    return _cancelTitleColor;
}


@end
