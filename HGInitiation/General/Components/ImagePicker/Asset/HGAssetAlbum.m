//
//  HGAlbum.m
//  HGInitiation
//
//  Created by __无邪_ on 2017/12/27.
//  Copyright © 2017年 __无邪_. All rights reserved.
//

#import "HGAssetAlbum.h"
#import "HGAssetManager.h"

@interface HGAssetAlbum ()
@property(nonatomic, strong, readwrite)PHAssetCollection *phAssetCollection;
@property(nonatomic, strong, readwrite)PHFetchResult *phFetchResult;
@end

@implementation HGAssetAlbum
- (instancetype)initWithPHCollection:(PHAssetCollection *)phAssetCollection fetchAssetsOptions:(PHFetchOptions *)pHFetchOptions{
    self = [super init];
    if (self) {
        PHFetchResult *phFetchResult = [PHAsset fetchAssetsInAssetCollection:phAssetCollection options:pHFetchOptions];
        self.phFetchResult = phFetchResult;
        self.phAssetCollection = phAssetCollection;
    }
    return self;
}

#pragma mark -

- (NSInteger)numberOfAssets {
    return self.phFetchResult.count;
}

- (NSString *)name {
    NSString *resultName = self.phAssetCollection.localizedTitle;
    return NSLocalizedString(resultName, resultName);
}

- (UIImage *)posterImageWithSize:(CGSize)size {
    __block UIImage *resultImage;
    NSInteger count = self.phFetchResult.count;
    if (count > 0) {
        PHAsset *asset = [self.phFetchResult lastObject];
        PHImageRequestOptions *pHImageRequestOptions = [[PHImageRequestOptions alloc] init];
        pHImageRequestOptions.synchronous = YES; // 同步请求
        pHImageRequestOptions.resizeMode = PHImageRequestOptionsResizeModeExact;
        // targetSize 中对传入的 Size 进行处理，宽高各自乘以 ScreenScale，从而得到正确的图片
        CGFloat scale = [[UIScreen mainScreen] scale];
        [[[HGAssetManager sharedManager] phCachingImageManager] requestImageForAsset:asset targetSize:CGSizeMake(size.width * scale, size.height * scale) contentMode:PHImageContentModeAspectFill options:pHImageRequestOptions resultHandler:^(UIImage *result, NSDictionary *info) {
            resultImage = result;
        }];
    }
    return resultImage;
}
- (void)enumerateAssetsWithOptions:(HGAlbumSortType)albumSortType usingBlock:(void (^)(HGAsset *asset))enumerationBlock {
    NSInteger resultCount = self.phFetchResult.count;
    if (albumSortType == HGAlbumSortTypeReverse) {
        for (NSInteger i = resultCount - 1; i >= 0; i--) {
            PHAsset *pHAsset = self.phFetchResult[i];
            HGAsset *hgAsset = [[HGAsset alloc] initWithPHAsset:pHAsset];
            if (enumerationBlock) {
                enumerationBlock(hgAsset);
            }
        }
    } else {
        for (NSInteger i = 0; i < resultCount; i++) {
            PHAsset *pHAsset = self.phFetchResult[i];
            HGAsset *hgAsset = [[HGAsset alloc] initWithPHAsset:pHAsset];
            if (enumerationBlock) {
                enumerationBlock(hgAsset);
            }
        }
    }
    /**
     *  For 循环遍历完毕，这时再调用一次 enumerationBlock，并传递 nil 作为实参，作为枚举资源结束的标记。
     */
    if (enumerationBlock) {
        enumerationBlock(nil);
    }
}

- (NSString *)identifier {
    NSString *identity = [[self name] hgMD5HexLower];
    return identity;
}


@end
