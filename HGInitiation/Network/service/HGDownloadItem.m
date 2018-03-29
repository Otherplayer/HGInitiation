//
//  HGDownloadItem.m
//  HGInitiation
//
//  Created by __无邪_ on 2018/3/29.
//  Copyright © 2018年 __无邪_. All rights reserved.
//

#import "HGDownloadItem.h"

@implementation HGDownloadItem
@synthesize progress = _progress, state, error = _error;
- (NSURL *)URL {
    NSLog(@"【You should override and implementation this function】");
    return nil;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@",@(self.progress.fractionCompleted)];
}

@end
