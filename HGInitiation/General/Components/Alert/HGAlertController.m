//
//  HGAlertController.m
//  HGInitiation
//
//  Created by __无邪_ on 2018/1/16.
//  Copyright © 2018年 __无邪_. All rights reserved.
//

#import "HGAlertController.h"

@interface HGAlertController ()

@end

@implementation HGAlertController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -

- (void)setTitleAttributes:(NSDictionary *)attributes {
    if (self.title.length == 0) return;
    
    if ([UIAlertController propertyIsExist:@"_attributedTitle"]) {
        NSMutableAttributedString *titleAttribute = [NSMutableAttributedString.alloc initWithString:self.title];
        [titleAttribute addAttributes:attributes range:NSMakeRange(0, self.title.length)];
        [self setValue:titleAttribute forKey:@"_attributedTitle"];
    }
    
}
- (void)setMessageAttributes:(NSDictionary *)attributes {
    if (self.message.length == 0) return;
    if ([UIAlertController propertyIsExist:@"_attributedMessage"]) {
        NSMutableAttributedString *messageAttribute = [NSMutableAttributedString.alloc initWithString:self.message];
        [messageAttribute addAttributes:attributes range:NSMakeRange(0, self.message.length)];
        [self setValue:messageAttribute forKey:@"_attributedMessage"];
    }
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
