//
//  HGWebViewController.m
//  HGInitiation
//
//  Created by __无邪_ on 2018/1/5.
//  Copyright © 2018年 __无邪_. All rights reserved.
//

#import "HGWebViewController.h"
#import "HGWebViewProgressView.h"
#import <WebKit/WebKit.h>


NSString *const HGWebViewEstimatedProgress = @"estimatedProgress";
NSString *const HGWebViewTitle = @"title";

static NSString * const JSCallbackIdentifier = @"jsCallback";

@interface HGWebViewController ()<WKNavigationDelegate,WKUIDelegate,WKScriptMessageHandler>
@property(nonatomic, strong)WKWebView *webView;
@property(nonatomic, strong)HGWebViewProgressView *progressView;
@property(nonatomic, strong)NSString *callbackFunctionName;
@end

@implementation HGWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initiateViews];
    [self addObservers];
    [self loadStart];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar addSubview:_progressView];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    // Remove progress view
    // because UINavigationBar is shared with other ViewControllers
    [_progressView removeFromSuperview];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self shouldPauseVideoAudioPlay];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    [self.webView.configuration.userContentController removeAllUserScripts];
    [self removeObservers];
}

#pragma mark -

- (void)loadStart{
    //    NSURL *url = [[NSBundle mainBundle] URLForResource:@"showtime" withExtension:@"html"];
    NSURL *url = [NSURL URLWithString:self.urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
}


#pragma mark - WKNavigationDelegate

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation{
    NSLog(@"=======%s",__func__);
}
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation {
    NSLog(@"=======%s",__func__);
}
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error{
    NSLog(@"=======%s%@",__func__,error);
}
- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    NSLog(@"=======%s%@",__func__,error);
}


#pragma mark - WKScriptMessageHandler

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    
    if ([message.name isEqualToString:JSCallbackIdentifier] && [message.body isKindOfClass:[NSDictionary class]]) {
        NSDictionary *info = message.body;
        
        NSString     *methods     = info[@"f"] ? info[@"f"] : info[@"function"];  // js调用objc函数名
        NSDictionary *params      = info[@"p"] ? info[@"p"] : info[@"parameter"]; // js调用objc参数
        self.callbackFunctionName = info[@"c"] ? info[@"c"] : info[@"callback"];  // objc回调js函数名
        
        if (params && [params isKindOfClass:[NSDictionary class]]) {
            methods = [methods stringByAppendingString:@":"];
        }
        
        SEL selector = NSSelectorFromString(methods);
        if ([self respondsToSelector:selector]) {
            [self performSelector:selector withObject:params afterDelay:0];
        }
        else {
            NSLog(@"未定义的方法%@",methods);
        }
    }else{
        // 方法名
        NSString *methods = [NSString stringWithFormat:@"%@:", message.name];
        SEL selector = NSSelectorFromString(methods);
        if ([self respondsToSelector:selector]){
            [self performSelector:selector withObject:message.body afterDelay:0];
        }
        else {
            //TODO
        }
    }
    
}

#pragma mark - WKUIDelegate

- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler{
    [self showAlertMessage:message completionHandler:completionHandler];
}

- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler{
    [self showAlertMessage:message withTitle:NSLocalizedString(@"提示", @"alert-tip")
              confirmTitle:NSLocalizedString(@"确定",@"alert-confirm")
               cancelTitle:NSLocalizedString(@"取消",@"alert-cancel")
            confirmHandler:^{completionHandler(NO);}
             cancelHandler:^{completionHandler(YES);}];
}

- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * _Nullable))completionHandler{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:prompt message:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.text = defaultText;
    }];
    [alertController addAction:([UIAlertAction actionWithTitle:@"完成" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(alertController.textFields[0].text?:@"");
    }])];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    NSURL *url = navigationAction.request.URL;
    NSString *scheme = [url scheme];
    // 打电话
    if ([scheme isEqualToString:@"tel"]) {
        UIApplication *app = [UIApplication sharedApplication];
        if ([app canOpenURL:url]) {
            [app openURL:url];
            decisionHandler(WKNavigationActionPolicyCancel);
            return;
        }
    }
    decisionHandler(WKNavigationActionPolicyAllow);
}


#pragma mark - 功能

- (void)hgWebViewReturn{
    if ([self respondsToSelector:@selector(popViewControllerAnimated:)]) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}
- (void)hgWebViewOpen:(NSDictionary *)params {
    HGWebViewController *controller = HGWebViewController.alloc.init;
    controller.urlStr = [params objectForKey:@"url"];
    [self.navigationController pushViewController:controller animated:YES];
}
- (void)hgWebViewReload{
    [self.webView reload];
}
- (void)hgWebViewGoBack{
    if ([self.webView canGoBack]) { [self.webView goBack]; }
}
- (void)hgWebViewGoForward{
    if ([self.webView canGoForward]) { [self.webView goForward]; }
}
- (void)objcCallbackJS:(NSString *)func {
    [self.webView evaluateJavaScript:func completionHandler:^(id _Nullable item, NSError * _Nullable error) {
        if (error) {
            NSLog(@"【执行js代码错误】%@  %s",func,__FUNCTION__);
        }else{
            self.callbackFunctionName = nil;
        }
    }];
}


#pragma mark - observer

- (void)addObservers {
    [self.webView addObserver:self forKeyPath:HGWebViewTitle options:NSKeyValueObservingOptionNew context:NULL];
    [self.webView addObserver:self forKeyPath:HGWebViewEstimatedProgress options:NSKeyValueObservingOptionNew context:NULL];
}
- (void)removeObservers {
    [self.webView removeObserver:self forKeyPath:HGWebViewTitle];
    [self.webView removeObserver:self forKeyPath:HGWebViewEstimatedProgress];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([object isEqual:self.webView]) {
        if ([keyPath isEqualToString:HGWebViewEstimatedProgress]) {
            [self.progressView setProgress:_webView.estimatedProgress animated:YES];
        }
        else if ([keyPath isEqualToString:HGWebViewTitle]) {
            self.title = self.webView.title;
        }
    }
    else{
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark - private

- (void)shouldPauseVideoAudioPlay {
    NSString *jscode = @"var vids = document.getElementsByTagName('video');for(var i = 0; i < vids.length; i++ ){vids.item(i).pause()}var audios = document.getElementsByTagName('audio');for(var i = 0; i < audios.length; i++){audios[i].pause();}";
    [self objcCallbackJS:jscode];
}

#pragma mark - initiate

- (void)initiateViews {
    
    WKUserContentController *userContentController = [[WKUserContentController alloc] init];
    [userContentController addScriptMessageHandler:self name:JSCallbackIdentifier];
    
    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
    configuration.userContentController = userContentController;
    configuration.preferences = [WKPreferences new];
    configuration.preferences.javaScriptEnabled = YES;
    configuration.preferences.javaScriptCanOpenWindowsAutomatically = YES;
    // A Boolean value indicating whether HTML5 videos play inline (YES) or use the native full-screen controller (NO).
    configuration.allowsInlineMediaPlayback = YES;
    if (@available(iOS 10, *)) {
        configuration.mediaTypesRequiringUserActionForPlayback = WKAudiovisualMediaTypeNone;
    }else if (@available(iOS 9, *)) {
        configuration.requiresUserActionForMediaPlayback = NO;
    }else if (@available(iOS 8, *)) {
        configuration.mediaPlaybackRequiresUserAction = NO;
    }
    
    self.webView = ({
        _webView = [WKWebView.alloc initWithFrame:self.view.bounds configuration:configuration];
        _webView.UIDelegate = self;
        _webView.navigationDelegate = self;
        _webView.scrollView.bounces = NO;
        _webView;
    });
    
    if (@available(iOS 11.0, *)) {
        self.webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        // Fallback on earlier versions
    }
    
    [self.view addSubview:self.webView];
    
    CGFloat progressBarHeight = 2.f;
    CGRect navigationBarBounds = self.navigationController.navigationBar.bounds;
    CGRect barFrame = CGRectMake(0, navigationBarBounds.size.height - progressBarHeight, navigationBarBounds.size.width, progressBarHeight);
    self.progressView = ({
        _progressView = [HGWebViewProgressView.alloc initWithFrame:barFrame];
        _progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
        _progressView;
    });
    [self.progressView setProgress:0 animated:NO];
    
}

@end
