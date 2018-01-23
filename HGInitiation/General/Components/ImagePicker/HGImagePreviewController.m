//
//  HGPhotoPreviewController.m
//  HGInitiation
//
//  Created by __无邪_ on 2017/12/26.
//  Copyright © 2017年 __无邪_. All rights reserved.
//

#import "HGImagePreviewController.h"
#import "HGImagePreviewCell.h"
#import "HGImagePickerController.h"

static NSString *Identifier = @"Identifier";

@interface HGImagePreviewController ()<UICollectionViewDataSource,UICollectionViewDelegate,HGZoomImageViewDelegate>
@property(nonatomic, strong)UICollectionView *collectionView;

@property(nonatomic, strong)UIButton *navRightButton;
@property(nonatomic, strong)UIView *toolBar;
@property(nonatomic, strong)UIButton *toolBarDoneButton;

@end

@implementation HGImagePreviewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initiateViews];
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)dealloc{
    
}
#pragma mark -

- (void)didClickSelectAction:(id)sender{
    HGPhotoModel *model = self.photos[self.currentIndex];
    if ([[HGAssetManager sharedManager] selectedPhotosContainObject:model]) {
        [[HGAssetManager sharedManager] removeObjectFromSelectedPhotos:model];
        model.isSelected = NO;
    }else{
        model.isSelected = YES;
        [[HGAssetManager sharedManager] addObject2SelectedPhotos:model];
    }
    if ([self.delegate respondsToSelector:@selector(previewController:didChangeSelected:)]) {
        [self.delegate previewController:self didChangeSelected:model];
    }
    [self refreshStatus:[NSIndexPath indexPathForItem:self.currentIndex inSection:0]];
}
- (void)didClickDoneAction:(id)sender{
    [[NSNotificationCenter defaultCenter] postNotificationName:HGNotificationDonePicker object:nil];
    //[[HGAssetManager sharedManager] removeAllSelectedPhotos];
}

#pragma mark - UICollectionViewDataSource & UICollectionViewDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.photos.count;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    HGImagePreviewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:Identifier forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    cell.zoomImageView.delegate = self;
    
    HGPhotoModel *model = self.photos[indexPath.item];
    [model.asset requestPreviewImageWithCompletion:^(UIImage *result, NSDictionary<NSString *,id> *info) {
        cell.zoomImageView.image = result;
    } withProgressHandler:^(double progress, NSError * _Nullable error, BOOL * _Nonnull stop, NSDictionary * _Nullable info) {
        
    }];
    
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
//    HGPhotoPreviewCell *previewCell = (HGPhotoPreviewCell *)cell;
//    [previewCell.zoomImageView revertZooming];
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
}


#pragma mark - HGZoomImageViewDelegate

- (void)singleTouchInZoomImageView:(HGZoomImageView *)zoomImageView location:(CGPoint)location {
    [self refreshBarStatus];
}
#pragma mark - <UIScrollViewDelegate>

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView != self.collectionView) {
        return;
    }
    
    // 当前滚动到的页数
    [self refreshStatus:[NSIndexPath indexPathForItem:self.currentIndex inSection:0]];
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

#pragma mark -

- (void)refreshBarStatus {
    bool isHidden = self.navigationController.navigationBar.isHidden;
    [self.navigationController setNavigationBarHidden:!isHidden animated:YES];
    self.collectionView.backgroundColor = isHidden ? UIColor.whiteColor : UIColor.blackColor;
    [UIView animateWithDuration:0.2f animations:^{
        self.toolBar.top = isHidden ? (self.view.height - TAB_BAR_HEIGHT) : self.view.height;
    }];
}

- (void)refreshStatus:(NSIndexPath *)indexPath{
    
    HGPhotoModel *model = self.photos[indexPath.item];
    if ([[HGAssetManager sharedManager] selectedPhotosContainObject:model]) {
        [self.navRightButton setSelected:YES];
    }else{
        [self.navRightButton setSelected:NO];
    }
    
    [self refreshButtonStatus];
}
- (void)refreshButtonStatus{
    if ([HGAssetManager sharedManager].selectedPhotos.count > 0 && self.maxSelectCount > 1) {
        [self.toolBarDoneButton setEnabled:YES];
        [self.toolBarDoneButton setTitle:[NSString stringWithFormat:@"完成(%@)",@([HGAssetManager sharedManager].selectedPhotos.count)] forState:UIControlStateNormal];
    }else{
        [self.toolBarDoneButton setEnabled:NO];
        [self.toolBarDoneButton setTitle:@"完成" forState:UIControlStateNormal];
    }
}

#pragma mark -

- (void)initiateViews {
    self.view.backgroundColor = [UIColor whiteColor];
    self.view.clipsToBounds = YES;
    self.title = NSLocalizedString(@"预览", @"preview");
    
    self.navRightButton = ({
        _navRightButton = [UIButton.alloc initWithFrame:CGRectMake(0, 0, 40, 40)];
        [_navRightButton setImage:[UIImage imageNamed:@"photo_unselect"] forState:UIControlStateNormal];
        [_navRightButton setImage:[UIImage imageNamed:@"photo_select"] forState:UIControlStateSelected];
        [_navRightButton addTarget:self action:@selector(didClickSelectAction:) forControlEvents:UIControlEventTouchUpInside];
        _navRightButton;
    });
    
    UIBarButtonItem *cancelItem = [UIBarButtonItem.alloc initWithCustomView:self.navRightButton];
    self.navigationItem.rightBarButtonItem = cancelItem;
    
    
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
        _collectionView.backgroundColor = UIColor.whiteColor;
        _collectionView.pagingEnabled = YES;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.scrollsToTop = NO;
        _collectionView.delaysContentTouches = NO;
        _collectionView.decelerationRate = UIScrollViewDecelerationRateFast;
        if (@available(iOS 11, *)) {
            _collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        _collectionView;
    });
    
    [self.collectionView registerClass:HGImagePreviewCell.class forCellWithReuseIdentifier:Identifier];
    [self.view addSubview:self.collectionView];
    [self.collectionView reloadData];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:self.currentIndex inSection:0];
    [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    
    
    CGFloat buttonWidth = 65.f;
    CGFloat buttonMarginTop = 5.f;
    CGFloat buttonMarginLeft = 10.f;
    CGFloat buttonHeight = 30.f;
    self.toolBar = ({
        _toolBar = [UIView.alloc initWithFrame:CGRectMake(0, self.view.height - TAB_BAR_HEIGHT, self.view.width, TAB_BAR_HEIGHT)];
        _toolBar.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        _toolBar;
    });
    self.toolBarDoneButton = ({
        _toolBarDoneButton = [UIButton.alloc initWithFrame:CGRectMake(self.view.width - buttonWidth - buttonMarginLeft, buttonMarginTop, buttonWidth, buttonHeight)];
        _toolBarDoneButton.backgroundColor = [UIColor colorWithRed:.15 green:.67 blue:.16 alpha:1];
        [_toolBarDoneButton.layer setCornerRadius:4];
        [_toolBarDoneButton.layer setMasksToBounds:YES];
        [_toolBarDoneButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [_toolBarDoneButton setTitle:@"完成" forState:UIControlStateNormal];
        [_toolBarDoneButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_toolBarDoneButton setTitleColor:[UIColor lightTextColor] forState:UIControlStateDisabled];
        [_toolBarDoneButton addTarget:self action:@selector(didClickDoneAction:) forControlEvents:UIControlEventTouchUpInside];
        _toolBarDoneButton;
    });
    [self.toolBar addSubview:self.toolBarDoneButton];
    
    [self.view addSubview:self.toolBar];
    
    [self refreshStatus:indexPath];
}

@end
