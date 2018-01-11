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
- (CGFloat)heightWithFont:(UIFont *)font limitWidth:(CGFloat)width {
    return [self sizeWithFont:font limitSize:CGSizeMake(width, CGFLOAT_MAX)].height;
}
- (CGFloat)widthWithFont:(UIFont *)font limitHeight:(CGFloat)height {
    return [self sizeWithFont:font limitSize:CGSizeMake(height, CGFLOAT_MAX)].width;
}
- (CGSize)sizeWithFont:(UIFont *)font limitSize:(CGSize)size{
    NSStringDrawingOptions options =  NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary *attributes = @{NSFontAttributeName:font};
    return [self boundingRectWithSize:size options:options attributes:attributes context:nil].size;
}


@end
