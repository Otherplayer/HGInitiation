//
//  HGPhotoAlbumController.m
//  HGInitiation
//
//  Created by __无邪_ on 2017/12/26.
//  Copyright © 2017年 __无邪_. All rights reserved.
//

#import "HGAlbumsController.h"

static NSString *Identifier = @"Identifier";

@interface HGAlbumsController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic, strong)HGAssetManager *photoBrowser;
@property(nonatomic, strong)NSMutableArray *albums;
@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, strong)UILabel *labEmpty;

@end

@implementation HGAlbumsController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initiateViews];
    [self fetchDatas];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    for (HGAssetAlbum *album in self.albums) {
        album.selectedCount = [[HGAssetManager sharedManager] selectedCount:album.identifier];
    }
    [self.tableView reloadData];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -

- (void)didClickCancelAction {
    [[HGAssetManager sharedManager] removeAllSelectedPhotos];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -

- (void)fetchDatas {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [[HGAssetManager sharedManager] enumerateAlbumsWithType:self.pickerType showEmpty:NO usingBlock:^(HGAssetAlbum *model) {
            if (model) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if ([HGAssetManager sharedManager].selectedPhotos.count) {
                        model.selectedCount = [[HGAssetManager sharedManager] selectedCount:model.identifier];
                    }else{
                        model.selectedCount = 0;
                    }
                    [self.albums addObject:model];
                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:((self.albums.count - 1) > 0 ? (self.albums.count - 1) : 0) inSection:0];
                    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationBottom];
                });
            }
        }];
    });
}

#pragma mark -

- (void)showEmptyWithMessage:(NSString *)message {
    [self.labEmpty setText:message];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.albums.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier forIndexPath:indexPath];
    
    HGAssetAlbum *model = self.albums[indexPath.row];
    NSString *name = [model name];
    NSString *num = [NSString stringWithFormat:@"（%@）",@([model numberOfAssets])];
    NSString *title = [name stringByAppendingString:num];
    NSString *count = model.selectedCount?[NSString stringWithFormat:@"『%@』",@(model.selectedCount)]:@"";
    title = [title stringByAppendingString:count];
    
    NSMutableAttributedString *attrTitle = [NSMutableAttributedString.alloc initWithString:title];
    [attrTitle addAttributes:@{NSForegroundColorAttributeName:[UIColor grayColor]} range:NSMakeRange(name.length, num.length)];
    [attrTitle addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:.15 green:.67 blue:.16 alpha:1],NSFontAttributeName:[UIFont boldSystemFontOfSize:16]} range:NSMakeRange(name.length + num.length, count.length)];
    cell.textLabel.attributedText = attrTitle;
    cell.imageView.clipsToBounds = YES;
    cell.imageView.contentMode = UIViewContentModeScaleAspectFill;
    cell.imageView.image = [model posterImageWithSize:CGSizeMake(100, 100)];
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 64;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    HGAssetAlbum *album = self.albums[indexPath.row];
    HGPhotosController *controller = [HGPhotosController.alloc init];
    
    controller.album = album;
    controller.pickerType = self.pickerType;
    controller.maxSelectCount = self.maxSelectCount;
    controller.title = [album name];
    
    [self.navigationController pushViewController:controller animated:YES];
}
#pragma mark -

- (void)initiateViews {
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"相册";
    UIBarButtonItem *cancelItem = [UIBarButtonItem.alloc initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(didClickCancelAction)];
    self.navigationItem.rightBarButtonItem = cancelItem;
    self.navigationController.navigationBar.tintColor = UIColor.whiteColor;
    
    self.albums = [NSMutableArray.alloc init];
    self.tableView = ({
        _tableView = [UITableView.alloc initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView;
    });
    [self.tableView registerClass:UITableViewCell.class forCellReuseIdentifier:Identifier];
    [self.tableView setTableFooterView:[UIView new]];
    [self.view addSubview:self.tableView];
}
- (HGAssetManager *)photoBrowser {
    if (!_photoBrowser) {
        _photoBrowser = [HGAssetManager.alloc init];
    }
    return _photoBrowser;
}
- (UILabel *)labEmpty {
    if (!_labEmpty) {
        _labEmpty = [UILabel.alloc initWithFrame:self.view.bounds];
        _labEmpty.textColor = [UIColor darkGrayColor];
        _labEmpty.font = [UIFont systemFontOfSize:20];
        _labEmpty.textAlignment = NSTextAlignmentCenter;
        _labEmpty.numberOfLines = 0;
        [self.view addSubview:_labEmpty];
    }
    return _labEmpty;
}

@end
