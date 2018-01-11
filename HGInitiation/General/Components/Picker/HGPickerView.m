//
//  HGPickerView.m
//  HGInitiation
//
//  Created by __无邪_ on 2017/12/29.
//  Copyright © 2017年 __无邪_. All rights reserved.
//

#import "HGPickerView.h"
#import <objc/runtime.h>

static const char HGDidFinishPickerResult;

#define kPickerViewHeight 216
#define kToolBarHeight 44

@interface HGPickerView ()<UIPickerViewDelegate,UIPickerViewDataSource>
@property (nonatomic, strong)UIPickerView *pickerView; //选择器

@property (nonatomic, strong)NSMutableArray *items;
@property (nonatomic, strong)UIView *containerView;

@property (nonatomic, strong)NSString *pkKey;
@property (nonatomic, strong)NSArray *pkIndexs;
@property (nonatomic, strong)NSString *pkSeparatedString;

@end

@implementation HGPickerView

- (instancetype)init{
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)showInView:(UIView *)superView items:(NSArray *)items selectedIdxs:(NSArray *)indexs showKey:(NSString *)showKey separatedByString:(NSString *)separatedString resultHandler:(void (^)(NSArray *selectedIdxs,NSArray *orgItems,NSString *showTitle))resultBlock{
    [superView addSubview:self];
    
    objc_setAssociatedObject(self, &HGDidFinishPickerResult, resultBlock, OBJC_ASSOCIATION_COPY);
    
    self.pkKey = showKey;
    self.pkIndexs = indexs;
    self.pkSeparatedString = separatedString ? : @"-";
    
    [self initiateViews];
    
    [UIView animateWithDuration:0.25 animations:^{
        [self.containerView setFrame:[self normalViewFrame]];
    }];
    
    [self.items removeAllObjects];
    [self.items addObjectsFromArray:items];
    [self.pickerView reloadAllComponents];
    
    if (self.pkIndexs.count == self.items.count) {
        for (NSInteger i = 0; i < self.pkIndexs.count; i ++) {
            NSInteger idx = [self.pkIndexs[i] integerValue];
            [self.pickerView selectRow:idx inComponent:i animated:YES];
        }
    }
    
}




#pragma mark - Action

- (void)doneAction{
    
    NSMutableArray *rs = [NSMutableArray.alloc init];
    NSMutableArray *results = [NSMutableArray.alloc init];
    
    for (int i = 0; i < self.items.count; i++) {
        NSInteger row = [self.pickerView selectedRowInComponent:i];
        NSString *title = [[self.items[i] objectAtIndex:row] objectForKey:self.pkKey];
        [results addObject:title];
        [rs addObject:@(row)];
    }
    
    void (^block)(NSArray *selectedIndexs,NSArray *orgItems,NSString *showTitle) = objc_getAssociatedObject(self, &HGDidFinishPickerResult);
    if (block) {
        block([rs copy],[self.items copy],[results componentsJoinedByString:self.pkSeparatedString]);
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




#pragma mark - UIPickerViewDelegate && UIPickerViewDataSource

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return self.items.count;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return [self.items[component] count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    NSArray *items = self.items[component];
    id obj = items[row];
    if ([obj isKindOfClass:[NSString class]]) {
        return obj;
    }
    return [obj objectForKey:self.pkKey];
}


#pragma mark - private

- (CGRect)normalViewFrame{
    return CGRectMake(0, SCREEN_HEIGHT - (kToolBarHeight + kPickerViewHeight) - (IS_IPHONEX ? 38 : 0), SCREEN_WIDTH, (kToolBarHeight + kPickerViewHeight) + (IS_IPHONEX ? 38 : 0));
}
- (CGRect)hiddenViewFrame{
    return CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, (kToolBarHeight + kPickerViewHeight) + (IS_IPHONEX ? 38 : 0));
}

#pragma mark -

- (NSMutableArray *)items {
    if (!_items) {
        _items = [NSMutableArray.alloc init];
    }
    return _items;
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
    
    self.pickerView = ({
        _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, kToolBarHeight, SCREEN_WIDTH, kPickerViewHeight)];
        [_pickerView setDataSource:self];
        [_pickerView setDelegate:self];
        _pickerView;
    });
    [self.containerView addSubview:self.pickerView];
    
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
