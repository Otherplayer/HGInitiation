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
            
            // op
            // +  | Reserved string expansion
            // #  | Fragment expansion, crosshatch-prefixed
            if ([operator isEqualToString:@"+"]) {
                
                // Reserved expansion
                
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
                
            }else if ([operator isEqualToString:@"#"]) {
                
                // Fragment expansion
                
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
                
            }else if ([operator isEqualToString:@"."]){
                // Label expansion, dot-prefixed
                
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
            }else if ([operator isEqualToString:@"/"]) {
                
                // Path segments, slash-prefixed
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
                
            } else if ([operator isEqualToString:@";"]) {
                
                // Path-style parameters, semicolon-prefixed
                NSString *realKey = [key substringWithRange:NSMakeRange(2, key.length - 3)];
                NSArray *subKeys = [realKey componentsSeparatedByString:@","];
                
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
                
            }else if ([operator isEqualToString:@"?"]) {
                
                // Form-style query, ampersand-separated
                NSString *realKey = [key substringWithRange:NSMakeRange(2, key.length - 3)];
                NSArray *subKeys = [realKey componentsSeparatedByString:@","];
                
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
                
            }else if ([operator isEqualToString:@"&"]) {
                
                // Form-style query continuation
                
                NSString *realKey = [key substringWithRange:NSMakeRange(2, key.length - 3)];
                NSArray *subKeys = [realKey componentsSeparatedByString:@","];
                
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
            }
            
        }else{
            
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
            
        }
    }
    
    return result;
}

@end
