//
//  HGTextFieldController.m
//  HGInitiation
//
//  Created by __无邪_ on 2018/1/2.
//  Copyright © 2018年 __无邪_. All rights reserved.
//

#import "HGTextFieldController.h"
#import "HGTextField.h"


@interface HGTextFieldController ()<HGTextFieldDelegate>

@end

@implementation HGTextFieldController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    NSMutableAttributedString *attStr = [NSMutableAttributedString.alloc initWithString:@"占位placeholder"];
    [attStr setAttributes:@{NSForegroundColorAttributeName:[UIColor orangeColor]} range:NSMakeRange(0, attStr.string.length)];
    
    HGTextField *textField = [HGTextField.alloc initWithFrame:CGRectMake(0, 100, SCREEN_WIDTH, 100)];
    textField.placeholder = @"占位placeholder";
    textField.placeholderColor = [UIColor orangeColor];
    textField.backgroundColor = [UIColor whiteColor];
    textField.clearButtonMode = UITextFieldViewModeAlways;
    textField.maxLimitedLength = 10;
    textField.font = [UIFont systemFontOfSize:30];
    textField.delegate = self;
    
    UIView *icon = [UIView.alloc initWithFrame:CGRectMake(0, 0, 80, 80)];
    icon.backgroundColor = [UIColor orangeColor];
    
    UIView *iconRight = [UIView.alloc initWithFrame:CGRectMake(0, 0, 80, 80)];
    iconRight.backgroundColor = [UIColor orangeColor];
    
    textField.leftView = icon;
    textField.leftViewMode = UITextFieldViewModeWhileEditing;
    textField.rightView = iconRight;
    textField.rightViewMode = UITextFieldViewModeUnlessEditing;
    
    [self.view addSubview:textField];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

#pragma mark -

- (void)textFieldDidChange:(HGTextField *)textField {
    NSLog(@"%@",textField.text);
}
- (BOOL)textFieldShouldClear:(UITextField *)textField{
    NSLog(@"%s",__func__);
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    NSLog(@"%s",__func__);
    return YES;
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
