//
//  HGPopTableViewController.m
//  HGInitiation
//
//  Created by __无邪_ on 2018/6/22.
//  Copyright © 2018年 __无邪_. All rights reserved.
//

#import "HGPopTableViewController.h"

@interface HGPopTableViewController ()<UIPopoverPresentationControllerDelegate,UIAdaptivePresentationControllerDelegate>
@property (nonatomic, assign)CGFloat perferdWidth;
@property (nonatomic, assign)CGFloat rowHeight;
@property (nonatomic, strong)UIColor *tintColor;
@property (nonatomic, strong)UIColor *textColor;
@property (nonatomic, strong)UIFont *font;
@end

@implementation HGPopTableViewController

- (instancetype)initWithTheme:(HGPopTableViewTheme)theme {
    return [self initWithStyle:UITableViewStylePlain theme:theme];
}
- (instancetype)init{
    return [self initWithStyle:UITableViewStylePlain];
}
- (instancetype)initWithStyle:(UITableViewStyle)style{
    return [self initWithStyle:style theme:HGPopTableViewThemeDefault];
}
- (instancetype)initWithStyle:(UITableViewStyle)style theme:(HGPopTableViewTheme)theme {
    self = [super initWithStyle:style];
    if (self) {
        if ([self respondsToSelector:@selector(automaticallyAdjustsScrollViewInsets)]) {
            self.automaticallyAdjustsScrollViewInsets = YES;
        }
        
        self.view.backgroundColor = [UIColor whiteColor];
        self.modalPresentationStyle = UIModalPresentationPopover;
        self.popoverPresentationController.delegate = self;
        
        
        self.tableView.estimatedRowHeight = 0;
        self.tableView.estimatedSectionHeaderHeight = 0;
        self.tableView.estimatedSectionFooterHeight = 0;
        self.tableView.backgroundColor = [UIColor clearColor];
        self.tableView.tableFooterView = UIView.new;
        
        
        self.rowHeight = 40.f;
        self.perferdWidth = 140.f;
        self.font = [UIFont systemFontOfSize:15];
        
        switch (theme) {
            case HGPopTableViewThemeDark:{
                self.textColor = UIColor.whiteColor;
                self.tintColor = UIColor.blackColor;
                self.tableView.separatorColor = [UIColor darkGrayColor];
                }
                break;
            case HGPopTableViewThemeWhite:{
                self.textColor = UIColor.blackColor;
                self.tintColor = UIColor.whiteColor;
                self.tableView.separatorColor = [UIColor grayColor];
                }
                break;
            default:{
                self.textColor = UIColor.whiteColor;
                self.tintColor = UIColor.clearColor;
                self.tableView.separatorColor = [UIColor groupTableViewBackgroundColor];
                }
                break;
        }
        
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGFloat)tableviewHeaderViewHeight{
    if (self.titleStr.length) {
        return 30.f;
    }
    return 0.01f;
}
- (CGFloat)contentHeight{
    return self.tableviewHeaderViewHeight + (self.menuArray.count)*self.rowHeight;
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.menuArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return [self tableviewHeaderViewHeight];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.rowHeight;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (self.titleStr.length) {
        UILabel *header = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, [self tableviewHeaderViewHeight])];
        header.backgroundColor = [UIColor clearColor];
        header.textColor = self.textColor;
        header.font = [UIFont boldSystemFontOfSize:14];
        header.textAlignment = NSTextAlignmentCenter;
        header.text = _titleStr;
        return header;
    }
    return nil;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:HGIdentifier];
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.text = self.menuArray[indexPath.row];
    cell.textLabel.textColor = self.textColor;
    cell.textLabel.font = self.font;
    
    if (self.imageArray && self.imageArray.count - 1 >= indexPath.row) {
        cell.imageView.image = [UIImage imageNamed:self.imageArray[indexPath.row]];
    }
    if (indexPath.row == self.menuArray.count - 1) {
        cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, SCREEN_WIDTH);
    }else{
        cell.separatorInset = UIEdgeInsetsMake(0, 15, 0, 15);
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.selectedIndex = indexPath.row;
    [self dismiss];
}

#pragma mark - UIPopoverPresentationControllerDelegate

- (void)prepareForPopoverPresentation:(UIPopoverPresentationController *)popoverPresentationController {
    
    _selectedIndex = -1;
    if (self.barButtonItem) {
        self.popoverPresentationController.barButtonItem = self.barButtonItem;
    } else {
        self.popoverPresentationController.sourceView = self.sourceView;
        self.popoverPresentationController.sourceRect = self.sourceView.bounds;
    }
    self.preferredContentSize = CGSizeMake(self.perferdWidth,[self contentHeight]);
    self.popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionAny;
    self.popoverPresentationController.passthroughViews = nil;
    self.popoverPresentationController.popoverLayoutMargins = UIEdgeInsetsMake(40, 0, 0, 0);
    self.popoverPresentationController.backgroundColor = self.tintColor;
    
}
- (BOOL)popoverPresentationControllerShouldDismissPopover:(UIPopoverPresentationController *)popoverPresentationController {
    return YES;
}
- (void)popoverPresentationController:(UIPopoverPresentationController *)popoverPresentationController willRepositionPopoverToRect:(inout CGRect *)rect inView:(inout UIView  * __nonnull * __nonnull)view {
    if (view != NULL) {
        *view = self.sourceView;
    }
    if (rect) {
        *rect = self.sourceView.bounds;
    }
}
- (void)popoverPresentationControllerDidDismissPopover:(UIPopoverPresentationController *)popoverPresentationController {
    
}


#pragma mark - UIAdaptivePresentationControllerDelegate

- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ) {
        return UIModalPresentationFullScreen;
    } else {
        return UIModalPresentationNone;
    }
}

- (UIViewController *)presentationController:(UIPresentationController *)controller viewControllerForAdaptivePresentationStyle:(UIModalPresentationStyle)style {
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:controller.presentedViewController];
    return navController;
}


#pragma mark - Actions

- (void)dismiss {
    [self dismissViewControllerAnimated:YES
                             completion:^{
                                 if (self.selectedIndex >= 0) {
                                     if (self.doneBlock) {
                                         self.doneBlock(self.selectedIndex);
                                     }
                                 }else{
                                     if (self.cancelBlock) {
                                         self.cancelBlock();
                                     }
                                 }
                             }];
}


@end
