//
//  AppDelegate.m
//  ZHBorrowClient
//
//  Created by 小飞鸟 on 2017/12/18.
//  Copyright © 2017年 小飞鸟. All rights reserved.
//

#import "AppDelegate.h"
#import "ZHHomeViewController.h"
#import "ZHNavigationController.h"
#import "AppDelegate+Category.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor=[UIColor whiteColor];
    [self requestWithUrl:[NSString stringWithFormat:@"%@/YJJQWebService/DispenseAddress.spring",UD_URL_HOME] Params:@{@"type":@"I",@"buildId":KVersion}];
    [self.window makeKeyAndVisible];
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    
    /********配置友盟统计*******/
    [self configUMengAnalytics];
     /********配置TalkingData*******/
    [self setupTalking];
    /********配置键盘弹框*******/
    [self configIQKeyboardManager];
    
    [SVProgressHUD setMaximumDismissTimeInterval:1.5];
    
    return YES;
}

#pragma mark 请求请求的地址
-(void)requestWithUrl:(NSString*)url Params:(NSDictionary*)params{
    
    //第一步，创建请求
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60];
    [request setHTTPMethod:@"POST"];//设置请求方式为POST，默认为GET
        NSString *str = [NSString stringWithFormat:@"paramJson=%@",[ZHStringFilterTool dictionaryToJson:params]];//设置参数
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:data];
    //第三步，连接服务器
    NSData *received = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSError *err;
    
    if (!received) {
        //请求失败 没数据
         self.window.rootViewController=[[ZHNavigationController alloc]initWithRootViewController:[ZHHomeViewController new]];
        return;
    }
    NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:received
                          
                                                         options:NSJSONReadingMutableContainers
                          
                                                           error:&err];
    NSLog(@"接口分发***%@",dic);
    if (!kDictIsEmpty(dic)&&[[dic objectForKey:@"code"]isEqualToString:@"200"]) {
        
        NSString * urlSTr=[dic objectForKey:@"data"];
        NSString * url = [urlSTr substringToIndex:urlSTr.length-16];
        
        [UserTool setObject:url forKey:@"Base_Url"];
        
        self.window.rootViewController=[[ZHNavigationController alloc]initWithRootViewController:[ZHHomeViewController new]];
        NSString *portStr = [NSString stringWithFormat:@"%@",[[NSURL URLWithString:urlSTr] port]];
        [UserTool setObject:portStr forKey:@"portStr"];
    }else{
        
        self.window.rootViewController=[[ZHNavigationController alloc]initWithRootViewController:[ZHHomeViewController new]];
    }
}

@end
