//
//  HGTextView.m
//  HGInitiation
//
//  Created by __无邪_ on 2018/1/2.
//  Copyright © 2018年 __无邪_. All rights reserved.
//

#import "HGTextView.h"

/// 系统 textView 默认的字号大小，用于 placeholder 默认的文字大小。实测得到，请勿修改。
const CGFloat kSystemTextViewDefaultFontPointSize = 12.0f;

/// 当系统的 textView.textContainerInset 为 UIEdgeInsetsZero 时，文字与 textView 边缘的间距。实测得到，请勿修改（在输入框font大于13时准确，小于等于12时，y有-1px的偏差）。
const UIEdgeInsets kSystemTextViewFixTextInsets = {0, 5, 0, 5};

@interface HGTextView ()<HGTextViewDelegate>
@property(nonatomic, strong) UILabel *placeholderLabel;
@property(nonatomic, weak) id <HGTextViewDelegate> originalDelegate;
@end

@implementation HGTextView

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
    self.autoResizable = NO;
    self.maxLimitedLength = NSUIntegerMax;
    self.placeholderColor = [UIColor grayColor];
    
    self.placeholderLabel = [[UILabel alloc] init];
    self.placeholderLabel.font = [UIFont systemFontOfSize:kSystemTextViewDefaultFontPointSize];
    self.placeholderLabel.textColor = self.placeholderColor;
    self.placeholderLabel.numberOfLines = 0;
    self.placeholderLabel.alpha = 0;
    [self addSubview:self.placeholderLabel];
    
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    self.delegate = nil;
    self.originalDelegate = nil;
}

#pragma mark -

- (void)textViewDidChange:(UITextView *)textView {
    // 输入字符的时候，placeholder隐藏
    if(self.placeholder.length > 0) {
        [self updatePlaceholderLabelHidden];
    }
    
    if (!textView.markedTextRange) {
        if (textView.text.length > self.maxLimitedLength) {
            textView.text = [textView.text substringToIndex:self.maxLimitedLength];
        }
        if ([self.originalDelegate respondsToSelector:@selector(textViewDidChange:)]) {
            [self.originalDelegate textViewDidChange:self];
        }
    }
    if (self.autoResizable) {
        CGFloat resultHeight = [textView sizeThatFits:CGSizeMake(CGRectGetWidth(self.bounds), CGFLOAT_MAX)].height;
        
        //NSLog(@"handleTextDidChange, text = %@, resultHeight = %f rectHeight = %f", textView.text, resultHeight, CGRectGetHeight(self.bounds));
        // 通知delegate去更新textView的高度
        if ([self.originalDelegate respondsToSelector:@selector(textView:newHeightAfterTextChanged:)] && resultHeight != CGRectGetHeight(self.bounds)) {
            [self.originalDelegate textView:self newHeightAfterTextChanged:resultHeight];
        }
    }
    
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        if ([self.delegate respondsToSelector:@selector(textViewShouldReturn:)]) {
            BOOL shouldReturn = [self.delegate textViewShouldReturn:self];
            if (shouldReturn) {
                if ([self.delegate respondsToSelector:@selector(textViewDidReturn:)]) {
                    [self.delegate textViewDidReturn:self];
                }
                return NO;
            }
        }
    }
    return YES;
}

#pragma mark -

- (void)layoutSubviews {
    [super layoutSubviews];
    if (self.placeholder.length > 0) {
        UIEdgeInsets labelMargins = UIEdgeInsetsMake(self.textContainerInset.top + kSystemTextViewFixTextInsets.top,
                                                     self.textContainerInset.right + kSystemTextViewFixTextInsets.right,
                                                     self.textContainerInset.bottom + kSystemTextViewFixTextInsets.bottom,
                                                     self.textContainerInset.left + kSystemTextViewFixTextInsets.left);
        CGFloat limitWidth = CGRectGetWidth(self.bounds) - (self.contentInset.left + self.contentInset.right);
        CGFloat limitHeight = CGRectGetHeight(self.bounds) - (self.contentInset.top + self.contentInset.bottom);
        CGSize labelSize = [self.placeholderLabel sizeThatFits:CGSizeMake(limitWidth, limitHeight)];
        labelSize.height = fmin(limitHeight, labelSize.height);
        self.placeholderLabel.frame = CGRectMake(labelMargins.left, labelMargins.top, limitWidth, labelSize.height);
    }
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    [self updatePlaceholderLabelHidden];
}


#pragma mark -

- (void)updatePlaceholderLabelHidden {
    if (self.text.length == 0 && self.placeholder.length > 0) {
        self.placeholderLabel.alpha = 1;
    } else {
        self.placeholderLabel.alpha = 0;// 用alpha来让placeholder隐藏，从而尽量避免因为显隐 placeholder 导致 layout
    }
}
- (void)updatePlaceholderStyle {
    self.placeholder = self.placeholder;// 触发文字样式的更新
}

- (void)setPlaceholder:(NSString *)placeholder {
    _placeholder = placeholder?placeholder:@"";
    self.placeholderLabel.attributedText = [[NSAttributedString alloc] initWithString:_placeholder attributes:self.typingAttributes];
    if (self.placeholderColor) {
        self.placeholderLabel.textColor = self.placeholderColor;
    }
}
- (void)setPlaceholderColor:(UIColor *)placeholderColor {
    _placeholderColor = placeholderColor;
    self.placeholderLabel.textColor = _placeholderColor;
}
- (void)setTypingAttributes:(NSDictionary<NSString *,id> *)typingAttributes {
    [super setTypingAttributes:typingAttributes];
    [self updatePlaceholderStyle];
}
- (void)setFont:(UIFont *)font {
    [super setFont:font];
    [self updatePlaceholderStyle];
}
- (void)setTextColor:(UIColor *)textColor {
    [super setTextColor:textColor];
    [self updatePlaceholderStyle];
}
- (void)setTextAlignment:(NSTextAlignment)textAlignment {
    [super setTextAlignment:textAlignment];
    [self updatePlaceholderStyle];
}
- (void)setTextContainerInset:(UIEdgeInsets)textContainerInset {
    [super setTextContainerInset:textContainerInset];
    if (@available(iOS 11, *)) {
    } else {
        // iOS 11 以下修改 textContainerInset 的时候无法自动触发 layoutSubview，导致 placeholderLabel 无法更新布局
        [self setNeedsLayout];
    }
}



#pragma mark - Delegate Proxy

- (void)setDelegate:(id<HGTextViewDelegate>)delegate {
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

// 下面这两个方法比较特殊，无法通过 forwardInvocation: 的方式把消息发送给 self.originalDelegate，只会直接被调用，所以只能在 QMUITextView 内部实现这连个方法然后调用 originalDelegate 的对应方法
// 注意，测过 UITextView 默认没有实现任何 UIScrollViewDelegate 方法

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if ([self.originalDelegate respondsToSelector:_cmd]) {
        [self.originalDelegate scrollViewDidScroll:scrollView];
    }
}

- (void)setContentOffset:(CGPoint)contentOffset animated:(BOOL)animated {
    [super setContentOffset:contentOffset animated:animated];
}

- (void)setContentOffset:(CGPoint)contentOffset {
    [super setContentOffset:contentOffset];
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    if ([self.originalDelegate respondsToSelector:_cmd]) {
        [self.originalDelegate scrollViewDidZoom:scrollView];
    }
}

@end
