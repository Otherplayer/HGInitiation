//
//  NSNumber+HGRandom.m
//  HGInitiation
//
//  Created by __无邪_ on 2018/5/16.
//  Copyright © 2018年 __无邪_. All rights reserved.
//

#import "NSNumber+HGRandom.h"

@implementation NSNumber (HGRandom)

+ (NSInteger)randomNumber:(NSInteger)from to:(NSInteger)to {
    return (from + arc4random() % (to - from + 1));
}

@end
