//
//  HGPhotoModel.h
//  HGInitiation
//
//  Created by __无邪_ on 2017/12/27.
//  Copyright © 2017年 __无邪_. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HGAsset.h"


typedef NS_ENUM(NSUInteger, HGPhotoModelType) {
    HGPhotoModelTypeAsset,
    HGPhotoModelTypeUrl,
    HGPhotoModelTypePath,
};

@interface HGPhotoModel : NSObject

@property(nonatomic) HGPhotoModelType type;
@property(nonatomic, strong) UIImage *placeholderImage;
- (instancetype)initWithUrlString:(NSString *)urlString;
- (instancetype)initWithPath:(NSString *)path;


/// 相册model
@property(nonatomic) BOOL isSelected;
@property(nonatomic, strong) HGAsset *asset;
@property(nonatomic, strong) NSString *albumIdentifier;
- (NSString *)identifier;

/// 网络图片
@property(nonatomic, copy) NSString *urlStr;
/// 本地图片
@property(nonatomic, copy) NSString *pathStr;


- (void)requestImageWithCompletion:(void (^)(UIImage *result))completion
               withProgressHandler:(SDWebImageDownloaderProgressBlock)progressHandler;

@end
