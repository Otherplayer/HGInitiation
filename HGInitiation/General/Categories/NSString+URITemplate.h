//
//  NSString+URITemplate.h
//  HGInitiation
//
//  Created by __无邪_ on 2018/4/10.
//  Copyright © 2018年 __无邪_. All rights reserved.
//

// [Guide](https://medialize.github.io/URI.js/uri-template.html)
// [RFC6570](https://tools.ietf.org/html/rfc6570)  level3


#import <Foundation/Foundation.h>

@interface NSString (URITemplate)

- (NSString *)templateExpand:(NSDictionary *)URIVariables;//TODO:未完


@end
