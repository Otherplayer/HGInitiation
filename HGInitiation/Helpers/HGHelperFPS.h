//
//  HGHelperFPS.h
//  HGInitiation
//
//  Created by __无邪_ on 2018/4/28.
//  Copyright © 2018年 __无邪_. All rights reserved.
//

/**
 一般来说以单机游戏来说，帧数与流畅度的关系如下：
 FPS<30，      有限的流畅度
 30<FPS<40 ，  基本流畅的画质
 40<FPS<60，   十分流畅的画质
 FPS>60，      十分流畅的画质
*/

#import <UIKit/UIKit.h>

@interface HGHelperFPS : UIWindow

+ (HGHelperFPS *)sharedInstance;
@property(nonatomic,copy)void(^didTapFPSHandler)(void);


@end
