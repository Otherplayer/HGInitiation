//
//  HGMutilHorizontalSVCell.m
//  HGInitiation
//
//  Created by __无邪_ on 2018/6/6.
//  Copyright © 2018年 __无邪_. All rights reserved.
//

#import "HGMutilHorizontalSVCell.h"

@interface HGMutilHorizontalSVCell ()<UICollectionViewDataSource,UICollectionViewDelegate>
@property(nonatomic, strong)UICollectionView *collectionView;
@end

@implementation HGMutilHorizontalSVCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        [self setBackgroundColor:[UIColor clearColor]];
        
        UICollectionViewFlowLayout *layout = ({
            layout = [[UICollectionViewFlowLayout alloc] init];
            layout.sectionInset = UIEdgeInsetsMake(10, 16, 0, 16);
            layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
            layout.minimumLineSpacing = 12;
            layout.minimumInteritemSpacing = 0;
            layout.itemSize = CGSizeMake(kHGMutilHorizontalCCellWidth, kHGMutilHorizontalCCellHeight - 10);
            layout;
        });
        
        self.collectionView = ({
            _collectionView = [UICollectionView.alloc initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kHGMutilHorizontalCCellHeight) collectionViewLayout:layout];
            _collectionView.dataSource = self;
            _collectionView.delegate = self;
            _collectionView.backgroundColor = UIColor.clearColor;
            _collectionView.directionalLockEnabled = YES;
            _collectionView.showsHorizontalScrollIndicator = NO;
            _collectionView.showsVerticalScrollIndicator = NO;
            _collectionView.bounces = YES;
            _collectionView.contentInset = UIEdgeInsetsZero;
            _collectionView;
        });
        
        [self.collectionView registerClass:HGMutilHorizontalCCell.class forCellWithReuseIdentifier:NSStringFromClass(HGMutilHorizontalCCell.class)];
        [self.contentView addSubview:self.collectionView];
    }
    return self;
}

- (void)setItems:(NSArray *)items {
    _items = items;
    [self.collectionView reloadData];
}

#pragma mark - <UICollectionViewDataSource>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.items.count;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    HGMutilHorizontalCCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(HGMutilHorizontalCCell.class) forIndexPath:indexPath];
    NSDictionary *info = self.items[indexPath.item];
    BOOL enabled = [info[@"enabled"] integerValue];
    if (enabled) {
        [cell.btnIcon setImage:[UIImage imageNamed:info[@"icon"]] forState:UIControlStateNormal];
    }else{
        [cell.btnIcon setImage:[UIImage imageNamed:info[@"icon_disabled"]] forState:UIControlStateNormal];
    }
    cell.labTitle.text = info[@"title"];
    WeakObject(self);
    [cell setDidTapHandler:^{
        if (weakObject.didTapHandler) {
            weakObject.didTapHandler(indexPath.item);
        }
    }];
    
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
//    if (self.didTapHandler) {
//        self.didTapHandler(indexPath.item);
//    }
}


@end
