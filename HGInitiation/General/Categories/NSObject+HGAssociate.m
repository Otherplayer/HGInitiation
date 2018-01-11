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

- (void)setAssociatedObject:(id)object forKey:(NSString*)key {
    NSMutableDictionary *dict = objc_getAssociatedObject(self, &HGAssociatedObjectsKey);
    if (!dict) {
        dict = [[NSMutableDictionary alloc] init];
        objc_setAssociatedObject(self, &HGAssociatedObjectsKey, dict, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    [dict setObject:object forKey:key];
}

- (NSArray *)getAllProperties{
    u_int count;
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    NSMutableArray *propertiesArray = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i<count; i++)
    {
        const char* propertyName =property_getName(properties[i]);
        [propertiesArray addObject: [NSString stringWithUTF8String: propertyName]];
    }
    free(properties);
    return propertiesArray;
}

- (NSString *)propertyNameByValue:(id)value{
    unsigned int numIvars = 0;
    NSString *key=nil;
    Ivar * ivars = class_copyIvarList([self class], &numIvars);
    for(int i = 0; i < numIvars; i++) {
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

@end
