//
//  LDLableButton.h
//  LDTooles
//
//  Created by 联动在线 on 15/6/26.
//  Copyright (c) 2015年 张辉. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZHLableButton : UILabel

@property (assign, nonatomic) BOOL selected;

/*是否改变文字的颜色*/
@property(assign,nonatomic)BOOL change;

-(void)addTarget:(id)target action:(SEL)action;


/**
 创建按钮button

 @param frame Frame
 @param title title
 @param titleColor titleColor
 @param font font
 @return ZHLableButton
 */
+ (instancetype)addLabelWithFrame:(CGRect)frame
                            title:(NSString *)title
                       titleColor:(UIColor *)titleColor
                             font:(UIFont *)font;


@end
