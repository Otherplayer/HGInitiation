//
//  HGDownloadItem.h
//  HGInitiation
//
//  Created by __无邪_ on 2018/3/29.
//  Copyright © 2018年 __无邪_. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSUInteger, HGDownloadState) {
    HGDownloadStateNormal,
    HGDownloadStateWaiting,
    HGDownloadStateDownloading,
    HGDownloadStatePaused,
    HGDownloadStateCompleted,
    HGDownloadStateError,
};

@protocol HGDownloadItem<NSObject>

@optional
@property(nonatomic, strong)NSError *error;
@property(nonatomic, strong)NSProgress *progress;
@property(nonatomic) HGDownloadState state;

@required
- (NSURL *)URL;

@end

@interface HGDownloadItem : NSObject<HGDownloadItem>

@end
