//
//  HGAlbum.h
//  HGInitiation
//
//  Created by __无邪_ on 2017/12/27.
//  Copyright © 2017年 __无邪_. All rights reserved.
//

#import "HGAsset.h"

/// 相册展示内容按日期排序的方式
typedef NS_ENUM(NSUInteger, HGAlbumSortType) {
    HGAlbumSortTypePositive,  // 日期最新的内容排在后面
    HGAlbumSortTypeReverse  // 日期最新的内容排在前面
};

@interface HGAssetAlbum : NSObject

@property(nonatomic) NSInteger selectedCount; //选中资源的数量
@property(nonatomic, strong, readonly)PHAssetCollection *phAssetCollection;
@property(nonatomic, strong, readonly)PHFetchResult *phFetchResult;

- (instancetype)initWithPHCollection:(PHAssetCollection *)phAssetCollection fetchAssetsOptions:(PHFetchOptions *)pHFetchOptions;


/// 相册的名称
- (NSString *)name;
- (NSString *)identifier;

/// 相册内的资源数量，包括视频、图片、音频（如果支持）这些类型的所有资源
- (NSInteger)numberOfAssets;

/// 缩略图
- (UIImage *)posterImageWithSize:(CGSize)size;

/// 枚举相册内所有的资源
- (void)enumerateAssetsWithOptions:(HGAlbumSortType)albumSortType
                        usingBlock:(void (^)(HGAsset *asset))enumerationBlock;

@end
