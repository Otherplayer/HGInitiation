//
//  UIAlertController+HGCustom.m
//  HGInitiation
//
//  Created by __无邪_ on 2018/1/16.
//  Copyright © 2018年 __无邪_. All rights reserved.
//

#import "UIAlertController+HGCustom.h"

static NSString * kAttributedTitle = @"_attributedTitle";//不要修改此变量内容 _attributedTitle 是通过runtime方式获取到的
static NSString * kAttributedMessage = @"_attributedMessage";//不要修改此变量内容 _attributedMessage 是通过runtime方式获取到的

@implementation UIAlertController (HGCustom)


- (NSDictionary *)titleAttributes {
    return [self associatedObjectForKey:kAttributedTitle];
}
- (NSDictionary *)messageAttributes {
    return [self associatedObjectForKey:kAttributedMessage];
}

- (void)setTitleAttributes:(NSDictionary *)attributes {
    if ([UIAlertController propertyIsExist:kAttributedTitle]) {
        NSMutableAttributedString *titleAttribute = [NSMutableAttributedString.alloc initWithString:self.title];
        [titleAttribute addAttributes:attributes range:NSMakeRange(0, self.title.length)];
        [self setValue:titleAttribute forKey:kAttributedTitle];
        [self setAssociatedObject:attributes forKey:kAttributedTitle];
    }
}
- (void)setMessageAttributes:(NSDictionary *)attributes {
    if ([UIAlertController propertyIsExist:kAttributedMessage]) {
        NSMutableAttributedString *messageAttribute = [NSMutableAttributedString.alloc initWithString:self.message];
        [messageAttribute addAttributes:attributes range:NSMakeRange(0, self.message.length)];
        [self setValue:messageAttribute forKey:kAttributedMessage];
        [self setAssociatedObject:attributes forKey:kAttributedMessage];
    }
}

@end
