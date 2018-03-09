//
//  ZHButtonItemView.m
//  ZHLoanClient
//
//  Created by 小飞鸟 on 2017/10/22.
//  Copyright © 2017年 小飞鸟. All rights reserved.
//

#import "ZHButtonItemView.h"

@implementation ZHButtonItemView

-(instancetype)initWithFrame:(CGRect)frame{
    
    if (self=[super initWithFrame:frame]) {
        self.itemLabel=[UILabel addLabelWithFrame:CGRectMake(ZHFit(30), 0,ZHScreenW-ZHFit(30), self.height) title:nil titleColor:UIColorWithRGB(0x383838,1.0) font:ZHFontSize(15)];
        self.itemLabel.textAlignment=NSTextAlignmentLeft;
        self.itemLabel.text=@"我有";
        self.clipsToBounds=YES;
        [self addSubview:self.itemLabel];
        
       self.topLine= [UIView addLineWithFrame:CGRectMake(ZHFit(12), 0, ZHScreenW-ZHFit(12)*2, 0.5) WithView:self];

    }
    
    return self;
}

@end
