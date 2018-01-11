//
//  HGPhotoPickerController.m
//  HGInitiation
//
//  Created by __无邪_ on 2017/12/26.
//  Copyright © 2017年 __无邪_. All rights reserved.
//

#import "HGPhotosController.h"
#import "HGImagePreviewController.h"
#import "HGPhotoCell.h"

NSNotificationName const HGNotificationDonePicker = @"HGNotificationDonePicker";


static NSString *Identifier = @"Identifier";

@interface HGPhotosController ()<UICollectionViewDataSource,UICollectionViewDelegate,HGImagePreviewDelegate>
@property(nonatomic, strong)UICollectionView *collectionView;
@property(nonatomic, strong)NSMutableArray *photos;

@property(nonatomic, strong)UIView *toolBar;
@property(nonatomic, strong)UIButton *toolBarPreviewButton;
@property(nonatomic, strong)UIButton *toolBarDoneButton;

@end

@implementation HGPhotosController

- (void)loadView {
    [super loadView];
    [self initiateViews];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initiateDatas];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self shouldRefreshSelectedStatus];
    [self refreshButtonStatus];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    
}

#pragma mark -

- (void)didClickCancelAction {
    [[HGAssetManager sharedManager] removeAllSelectedPhotos];
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)didClickPreviewAction:(id)sender{
    HGImagePreviewController *controller = [HGImagePreviewController.alloc init];
    controller.currentIndex = 0;
    controller.delegate = self;
    controller.photos = [[HGAssetManager sharedManager].selectedPhotos copy];
    controller.maxSelectCount = self.maxSelectCount;
    [self.navigationController pushViewController:controller animated:YES];
}
- (void)didClickDoneAction:(id)sender{
    [[NSNotificationCenter defaultCenter] postNotificationName:HGNotificationDonePicker object:nil];
}

#pragma mark -

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.photos.count;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    HGPhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:Identifier forIndexPath:indexPath];
    
    __weak typeof(self) weakSelf = self;
    HGPhotoModel *model = self.photos[indexPath.item];
    cell.model = model;
    cell.btnSelectStatus.hidden = self.maxSelectCount == 1;
    cell.callbackHandler = ^ (HGPhotoCell *pCell){
        
        if (model.isSelected) {
            [[HGAssetManager sharedManager] removeObjectFromSelectedPhotos:model];
            model.isSelected = NO;
        }else{
            if ([HGAssetManager sharedManager].selectedPhotos.count >= self.maxSelectCount) {
                NSLog(@"选择数量限制");
                return ;
            }
            model.isSelected = YES;
            [[HGAssetManager sharedManager] addObject2SelectedPhotos:model];
        }
        
        pCell.model = model;
        
        [weakSelf refreshButtonStatus];
        
    };
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.maxSelectCount > 1) {
        HGImagePreviewController *controller = [HGImagePreviewController.alloc init];
        controller.currentIndex = indexPath.item;
        controller.delegate = self;
        controller.photos = self.photos;
        controller.maxSelectCount = self.maxSelectCount;
        [self.navigationController pushViewController:controller animated:YES];
    }else{
        HGPhotoModel *model = self.photos[indexPath.item];
        [[HGAssetManager sharedManager] addObject2SelectedPhotos:model];
        [self didClickDoneAction:nil];
    }
}

#pragma mark - HGImagePreviewDelegate

- (void)previewController:(HGImagePreviewController *)controller didChangeSelected:(HGPhotoModel *)model {
    for (HGPhotoModel *m in self.photos) {
        if ([m.identifier isEqualToString:model.identifier]) {
            m.isSelected = model.isSelected;
            break;
        }
    }
    [self.collectionView reloadData];
}

#pragma mark -

- (void)refreshButtonStatus{
    if ([HGAssetManager sharedManager].selectedPhotos.count > 0 && self.maxSelectCount > 1) {
        [self.toolBarPreviewButton setEnabled:YES];
        [self.toolBarDoneButton setEnabled:YES];
        [self.toolBarDoneButton setTitle:[NSString stringWithFormat:@"完成(%@)",@([HGAssetManager sharedManager].selectedPhotos.count)] forState:UIControlStateNormal];
    }else{
        [self.toolBarPreviewButton setEnabled:NO];
        [self.toolBarDoneButton setEnabled:NO];
        [self.toolBarDoneButton setTitle:@"完成" forState:UIControlStateNormal];
    }
}
- (void)shouldRefreshSelectedStatus {
    [self.collectionView reloadData];
}


#pragma mark -

- (void)fetchDatas {
    if (self.album) {
        [self fetchAssetsFromAlbum:self.album];
    }else {
        NSMutableArray *albums = [NSMutableArray.alloc init];
        [[HGAssetManager sharedManager] enumerateAlbumsWithType:self.pickerType showEmpty:NO usingBlock:^(HGAssetAlbum *model) {
            if (model) {
                [albums addObject:model];
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.album = [albums firstObject];
                    [self fetchAssetsFromAlbum:self.album];
                });
            }
        }];
    }
}
- (void)fetchAssetsFromAlbum:(HGAssetAlbum *)album {
    [album enumerateAssetsWithOptions:HGAlbumSortTypePositive usingBlock:^(HGAsset *asset) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (asset) {
                HGPhotoModel *model = [HGPhotoModel.alloc init];
                model.asset = asset;
                model.isSelected = YES;
                model.albumIdentifier = self.album.identifier;
                if (![[HGAssetManager sharedManager] selectedPhotosContainObject:model]) {
                    model.isSelected = NO;
                }
                [self.photos addObject:model];
                [self.collectionView insertItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:self.photos.count - 1 inSection:0]]];
            }else{
                [self.collectionView reloadData];
            }
        });
    }];
}


#pragma mark -

- (void)initiateViews {
    self.view.backgroundColor = [UIColor whiteColor];
    if (!self.title) {
        self.title = @"所有照片";
    }
    
    UIBarButtonItem *cancelItem = [UIBarButtonItem.alloc initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(didClickCancelAction)];
    self.navigationItem.rightBarButtonItem = cancelItem;
    
    self.photos = [NSMutableArray.alloc init];
    CGFloat width = self.view.width;
    CGFloat space = 2;
    NSInteger cols = 4;
    CGFloat itemWidth = (width - (cols - 1) * space)/cols;
    CGFloat itemHeight = itemWidth;
    
    UICollectionViewFlowLayout *layout = ({
        layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(itemWidth, itemHeight);
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        layout.minimumLineSpacing = space;
        layout.minimumInteritemSpacing = space;
        layout;
    });
    
    self.collectionView = ({
        _collectionView = [UICollectionView.alloc initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - TAB_BAR_HEIGHT) collectionViewLayout:layout];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = UIColor.whiteColor;
        _collectionView.clipsToBounds = NO;
        _collectionView;
    });
    
    [self.collectionView registerClass:HGPhotoCell.class forCellWithReuseIdentifier:Identifier];
    [self.view addSubview:self.collectionView];
    [self.collectionView reloadData];
    
    CGFloat buttonWidth = 65.f;
    CGFloat buttonMarginTop = 5.f;
    CGFloat buttonMarginLeft = 10.f;
    CGFloat buttonHeight = 30.f;
    self.toolBar = ({
        _toolBar = [UIView.alloc initWithFrame:CGRectMake(0, self.view.height - TAB_BAR_HEIGHT, self.view.width, TAB_BAR_HEIGHT)];
        _toolBar.backgroundColor = [UIColor colorWithWhite:0 alpha:0.85];
        _toolBar;
    });
    self.toolBarPreviewButton = ({
        _toolBarPreviewButton = [UIButton.alloc initWithFrame:CGRectMake(buttonMarginLeft, buttonMarginTop, buttonWidth, buttonHeight)];
        [_toolBarPreviewButton setTitle:@"预览" forState:UIControlStateNormal];
        [_toolBarPreviewButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [_toolBarPreviewButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_toolBarPreviewButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
        [_toolBarPreviewButton addTarget:self action:@selector(didClickPreviewAction:) forControlEvents:UIControlEventTouchUpInside];
        [_toolBarPreviewButton setEnabled:NO];
        _toolBarPreviewButton;
    });
    self.toolBarDoneButton = ({
        _toolBarDoneButton = [UIButton.alloc initWithFrame:CGRectMake(self.view.width - buttonWidth - buttonMarginLeft, buttonMarginTop, buttonWidth, buttonHeight)];
        _toolBarDoneButton.backgroundColor = [UIColor colorWithRed:.15 green:.67 blue:.16 alpha:1];
        [_toolBarDoneButton.layer setCornerRadius:4];
        [_toolBarDoneButton.layer setMasksToBounds:YES];
        [_toolBarDoneButton setTitle:@"完成" forState:UIControlStateNormal];
        [_toolBarDoneButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [_toolBarDoneButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_toolBarDoneButton setTitleColor:[UIColor lightTextColor] forState:UIControlStateDisabled];
        [_toolBarDoneButton addTarget:self action:@selector(didClickDoneAction:) forControlEvents:UIControlEventTouchUpInside];
        [_toolBarDoneButton setEnabled:NO];
        _toolBarDoneButton;
    });
    [self.toolBar addSubview:self.toolBarPreviewButton];
    [self.toolBar addSubview:self.toolBarDoneButton];
    
    [self.view addSubview:self.toolBar];
    
    
    if (1 == self.maxSelectCount) {
        self.toolBar.alpha = 0;
        self.collectionView.frame = self.view.bounds;
    }
    
    
}
- (void)initiateDatas {
    [self fetchDatas];
}

@end
