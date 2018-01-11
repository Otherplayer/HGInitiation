//
//  HGTextField.m
//  HGInitiation
//
//  Created by __无邪_ on 2018/1/2.
//  Copyright © 2018年 __无邪_. All rights reserved.
//

#import "HGTextField.h"

@interface HGTextField ()<HGTextFieldDelegate>
@property(nonatomic, weak) id <HGTextFieldDelegate> originalDelegate;
@end

@implementation HGTextField

@dynamic delegate;

- (instancetype)init{
    self = [super init];
    if (self) {
        [self initiate];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initiate];
    }
    return self;
}
- (instancetype)initWithCoder:(NSCoder *)coder{
    self = [super initWithCoder:coder];
    if (self) {
        [self initiate];
    }
    return self;
}

- (void)initiate {
    self.delegate = self;
    self.textContainerInset = UIEdgeInsetsMake(0, 7, 0, 7);
    self.maxLimitedLength = NSUIntegerMax;
    [self addTarget:self action:@selector(handleTextChangeEvent:) forControlEvents:UIControlEventEditingChanged];
}

- (void)dealloc {
    self.delegate = nil;
    self.originalDelegate = nil;
}

#pragma mark -

//控制编辑文本的位置
-(CGRect)editingRectForBounds:(CGRect)bounds{
    return [super textRectForBounds:UIEdgeInsetsInsetRect(bounds,self.textContainerInset)];
}
//控制显示文本的位置
-(CGRect)textRectForBounds:(CGRect)bounds{
    return [super textRectForBounds:UIEdgeInsetsInsetRect(bounds,self.textContainerInset)];
}

#pragma mark - setter

- (void)setPlaceholder:(NSString *)placeholder {
    [super setPlaceholder:placeholder];
    placeholder = placeholder?:@"";
    
    NSMutableAttributedString *attStr = [NSMutableAttributedString.alloc initWithString:placeholder];
    [attStr setAttributes:@{
                            NSForegroundColorAttributeName:self.placeholderColor?:[UIColor grayColor],
                            NSFontAttributeName:self.font?:[UIFont systemFontOfSize:12.f]
                            }
                    range:NSMakeRange(0, placeholder.length)];
    [self setAttributedPlaceholder:attStr];
}

- (void)setPlaceholderColor:(UIColor *)placeholderColor {
    _placeholderColor = placeholderColor;
    [self setPlaceholder:self.placeholder];
}
- (void)setFont:(UIFont *)font {
    [super setFont:font];
    [self setPlaceholder:self.placeholder];
}

#pragma mark -

- (void)handleTextChangeEvent:(HGTextField *)textField {
    if (!textField.markedTextRange) {
        if (textField.text.length > self.maxLimitedLength) {
            textField.text = [textField.text substringToIndex:self.maxLimitedLength];
        }
        if ([self.originalDelegate respondsToSelector:@selector(textFieldDidChange:)]) {
            [self.originalDelegate textFieldDidChange:textField];
        }
    }
}

#pragma mark - HGTextFieldDelegate


#pragma mark - Delegate Proxy

- (void)setDelegate:(id<HGTextFieldDelegate>)delegate {
    self.originalDelegate = delegate != self ? delegate : nil;
    [super setDelegate:delegate ? self : nil];
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    NSMethodSignature *a = [super methodSignatureForSelector:aSelector];
    NSMethodSignature *b = [(id)self.originalDelegate methodSignatureForSelector:aSelector];
    NSMethodSignature *result = a ? a : b;
    return result;
}

- (void)forwardInvocation:(NSInvocation *)anInvocation {
    if ([(id)self.originalDelegate respondsToSelector:anInvocation.selector]) {
        [anInvocation invokeWithTarget:(id)self.originalDelegate];
    }
}

- (BOOL)respondsToSelector:(SEL)aSelector {
    BOOL a = [super respondsToSelector:aSelector];
    BOOL c = [self.originalDelegate respondsToSelector:aSelector];
    BOOL result = a || c;
    return result;
}

@end
