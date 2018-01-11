//
//  PhotoTweaksViewController.h
//  PhotoTweaks
//
//  Created by Tu You on 14/12/5.
//  Copyright (c) 2014年 Tu You. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HGAvatarClipperDelegate;

/**
 The photo tweaks controller.
 */
@interface HGAvatarClipperController : UIViewController

/**
 Image to process.
 */
@property (nonatomic, strong, readonly) UIImage *image;

/**
 Flag indicating whether the image cropped will be saved to photo library automatically. Defaults to NO.
 */
@property (nonatomic, assign) BOOL autoSaveToLibray;

/**
 Max rotation angle
 */
@property (nonatomic, assign) CGFloat maxRotationAngle;

/**
 The optional photo tweaks controller delegate.
 */
@property (nonatomic, weak) id<HGAvatarClipperDelegate> delegate;

/**
 Save action button's default title color
 */
@property (nonatomic, strong) UIColor *saveButtonTitleColor;

/**
 Save action button's highlight title color
 */
@property (nonatomic, strong) UIColor *saveButtonHighlightTitleColor;

/**
 Cancel action button's default title color
 */
@property (nonatomic, strong) UIColor *cancelButtonTitleColor;

/**
 Cancel action button's highlight title color
 */
@property (nonatomic, strong) UIColor *cancelButtonHighlightTitleColor;

/**
 Creates a photo tweaks view controller with the image to process.
 */
- (instancetype)initWithImage:(UIImage *)image;

@end

/**
 The photo tweaks controller delegate
 */
@protocol HGAvatarClipperDelegate <NSObject>

/**
 Called on image cropped.
 */
- (void)avatarClipperController:(HGAvatarClipperController *)controller didFinishWithCroppedImage:(UIImage *)croppedImage;

/**
 Called on cropping image canceled
 */
- (void)avatarClipperControllerDidCancel:(HGAvatarClipperController *)controller;

@end
