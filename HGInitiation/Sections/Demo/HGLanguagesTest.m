//
//  HGLanguagesTest.m
//  HGInitiation
//
//  Created by __无邪_ on 2018/7/5.
//  Copyright © 2018年 __无邪_. All rights reserved.
//

#import "HGLanguagesTest.h"
#import "HGLanguageManager.h"
#import "AppDelegate.h"
#import "HGHelperFPS.h"

@interface HGLanguagesTest ()
@property(nonatomic, strong) NSArray *languages;
@end

@implementation HGLanguagesTest

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.title = i18n_Text(@"app_language");
    self.languages = [[HGLanguageManager shared] supportLanguages];
    
    [self.tableView registerClass:UITableViewCell.class forCellReuseIdentifier:HGIdentifier];
    [self.tableView setTableFooterView:[UIView new]];
    [self.tableView reloadData];
    
    [self.view setBackgroundColor:UIColor.groupTableViewBackgroundColor];
    
    
    NSString *labelString = i18n_Text(@"app_language");
    NSLog(@"result: %@", labelString);
    //输出:MultiLanguage[1887:72599] result: 标签
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.languages.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *info = self.languages[indexPath.row];
    NSString *flag = info[@"flag"];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:HGIdentifier forIndexPath:indexPath];
    cell.textLabel.textColor = self.view.tintColor;
    cell.textLabel.text = info[@"title"];
    [cell customSelectedBackgroundView];
    
    if ([flag isEqualToString:[HGLanguageManager shared].appLanguage]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *info = self.languages[indexPath.row];
    [[HGLanguageManager shared] setAppLanguage:info[@"flag"]];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {
        return;
    }
    for (UITableViewCell *acell in tableView.visibleCells) {
        acell.accessoryType = acell == cell ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    }
    
    
    // 更新UI
    HGBASETabBarController *tab = [[HGBASETabBarController alloc] init];
    [tab setDefaultViewControllers];
    
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    delegate.tabBarController = tab;
    
    [HGShowTip showLoadingIn:self.view msg:nil hideAfterDealy:5];
    perform_block_after_delay(1, ^{
        [self dismissViewControllerAnimated:YES completion:^{
            delegate.window.rootViewController = tab;
            [HGHelperFPS sharedInstance].isTaped = YES;
            [HGShowTip hideProgressHUD];
        }];
    });
    
    
}

@end
