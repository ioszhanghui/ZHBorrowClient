//
//  ZHMyTextView.m
//  ZHMoneyClient
//
//  Created by zhph on 2017/7/14.
//  Copyright © 2017年 正和普惠. All rights reserved.
//

#import "ZHMyTextView.h"

@interface ZHMyTextView ()<UITextViewDelegate>

@end

@implementation ZHMyTextView

+(ZHMyTextView*)createTextViewWithFrame:(CGRect)frame TextBlock:(void(^)(NSString * text))textViewBlock;{

    return [[ZHMyTextView alloc]initWithFrame:frame TextBlock:textViewBlock];
}

- (instancetype)initWithFrame:(CGRect)frame TextBlock:(void(^)(NSString * text))textViewBlock;
{
    if (self = [super initWithFrame:frame]) {
        
        self.textViewBlock=textViewBlock;
        
        self.width=(NSInteger)frame.size.width;
        self.height=(NSInteger)frame.size.height;
        self.backgroundColor=[UIColor whiteColor];
        self.delegate=self;
        self.font = ZHFontSize(15);
        self.placeholderColor =UIColorWithRGB(0xc3c3c3, 1.0);
        self.placeholder = @"请输入详细地址";
        self.textColor=UIColorWithRGB(0x656565,1.0);
        //内边距
        self.textContainerInset = UIEdgeInsetsMake(0, 0, 0, 0);
        //光标的缩进
        self.textContainer.lineFragmentPadding = 0;
        self.textAlignment=NSTextAlignmentRight;

    }
    return self;
}


#pragma mark - UITextViewDelegate
- (void)textViewDidChange:(ZHMyTextView *)textView // 此处取巧，把代理方法参数类型直接改成自定义的WSTextView类型，为了可以使用自定义的placeholder属性，省去了通过给控制器WSTextView类型属性这样一步。
{
    if (self.hasText) { // textView.text.length
        self.placeholder = @"";
    } else {
        self.placeholder = @"请输入详细地址";
    }
    
    if (self.textViewBlock) {
        
        self.textViewBlock([textView text]);
    }
    
}


#pragma mark 位数限制
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@""] && range.length > 0) {
        //删除字符肯定是安全的
        return YES;
    }
    else {
        if (textView.text.length - range.length + text.length > MAX_INPUT_LENGTH) {
            
            return NO;
        }
        else {
            return YES;
        }
    }
}

#pragma mark 水印设置
- (void)drawRect:(CGRect)rect {
    // Drawing code
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = ZHFontSize(15);
    attrs[NSForegroundColorAttributeName] = UIColorWithRGB(0xc3c3c3, 1.0);
    attrs[NSBackgroundColorAttributeName] = [UIColor whiteColor];
    [self.placeholder drawInRect:CGRectMake(self.frame.size.width*0.53, 0,self.frame.size.width*0.5, self.frame.size.height) withAttributes:attrs];
}

- (void)setPlaceholderColor:(UIColor *)placeholderColor
{
    _placeholderColor = placeholderColor;
    [self setNeedsDisplay];
    
}

- (void)setFont:(UIFont *)font
{
    [super setFont:font];
    [self setNeedsDisplay];
}

- (void)setText:(NSString *)text
{
    [super setText:text];
    if (text.length) { // 因为是在文本改变的代理方法中判断是否显示placeholder，而通过代码设置text的方式又不会调用文本改变的代理方法，所以再此根据text是否不为空判断是否显示placeholder。
        self.placeholder = @"";
    }
    [self setNeedsDisplay];
}

- (void)setAttributedText:(NSAttributedString *)attributedText
{
    [super setAttributedText:attributedText];
    if (attributedText.length) {
        self.placeholder = @"";
    }
    [self setNeedsDisplay];
}

// 布局子控件的时候需要重绘
- (void)layoutSubviews
{
    [super layoutSubviews];
    [self setNeedsDisplay];
    
}
// 设置属性的时候需要重绘，所以需要重写相关属性的set方法
- (void)setPlaceholder:(NSString *)placeholder
{
    _placeholder = placeholder;
    [self setNeedsDisplay];
}


@end
