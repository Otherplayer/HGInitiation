//
//  HGPhotoModel.m
//  HGInitiation
//
//  Created by __无邪_ on 2017/12/27.
//  Copyright © 2017年 __无邪_. All rights reserved.
//

#import "HGPhotoModel.h"

@interface HGPhotoModel ()
@property (nonatomic, strong) UIImage *image;
@property (nonatomic) BOOL loadingInProgress;
@end

@implementation HGPhotoModel

- (instancetype)init{
    self = [super init];
    if (self) {
        self.isSelected = NO;
        self.type = HGPhotoModelTypeAsset;
    }
    return self;
}
- (instancetype)initWithPath:(NSString *)path{
    self = [super init];
    if (self) {
        self.type = HGPhotoModelTypePath;
        self.pathStr = path;
    }
    return self;
}
- (instancetype)initWithUrlString:(NSString *)urlString{
    self = [super init];
    if (self) {
        self.type = HGPhotoModelTypeUrl;
        self.urlStr = urlString;
    }
    return self;
}


#pragma mark - Request

- (void)requestImageWithCompletion:(void (^)(UIImage *result))completion
                          withProgressHandler:(SDWebImageDownloaderProgressBlock)progressHandler {
    self.loadingInProgress = YES;
    if (self.image) {
        completion(self.image);
        self.loadingInProgress = NO;
        return;
    }else {
        completion(self.placeholderImage);
    }
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        if (self.type == HGPhotoModelTypeUrl) {
            [[SDWebImageManager sharedManager] loadImageWithURL:self.urlStr.url options:SDWebImageRetryFailed progress:progressHandler completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
                if (!error) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.loadingInProgress = NO;
                        completion(image);
                    });
                }
            }];
        }else if (self.type == HGPhotoModelTypePath) {
            @autoreleasepool {
                self.image = [UIImage imageWithContentsOfFile:self.pathStr];
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.loadingInProgress = NO;
                    completion(self.image);
                });
            }
        }
    });
}
- (void)loadImageFromFileAsync {
    
}


#pragma mark -

- (NSString *)identifier {
    return self.asset.identifier;
}





@end
