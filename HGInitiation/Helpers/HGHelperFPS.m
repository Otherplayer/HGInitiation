//
//  HGHelperFPS.m
//  HGInitiation
//
//  Created by __无邪_ on 2018/4/28.
//  Copyright © 2018年 __无邪_. All rights reserved.
//

#import "HGHelperFPS.h"

NSNotificationName HGHelperFPSDidTapedNotification = @"HGHelperFPSDidTapedNotification";

#define kFPSViewWidth 80
#define kFPSViewHeight STATUS_BAR_HEIGHT

@interface HGHelperFPS ()
@property(nonatomic, strong) CADisplayLink *displayLink;
@property(nonatomic, strong) UIButton *btnInfo;
@property(nonatomic) CFTimeInterval lastTickTimestamp;
@property(nonatomic) NSUInteger count;
@property(nonatomic) NSInteger lastFPSValue;

@end

@implementation HGHelperFPS

+ (HGHelperFPS *)sharedInstance {
    static HGHelperFPS *sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[HGHelperFPS alloc] init];
        if([[UIDevice currentDevice].systemVersion floatValue] >= 9.0)
            sharedInstance.rootViewController = [UIViewController new]; // iOS 9 requires rootViewController for any window
    });
    return sharedInstance;
}

- (instancetype)init{
    self = [super initWithFrame:CGRectMake(0, 0, kFPSViewWidth, kFPSViewHeight)];
    if (self) {
        
        [self setWindowLevel:UIWindowLevelStatusBar + 1.f];
        [self setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.5]];
        [self setUserInteractionEnabled:YES];
        
        self.lastTickTimestamp = 0.f;
        self.count = 0;
        self.lastFPSValue = 60;
        self.isTaped = NO;
        
        YYWeakProxy *proxy = [YYWeakProxy proxyWithTarget:self];
        
        self.displayLink = ({
            _displayLink = [CADisplayLink displayLinkWithTarget:proxy selector:@selector(displayTickCallback:)];
            [_displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
            _displayLink;
        });
        self.btnInfo = ({
            _btnInfo = [UIButton.alloc initWithFrame:CGRectMake(0, 0, kFPSViewWidth, kFPSViewHeight)];
            [_btnInfo.titleLabel setFont:[UIFont systemFontOfSize:14]];
            [_btnInfo setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
            _btnInfo;
        });
        [self addSubview:self.btnInfo];
        
        UIPanGestureRecognizer *panGesture = ({
            panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(didPanAction:)];
            panGesture;
        });
        UITapGestureRecognizer *tapGesture = ({
            tapGesture = [UITapGestureRecognizer.alloc initWithTarget:self action:@selector(didClickAction:)];
            tapGesture;
        });
        [self addGestureRecognizer:panGesture];
        [self addGestureRecognizer:tapGesture];
        
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(applicationDidBecomeActiveNotification)
                                                     name:UIApplicationDidBecomeActiveNotification
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(applicationWillResignActiveNotification)
                                                     name:UIApplicationWillResignActiveNotification
                                                   object:nil];
    }
    return self;
}

- (void)displayTickCallback:(CADisplayLink *)sender {
    
    NSTimeInterval delta = sender.timestamp - self.lastTickTimestamp;
    self.count ++;
    if (delta < 1) {
        return;
    }
    
    NSInteger fps = (int)round(self.count / delta);
    self.count = 0;
    
    if (fps != self.lastFPSValue) {
        self.lastFPSValue = fps;
        //update UI
        NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ FPS",@(fps)]];
        [self.btnInfo setTitle:text.string forState:UIControlStateNormal];
    }
    self.lastTickTimestamp = sender.timestamp;
}
- (void)didPanAction:(UIPanGestureRecognizer *)recognizer {
    UIView *targetView = recognizer.view;
    
    targetView.layer.shadowColor = [UIColor blackColor].CGColor;
    targetView.layer.shadowOpacity = 0.35;
    
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        targetView.layer.shadowOffset = CGSizeMake(5, 5);
    }else if (recognizer.state == UIGestureRecognizerStateEnded){
        targetView.layer.shadowOffset = CGSizeMake(0, 0);
        if (targetView.top < 0) {
            targetView.top = 0;
        }
        if (targetView.left < 0) {
            targetView.left = 0;
        }
        if (targetView.left > kScreenWidth - targetView.width) {
            targetView.left = kScreenWidth - targetView.width;
        }
        if (targetView.top > kScreenHeight - targetView.height) {
            targetView.top = kScreenHeight - targetView.height;
        }
        
    }else if(recognizer.state == UIGestureRecognizerStateChanged){
        CGPoint point = [recognizer translationInView:self];
        CGFloat absX = fabs(point.x);
        CGFloat absY = fabs(point.y);
        
        if (absX > absY) {
            if (point.x < 0) {//左
                targetView.layer.shadowOffset = CGSizeMake(5, 0);
            }else{//右
                targetView.layer.shadowOffset = CGSizeMake(-5, 0);
            }
            
        } else if (absY > absX) {
            if (point.y < 0) {//上
                targetView.layer.shadowOffset = CGSizeMake(0, 5);
            }else{//下
                targetView.layer.shadowOffset = CGSizeMake(0, -5);
            }
        }
        
        targetView.center = CGPointMake(recognizer.view.center.x + point.x, recognizer.view.center.y + point.y);
        [recognizer setTranslation:CGPointMake(0, 0) inView:self];
    }
}
- (void)didClickAction:(UITapGestureRecognizer *)gesture {
    self.isTaped = !self.isTaped;
    [[NSNotificationCenter defaultCenter] postNotificationName:HGHelperFPSDidTapedNotification object:@(self.isTaped)];
    if (self.didTapFPSHandler) {
        self.didTapFPSHandler(self.isTaped);
    }
}

#pragma mark -

- (void)becomeKeyWindow {
    // prevent self to be key window
    [self setHidden: YES];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self setHidden: NO];
    });
}
- (void)applicationDidBecomeActiveNotification {
    [self.displayLink setPaused:NO];
}
- (void)applicationWillResignActiveNotification {
    [self.displayLink setPaused:YES];
}
- (void)dealloc {
    [self.displayLink setPaused:YES];
    [self.displayLink removeFromRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
