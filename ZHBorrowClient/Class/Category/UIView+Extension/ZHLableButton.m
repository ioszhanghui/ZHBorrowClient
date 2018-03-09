//
//  LDLableButton.m
//  LDTooles
//
//  Created by 联动在线 on 15/6/26.
//  Copyright (c) 2015年 张辉. All rights reserved.
//

#import "ZHLableButton.h"
@interface ZHLableButton()

{
    SEL _action;
 __weak  id _target;
}

@end


@implementation ZHLableButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor=ZHClearColor;
        self.userInteractionEnabled=YES;
        
        [self addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew context:nil];
}

    return self;
}

#pragma mark 观察者
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    
    if ([[change objectForKey:@"new"] isKindOfClass:[NSNull class]]|[keyPath isEqual:[NSNull null]]) {
        
        return;
    }
    
    if ([[NSString stringWithFormat:@"%@",keyPath] isEqualToString:@"text"]&&([[change objectForKey:@"new"]isEqualToString:@"点击通讯录加载"])) {
        
        self.textColor=UIColorWithRGB(0xc3c3c3, 1.0);
        self.textAlignment=NSTextAlignmentCenter;
    }

    
    if ([[NSString stringWithFormat:@"%@",keyPath] isEqualToString:@"text"]&&([[change objectForKey:@"new"]isEqualToString:@"请选择"])) {
        
        self.textColor=UIColorWithRGB(0xc3c3c3, 1.0);
        self.textAlignment=NSTextAlignmentRight;
    }
    
    if ([[NSString stringWithFormat:@"%@",keyPath] isEqualToString:@"text"]&&!([[change objectForKey:@"new"]isEqualToString:@"请选择"]||[[change objectForKey:@"new"]isEqualToString:@"点击通讯录加载"])) {
        
        self.textColor=UIColorWithRGB(0x5e5e5e, 1.0);
//        self.textAlignment=NSTextAlignmentRight;
    }
}


-(void)addTarget:(id)target action:(SEL)action{
    
    _target=target;
    _action=action;
    
}

-(void)tapAction:(UITapGestureRecognizer*)tap
{
    self.alpha=0.8;
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha=1;
    } completion:^(BOOL finished) {
        
        if ([_target respondsToSelector:_action]) {
            
            [_target performSelector:_action withObject:self];
        }
    }];

}

+ (instancetype)addLabelWithFrame:(CGRect)frame
                            title:(NSString *)title
                       titleColor:(UIColor *)titleColor
                             font:(UIFont *)font
{
    ZHLableButton *label = [[ZHLableButton alloc] init];
    label.frame = frame;
    label.text = title;
    label.textColor = titleColor;
    label.font = font;
    label.backgroundColor=[UIColor clearColor];
    
    return label;
}

- (void)dealloc {
    @try {
        [self removeObserver:self forKeyPath:@"text"];
    }
    @catch (NSException *exception) {
        NSLog(@"Exception: %@", exception);
    }
    @finally  {
        // Added to show finally works as well
    }
}

@end
