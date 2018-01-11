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

- (NSArray *)getAllProperties;
- (NSString *)propertyNameByValue:(id)value;




@end
