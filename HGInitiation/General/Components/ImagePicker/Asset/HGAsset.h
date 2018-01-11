//
//  HGAsset.h
//  HGInitiation
//
//  Created by __无邪_ on 2017/12/27.
//  Copyright © 2017年 __无邪_. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>


typedef NS_ENUM(NSUInteger, HGAssetType) {
    HGAssetTypeUnknown = 0,
    HGAssetTypePhoto   = 1,
    HGAssetTypeVideo   = 2,
    HGAssetTypeAudio   = 3,
};

typedef NS_ENUM(NSUInteger, HGAssetSubType) {
    HGAssetSubTypeUnknow,                                 // 未知类型
    HGAssetSubTypeImage,                                  // 静态图片类型
    HGAssetSubTypeLivePhoto NS_ENUM_AVAILABLE_IOS(9_1),   // Live Photo 类型
    HGAssetSubTypeGIF                                     // GIF类型
};

@interface HGAsset : NSObject

@property(nonatomic) HGAssetType type;
@property(nonatomic) HGAssetSubType subType;
@property(nonatomic, strong, readonly)PHAsset *asset;

- (instancetype)initWithPHAsset:(PHAsset *)phAsset;

- (UIImage *)originImage;
- (NSInteger)requestOriginImageWithCompletion:(void (^)(UIImage *result, NSDictionary<NSString *, id> *info))completion
                          withProgressHandler:(PHAssetImageProgressHandler)phProgressHandler;
- (UIImage *)thumbnailWithSize:(CGSize)size;
- (NSInteger)requestThumbnailImageWithSize:(CGSize)size
                                completion:(void (^)(UIImage *result, NSDictionary<NSString *, id> *info))completion;
- (UIImage *)previewImage;
- (NSInteger)requestPreviewImageWithCompletion:(void (^)(UIImage *result, NSDictionary<NSString *, id> *info))completion
                           withProgressHandler:(PHAssetImageProgressHandler)phProgressHandler;

/**
 *  异步请求 Live Photo，可能会有网络请求
 *
 *  @param completion        完成请求后调用的 block，参数中包含了请求的 Live Photo 以及相关信息，若 assetType 不是 QMUIAssetTypeLivePhoto 则为 nil
 *  @param phProgressHandler 处理请求进度的 handler，不在主线程上执行，在 block 中修改 UI 时注意需要手工放到主线程处理。
 *
 *  @wraning iOS 9.1 以下中并没有 Live Photo，因此无法获取有效结果。
 *
 *  @return 返回请求图片的请求 id
 */
- (NSInteger)requestLivePhotoWithCompletion:(void (^)(PHLivePhoto *livePhoto, NSDictionary<NSString *, id> *info))completion withProgressHandler:(PHAssetImageProgressHandler)phProgressHandler NS_AVAILABLE_IOS(9_1);

/**
 *  异步请求 AVPlayerItem，可能会有网络请求
 *
 *  @param completion        完成请求后调用的 block，参数中包含了请求的 AVPlayerItem 以及相关信息，若 assetType 不是 Video 则为 nil
 *  @param phProgressHandler 处理请求进度的 handler，不在主线程上执行，在 block 中修改 UI 时注意需要手工放到主线程处理。
 *
 *  @return 返回请求 AVPlayerItem 的请求 id
 */
- (NSInteger)requestPlayerItemWithCompletion:(void (^)(AVPlayerItem *playerItem, NSDictionary<NSString *, id> *info))completion withProgressHandler:(PHAssetVideoProgressHandler)phProgressHandler;

- (void)assetSize:(void (^)(long long size))completion;

- (NSString *)identifier;

@end
