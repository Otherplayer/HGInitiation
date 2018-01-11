//
//  HGImagesManager.h
//  HGInitiation
//
//  Created by __无邪_ on 2017/12/26.
//  Copyright © 2017年 __无邪_. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HGAssetAlbum.h"
#import "HGPhotoModel.h"

typedef NS_ENUM(NSUInteger, HGAssetPickerType) {
    HGAssetPickerTypeImage,
    HGAssetPickerTypeVideo,
    HGAssetPickerTypeAudio,
    HGAssetPickerTypeAll,
};

@interface HGAssetManager : NSObject

@property(nonatomic, strong) NSMutableDictionary *selectedPhotosInfo;
@property(nonatomic, strong) NSMutableArray *selectedPhotos;
- (void)addObject2SelectedPhotos:(HGPhotoModel *)photo;
- (BOOL)selectedPhotosContainObject:(HGPhotoModel *)photo;
- (void)removeObjectFromSelectedPhotos:(HGPhotoModel *)photo;
- (void)removeAllSelectedPhotos;
- (NSInteger)selectedCount:(NSString *)albumIdentifier;


+ (instancetype)sharedManager;

- (PHAuthorizationStatus)authorizationStatus;
- (void)requestAuthorization:(void (^)(PHAuthorizationStatus status))handler;


- (void)enumerateAlbumsWithType:(HGAssetPickerType)pickerType
                      showEmpty:(BOOL)showEmpty
                     usingBlock:(void (^)(HGAssetAlbum *model))enumerationBlock;



/// 获取一个 PHCachingImageManager 的实例
- (PHCachingImageManager *)phCachingImageManager;

@end
