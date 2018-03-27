//
//  GGProgressHUD.m
//  GGProgressHUD
//
//  Created by __无邪_ on 15/5/1.
//  Copyright (c) 2015年 __无邪_. All rights reserved.
//

#import "HGHelperHUD.h"

#define kHGHUDMaskType @"HGHUDMaskType"

#define MB_MULTILINE_TEXTSIZE(text, font, maxSize, mode) [text length] > 0 ? [text \
boundingRectWithSize:maxSize options:(NSStringDrawingUsesLineFragmentOrigin) \
attributes:@{NSFontAttributeName:font} context:nil].size : CGSizeZero;

@interface HGHelperHUD ()
@property (nonatomic, strong)HGHelperHUD *HUD;
@property (nonatomic, strong)HGHelperHUD *hud;
@property (nonatomic, strong)UIView *superView;
@end



@implementation HGHelperHUD


+ (instancetype)sharedInstance{
    static HGHelperHUD *HUD;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        HUD = [[HGHelperHUD alloc] init];
        HUD.maskType = HGHUDMaskTypeNone;
    });
    return HUD;
}

#pragma mark - Private
/*
 *
 * 激活锁定，点击时可操作
 *
 */
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event{
    HGHUDMaskType maskType = [[[NSUserDefaults standardUserDefaults] objectForKey:kHGHUDMaskType] intValue];
    if (maskType == HGHUDMaskTypeNone) {
        return NO;
    }
    
    return YES;
}
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    HGHUDMaskType maskType = [[[NSUserDefaults standardUserDefaults] objectForKey:kHGHUDMaskType] intValue];
    if (maskType == HGHUDMaskTypeNone) {
        return nil;
    }
    
    return self;
}
-(void)setMaskType:(HGHUDMaskType)maskType{
    [[NSUserDefaults standardUserDefaults] setInteger:maskType forKey:kHGHUDMaskType];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


#pragma mark - Public

+ (instancetype)showTip:(NSString *)text afterDelay:(NSTimeInterval)delay{ //自定义view
    
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    
    
    HGHelperHUD *hud = [self showHUDAddedTo:window animated:YES];
    
    // Configure CustomView
    UILabel *backg = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 260, 80)];
    backg.backgroundColor = [UIColor whiteColor];
    backg.textAlignment = NSTextAlignmentCenter;
    backg.textColor = [UIColor darkGrayColor];
    backg.layer.cornerRadius = 10;
    backg.layer.masksToBounds = YES;
    
    NSString *fixText = text?:@"";
    backg.text = fixText;
    
    hud.margin = 0.f;
    hud.mode = MBProgressHUDModeCustomView;
    hud.customView = backg;
    //    hud.dimBackground = NO;
    hud.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.210];
    hud.removeFromSuperViewOnHide = YES;
    [hud hideAnimated:YES afterDelay:delay];
    
    return hud;
    
}


- (void)showTipDealy:(NSTimeInterval)dealy format:(NSString *)format arg:(NSString*)arg ,...{ //只有文字的
    NSString *str=[NSString stringWithFormat:format,arg];
    [self showTipTextOnly:str dealy:dealy position:HGHUDPosition_center];
}

- (void)showTipDealy:(NSTimeInterval)dealy position:(HGHUDPosition)position format:(NSString *)format arg:(NSString*)arg ,...{ //只有文字的
    NSString *str=[NSString stringWithFormat:format,arg];
    [self showTipTextOnly:str dealy:dealy position:position];
}

- (void)showTipTextOnly:(NSString *)text dealy:(NSTimeInterval)dealy{ //只有文字的
    if (![text isKindOfClass:[NSString class]]) {
        return;
    }
    if (!text.length) {
        return;
    }
    [self showTipTextOnly:text dealy:dealy position:HGHUDPosition_center];
}

- (void)showTipTextOnly:(NSString *)text dealy:(NSTimeInterval)dealy position:(HGHUDPosition)position{ //只有文字的
    dispatch_async(dispatch_get_main_queue(), ^{
        self.HUD.mode = MBProgressHUDModeText;
        
        
        NSString *fixText = text?:@"";
        _HUD.detailsLabel.text = fixText;
        _HUD.detailsLabel.font = [UIFont systemFontOfSize:15];
        [_HUD setMinSize:CGSizeMake(100, 44)];
        
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        
        switch (position) {
            case HGHUDPosition_top:{
                CGSize detailsLabelSize = MB_MULTILINE_TEXTSIZE(_HUD.detailsLabel.text, _HUD.detailsLabel.font, CGSizeMake(screenSize.width - 4 * self.margin,MAXFLOAT), NSLineBreakByWordWrapping);
                CGFloat yoffset = screenSize.height/2 - detailsLabelSize.height / 2 - self.margin * 1.5 - 64;
                [_HUD setOffset:CGPointMake(_HUD.offset.x, yoffset)];
            }
                break;
            case HGHUDPosition_bottom:{
                CGSize detailsLabelSize = MB_MULTILINE_TEXTSIZE(_HUD.detailsLabel.text, _HUD.detailsLabel.font, CGSizeMake(screenSize.width - 4 * self.margin,MAXFLOAT), NSLineBreakByWordWrapping);
                CGFloat yoffset = screenSize.height/2 - detailsLabelSize.height / 2 - self.margin * 1.5 - 64;
                [_HUD setOffset:CGPointMake(_HUD.offset.x, yoffset)];
            }
                break;
            default:
                break;
        }
        
        [_HUD showAnimated:YES];
        [_HUD hideAnimated:YES afterDelay:dealy];
    });
}

- (void)showProgressWithText:(NSString *)text dealy:(NSTimeInterval)dealy{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.HUD setMode:MBProgressHUDModeIndeterminate];
        NSString *fixText = text?:@"";
        _HUD.detailsLabel.text = fixText;
        _HUD.detailsLabel.font = [UIFont systemFontOfSize:15];
        [_HUD showAnimated:YES];
        [_HUD hideAnimated:YES afterDelay:dealy];
    });
}

- (void)showHProgressWithText:(NSString *)text dealy:(NSTimeInterval)dealy{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.HUD setMode:MBProgressHUDModeAnnularDeterminate];
        NSString *fixText = text?:@"";
        _HUD.detailsLabel.text = fixText;
        _HUD.detailsLabel.font = [UIFont systemFontOfSize:15];
        [_HUD showAnimated:YES];
    });
}

-(void)showProgress:(NSString*)progress
{
    dispatch_async(dispatch_get_main_queue(), ^{
        _HUD.progress = [progress floatValue] / 100.0;
    });
}

- (void)hideImmediately{
    dispatch_async(dispatch_get_main_queue(), ^{
        [_HUD hideAnimated:YES];
        [_HUD removeFromSuperview];
    });
}

#pragma mark - Other

-(MBProgressHUD *)HUD{
    [_HUD removeFromSuperview];
    _HUD = nil;
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    _HUD = [self initWithView:window];
    
    [window addSubview:_HUD];
    
    _HUD.delegate = nil;
    _HUD.margin = 10.f;
    _HUD.removeFromSuperViewOnHide = YES;
    return _HUD;
}

////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////



- (void)showTipInView:(UIView *)view tip:(NSString *)text dealy:(NSTimeInterval)dealy{
    self.superView = view;
    [self hideHud];
    NSString *fixText = text?text:@"";
    self.hud.detailsLabel.text = fixText;
    [self.hud setMode:MBProgressHUDModeText];
    [self.hud showAnimated:YES];
    [self.hud hideAnimated:YES afterDelay:dealy];
}



- (void)showProgressInView:(UIView *)view tip:(NSString *)text afterDelay:(NSTimeInterval)delay{
    self.superView = view;
    [self hideHud];
    NSString *fixText = text?text:@"";
    self.hud.detailsLabel.text = fixText;
    [self.hud setMode:MBProgressHUDModeIndeterminate];
    [self.hud showAnimated:YES];
    [self.hud hideAnimated:YES afterDelay:delay];
}

- (void)hideHud{
    [_hud hideAnimated:YES];
    [_hud removeFromSuperview];
    _hud = nil;
}

- (HGHelperHUD *)hud{
    if (_hud == nil) {
        _hud = [[HGHelperHUD alloc] initWithView:self.superView];
        [self.superView addSubview:_hud];
        _hud.margin = 10.f;
        _hud.removeFromSuperViewOnHide = YES;
        _hud.detailsLabel.font = [UIFont systemFontOfSize:15];
        [_hud setMinSize:CGSizeMake(44, 44)];
    }
    return _hud;
}

@end
