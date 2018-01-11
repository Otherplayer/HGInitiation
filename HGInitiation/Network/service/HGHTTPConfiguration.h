//
//  HGHTTPConfiguration.h
//  HGInitiation
//
//  Created by __无邪_ on 2017/12/25.
//  Copyright © 2017年 __无邪_. All rights reserved.
//

#ifndef HGHTTPConfiguration_h
#define HGHTTPConfiguration_h

#define kHTTPEnvironmentISTest 1    //0:正式服务器，1:测试服务器

/********************下面是服务器接口地址********************/

#if (0 == kHTTPEnvironmentISTest)
#define BASE_API_URL @"https://api.hitbtc.com/api/2/"
#define BASE_GITHUB_URL @"https://api.github.com/"
#else
#define BASE_API_URL @"https://api.hitbtc.com/api/2/"
#define BASE_GITHUB_URL @"https://api.github.com/"
#endif


#define kHTTPTimeoutIntervalForRequest 20

#endif /* HGHTTPConfiguration_h */
