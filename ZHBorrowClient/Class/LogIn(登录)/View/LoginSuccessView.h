//
//  LoginSuccessView.h
//  ZHBorrowClient
//
//  Created by zhph on 2017/12/19.
//  Copyright © 2017年 小飞鸟. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    LogInSuccess,//登录成功
    MatchResult,//匹配结果
} Alert_Type;

@interface LoginSuccessView : UIView
/*弹框提示的类型*/
@property(nonatomic,assign)Alert_Type type;
/*创建分享成功的页面*/
+(void)shareLoginSuccessViewWithFrame:(CGRect)frame Type:(Alert_Type)type CancelAction:(void(^)(void))cancelBlock SureAction:(void(^)(void))sureAction;
@end
