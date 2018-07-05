//
//  HGLanguagesTest.m
//  HGInitiation
//
//  Created by __无邪_ on 2018/7/5.
//  Copyright © 2018年 __无邪_. All rights reserved.
//

#import "HGLanguagesTest.h"
#import "HGLanguageManager.h"

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
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:HGIdentifier forIndexPath:indexPath];
    cell.textLabel.textColor = self.view.tintColor;
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.text = info[@"title"];
    [cell customSelectedBackgroundView];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *info = self.languages[indexPath.row];
    [[HGLanguageManager shared] setAppLanguage:info[@"flag"]];
}

@end
