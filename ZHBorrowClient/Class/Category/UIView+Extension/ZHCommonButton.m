//
//  ZHCommonButton.m
//  ZHLoanClient
//
//  Created by 小飞鸟 on 2017/10/21.
//  Copyright © 2017年 小飞鸟. All rights reserved.
//

#import "ZHCommonButton.h"

@implementation ZHCommonButton
- (void)sendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event
{
    [super sendAction:action to:target forEvent:event];
    self.enabled = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.enabled = YES;
    });
}

@end
