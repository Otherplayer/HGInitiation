//
//  UIButton+CountDown.m
//  HGInitiation
//
//  Created by __无邪_ on 2018/6/20.
//  Copyright © 2018年 __无邪_. All rights reserved.
//

#import "UIButton+CountDown.h"

@implementation UIButton (CountDown)
- (void)startTime:(NSInteger )timeout title:(NSString *)tittle waitTittle:(NSString *)waitTittle{
    __weak typeof(self) weakSelf = self;
    __block NSInteger timeOut=timeout; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeOut<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [weakSelf setEnabled:YES];
                [weakSelf setBackgroundColor:[UIColor whiteColor]];
                [weakSelf setTitle:tittle forState:UIControlStateNormal];
                weakSelf.userInteractionEnabled = YES;
            });
        }else{
            
            int seconds = ((timeOut == 60) ? 60 : (timeOut % 60));
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                if (weakSelf.isEnabled) {
                    [weakSelf setEnabled:NO];
                    [weakSelf setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
                }
                
                [weakSelf setTitle:[NSString stringWithFormat:@"%@ %@",strTime,waitTittle] forState:UIControlStateNormal];
                
            });
            timeOut--;
            
        }
    });
    dispatch_resume(_timer);
}
@end
