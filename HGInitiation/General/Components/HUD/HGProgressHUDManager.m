//
//  HGProgressHUDManager.m
//  HGInitiation
//
//  Created by __无邪_ on 2018/6/27.
//  Copyright © 2018年 __无邪_. All rights reserved.
//

#import "HGProgressHUDManager.h"
#import "MBProgressHUD.h"


@interface HGProgressHUDManager ()
@property(nonatomic, strong) MBProgressHUD *progressHUD;
@property(nonatomic, strong) UIView *superView;

@end


@implementation HGProgressHUDManager

+ (instancetype)shared {
    static HGProgressHUDManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[HGProgressHUDManager alloc] init];
    });
    return manager;
}

- (void)showLoadingIn:(UIView *)view msg:(nullable NSString *)msg hideAfterDealy:(CGFloat)dealy {
    if (![self.progressHUD isDescendantOfView:view]) {
        self.progressHUD = [MBProgressHUD showHUDAddedTo:view animated:YES];
    }
    
    self.progressHUD.backgroundView.style = MBProgressHUDBackgroundStyleBlur;
    self.progressHUD.backgroundView.blurEffectStyle = UIBlurEffectStyleLight;
    self.progressHUD.backgroundView.color = [UIColor colorWithWhite:0.f alpha:0.1f];
    self.progressHUD.backgroundView.alpha = 0.35;
    self.progressHUD.animationType = MBProgressHUDAnimationZoom;
    
    self.progressHUD.margin = 10;
    self.progressHUD.mode = MBProgressHUDModeIndeterminate;
    self.progressHUD.bezelView.color = [UIColor clearColor];
    self.progressHUD.contentColor = [UIColor blackColor];
    self.progressHUD.detailsLabel.text = msg?:@"";
    self.progressHUD.detailsLabel.font = [UIFont systemFontOfSize:16.f];
    
    [self.progressHUD hideAnimated:YES afterDelay:dealy];
}

- (void)showMSGIn:(UIView *)view msg:(nullable NSString *)msg hideAfterDealy:(CGFloat)dealy {
    
    if (![self.progressHUD isDescendantOfView:view]) {
        self.progressHUD = [MBProgressHUD showHUDAddedTo:view animated:YES];
    }
    
    self.progressHUD.backgroundView.style = MBProgressHUDBackgroundStyleBlur;
    self.progressHUD.backgroundView.blurEffectStyle = UIBlurEffectStyleLight;
    self.progressHUD.backgroundView.color = [UIColor colorWithWhite:0.f alpha:0.1f];
    self.progressHUD.backgroundView.alpha = 0.35;
    self.progressHUD.animationType = MBProgressHUDAnimationZoom;
    
    self.progressHUD.margin = 20;
    self.progressHUD.mode = MBProgressHUDModeText;
    self.progressHUD.bezelView.color = [UIColor colorWithWhite:0.f alpha:0.85f];
    self.progressHUD.contentColor = [UIColor whiteColor];
    self.progressHUD.detailsLabel.text = msg?:@"";
    self.progressHUD.detailsLabel.font = [UIFont systemFontOfSize:16.f];
    
    [self.progressHUD hideAnimated:YES afterDelay:dealy];
}


- (void)hideProgressHUD {
    [self.progressHUD hideAnimated:YES];
}


#pragma mark - private








@end



/* 记录一下
 * 激活锁定，点击时可操作
*/
/*
typedef NS_ENUM(NSUInteger, HGHUDMaskType) {
    HGHUDMaskTypeNone = 1,  // allow user interactions while HUD is displayed
    HGHUDMaskTypeClear = 2, // don't allow user interactions
};
@interface HGHelperHUD : MBProgressHUD
@property (nonatomic, unsafe_unretained) HGHUDMaskType maskType;
@end
@implementation HGHelperHUD
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
@end
*/








