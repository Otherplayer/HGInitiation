//
//  HGAsset.m
//  HGInitiation
//
//  Created by __无邪_ on 2017/12/27.
//  Copyright © 2017年 __无邪_. All rights reserved.
//

#import "HGAsset.h"
#import <MobileCoreServices/UTCoreTypes.h>
#import "HGAssetManager.h"

static NSString * const kAssetInfoImageData = @"imageData";
static NSString * const kAssetInfoOriginInfo = @"originInfo";
static NSString * const kAssetInfoDataUTI = @"dataUTI";
static NSString * const kAssetInfoOrientation = @"orientation";
static NSString * const kAssetInfoSize = @"size";

@interface HGAsset ()
@property(nonatomic, strong, readwrite)PHAsset *asset;
@end


@implementation HGAsset


- (instancetype)initWithPHAsset:(PHAsset *)phAsset {
    if (self = [super init]) {
        self.asset = phAsset;
        
        switch (phAsset.mediaType) {
            case PHAssetMediaTypeImage:{
                self.type = HGAssetTypePhoto;
                if ([[self.asset valueForKey:@"uniformTypeIdentifier"] isEqualToString:(__bridge NSString *)kUTTypeGIF]) {
                    self.subType = HGAssetSubTypeGIF;
                } else if (@available(iOS 9.1, *)) {
                    if (self.asset.mediaSubtypes & PHAssetMediaSubtypePhotoLive) {
                        self.subType = HGAssetSubTypeLivePhoto;
                    } else {
                        self.subType = HGAssetSubTypeImage;
                    }
                } else {
                    self.subType = HGAssetSubTypeImage;
                }
            }
                break;
            case PHAssetMediaTypeVideo:
                self.type = HGAssetTypeVideo;
                break;
            case PHAssetMediaTypeAudio:
                self.type = HGAssetTypeAudio;
                break;
            default:
                self.type = HGAssetTypeUnknown;
                break;
        }
    }
    return self;
}

- (UIImage *)originImage {
    __block UIImage *resultImage = nil;
    PHImageRequestOptions *phImageRequestOptions = [[PHImageRequestOptions alloc] init];
    phImageRequestOptions.synchronous = YES;
    [[[HGAssetManager sharedManager] phCachingImageManager] requestImageForAsset:self.asset
                                                                          targetSize:PHImageManagerMaximumSize
                                                                         contentMode:PHImageContentModeDefault
                                                                             options:phImageRequestOptions
                                                                       resultHandler:^(UIImage *result, NSDictionary *info) {
                                                                           resultImage = result;
                                                                       }];
    return resultImage;
}

- (UIImage *)thumbnailWithSize:(CGSize)size {
    __block UIImage *resultImage;
    PHImageRequestOptions *phImageRequestOptions = [[PHImageRequestOptions alloc] init];
    phImageRequestOptions.resizeMode = PHImageRequestOptionsResizeModeExact;
    [[[HGAssetManager sharedManager] phCachingImageManager] requestImageForAsset:self.asset
                                                                          targetSize:CGSizeMake(size.width * [UIScreen mainScreen].scale, size.height * [UIScreen mainScreen].scale)
                                                                         contentMode:PHImageContentModeAspectFill options:phImageRequestOptions
                                                                       resultHandler:^(UIImage *result, NSDictionary *info) {
                                                                           resultImage = result;
                                                                       }];
    
    return resultImage;
}

- (UIImage *)previewImage {
    __block UIImage *resultImage = nil;
    PHImageRequestOptions *imageRequestOptions = [[PHImageRequestOptions alloc] init];
    imageRequestOptions.synchronous = YES;
    [[[HGAssetManager sharedManager] phCachingImageManager] requestImageForAsset:self.asset
                                                                          targetSize:CGSizeMake(([[UIScreen mainScreen] bounds].size.width), ([[UIScreen mainScreen] bounds].size.height))
                                                                         contentMode:PHImageContentModeAspectFill
                                                                             options:imageRequestOptions
                                                                       resultHandler:^(UIImage *result, NSDictionary *info) {
                                                                           resultImage = result;
                                                                       }];
    return resultImage;
}


- (NSInteger)requestOriginImageWithCompletion:(void (^)(UIImage *result, NSDictionary<NSString *, id> *info))completion withProgressHandler:(PHAssetImageProgressHandler)phProgressHandler {
    PHImageRequestOptions *imageRequestOptions = [[PHImageRequestOptions alloc] init];
    imageRequestOptions.networkAccessAllowed = YES; // 允许访问网络
    imageRequestOptions.progressHandler = phProgressHandler;
    return [[[HGAssetManager sharedManager] phCachingImageManager] requestImageForAsset:self.asset targetSize:PHImageManagerMaximumSize contentMode:PHImageContentModeDefault options:imageRequestOptions resultHandler:^(UIImage *result, NSDictionary *info) {
        if (completion) {
            completion(result, info);
        }
    }];
}
- (NSInteger)requestThumbnailImageWithSize:(CGSize)size completion:(void (^)(UIImage *result, NSDictionary<NSString *, id> *info))completion {
    PHImageRequestOptions *imageRequestOptions = [[PHImageRequestOptions alloc] init];
    imageRequestOptions.resizeMode = PHImageRequestOptionsResizeModeFast;
    return [[[HGAssetManager sharedManager] phCachingImageManager] requestImageForAsset:self.asset targetSize:CGSizeMake(size.width * [UIScreen mainScreen].scale, size.height * [UIScreen mainScreen].scale) contentMode:PHImageContentModeAspectFill options:imageRequestOptions resultHandler:^(UIImage *result, NSDictionary *info) {
        if (completion) {
            completion(result, info);
        }
    }];
}
- (NSInteger)requestPreviewImageWithCompletion:(void (^)(UIImage *result, NSDictionary<NSString *, id> *info))completion withProgressHandler:(PHAssetImageProgressHandler)phProgressHandler {
    PHImageRequestOptions *imageRequestOptions = [[PHImageRequestOptions alloc] init];
    imageRequestOptions.networkAccessAllowed = YES; // 允许访问网络
    imageRequestOptions.progressHandler = phProgressHandler;
    return [[[HGAssetManager sharedManager] phCachingImageManager] requestImageForAsset:self.asset targetSize:CGSizeMake([[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height) contentMode:PHImageContentModeAspectFill options:imageRequestOptions resultHandler:^(UIImage *result, NSDictionary *info) {
        if (completion) {
            completion(result, info);
        }
    }];
}
- (NSInteger)requestLivePhotoWithCompletion:(void (^)(PHLivePhoto *livePhoto, NSDictionary<NSString *, id> *info))completion withProgressHandler:(PHAssetImageProgressHandler)phProgressHandler {
    if ([[PHCachingImageManager class] instancesRespondToSelector:@selector(requestLivePhotoForAsset:targetSize:contentMode:options:resultHandler:)]) {
        PHLivePhotoRequestOptions *livePhotoRequestOptions = [[PHLivePhotoRequestOptions alloc] init];
        livePhotoRequestOptions.networkAccessAllowed = YES; // 允许访问网络
        livePhotoRequestOptions.progressHandler = phProgressHandler;
        return [[[HGAssetManager sharedManager] phCachingImageManager] requestLivePhotoForAsset:self.asset targetSize:CGSizeMake([[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height) contentMode:PHImageContentModeDefault options:livePhotoRequestOptions resultHandler:^(PHLivePhoto * _Nullable livePhoto, NSDictionary * _Nullable info) {
            if (completion) {
                completion(livePhoto, info);
            }
        }];
    } else {
        if (completion) {
            completion(nil, nil);
        }
        return 0;
    }
}

- (NSInteger)requestPlayerItemWithCompletion:(void (^)(AVPlayerItem *playerItem, NSDictionary<NSString *, id> *info))completion withProgressHandler:(PHAssetVideoProgressHandler)phProgressHandler {
    if ([[PHCachingImageManager class] instancesRespondToSelector:@selector(requestPlayerItemForVideo:options:resultHandler:)]) {
        PHVideoRequestOptions *videoRequestOptions = [[PHVideoRequestOptions alloc] init];
        videoRequestOptions.networkAccessAllowed = YES; // 允许访问网络
        videoRequestOptions.progressHandler = phProgressHandler;
        return [[[HGAssetManager sharedManager] phCachingImageManager] requestPlayerItemForVideo:self.asset options:videoRequestOptions resultHandler:^(AVPlayerItem * _Nullable playerItem, NSDictionary * _Nullable info) {
            if (completion) {
                completion(playerItem, info);
            }
        }];
    } else {
        if (completion) {
            completion(nil, nil);
        }
        return 0;
    }
}

- (void)requestPhAssetInfo:(void (^)(NSDictionary *))completion {
    if (!self.asset) {
        if (completion) {
            completion(nil);
        }
        return;
    }
    if (self.type == HGAssetTypeVideo) {
        [[[HGAssetManager sharedManager] phCachingImageManager] requestAVAssetForVideo:self.asset options:NULL resultHandler:^(AVAsset * _Nullable asset, AVAudioMix * _Nullable audioMix, NSDictionary * _Nullable info) {
            if ([asset isKindOfClass:[AVURLAsset class]]) {
                NSMutableDictionary *tempInfo = [[NSMutableDictionary alloc] init];
                if (info) {
                    [tempInfo setObject:info forKey:kAssetInfoOriginInfo];
                }
                AVURLAsset *urlAsset = (AVURLAsset*)asset;
                NSNumber *size;
                [urlAsset.URL getResourceValue:&size forKey:NSURLFileSizeKey error:nil];
                [tempInfo setObject:size forKey:kAssetInfoSize];
                if (completion) {
                    completion(tempInfo);
                }
            }
        }];
    } else {
        [self requestImagePhAssetInfo:^(NSDictionary *phAssetInfo) {
            if (completion) {
                completion(phAssetInfo);
            }
        } synchronous:NO];
    }
}

- (void)requestImagePhAssetInfo:(void (^)(NSDictionary *))completion synchronous:(BOOL)synchronous {
    PHImageRequestOptions *imageRequestOptions = [[PHImageRequestOptions alloc] init];
    imageRequestOptions.synchronous = synchronous;
    imageRequestOptions.networkAccessAllowed = YES;
    [[[HGAssetManager sharedManager] phCachingImageManager] requestImageDataForAsset:self.asset options:imageRequestOptions resultHandler:^(NSData *imageData, NSString *dataUTI, UIImageOrientation orientation, NSDictionary *info) {
        if (info) {
            NSMutableDictionary *tempInfo = [[NSMutableDictionary alloc] init];
            if (imageData) {
                [tempInfo setObject:imageData forKey:kAssetInfoImageData];
                [tempInfo setObject:@(imageData.length) forKey:kAssetInfoSize];
            }
            [tempInfo setObject:info forKey:kAssetInfoOriginInfo];
            if (dataUTI) {
                [tempInfo setObject:dataUTI forKey:kAssetInfoDataUTI];
            }
            [tempInfo setObject:@(orientation) forKey:kAssetInfoOrientation];
            if (completion) {
                completion(tempInfo);
            }
        }
    }];
}

- (void)assetSize:(void (^)(long long size))completion {
    [self requestPhAssetInfo:^(NSDictionary *phAssetInfo) {
        if (completion) {
            /**
             *  这里不在主线程执行，若用户在该 block 中操作 UI 时会产生一些问题，
             *  为了避免这种情况，这里该 block 主动放到主线程执行。
             */
            dispatch_async(dispatch_get_main_queue(), ^{
                completion([phAssetInfo[kAssetInfoSize] longLongValue]);
            });
        }
    }];
}

- (NSString *)identifier {
    NSString *identity = [self.asset.localIdentifier hgMD5HexLower];
    return identity;
}

+ (NSDictionary *)abcd {
    return nil;
}

@end
