//
//  ZHPickerView.h
//  ZHPickerView
//
//  Created by Nineteen on 3/18/17.
//  Copyright © 2017 Nineteen. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ZHPickerViewDelegate <NSObject>

@optional
//修改箭头的指向
-(void)changeArrowDirection:(NSString*)type;

@end

typedef void(^confirmButtonAction)(NSString *string);
typedef void(^cancelButtonAction)(void);
typedef void(^maskClickAction)(void);

@interface ZHPickerView : UIView

/*
 * 将实现细节封装为一个类方法
 *
 * @param view : 父视图
 * @param array : 数据源
 * @param confirmButtonAction : 点击确认按钮回调的方法
 * @param cancelButtonAction : 点击取消按钮回调的方法
 * @param maskClickAction : 点击背景回调的方法
 */

//用来修改箭头的指向
@property(nonatomic,weak)id<ZHPickerViewDelegate>changeDelegate;

+ (ZHPickerView *)showPickerViewAddedTo :(UIView *)view dataArray: (NSArray *)array
                confirmAction :(confirmButtonAction)confrimButtonAction
                 cancelAction :(cancelButtonAction)cancelButtonAction
                    maskClick :(maskClickAction)maskClickAction;

@end
