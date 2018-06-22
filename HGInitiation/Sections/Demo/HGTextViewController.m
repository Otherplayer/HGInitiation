//
//  HGTextViewController.m
//  HGInitiation
//
//  Created by __无邪_ on 2018/1/2.
//  Copyright © 2018年 __无邪_. All rights reserved.
//

#import "HGTextViewController.h"
#import "HGTextView.h"
@interface HGTextViewController ()<HGTextViewDelegate>

@end

@implementation HGTextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    HGTextView *textView = ({
        textView = [HGTextView.alloc initWithFrame:CGRectMake(0, 100, SCREEN_WIDTH, 400)];
        textView.backgroundColor = [UIColor whiteColor];
        textView.selectable = YES;
        textView.editable = YES;
        textView.font = [UIFont systemFontOfSize:30];
        textView.textColor = [UIColor orangeColor];
        textView.textContainerInset = UIEdgeInsetsMake(18, 17, 18, 17);
        textView.delegate = self;
        textView.maxLimitedLength = 10;
        textView.placeholder = @"占位placeholder";
        textView.autoResizable = YES;
        textView.layer.borderWidth = HGPixelOne;
        textView.layer.borderColor = [UIColor grayColor].CGColor;
        textView.layer.cornerRadius = 4;
        textView;
    });
    NSLog(@"%@",NSStringFromUIEdgeInsets(textView.textContainerInset));
    [self.view addSubview:textView];
    [self.view setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

#pragma mark -

- (void)textViewDidChange:(HGTextView *)textView {
    NSLog(@"%@",textView.text);
}
- (void)textView:(HGTextView *)textView newHeightAfterTextChanged:(CGFloat)height {
    NSLog(@"%f",height);
    textView.height = height;
}
- (BOOL)textViewShouldReturn:(HGTextView *)textView {
    return YES;
}
- (void)textViewDidReturn:(HGTextView *)textView {
    NSLog(@"%@ %@",textView.text,@(textView.text.length));
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
