//
//  HGMutilHorizontalScrollView.m
//  HGInitiation
//
//  Created by __无邪_ on 2018/6/6.
//  Copyright © 2018年 __无邪_. All rights reserved.
//

#import "HGMutilHorizontalScrollView.h"
#import "HGMutilHorizontalSVCell.h"
static NSString *HGMutilHorizontalIdentifier = @"Identifier";


@interface HGMutilHorizontalScrollView ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, strong)NSArray *items;
@end

@implementation HGMutilHorizontalScrollView


- (instancetype)initWithItems:(NSArray *)items{
    self = [super init];
    if (self) {
        self.items = items;
        [self initiateViews];
    }
    return self;
}

#pragma mark - Action
- (void)didTapCancelAction:(UIButton *)sender {
    if (self.didTapCancelHandler) {
        self.didTapCancelHandler();
    }
}

#pragma mark - <UITableViewDataSource>

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.items.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *subItems = self.items[section];
    return subItems.count > 0 ? 1:0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HGMutilHorizontalSVCell *cell = [tableView dequeueReusableCellWithIdentifier:HGMutilHorizontalIdentifier forIndexPath:indexPath];
    cell.items = self.items[indexPath.section];
    NSLog(@"%@",@([self.items[indexPath.section] count]));
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kHGMutilHorizontalCellHeight;
}

- (void)initiateViews {
    self.tableView = ({
        _tableView = [UITableView.alloc initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.bounces = NO;
        _tableView.scrollEnabled = NO;
        _tableView;
    });
    
    UIView *tableFooterView = ({
        tableFooterView = [UIView.alloc initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, TAB_BAR_HEIGHT)];
        tableFooterView.backgroundColor = [UIColor whiteColor];
        tableFooterView;
    });
    
    UIButton *btnCancel = ({
        btnCancel = [UIButton.alloc initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, TAB_BAR_HEIGHT)];
        [btnCancel setTitle:NSLocalizedString(@"取消", @"cancel") forState:UIControlStateNormal];
        [btnCancel setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btnCancel setTitleColor:[UIColor darkGrayColor] forState:UIControlStateHighlighted];
        [btnCancel.titleLabel setFont:[UIFont systemFontOfSize:20]];
        [btnCancel setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
        [btnCancel setBackgroundImage:[UIImage imageWithColor:[UIColor groupTableViewBackgroundColor]] forState:UIControlStateHighlighted];
        [btnCancel addTarget:self action:@selector(didTapCancelAction:) forControlEvents:UIControlEventTouchUpInside];
        btnCancel;
    });
    [tableFooterView addSubview:btnCancel];
    
    [self.tableView registerClass:HGMutilHorizontalSVCell.class forCellReuseIdentifier:HGMutilHorizontalIdentifier];
    [self addSubview:self.tableView];
    [self.tableView setTableFooterView:tableFooterView];
    
    CGRect frame = CGRectMake(0, 0, SCREEN_WIDTH, kHGMutilHorizontalCellHeight * self.items.count + TAB_BAR_HEIGHT);
    [self setFrame:frame];
    [self.tableView setFrame:frame];
    
}


@end
