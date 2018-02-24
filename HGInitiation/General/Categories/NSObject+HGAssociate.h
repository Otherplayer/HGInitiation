//
//  NSObject+HGAssociate.h
//  HGInitiation
//
//  Created by __无邪_ on 2018/1/11.
//  Copyright © 2018年 __无邪_. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface NSObject (HGAssociate)

/// 为NSObject子类添加任何信息..associative机制
- (id)associatedObjectForKey:(NSString *)key;
- (void)setAssociatedObject:(id)object forKey:(NSString *)key;

- (NSString *)propertyNameByValue:(id)value;

- (NSArray *)propertyList;//获取由@property声明的属性
- (NSArray *)ivarList;//获取所有的成员变量
- (NSArray *)methodList;
- (NSArray *)protocolList;


+ (BOOL)propertyIsExist:(NSString *)property;


@end
