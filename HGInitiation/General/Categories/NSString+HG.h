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

+ (NSString *)preferredLanguage;

//    1B(Byte 字节)=8bit，
//　　 1KB (Kilobyte 千字节)=1024B，
//　　 1MB (Megabyte 兆字节 简称“兆”)=1024KB，
//　　 1GB (Gigabyte 吉字节 又称“千兆”)=1024MB，
//　　 1TB (Trillionbyte 万亿字节 太字节)=1024GB，其中1024=2^10 ( 2 的10次方)，
//　　 1PB（Petabyte 千万亿字节 拍字节）=1024TB，
//　　 1EB（Exabyte 百亿亿字节 艾字节）=1024PB，
//　　 1ZB (Zettabyte 十万亿亿字节 泽字节)= 1024 EB,
//　　 1YB (Yottabyte 一亿亿亿字节 尧字节)= 1024 ZB,
//　　 1BB (Brontobyte 一千亿亿亿字节)= 1024 YB.
+ (NSString *)unitSymbolTransform:(unsigned long)value;



@end
