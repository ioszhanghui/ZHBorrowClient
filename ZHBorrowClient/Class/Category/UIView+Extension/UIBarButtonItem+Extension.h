//
//  UIBarButtonItem+Extension.h
//  黑马微博2期
//
//  Created by apple on 14-10-7.
//  Copyright (c) 2014年 heima. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (Extension)

/*图片文字都有的按钮*/
+ (UIBarButtonItem *)itemWithTarget:(id)target action:(SEL)action Title:(NSString *)title image:(NSString *)image highImage:(NSString *)highImage;
/*文字按钮*/
+ (UIBarButtonItem *)itemWithTarget:(id)target action:(SEL)action Title:(NSString *)title;

+ (UIBarButtonItem *)itemWithTarget:(id)target action:(SEL)action image:(NSString *)image highImage:(NSString *)highImage  ;
@end
