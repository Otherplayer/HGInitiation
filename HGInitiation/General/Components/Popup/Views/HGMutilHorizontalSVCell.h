//
//  HGMutilHorizontalSVCell.h
//  HGInitiation
//
//  Created by __无邪_ on 2018/6/6.
//  Copyright © 2018年 __无邪_. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HGMultiHorizontalSCCell.h"

@interface HGMutilHorizontalSVCell : UITableViewCell
@property(nonatomic, copy)void(^didTapHandler)(NSInteger row);
@property(nonatomic, strong)NSArray *items;

@end
