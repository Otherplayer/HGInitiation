//
//  HGProgressHUDTest.m
//  HGInitiation
//
//  Created by __无邪_ on 2018/6/27.
//  Copyright © 2018年 __无邪_. All rights reserved.
//

#import "HGProgressHUDTest.h"
#import "HGProgressHUDManager.h"


@interface MBExample : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) SEL selector;

@end


@implementation MBExample

+ (instancetype)exampleWithTitle:(NSString *)title selector:(SEL)selector {
    MBExample *example = [[self class] new];
    example.title = title;
    example.selector = selector;
    return example;
}

@end



@interface HGProgressHUDTest ()
@property(nonatomic, strong)NSArray *examples;
@end

@implementation HGProgressHUDTest

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.examples =
    @[@[[MBExample exampleWithTitle:@"Progress mode : on navigationController.view" selector:@selector(progressExample)],
        [MBExample exampleWithTitle:@"Text Only : on view" selector:@selector(textOnlyExample)],
        [MBExample exampleWithTitle:@"Progress mode : on window" selector:@selector(detailsLabelExample)]]
      ];
    
    [self.tableView registerClass:UITableViewCell.class forCellReuseIdentifier:HGIdentifier];
    [self.tableView setTableFooterView:[UIView new]];
    [self.tableView reloadData];
    
    [self.view setBackgroundColor:UIColor.groupTableViewBackgroundColor];
    [self addRightBarButtonItemWithTitle:@"hide"];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Action


- (void)rightBarButtonPressed:(id)rightBarButtonPressed{
    [[HGProgressHUDManager shared] hideProgressHUD];
}
- (void)progressExample {
    [[HGProgressHUDManager shared] showLoadingIn:self.navigationController.view msg:@"loading" hideAfterDealy:3];
}
- (void)textOnlyExample {
    [HGShowTip showMSGIn:self.view msg:@"这是一个文本" hideAfterDealy:1.2];
}
- (void)detailsLabelExample {
    [[HGProgressHUDManager shared] showLoadingIn:self.view.window msg:@"loading" hideAfterDealy:3];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.examples.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.examples[section] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MBExample *example = self.examples[indexPath.section][indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:HGIdentifier forIndexPath:indexPath];
    cell.textLabel.text = example.title;
    cell.textLabel.textColor = self.view.tintColor;
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.selectedBackgroundView = [UIView new];
    cell.selectedBackgroundView.backgroundColor = [cell.textLabel.textColor colorWithAlphaComponent:0.1f];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MBExample *example = self.examples[indexPath.section][indexPath.row];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    [self performSelector:example.selector];
#pragma clang diagnostic pop
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    });
}



@end
