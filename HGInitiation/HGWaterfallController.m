//
//  HGWaterfallController.m
//  HGInitiation
//
//  Created by __无邪_ on 2018/1/11.
//  Copyright © 2018年 __无邪_. All rights reserved.
//

#import "HGWaterfallController.h"
#import <CHTCollectionViewWaterfallLayout.h>
#import "HGHTTPClient.h"

static NSString *Identifier = @"Identifier";

#define kEmojiTitleFont [UIFont systemFontOfSize:15]



@interface HGEmojiModel : NSObject
@property(nonatomic, strong)NSString *name;
@property(nonatomic, strong)NSString *avatar;
@property(nonatomic)CGFloat width;
@property(nonatomic)CGFloat height;
@end
@implementation HGEmojiModel

@end



@interface HGEmojiCell : UICollectionViewCell
@property(nonatomic, strong)UILabel *labTitle;
@property(nonatomic, strong)UIImageView *imageView;
@end
@implementation HGEmojiCell
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.imageView = ({
            _imageView = [UIImageView.alloc initWithFrame:CGRectMake(0, 0, self.width, self.width)];
            _imageView.contentMode = UIViewContentModeScaleAspectFit;
            _imageView;
        });
        self.labTitle = ({
            _labTitle = [UILabel.alloc initWithFrame:CGRectMake(0, self.imageView.bottom, self.width, 0)];
            _labTitle.font = kEmojiTitleFont;
            _labTitle.textAlignment = NSTextAlignmentCenter;
            _labTitle.textColor = [UIColor darkGrayColor];
            _labTitle.numberOfLines = 0;
            _labTitle.lineBreakMode = NSLineBreakByWordWrapping;
            _labTitle;
        });
        [self.contentView addSubview:self.imageView];
        [self.contentView addSubview:self.labTitle];
    }
    return self;
}
- (void)setModel:(HGEmojiModel *)model {
    [self.imageView sd_setImageWithURL:model.avatar.url];
    [self.labTitle setText:model.name];
    self.labTitle.height = model.height;
}
@end







@interface HGWaterfallController ()<UICollectionViewDataSource,UICollectionViewDelegate,CHTCollectionViewDelegateWaterfallLayout>
@property(nonatomic, strong)UICollectionView *collectionView;
@property(nonatomic, strong)NSMutableArray *emojis;
@end

@implementation HGWaterfallController

const CGFloat COLUMNCOUNT = 6;
const CGFloat SPACE = 5;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initiateViews];
    [self fetchDatas];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -

- (void)fetchDatas {
    [self showProgressTip:nil];
    
    [[HGHTTPClient sharedInstance] fetchEmojies:^(BOOL success, NSString *errDesc, id responseData) {
        
        if (success) {
            NSDictionary *result = (NSDictionary *)responseData;
            NSMutableArray *datas = [NSMutableArray.alloc init];
            
            CGFloat width = ( SCREEN_WIDTH - (COLUMNCOUNT + 1) * SPACE) / COLUMNCOUNT;
            
            for (NSString *name in result.allKeys) {
                NSString *avatar = result[name];
                CGFloat height = [name heightWithFont:kEmojiTitleFont limitWidth:width];
                HGEmojiModel *model = [HGEmojiModel.alloc init];
                model.name = name;
                model.avatar = avatar;
                model.height = height;
                model.width = width;
                [datas addObject:model];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self hideTip];
                [self.emojis addObjectsFromArray:datas];
                [self.collectionView reloadData];
            });
            
        }else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self showTip:errDesc];
            });
        }
        
        
    }];
}

#pragma mark - UICollectionViewDataSource & UICollectionViewDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.emojis.count;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    HGEmojiCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:Identifier forIndexPath:indexPath];
    HGEmojiModel *model = self.emojis[indexPath.item];
    [cell setModel:model];
    return cell;
}

#pragma mark - CHTCollectionViewDelegateWaterfallLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    HGEmojiModel *model = self.emojis[indexPath.item];
    return CGSizeMake(model.width, model.height + model.width);
}

#pragma mark -

- (void)initiateViews {
    self.view.backgroundColor = [UIColor whiteColor];
    self.emojis = [NSMutableArray.alloc init];
    
    
    CHTCollectionViewWaterfallLayout *layout = ({
        layout = [[CHTCollectionViewWaterfallLayout alloc] init];
        layout.columnCount = COLUMNCOUNT;
        layout.minimumColumnSpacing = SPACE;
        layout.minimumInteritemSpacing = SPACE;
        layout.sectionInset = UIEdgeInsetsMake(SPACE, SPACE, SPACE, SPACE);
        layout;
    });
    
    self.collectionView = ({
        _collectionView = [UICollectionView.alloc initWithFrame:self.view.bounds collectionViewLayout:layout];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        _collectionView.decelerationRate = UIScrollViewDecelerationRateFast;
        _collectionView;
    });
    
    [self.collectionView registerClass:HGEmojiCell.class forCellWithReuseIdentifier:Identifier];
    [self.view addSubview:self.collectionView];
    [self.collectionView reloadData];
    
}

@end
