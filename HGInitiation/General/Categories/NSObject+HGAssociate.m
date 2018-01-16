//
//  NSObject+HGAssociate.m
//  HGInitiation
//
//  Created by __无邪_ on 2018/1/11.
//  Copyright © 2018年 __无邪_. All rights reserved.
//

#import "NSObject+HGAssociate.h"
#import <objc/runtime.h>
static const char *HGAssociatedObjectsKey = "HGAssociatedObjectsKey";


@implementation NSObject (HGAssociate)

- (id)associatedObjectForKey:(NSString *)key {
    NSMutableDictionary *dict = objc_getAssociatedObject(self, &HGAssociatedObjectsKey);
    return [dict objectForKey:key];
}

- (void)setAssociatedObject:(id)object forKey:(NSString *)key {
    NSMutableDictionary *dict = objc_getAssociatedObject(self, &HGAssociatedObjectsKey);
    if (!dict) {
        dict = [[NSMutableDictionary alloc] init];
        objc_setAssociatedObject(self, &HGAssociatedObjectsKey, dict, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    [dict setObject:object forKey:key];
}


- (NSArray *)propertyList{
    u_int count;
    objc_property_t *list = class_copyPropertyList([self class], &count);
    NSMutableArray *results = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i < count; i++){
        const char *name = property_getName(list[i]);
        [results addObject:[NSString stringWithUTF8String:name]];
    }
    free(list);
    return results;
}
- (NSArray *)methodList {
    u_int count;
    Method *list = class_copyMethodList([self class], &count);
    NSMutableArray *results = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i < count; i++) {
        const char *name = sel_getName(method_getName(list[i]));
        [results addObject:[NSString stringWithUTF8String:name]];
    }
    free(list);
    return results;
}
- (NSArray *)ivarList {
    u_int count;
    Ivar *list = class_copyIvarList([self class], &count);
    NSMutableArray *results = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i < count; i++) {
        const char *name = ivar_getName(list[i]);
        [results addObject:[NSString stringWithUTF8String:name]];
    }
    free(list);
    return results;
}
- (NSArray *)protocolList {
    u_int count;
    Protocol * __unsafe_unretained *list = class_copyProtocolList([self class], &count);
    NSMutableArray *results = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i < count; i++) {
        const char *name = protocol_getName(list[i]);
        [results addObject:[NSString stringWithUTF8String:name]];
    }
    free(list);
    return results;
}

- (NSString *)propertyNameByValue:(id)value{
    u_int count;
    NSString *key = nil;
    Ivar * ivars = class_copyIvarList([self class], &count);
    for(int i = 0; i < count; i++) {
        Ivar thisIvar = ivars[i];
        const char *type = ivar_getTypeEncoding(thisIvar);
        NSString *stringType =  [NSString stringWithCString:type encoding:NSUTF8StringEncoding];
        if (![stringType hasPrefix:@"@"]) {
            continue;
        }
        if ((object_getIvar(self, thisIvar) == value)) {
            key = [NSString stringWithUTF8String:ivar_getName(thisIvar)];
            break;
        }
    }
    free(ivars);
    return key;
}
+ (BOOL)propertyIsExist:(NSString *)property {
    u_int count;
    Ivar *list = class_copyIvarList([self class], &count);
    for (int i = 0; i < count; i++) {
        NSString *name = [NSString stringWithUTF8String:ivar_getName(list[i])];
        if ([name isEqualToString:property]) {
            free(list);
            return YES;
        }
    }
    free(list);
    return NO;
}


@end
