//
//  NSString+HG.h
//  HGInitiation
//
//  Created by __无邪_ on 2018/1/4.
//  Copyright © 2018年 __无邪_. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (HG)

- (CGFloat)heightWithFont:(UIFont *)font limitWidth:(CGFloat)width;
- (CGFloat)widthWithFont:(UIFont *)font limitHeight:(CGFloat)height;


- (NSString *)hgMD5HexLower;
- (NSURL *)url;

@end
