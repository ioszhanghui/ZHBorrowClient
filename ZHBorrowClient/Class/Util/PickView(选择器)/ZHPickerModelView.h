//
//  ZHPickerModelView.h
//  ZHLoanClient
//
//  Created by 正和 on 2017/10/31.
//  Copyright © 2017年 小飞鸟. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BasicModel;
typedef void(^confirmButtonAction)(BasicModel *model);
typedef void(^cancelButtonAction)(void);
typedef void(^maskClickAction)(void);

@interface ZHPickerModelView : UIView

/*
 * 将实现细节封装为一个类方法
 *
 * @param view : 父视图
 * @param array : 数据源
 * @param confirmButtonAction : 点击确认按钮回调的方法
 * @param cancelButtonAction : 点击取消按钮回调的方法
 * @param maskClickAction : 点击背景回调的方法
 */

+ (ZHPickerModelView *)showPickerViewAddedTo :(UIView *)view dataArray: (NSArray *)array
                          confirmAction :(confirmButtonAction)confrimButtonAction
                           cancelAction :(cancelButtonAction)cancelButtonAction
                              maskClick :(maskClickAction)maskClickAction;

@end
