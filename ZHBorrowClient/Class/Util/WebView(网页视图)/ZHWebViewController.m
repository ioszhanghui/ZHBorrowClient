//
//  CCWebViewController.m
//  WebViewDemo
//
//  Created by dangxy on 16/9/6.
//  Copyright © 2016年 xproinfo.com. All rights reserved.
//

#import <WebKit/WebKit.h>
#import "ZHWebViewController.h"

@interface ZHWebViewController ()<UIWebViewDelegate,UIActionSheetDelegate,WKNavigationDelegate,WKUIDelegate,WKScriptMessageHandler,UIScrollViewDelegate>
@property (assign, nonatomic) NSUInteger loadCount;
@property (strong, nonatomic) UIProgressView *progressView;
@property (strong, nonatomic) UIWebView *webView;
@property (strong, nonatomic) WKWebView *wkWebView;
@end

@implementation ZHWebViewController

/** 传入控制器、url、标题 */
+ (void)showWithContro:(UIViewController *)contro withUrlStr:(NSString *)urlStr withTitle:(NSString *)title {
    
    ZHWebViewController *webContro = [ZHWebViewController new];
    webContro.homeUrl = [NSURL URLWithString:urlStr];
    webContro.hidesBottomBarWhenPushed=YES;
    webContro.title = title;
    [contro.navigationController pushViewController:webContro animated:YES];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor whiteColor];
    [self configUI];
    [self configBackItem];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor] size:CGSizeMake(ZHScreenW, StatusBarHeight+self.navigationController.navigationBar.height)] forBarMetrics:UIBarMetricsDefault];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}


- (void)configUI {
 
    // 进度条
    UIProgressView *progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 0.1, self.view.frame.size.width, 0)];
    //progressView.tintColor = WebViewNav_TintColor;
    progressView.tintColor = ZHThemeColor;
    progressView.trackTintColor = [UIColor whiteColor];
    [self.view addSubview:progressView];
    self.progressView = progressView;
    
    // 网页
    if (IOS8AndLater) {
        
        //创建并配置WKWebView的相关参数
        //1.WKWebViewConfiguration:是WKWebView初始化时的配置类，里面存放着初始化WK的一系列属性；
        //2.WKUserContentController:为JS提供了一个发送消息的通道并且可以向页面注入JS的类，WKUserContentController对象可以添加多个scriptMessageHandler；
        //3.addScriptMessageHandler:name:有两个参数，第一个参数是userContentController的代理对象，第二个参数是JS里发送postMessage的对象。添加一个脚本消息的处理器,同时需要在JS中添加，window.webkit.messageHandlers..postMessage()才能起作用。
        
        WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
        WKUserContentController *userContentController = [[WKUserContentController alloc] init];
        /*禁止缩放*/
        NSString *js = @" $('meta[name=description]').remove(); $('head').append( '<meta name=\"viewport\" content=\"width=device-width, initial-scale=1,user-scalable=no\">' );";
        WKUserScript *script = [[WKUserScript alloc] initWithSource:js injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:NO];
        [userContentController addUserScript:script];
        
        [userContentController addScriptMessageHandler:self name:@"close"];
        
        configuration.userContentController = userContentController;
        
        
        WKPreferences *preferences = [WKPreferences new];
        preferences.javaScriptCanOpenWindowsAutomatically = YES;
        configuration.preferences = preferences;
        
        WKWebView *wkWebView  = [[WKWebView alloc] initWithFrame:self.view.frame configuration:configuration];
        wkWebView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        wkWebView.backgroundColor = [UIColor whiteColor];
        wkWebView.UIDelegate=self;
        wkWebView.navigationDelegate = self;
        [self.view insertSubview:wkWebView belowSubview:progressView];
        
        //捏合手势禁止缩放
        wkWebView.scrollView.delegate = self;
        
        [wkWebView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
        NSURLRequest *request = [NSURLRequest requestWithURL:_homeUrl];
        [wkWebView loadRequest:request];
        self.wkWebView = wkWebView;
        //清理缓存
        [self clearWebCache];
    }else {
        UIWebView *webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
        webView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        webView.scalesPageToFit = YES;
        webView.backgroundColor = [UIColor whiteColor];
        webView.delegate = self;
        [self.view insertSubview:webView belowSubview:progressView];
        
        NSURLRequest *request = [NSURLRequest requestWithURL:_homeUrl];
        [webView loadRequest:request];
        self.webView = webView;
    }
          [UIView addLineWithFrame:CGRectMake(0,0, ZHScreenW,0.5) WithView:self.view];
}
#pragma mark 清理缓存
- (void)clearWebCache {
    
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 9.0) {
        
        NSSet *websiteDataTypes
        
        = [NSSet setWithArray:@[
                                WKWebsiteDataTypeDiskCache,
                                
                                //WKWebsiteDataTypeOfflineWebApplicationCache,
                                
                                WKWebsiteDataTypeMemoryCache,
                                
                                //WKWebsiteDataTypeLocalStorage,
                                
                                //WKWebsiteDataTypeCookies,
                                
                                //WKWebsiteDataTypeSessionStorage,
                                
                                //WKWebsiteDataTypeIndexedDBDatabases,
                                
                                //WKWebsiteDataTypeWebSQLDatabases
                                ]];
        
        //// All kinds of data
        
        //NSSet *websiteDataTypes = [WKWebsiteDataStore allWebsiteDataTypes];
        
        //// Date from
        
        NSDate *dateFrom = [NSDate dateWithTimeIntervalSince1970:0];
        
        //// Execute
        
        [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:websiteDataTypes modifiedSince:dateFrom completionHandler:^{
            
            // Done
            
        }];
    } else {
        NSString *libraryPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        
        NSString *cookiesFolderPath = [libraryPath stringByAppendingString:@"/Cookies"];
        
        NSError *errors;
        
        [[NSFileManager defaultManager] removeItemAtPath:cookiesFolderPath error:&errors];
    }
}

#pragma mark -- WKScriptMessageHandler
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    //JS调用OC方法
    
    //message.boby就是JS里传过来的参数
    NSLog(@"body:%@",message.body);
    if ([message.name isEqualToString:@"close"]) {
        
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    
}

#pragma mark -- 捏合手势禁止缩放
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    
    return nil;
    
}

#pragma mark - 导航栏的返回按钮
- (void)configBackItem {
    
    // 导航栏的返回按钮
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(backBtnPressed:) image:@"arrow2" highImage:@"arrow2"];
}

#pragma mark - 导航栏的菜单按钮
- (void)configMenuItem {
    
    // 导航栏的菜单按钮
    UIImage *menuImage = [UIImage imageNamed:@"cc_webview_menu"];
    menuImage = [menuImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    UIButton *menuBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 5, 20)];
    [menuBtn setImage:menuImage forState:UIControlStateNormal];
    [menuBtn addTarget:self action:@selector(menuBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *menuItem = [[UIBarButtonItem alloc] initWithCustomView:menuBtn];
    self.navigationItem.rightBarButtonItem = menuItem;
}

#pragma mark - 导航栏的关闭按钮
- (void)configColseItem {
    
    // 导航栏的关闭按钮
    UIBarButtonItem *colseItem =[UIBarButtonItem itemWithTarget:self action:@selector(colseBtnPressed:) image:@"关闭" highImage:@"关闭"];;
    NSMutableArray *newArr = [NSMutableArray arrayWithObjects:self.navigationItem.leftBarButtonItem,colseItem, nil];
    self.navigationItem.leftBarButtonItems = newArr;
}

#pragma mark - 普通按钮事件

// 返回按钮点击
- (void)backBtnPressed:(id)sender {
    if (IOS8AndLater) {
        if (self.wkWebView.canGoBack) {
            [self.wkWebView goBack];
            if (self.navigationItem.leftBarButtonItems.count == 1) {
                [self configColseItem];
            }
        }else {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }else {
        if (self.webView.canGoBack) {
            [self.webView goBack];
            if (self.navigationItem.leftBarButtonItems.count == 1) {
                [self configColseItem];
            }
        }else {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

// 菜单按钮点击
- (void)menuBtnPressed:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"safari打开",@"复制链接",@"分享",@"刷新", nil];
    [actionSheet showInView:self.view];
}

// 关闭按钮点击
- (void)colseBtnPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 菜单按钮事件

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
    
    NSString *urlStr = _homeUrl.absoluteString;
    if (IOS8AndLater) urlStr = self.wkWebView.URL.absoluteString;
    else urlStr = self.webView.request.URL.absoluteString;
    if (buttonIndex == 0) {
        
        // safari打开
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];
    }else if (buttonIndex == 1) {
        
        // 复制链接
        if (urlStr.length > 0) {
            [[UIPasteboard generalPasteboard] setString:urlStr];
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"已复制链接到黏贴板" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"知道了", nil];
            [alertView show];
        }
    }else if (buttonIndex == 2) {
        
        // 分享
        //[self.wkWebView evaluateJavaScript:@"这里写js代码" completionHandler:^(id reponse, NSError * error) {
            //NSLog(@"返回的结果%@",reponse);
        //}];
        NSLog(@"这里自己写，分享url：%@",urlStr);
    }else if (buttonIndex == 3) {
        
        // 刷新
        if (IOS8AndLater) [self.wkWebView reload];
        else [self.webView reload];
        
    }
}

#pragma mark - wkWebView代理

// 如果不添加这个，那么wkwebview跳转不了AppStore
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    
    if ([webView.URL.absoluteString hasPrefix:@"https://itunes.apple.com"]) {
        [[UIApplication sharedApplication] openURL:navigationAction.request.URL];
        decisionHandler(WKNavigationActionPolicyCancel);
    }else {
        decisionHandler(WKNavigationActionPolicyAllow);
    }
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{

    [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
    
}

#pragma mark -网络加载指示器
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation{
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible=YES;

}


- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error{
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;

}

// 计算wkWebView进度条
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (object == self.wkWebView && [keyPath isEqualToString:@"estimatedProgress"]) {
        CGFloat newprogress = [[change objectForKey:NSKeyValueChangeNewKey] doubleValue];
        if (newprogress == 1) {
            self.progressView.hidden = YES;
            [self.progressView setProgress:0 animated:NO];
        }else {
            self.progressView.hidden = NO;
            [self.progressView setProgress:newprogress animated:YES];
        }
    }
}

// 记得取消监听
- (void)dealloc {
    if (IOS8AndLater) {
        [self.wkWebView removeObserver:self forKeyPath:@"estimatedProgress"];
    }
}

#pragma mark - webView代理

// 计算webView进度条
- (void)setLoadCount:(NSUInteger)loadCount {
    _loadCount = loadCount;
    if (loadCount == 0) {
        self.progressView.hidden = YES;
        [self.progressView setProgress:0 animated:NO];
    }else {
        self.progressView.hidden = NO;
        CGFloat oldP = self.progressView.progress;
        CGFloat newP = (1.0 - oldP) / (loadCount + 1) + oldP;
        if (newP > 0.95) {
            newP = 0.95;
        }
        [self.progressView setProgress:newP animated:YES];
    }
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    self.loadCount ++;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    self.loadCount --;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    self.loadCount --;
}

@end
