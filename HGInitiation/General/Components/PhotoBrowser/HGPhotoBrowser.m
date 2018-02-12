//
//  HGPhotoBrowser.m
//  HGInitiation
//
//  Created by __无邪_ on 2018/1/8.
//  Copyright © 2018年 __无邪_. All rights reserved.
//

#import "HGPhotoBrowser.h"
#import "HGZoomImageView.h"
#import "HGImagePreviewCell.h"

#define kPhotoBrowserAnimationDuration (0.28f)
static NSString *Identifier = @"Identifier";

@interface HGPhotoBrowser ()<UICollectionViewDataSource,UICollectionViewDelegate,HGZoomImageViewDelegate>{
    UIView *_senderViewForAnimation;
    CGRect _senderViewOriginalFrame;
    UIWindow *_applicationWindow;
    BOOL _isdraggingPhoto;
}

@property(nonatomic, strong)UICollectionView *collectionView;
@property(nonatomic, strong)NSMutableArray *photos;
@property(nonatomic)NSInteger currentIndex;
@property(nonatomic)NSInteger initIndex;

@end

@implementation HGPhotoBrowser

- (instancetype)init{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (instancetype)initWithPhotos:(NSArray <HGPhotoModel *>*)photosArray index:(NSInteger)index animatedFromView:(UIView*)view {
    if ((self = [self init])) {
        
        self.initIndex = index;
        self.currentIndex = index;
        
        _senderViewForAnimation = view;
        
        _applicationWindow = [[[UIApplication sharedApplication] delegate] window];
        self.modalPresentationStyle = UIModalPresentationCustom;
        self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        self.modalPresentationCapturesStatusBarAppearance = YES;
        self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        self.photos = [NSMutableArray.alloc init];
        
        [self.photos addObjectsFromArray:photosArray];
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initiateViews];
    
    // Transition animation
    [self performPresentAnimation];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    
}

#pragma mark - Action

- (void)doneAction:(id)sender {
    if (_senderViewForAnimation && self.currentIndex == self.initIndex) {
        HGImagePreviewCell *cell = (HGImagePreviewCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:self.currentIndex inSection:0]];
        [self performCloseAnimationWithScrollView:cell.zoomImageView];
    }
    else {
        _senderViewForAnimation.hidden = NO;
        [self dismissPhotoBrowserAnimated:YES];
    }
}
- (void)dismissPhotoBrowserAnimated:(BOOL)animated {
    // Cancel any pending toggles from taps
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self dismissViewControllerAnimated:animated completion:nil];
}
- (void)panGestureRecognized:(UIPanGestureRecognizer *)sender {
    // Initial Setup
    
    HGImagePreviewCell *cell = (HGImagePreviewCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:self.currentIndex inSection:0]];
    
    UIScrollView *scrollView = cell.zoomImageView.scrollView;
    
    static float firstX, firstY;
    
    float viewHeight = scrollView.frame.size.height;
    float viewHalfHeight = viewHeight/2;
    
    CGPoint translatedPoint = [sender translationInView:self.view];
    
    // Gesture Began
    if ([(UIPanGestureRecognizer*)sender state] == UIGestureRecognizerStateBegan) {
        
        firstX = [scrollView center].x;
        firstY = [scrollView center].y;
        
        _senderViewForAnimation.hidden = 1;
        
        _isdraggingPhoto = YES;
    }
    
    translatedPoint = CGPointMake(firstX, firstY+translatedPoint.y);
    [scrollView setCenter:translatedPoint];
    
    float newY = scrollView.center.y - viewHalfHeight;
    float newAlpha = 1 - fabsf(newY)/viewHeight; //abs(newY)/viewHeight * 1.8;
    
    self.view.opaque = YES;
    self.view.alpha = newAlpha;
    
    // Gesture Ended
    if ([sender state] == UIGestureRecognizerStateEnded) {
        if(scrollView.center.y > viewHalfHeight+200 || scrollView.center.y < viewHalfHeight-200) // Automatic Dismiss View
        {
            if (_senderViewForAnimation && self.currentIndex == self.initIndex) {
                [self performCloseAnimationWithScrollView:cell.zoomImageView];
                return;
            }
            
            CGFloat finalX = firstX, finalY;
            
            CGFloat windowsHeigt = SCREEN_HEIGHT;
            
            if(scrollView.center.y > viewHalfHeight+30) // swipe down
                finalY = windowsHeigt*2;
            else // swipe up
                finalY = -viewHalfHeight;
            
            CGFloat animationDuration = 0.35;
            
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:animationDuration];
            [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
            [UIView setAnimationDelegate:self];
            [scrollView setCenter:CGPointMake(finalX, finalY)];
            [UIView commitAnimations];
            
            [self performSelector:@selector(doneAction:) withObject:self afterDelay:0.35];
        }
        else // Continue Showing View
        {
            _isdraggingPhoto = NO;
            
            self.view.alpha = 1;
            
            CGFloat velocityY = (.35 * [sender velocityInView:self.view].y);
            
            CGFloat finalX = firstX;
            CGFloat finalY = viewHalfHeight;
            
            CGFloat animationDuration = (ABS(velocityY)*.0002)+.2;
            
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:animationDuration];
            [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
            [UIView setAnimationDelegate:self];
            [scrollView setCenter:CGPointMake(finalX, finalY)];
            [UIView commitAnimations];
        }
    }
}


#pragma mark - UICollectionViewDataSource & UICollectionViewDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.photos.count;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    HGImagePreviewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:Identifier forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    cell.zoomImageView.delegate = self;
    //TODO:设置placeholder
    HGPhotoModel *model = self.photos[indexPath.item];
    [model requestImageWithCompletion:^(UIImage *result) {
        cell.zoomImageView.image = result;
        cell.isLoading = YES;
    } withProgressHandler:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
        if (receivedSize >= expectedSize && expectedSize > 0) {
            dispatch_async(dispatch_get_main_queue(), ^{
               cell.isLoading = NO;
            });
        }
    }];
    
    
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    HGImagePreviewCell *previewCell = (HGImagePreviewCell *)cell;
    [previewCell.zoomImageView revertZooming];
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
}


#pragma mark - HGZoomImageViewDelegate

- (void)singleTouchInZoomImageView:(HGZoomImageView *)zoomImageView location:(CGPoint)location {
    [self doneAction:nil];
}


#pragma mark - <UIScrollViewDelegate>

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView != self.collectionView) {
        return;
    }
    
    // 当前滚动到的页数
    NSLog(@"%@",@(self.currentIndex));
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView != self.collectionView) {
        return;
    }
    
    CGFloat pageWidth = self.collectionView.width;
    CGFloat contentOffsetX = self.collectionView.contentOffset.x;
    CGFloat index = contentOffsetX / (pageWidth);
    self.currentIndex = (NSInteger)index;
}

#pragma mark - perform animation

- (void)performPresentAnimation {
    
    UIImage *imageFromView = [self getImageFromView:_senderViewForAnimation];
    
    _senderViewOriginalFrame = [_senderViewForAnimation.superview convertRect:_senderViewForAnimation.frame toView:nil];

    UIView *fadeView = [[UIView alloc] initWithFrame:_applicationWindow.bounds];
    fadeView.backgroundColor = [UIColor clearColor];
    [_applicationWindow addSubview:fadeView];

    UIImageView *resizableImageView = [[UIImageView alloc] initWithImage:imageFromView];
    resizableImageView.frame = _senderViewOriginalFrame;
    resizableImageView.clipsToBounds = YES;
    resizableImageView.contentMode = _senderViewForAnimation ? _senderViewForAnimation.contentMode : UIViewContentModeScaleAspectFit;
    resizableImageView.backgroundColor = [UIColor clearColor];
    [_applicationWindow addSubview:resizableImageView];
    _senderViewForAnimation.hidden = YES;

    void (^completion)(void) = ^() {
        self.view.alpha = 1.0f;
        self.collectionView.alpha = 1.0f;
        [fadeView removeFromSuperview];
        [resizableImageView removeFromSuperview];
    };

    [UIView animateWithDuration:kPhotoBrowserAnimationDuration animations:^{
        fadeView.backgroundColor = [UIColor blackColor];
    } completion:nil];

    CGRect finalImageViewFrame = [self animationFrameForImage:imageFromView presenting:YES scrollView:nil];
    
    
    [UIView animateWithDuration:kPhotoBrowserAnimationDuration animations:^{
        resizableImageView.layer.frame = finalImageViewFrame;
    } completion:^(BOOL finished) {
        completion();
    }];
    
}
- (void)performCloseAnimationWithScrollView:(HGZoomImageView *)scrollView {
    
    float fadeAlpha = 1 - fabs(scrollView.frame.origin.y)/scrollView.frame.size.height;
    
    UIImage *imageFromView = scrollView.image;
    
    UIView *fadeView = [[UIView alloc] initWithFrame:_applicationWindow.bounds];
    fadeView.backgroundColor = [UIColor blackColor];
    fadeView.alpha = fadeAlpha;
    [_applicationWindow addSubview:fadeView];
    
    CGRect imageViewFrame = [self animationFrameForImage:imageFromView presenting:NO scrollView:scrollView.scrollView];
    
    UIImageView *resizableImageView = [[UIImageView alloc] initWithImage:imageFromView];
    resizableImageView.frame = imageViewFrame;
    resizableImageView.contentMode = _senderViewForAnimation ? _senderViewForAnimation.contentMode : UIViewContentModeScaleAspectFit;
    resizableImageView.backgroundColor = [UIColor clearColor];
    resizableImageView.clipsToBounds = YES;
    [_applicationWindow addSubview:resizableImageView];
    self.view.hidden = YES;
    
    void (^completion)(void) = ^() {
        _senderViewForAnimation.hidden = NO;
        _senderViewForAnimation = nil;
        
        [fadeView removeFromSuperview];
        [resizableImageView removeFromSuperview];
        
        [self dismissPhotoBrowserAnimated:NO];
    };
    
    [UIView animateWithDuration:kPhotoBrowserAnimationDuration animations:^{
        fadeView.alpha = 0;
        self.view.backgroundColor = [UIColor clearColor];
    } completion:nil];
    
    CGRect senderViewOriginalFrame = _senderViewForAnimation.superview ? [_senderViewForAnimation.superview convertRect:_senderViewForAnimation.frame toView:nil] : _senderViewOriginalFrame;
    
    [UIView animateWithDuration:kPhotoBrowserAnimationDuration animations:^{
        resizableImageView.layer.frame = senderViewOriginalFrame;
    } completion:^(BOOL finished) {
        completion();
    }];
}


#pragma mark - private

- (UIImage *)getImageFromView:(UIView *)view {
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, YES, 2);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
- (CGRect)animationFrameForImage:(UIImage *)image presenting:(BOOL)presenting scrollView:(UIScrollView *)scrollView{
    if (!image) {
        return CGRectZero;
    }
    
    CGSize imageSize = image.size;
    
    CGFloat maxWidth = SCREEN_WIDTH;
    CGFloat maxHeight = SCREEN_HEIGHT;
    
    CGRect animationFrame = CGRectZero;
    
    CGFloat aspect = imageSize.width / imageSize.height;
    if (maxWidth / aspect <= maxHeight) {
        animationFrame.size = CGSizeMake(maxWidth, maxWidth / aspect);
    }
    else {
        animationFrame.size = CGSizeMake(maxHeight * aspect, maxHeight);
    }
    
    animationFrame.origin.x = roundf((maxWidth - animationFrame.size.width) / 2.0f);
    animationFrame.origin.y = roundf((maxHeight - animationFrame.size.height) / 2.0f);
    
    if (!presenting) {
        animationFrame.origin.y += scrollView.frame.origin.y;
    }
    
    return animationFrame;
}

#pragma mark -

- (void)initiateViews {
    self.hidesBottomBarWhenPushed = YES;
    self.view.backgroundColor = [UIColor colorWithWhite:1 alpha:1];
    self.view.clipsToBounds = YES;
    self.view.alpha = 0.0f;
    
    
    UICollectionViewFlowLayout *layout = ({
        layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(self.view.width, self.view.height);
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout;
    });
    
    self.collectionView = ({
        _collectionView = [UICollectionView.alloc initWithFrame:self.view.bounds collectionViewLayout:layout];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = UIColor.blackColor;
        _collectionView.pagingEnabled = YES;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.scrollsToTop = NO;
        _collectionView.delaysContentTouches = NO;
        _collectionView.decelerationRate = UIScrollViewDecelerationRateFast;
        _collectionView.alpha = 0;
        if (@available(iOS 11, *)) {
            _collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        _collectionView;
    });
    
    [self.collectionView registerClass:HGImagePreviewCell.class forCellWithReuseIdentifier:Identifier];
    [self.view addSubview:self.collectionView];
    [self.collectionView reloadData];
    
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:self.initIndex inSection:0];
    [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognized:)];
    [panGesture setMinimumNumberOfTouches:1];
    [panGesture setMaximumNumberOfTouches:1];
    [self.view addGestureRecognizer:panGesture];
    
}



@end
