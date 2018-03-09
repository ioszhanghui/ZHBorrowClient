//
//  ZHItemFooterView.m
//  ZHLoanClient
//
//  Created by 小飞鸟 on 2017/10/22.
//  Copyright © 2017年 小飞鸟. All rights reserved.
//

#import "ZHItemFooterView.h"

@interface ZHItemFooterView()
//重置
@property(nonatomic,strong)UIButton * resetBtn;
//确认
@property(nonatomic,strong)UIButton * sureBtn;

@end

@implementation ZHItemFooterView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        
        self.sureBtn=[UIButton addButtonWithFrame:CGRectMake(ZHScreenW-ZHFit(12)-ZHFit(225), ZHFit(15), ZHFit(225), ZHFit(40)) title:@"确认" titleColor:[UIColor whiteColor] font:ZHFontSize(16) image:nil highImage:nil backgroundColor:ZHThemeColor tapAction:^(UIButton *button) {
           
            if (self.ClickBtnBlock) {
                self.ClickBtnBlock(button.tag);
            }
        }];
        self.sureBtn.tag=2001;
        [self addSubview:self.sureBtn];
        
        self.resetBtn=[UIButton addButtonWithFrame:CGRectMake(self.sureBtn.left-ZHFit(100), ZHFit(15), ZHFit(50), ZHFit(40)) title:@"重置" titleColor:ZHThemeColor font:ZHFontSize(16) image:nil highImage:nil backgroundColor:nil tapAction:^(UIButton *button) {
            if (self.ClickBtnBlock) {
                self.ClickBtnBlock(button.tag);
            }
        }];
        self.resetBtn.tag=2000;
        self.resetBtn.contentHorizontalAlignment=UIControlContentHorizontalAlignmentRight;
        [self addSubview:self.resetBtn];
        [UIView addLineWithFrame:CGRectMake(ZHFit(12), 0, ZHScreenW-ZHFit(12)*2, 0.5) WithView:self];
        
    }
    return self;
}

@end
