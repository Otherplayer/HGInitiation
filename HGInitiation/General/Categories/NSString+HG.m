//
//  NSString+HG.m
//  HGInitiation
//
//  Created by __无邪_ on 2018/1/4.
//  Copyright © 2018年 __无邪_. All rights reserved.
//

#import "NSString+HG.h"

@implementation NSString (HG)

- (NSString *)hgMD5HexLower {
    return [CocoaSecurity md5:self].hexLower;
}
- (NSURL *)url {
    return [NSURL URLWithString:self];
}


@end
