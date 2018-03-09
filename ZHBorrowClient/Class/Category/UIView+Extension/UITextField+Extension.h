//
//  UITextField+Extension.h
//  魔颜
//
//  Created by Meiyue on 15/12/16.
//  Copyright © 2015年 abc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (Extension)

+ (instancetype )addFieldWithFrame:(CGRect)frame
                          delegate:(id)delegate
                           action:(SEL)action;

+ (instancetype )addFieldWithFrame:(CGRect)frame
                              delegate:(id)delegate;


+ (instancetype )addFieldWithFrame:(CGRect)frame
                       placeholder:(NSString *)placeholder
                          delegate:(id)delegate;



@end
