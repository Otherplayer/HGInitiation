//
//  HGPageContent2Controller.m
//  HGInitiation
//
//  Created by __无邪_ on 2018/6/6.
//  Copyright © 2018年 __无邪_. All rights reserved.
//

#import "HGPageContent2Controller.h"

@interface HGPageContent2Controller ()<UITableViewDataSource>
@property(nonatomic, strong)UITableView *tableView;
@end

@implementation HGPageContent2Controller

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.tableView = ({
        _tableView = [UITableView.alloc initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView;
    });
    
    [self.tableView registerClass:UITableViewCell.class forCellReuseIdentifier:@"identifier"];
    [self.tableView setTableFooterView:[UIView new]];
    [self.view addSubview:self.tableView];
    
    @weakify(self)
    [self.tableView addRefreshingHeader:^{
        double delayInSeconds = 2.f;
        dispatch_time_t delayInNanoSeconds = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_queue_t concurrentQueue = dispatch_get_main_queue();
        dispatch_after(delayInNanoSeconds, concurrentQueue, ^(void){
            @strongify(self)
            if (!self) return;
            [self.tableView endRefreshing];
        });
    }];
    [self.tableView addRefreshingFooter:^{
        double delayInSeconds = 2.f;
        dispatch_time_t delayInNanoSeconds = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_queue_t concurrentQueue = dispatch_get_main_queue();
        dispatch_after(delayInNanoSeconds, concurrentQueue, ^(void){
            @strongify(self)
            if (!self) return;
            [self.tableView endRefreshingWithNoMoreData];
        });
    }];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.tableView.frame = self.view.bounds;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 40;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"identifier" forIndexPath:indexPath];
    cell.textLabel.text = [NSString stringWithFormat:@"中国%@",@(indexPath.row)];
    
    return cell;
}

@end
