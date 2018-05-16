//
//  NSString+URITemplate.m
//  HGInitiation
//
//  Created by __无邪_ on 2018/4/10.
//  Copyright © 2018年 __无邪_. All rights reserved.
//

#import "NSString+URITemplate.h"

#define PATTERN @"\\{([^\\}]+)\\}" ///(\\{.+?\\})
//#define PATTERN @"((?<=\\{).+?(?=\\}))"
#define kHGOperator @"+#./;?&"

@implementation NSString (URITemplate)

- (NSString *)templateExpand:(NSDictionary *)URIVariables {
    
    NSError *error = NULL;
    NSString *result = self;
    // Match all {...} in the path
    NSRegularExpression *regularExpr = [NSRegularExpression regularExpressionWithPattern:PATTERN
                                                                                 options:NSRegularExpressionCaseInsensitive
                                                                                   error:&error];
    
    if (error) {
        NSLog(@"Regular expression failed with reason:%@", error);
    }
    
    NSArray *matches = [regularExpr matchesInString:self
                                            options:NSMatchingReportProgress
                                              range:NSMakeRange(0, self.length)];
    
    for (NSTextCheckingResult *match in matches) {
        
        NSString *key = [[self substringWithRange:match.range] stringByTrim];
        NSString *operator = [key substringWithRange:[key rangeOfComposedCharacterSequencesForRange:NSMakeRange(1, 1)]];
        
        NSLog(@"%@ %@",key,operator);
        
        if ([kHGOperator containsString:operator]) {

            if ([operator isEqualToString:@"+"]) {
                result = [self operatorReservedCharacter:key URIVariables:URIVariables];
            }else if ([operator isEqualToString:@"#"]) {
                result = [self operatorFragmentIdentifiers:key URIVariables:URIVariables];
            }else if ([operator isEqualToString:@"."]){
                result = [self operatorNameLabels:key URIVariables:URIVariables];
            }else if ([operator isEqualToString:@"/"]) {
                result = [self operatorPathSegments:key URIVariables:URIVariables];
            } else if ([operator isEqualToString:@";"]) {
                result = [self operatorPathParameter:key URIVariables:URIVariables];
            }else if ([operator isEqualToString:@"?"]) {
                result = [self operatorQueryComponent:key URIVariables:URIVariables];
            }else if ([operator isEqualToString:@"&"]) {
                result = [self operatorContinuation:key URIVariables:URIVariables];
            }
            
        }else{
            result = [self operatorNone:key URIVariables:URIVariables];
        }
    }
    
    return result;
}

#pragma mark - operator

// op
// +  | Reserved string expansion
// #  | Fragment expansion, crosshatch-prefixed
- (NSString *)operatorReservedCharacter:(NSString *)key URIVariables:(NSDictionary *)URIVariables{
    // Reserved expansion
    NSString *result = nil;
    NSString *realKey = [key substringWithRange:NSMakeRange(2, key.length - 3)];
    NSArray *subKeys = [realKey componentsSeparatedByString:@","];
    
    if (subKeys && subKeys.count > 1) {
        
        // String expansion with multiple variables
        NSString *var = realKey;
        for (NSString *sKey in subKeys) {
            NSString *sVar = URIVariables[sKey];
            if (sVar == nil) {
                NSLog(@"Error: %@ is nil",sKey);
            }else {
                var = [var stringByReplacingOccurrencesOfString:sKey withString:sVar];
            }
        }
        result = [result stringByReplacingOccurrencesOfString:key withString:var];
        
    }else{
        NSString *var = URIVariables[realKey];
        if (var.length == 0) {
            var = @"";
            if ([result containsString:[key stringByAppendingString:@"/"]]) {
                key = [key stringByAppendingString:@"/"];
            }
        }
        result = [result stringByReplacingOccurrencesOfString:key withString:var];
    }
    return result;
}
// #
- (NSString *)operatorFragmentIdentifiers:(NSString *)key URIVariables:(NSDictionary *)URIVariables {
    NSString *result = nil;
    NSString *realKey = [key substringWithRange:NSMakeRange(2, key.length - 3)];
    NSArray *subKeys = [realKey componentsSeparatedByString:@","];
    if (subKeys && subKeys.count > 1) {
        
        // String expansion with multiple variables
        NSString *var = realKey;
        for (NSString *sKey in subKeys) {
            NSString *sVar = URIVariables[sKey];
            if (sVar == nil) {
                NSLog(@"Error: %@ is nil",sKey);
            }else {
                var = [var stringByReplacingOccurrencesOfString:sKey withString:sVar];
            }
        }
        var = [@"#" stringByAppendingString:var];
        result = [result stringByReplacingOccurrencesOfString:key withString:var];
        
    }else{
        NSString *var = URIVariables[realKey];
        if (var.length == 0) {
            var = @"";
            if ([result containsString:[key stringByAppendingString:@"/"]]) {
                key = [key stringByAppendingString:@"/"];
            }
        }else{
            var = [@"#" stringByAppendingString:var];
        }
        
        result = [result stringByReplacingOccurrencesOfString:key withString:var];
    }
    return result;
}
// .
- (NSString *)operatorNameLabels:(NSString *)key URIVariables:(NSDictionary *)URIVariables {
    NSString *result = nil;
    NSString *realKey = [key substringWithRange:NSMakeRange(2, key.length - 3)];
    NSArray *subKeys = [realKey componentsSeparatedByString:@","];
    if (subKeys && subKeys.count > 1) {
        
        // String expansion with multiple variables
        __block NSString *var = realKey;
        [subKeys enumerateObjectsUsingBlock:^(NSString *sKey, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString *sVar = URIVariables[sKey];
            if (sVar == nil) {
                NSLog(@"Error: %@ is nil",sKey);
            }else {
                sVar = [@"." stringByAppendingString:sVar];
                if (idx == subKeys.count - 1) {
                    var = [var stringByReplacingOccurrencesOfString:sKey withString:sVar];
                }else{
                    var = [var stringByReplacingOccurrencesOfString:[sKey stringByAppendingString:@","] withString:sVar];
                }
            }
        }];
        result = [result stringByReplacingOccurrencesOfString:key withString:var];
        
    }else{
        NSString *var = URIVariables[realKey];
        if (var.length == 0) {
            var = @"";
            if ([result containsString:[key stringByAppendingString:@"/"]]) {
                key = [key stringByAppendingString:@"/"];
            }
        }else{
            var = [@"." stringByAppendingString:var];
        }
        
        result = [result stringByReplacingOccurrencesOfString:key withString:var];
    }
    return result;
}
// /
- (NSString *)operatorPathSegments:(NSString *)key URIVariables:(NSDictionary *)URIVariables {
    NSString *result = nil;
    NSString *realKey = [key substringWithRange:NSMakeRange(2, key.length - 3)];
    NSArray *subKeys = [realKey componentsSeparatedByString:@","];
    // Path segments, slash-prefixed
    
    
    if (subKeys && subKeys.count > 1) {
        
        // String expansion with multiple variables
        __block NSString *var = realKey;
        [subKeys enumerateObjectsUsingBlock:^(NSString *sKey, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString *sVar = URIVariables[sKey];
            if (sVar == nil) {
                NSLog(@"Error: %@ is nil",sKey);
            }else {
                sVar = [@"/" stringByAppendingString:sVar];
                if (idx == subKeys.count -1) {
                    var = [var stringByReplacingOccurrencesOfString:sKey withString:sVar];
                }else{
                    var = [var stringByReplacingOccurrencesOfString:[sKey stringByAppendingString:@","] withString:sVar];
                }
            }
        }];
        
        result = [result stringByReplacingOccurrencesOfString:key withString:var];
        
    }else{
        NSString *var = URIVariables[realKey];
        if (var.length == 0) {
            var = @"";
            if ([result containsString:[key stringByAppendingString:@"/"]]) {
                key = [key stringByAppendingString:@"/"];
            }
        }else{
            var = [@"/" stringByAppendingString:var];
        }
        
        result = [result stringByReplacingOccurrencesOfString:key withString:var];
    }
    
    return result;
}
// ;
- (NSString *)operatorPathParameter:(NSString *)key URIVariables:(NSDictionary *)URIVariables {
    NSString *result = nil;
    NSString *realKey = [key substringWithRange:NSMakeRange(2, key.length - 3)];
    NSArray *subKeys = [realKey componentsSeparatedByString:@","];
    // Path-style parameters, semicolon-prefixed
    
    // String expansion with multiple variables
    __block NSString *var = realKey;
    [subKeys enumerateObjectsUsingBlock:^(NSString *sKey, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *sVar = URIVariables[sKey];
        if (sVar.length == 0) {
            sVar = [@";" stringByAppendingString:sKey];
        }else{
            sVar = [[[@";" stringByAppendingString:sKey] stringByAppendingString:@"="] stringByAppendingString:sVar];
        }
        
        if (idx == subKeys.count -1) {
            var = [var stringByReplacingOccurrencesOfString:sKey withString:sVar];
        }else{
            var = [var stringByReplacingOccurrencesOfString:[sKey stringByAppendingString:@","] withString:sVar];
        }
    }];
    
    result = [result stringByReplacingOccurrencesOfString:key withString:var];
    return result;
}
// ?
- (NSString *)operatorQueryComponent:(NSString *)key URIVariables:(NSDictionary *)URIVariables {
    NSString *result = nil;
    NSString *realKey = [key substringWithRange:NSMakeRange(2, key.length - 3)];
    NSArray *subKeys = [realKey componentsSeparatedByString:@","];
    // Form-style query, ampersand-separated
    
    // String expansion with multiple variables
    __block NSString *var = realKey;
    [subKeys enumerateObjectsUsingBlock:^(NSString *sKey, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *sVar = URIVariables[sKey];
        
        if (idx == 0) {
            sVar = [[[@"?" stringByAppendingString:sKey] stringByAppendingString:@"="] stringByAppendingString:sVar];
        }else{
            sVar = [[[@"&" stringByAppendingString:sKey] stringByAppendingString:@"="] stringByAppendingString:sVar];
        }
        
        if (idx == subKeys.count -1) {
            var = [var stringByReplacingOccurrencesOfString:sKey withString:sVar];
        }else{
            var = [var stringByReplacingOccurrencesOfString:[sKey stringByAppendingString:@","] withString:sVar];
        }
        
    }];
    
    result = [result stringByReplacingOccurrencesOfString:key withString:var];
    return result;
}
// &
- (NSString *)operatorContinuation:(NSString *)key URIVariables:(NSDictionary *)URIVariables {
    NSString *result = nil;
    NSString *realKey = [key substringWithRange:NSMakeRange(2, key.length - 3)];
    NSArray *subKeys = [realKey componentsSeparatedByString:@","];
    // Form-style query continuation
    
    // String expansion with multiple variables
    __block NSString *var = realKey;
    [subKeys enumerateObjectsUsingBlock:^(NSString *sKey, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *sVar = URIVariables[sKey];
        
        sVar = [[[@"&" stringByAppendingString:sKey] stringByAppendingString:@"="] stringByAppendingString:sVar];
        
        if (idx == subKeys.count -1) {
            var = [var stringByReplacingOccurrencesOfString:sKey withString:sVar];
        }else{
            var = [var stringByReplacingOccurrencesOfString:[sKey stringByAppendingString:@","] withString:sVar];
        }
        
    }];
    
    result = [result stringByReplacingOccurrencesOfString:key withString:var];
    return result;
}
// None
- (NSString *)operatorNone:(NSString *)key URIVariables:(NSDictionary *)URIVariables {
    NSString *result = nil;
    NSString *realKey = [key substringWithRange:NSMakeRange(1, key.length - 2)];
    NSArray *subKeys = [realKey componentsSeparatedByString:@","];
    
    if (subKeys && subKeys.count > 1) {
        // String expansion with multiple variables
        NSString *var = realKey;
        for (NSString *sKey in subKeys) {
            NSString *sVar = URIVariables[sKey];
            if (sVar == nil) {
                NSLog(@"Error: %@ is nil",sKey);
            }else{
                var = [var stringByReplacingOccurrencesOfString:sKey withString:sVar];
            }
        }
        result = [result stringByReplacingOccurrencesOfString:key withString:var];
        
    }else{
        NSString *var = URIVariables[realKey];
        if (var.length == 0) {
            var = @"";
            if ([result containsString:[key stringByAppendingString:@"/"]]) {
                key = [key stringByAppendingString:@"/"];
            }
        }
        result = [result stringByReplacingOccurrencesOfString:key withString:var];
    }
    return result;
}


@end
