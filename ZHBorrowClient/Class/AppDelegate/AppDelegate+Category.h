//
//  AppDelegate+Category.h
//  ZHMoneyClient
//
//  Created by zhph on 2017/7/18.
//  Copyright © 2017年 正和普惠. All rights reserved.
//

#import "AppDelegate.h"
#import "IQKeyboardManager.h"

@interface AppDelegate (Category)
/*配置键盘*/
-(void)configIQKeyboardManager;

/*友盟统计*/
-(void)configUMengAnalytics;

/*talkingData*/
-(void)setupTalking;
@end
