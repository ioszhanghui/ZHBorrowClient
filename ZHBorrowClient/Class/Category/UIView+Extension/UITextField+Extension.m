//
//  UITextField+Extension.m
//  魔颜
//
//  Created by Meiyue on 15/12/16.
//  Copyright © 2015年 abc. All rights reserved.
//

#import "UITextField+Extension.h"
// 颜色
@interface UITextField ()

@end

@implementation UITextField (Extension)


+ (instancetype )addFieldWithFrame:(CGRect)frame
                          delegate:(id)delegate
                          action:(SEL)action

{
    UITextField *textField = [[UITextField alloc] init];
    textField.placeholder = @"请输入";
    textField.returnKeyType = UIReturnKeyDone;
    textField.delegate = delegate;
    textField.frame = frame;
    textField.font = ZHFont_Title;
    textField.textColor = UIColorWithRGB(0x676767,1.0);
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [textField addTarget:delegate action:action forControlEvents:UIControlEventEditingChanged];
    
    return textField;
}

+ (instancetype )addFieldWithFrame:(CGRect)frame
                          delegate:(id)delegate

{
    UITextField *textField = [[UITextField alloc] init];
    textField.placeholder = @"请输入";
    textField.returnKeyType = UIReturnKeyDone;
    textField.delegate = delegate;
    textField.frame = frame;
    textField.font = ZHFont_Title;
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.textColor = UIColorWithRGB(0x676767,1.0);
    
    return textField;
}

+ (instancetype )addFieldWithFrame:(CGRect)frame
                       placeholder:(NSString *)placeholder
                          delegate:(id)delegate{
    
    UITextField *textField = [[UITextField alloc] init];
    textField.placeholder = placeholder;
    textField.returnKeyType = UIReturnKeyDone;
    textField.clearButtonMode = UITextFieldViewModeNever;
    [textField setValue:UIColorWithRGB(0xcacdd2, 1.0) forKeyPath:@"_placeholderLabel.textColor"];
    textField.delegate = delegate;
    textField.frame = frame;
    textField.textAlignment=NSTextAlignmentRight;
            
    if (ZHScreenW == 320) {
        textField.font = [UIFont systemFontOfSize:16.0f];
    }
    textField.textColor = UIColorWithRGB(0x676767,1.0);
    textField.font = ZHFont_Title;
    return textField;

}


@end
