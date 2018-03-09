//
//  AppDelegate+Category.m
//  ZHMoneyClient
//
//  Created by zhph on 2017/7/18.
//  Copyright © 2017年 正和普惠. All rights reserved.
//

#import "AppDelegate+Category.h"


@implementation AppDelegate (Category)

-(void)configIQKeyboardManager{
    [IQKeyboardManager sharedManager].enable = YES;  //关闭设置为NO, 默认值为NO.
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;//点击背景收起键盘
    [IQKeyboardManager sharedManager].toolbarTintColor = UIColorWithRGB(0x2083FB, 1.0);;//修改文字的颜色
}

#pragma mark 友盟统计
-(void)configUMengAnalytics{
    UMConfigInstance.appKey = UM_App_Key;
    UMConfigInstance.channelId = @"app store";
    [MobClick startWithConfigure:UMConfigInstance];
    [MobClick setAppVersion:KVersion];
}
#pragma mark talking
-(void)setupTalking{
    
    [TalkingData sessionStarted:Talking_API_ID withChannelId:@"app store"];
}

@end
