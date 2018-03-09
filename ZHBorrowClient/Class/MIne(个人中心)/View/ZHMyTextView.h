//
//  ZHMyTextView.h
//  ZHMoneyClient
//
//  Created by zhph on 2017/7/14.
//  Copyright © 2017年 正和普惠. All rights reserved.
//

#import <UIKit/UIKit.h>

#define MAX_INPUT_LENGTH  40

@interface ZHMyTextView : UITextView

/** 占位文字 */
@property (nonatomic,copy) NSString *placeholder;
/** 占位文字颜色 */
@property (nonatomic,strong) UIColor *placeholderColor;

/*textView的文字内容回调*/
@property(nonatomic,copy)void (^textViewBlock)(NSString* text);

+(ZHMyTextView*)createTextViewWithFrame:(CGRect)frame TextBlock:(void(^)(NSString * text))textViewBlock;

@end
