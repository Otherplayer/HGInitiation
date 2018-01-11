//
//  HGImagesManager.m
//  HGInitiation
//
//  Created by __无邪_ on 2017/12/26.
//  Copyright © 2017年 __无邪_. All rights reserved.
//

#import "HGAssetManager.h"

@implementation HGAssetManager{
    PHCachingImageManager *_phCachingImageManager;
}


#pragma mark - fetch albums

- (PHFetchOptions *)createFetchOptions:(HGAssetPickerType)pickerType {
    PHFetchOptions *fetchOptions = [[PHFetchOptions alloc] init];
    if (pickerType == HGAssetPickerTypeImage) fetchOptions.predicate = [NSPredicate predicateWithFormat:@"mediaType == %ld",PHAssetMediaTypeImage];
    if (pickerType == HGAssetPickerTypeVideo) fetchOptions.predicate = [NSPredicate predicateWithFormat:@"mediaType == %ld",PHAssetMediaTypeVideo];
    if (pickerType == HGAssetPickerTypeAudio) fetchOptions.predicate = [NSPredicate predicateWithFormat:@"mediaType == %ld",PHAssetMediaTypeAudio];
    return fetchOptions;
}
- (NSArray *)fetchAlbumsWithType:(HGAssetPickerType)pickerType showEmpty:(BOOL)showEmpty{
    NSMutableArray *albumArr = [NSMutableArray array];
    PHFetchOptions *fetchOptions = [self createFetchOptions:pickerType];
    
    PHFetchResult *myPhotoStreamAlbum = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumMyPhotoStream options:nil];
    // 系统的智能相册
    PHFetchResult *smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary options:nil];//???PHAssetCollectionSubtypeAny
    // 获取所有用户自己建立的相册
    PHFetchResult *topLevelUserCollections = [PHCollectionList fetchTopLevelUserCollectionsWithOptions:nil];
    // 获取从 macOS 设备同步过来的相册，同步过来的相册不允许删除照片，因此不会为空
    PHFetchResult *syncedAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumSyncedAlbum options:nil];
    NSArray *allAlbums = @[myPhotoStreamAlbum,smartAlbums,topLevelUserCollections,syncedAlbums];
    
    for (PHFetchResult *fetchResult in allAlbums) {
        for (PHCollection *cllctn in fetchResult) {
            if ([cllctn isKindOfClass:[PHAssetCollection class]]) {
                PHAssetCollection *collection = (PHAssetCollection *)cllctn;
                PHFetchResult *fetchResult = [PHAsset fetchAssetsInAssetCollection:collection options:fetchOptions];
                if (fetchResult.count > 0 || showEmpty) {
                    // 判断如果是“相机胶卷”，则放到结果列表的第一位
                    if (collection.assetCollectionSubtype == PHAssetCollectionSubtypeSmartAlbumUserLibrary) {
                        [albumArr insertObject:collection atIndex:0];
                    } else {
                        [albumArr addObject:collection];
                    }
                };
            }else{
                NSLog(@"-------Not PHAssetCollection");
            }
        }
    }
    return [albumArr copy];
}
- (void)enumerateAlbumsWithType:(HGAssetPickerType)pickerType showEmpty:(BOOL)showEmpty usingBlock:(void (^)(HGAssetAlbum *model))enumerationBlock{
    
    NSArray *tmpAlbums = [self fetchAlbumsWithType:pickerType showEmpty:showEmpty];
    PHFetchOptions *fetchOptions = [self createFetchOptions:pickerType];
    for (PHAssetCollection *cllctn in tmpAlbums) {
        HGAssetAlbum *model = [HGAssetAlbum.alloc initWithPHCollection:cllctn fetchAssetsOptions:fetchOptions];
        if (enumerationBlock) {
            enumerationBlock(model);
        }
    }
    /**
     *  所有结果遍历完毕，这时再调用一次 enumerationBlock，并传递 nil 作为实参，作为枚举相册结束的标记。
     */
    if (enumerationBlock) {
        enumerationBlock(nil);
    }
    
}

- (PHCachingImageManager *)phCachingImageManager {
    if (!_phCachingImageManager) {
        _phCachingImageManager = [[PHCachingImageManager alloc] init];
    }
    return _phCachingImageManager;
}

#pragma mark - authorization

- (void)requestAuthorization:(void (^)(PHAuthorizationStatus status))handler {
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        handler(status);
    }];
}
- (PHAuthorizationStatus)authorizationStatus {
    return [PHPhotoLibrary authorizationStatus];
}

#pragma mark -

- (void)addObject2SelectedPhotos:(HGPhotoModel *)photo {
    [self.selectedPhotos addObject:photo];
    @autoreleasepool {
        NSString *albumIdentifier = photo.albumIdentifier;
        NSArray *photos = [self.selectedPhotosInfo objectForKey:albumIdentifier];
        NSMutableArray *sPhotos = [NSMutableArray.alloc initWithArray:photos];
        [sPhotos addObject:photo];
        [self.selectedPhotosInfo setObject:sPhotos forKey:albumIdentifier];
    }
}
- (void)removeObjectFromSelectedPhotos:(HGPhotoModel *)photo {
    for (int i = 0; i < self.selectedPhotos.count; i++) {
        HGPhotoModel *m = self.selectedPhotos[i];
        if ([m.identifier isEqualToString:photo.identifier]) {
            [self.selectedPhotos removeObjectAtIndex:i];
            break;
        }
    }
    
    @autoreleasepool {
        NSString *albumIdentifier = photo.albumIdentifier;
        NSArray *photos = [self.selectedPhotosInfo objectForKey:albumIdentifier];
        NSMutableArray *sPhotos = [NSMutableArray.alloc initWithArray:photos];
        for (int i = 0; i < sPhotos.count; i++) {
            HGPhotoModel *m = sPhotos[i];
            if ([m.identifier isEqualToString:photo.identifier]) {
                [sPhotos removeObjectAtIndex:i];
                break;
            }
        }
        [self.selectedPhotosInfo setObject:sPhotos forKey:albumIdentifier];
    }
}
- (BOOL)selectedPhotosContainObject:(HGPhotoModel *)photo {
    for (int i = 0; i < self.selectedPhotos.count; i++) {
        HGPhotoModel *m = self.selectedPhotos[i];
        if ([m.identifier isEqualToString:photo.identifier]) {
            return YES;
        }
    }
    return NO;
}
- (void)removeAllSelectedPhotos {
    [self.selectedPhotosInfo removeAllObjects];
    [self.selectedPhotos removeAllObjects];
}
- (NSInteger)selectedCount:(NSString *)albumIdentifier {
    NSArray *photos = [self.selectedPhotosInfo objectForKey:albumIdentifier];
    if (photos) {
        return photos.count;
    }
    return 0;
}

#pragma mark - SHARED INSTANCE
+ (instancetype)sharedManager{
    static HGAssetManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[HGAssetManager alloc] init];
    });
    return manager;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        self.selectedPhotosInfo = [NSMutableDictionary.alloc init];
        self.selectedPhotos = [NSMutableArray.alloc init];
    }
    return self;
}

@end




/***


enum PHAssetCollectionType : Int {
case Album //从 iTunes 同步来的相册，以及用户在 Photos 中自己建立的相册
case SmartAlbum //经由相机得来的相册
case Moment //Photos 为我们自动生成的时间分组的相册
}

enum PHAssetCollectionSubtype : Int {
case AlbumRegular //用户在 Photos 中创建的相册，也就是我所谓的逻辑相册
case AlbumSyncedEvent //使用 iTunes 从 Photos 照片库或者 iPhoto 照片库同步过来的事件。然而，在iTunes 12 以及iOS 9.0 beta4上，选用该类型没法获取同步的事件相册，而必须使用AlbumSyncedAlbum。
case AlbumSyncedFaces //使用 iTunes 从 Photos 照片库或者 iPhoto 照片库同步的人物相册。
case AlbumSyncedAlbum //做了 AlbumSyncedEvent 应该做的事
case AlbumImported //从相机或是外部存储导入的相册，完全没有这方面的使用经验，没法验证。
case AlbumMyPhotoStream //用户的 iCloud 照片流
case AlbumCloudShared //用户使用 iCloud 共享的相册
case SmartAlbumGeneric //文档解释为非特殊类型的相册，主要包括从 iPhoto 同步过来的相册。由于本人的 iPhoto 已被 Photos 替代，无法验证。不过，在我的 iPad mini 上是无法获取的，而下面类型的相册，尽管没有包含照片或视频，但能够获取到。
case SmartAlbumPanoramas //相机拍摄的全景照片
case SmartAlbumVideos //相机拍摄的视频
case SmartAlbumFavorites //收藏文件夹
case SmartAlbumTimelapses //延时视频文件夹，同时也会出现在视频文件夹中
case SmartAlbumAllHidden //包含隐藏照片或视频的文件夹
case SmartAlbumRecentlyAdded //相机近期拍摄的照片或视频
case SmartAlbumBursts //连拍模式拍摄的照片，在 iPad mini 上按住快门不放就可以了，但是照片依然没有存放在这个文件夹下，而是在相机相册里。
case SmartAlbumSlomoVideos //Slomo 是 slow motion 的缩写，高速摄影慢动作解析，在该模式下，iOS 设备以120帧拍摄。不过我的 iPad mini 不支持，没法验证。
case SmartAlbumUserLibrary //这个命名最神奇了，就是相机相册，所有相机拍摄的照片或视频都会出现在该相册中，而且使用其他应用保存的照片也会出现在这里。
case Any //包含所有类型
}

**/


