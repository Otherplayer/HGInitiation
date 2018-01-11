//
//  HGWebViewController.h
//  HGInitiation
//
//  Created by __无邪_ on 2018/1/5.
//  Copyright © 2018年 __无邪_. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HGWebViewController : UIViewController
@property (nonatomic, strong) NSString *urlStr;


// js调用及回调方式

//window.webkit.messageHandlers.jsCallback.postMessage({'function': 'hgWebViewOpen','callback':'didOpenSuccess','parameter':{'url':'https://www.baidu.com'}});
//window.webkit.messageHandlers.jsCallback.postMessage({'f': 'hgWebViewOpen','c':'didOpenSuccess','p':{'url':'https://www.baidu.com'}});



@end
