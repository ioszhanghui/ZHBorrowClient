//
//  ZHMyAuthView.m
//  ZHBorrowClient
//
//  Created by 小飞鸟 on 2017/12/19.
//  Copyright © 2017年 小飞鸟. All rights reserved.
//

#import "ZHMyAuthView.h"

@interface ZHMyAuthView()
/*认证的个数*/
@property(nonatomic,strong)UILabel * authNumberLabel;
@end

@implementation ZHMyAuthView
/*创建分享成功的页面*/
+(ZHMyAuthView *)shareMyAuthViewWithFrame:(CGRect)frame GoToAction:(void(^)(void))goToBlock{
    
    return[[ZHMyAuthView alloc]initWithFrame:frame GoToAction:goToBlock];
}

-(instancetype)initWithFrame:(CGRect)frame GoToAction:(void(^)(void))goToBlock{
    
    if (self=[super initWithFrame:frame]) {
        self.userInteractionEnabled=YES;
        self.image=[UIImage imageNamed:@"背景2"];
        self.goToAction=goToBlock;
        
        UITapGestureRecognizer * tap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction)];
        [self addGestureRecognizer:tap];
        
        [self layoutUI];
    }
    
    return self;
}

#pragma nark 点击
-(void)tapAction{
    if (self.goToAction) {
        self.goToAction();
    }
}
#pragma mark 布局UI
-(void)layoutUI{
    
    UILabel * label1 = [UILabel addLabelWithFrame:CGRectMake(ZHFit(27),ZHFit(32), ZHFit(70), ZHFit(16)) title:@"我的认证" titleColor:UIColorWithRGB(0x5e5e5e, 1.0) font:ZHFontSemibold(16)];
    [self addSubview:label1];
    
    UILabel * label2 = [UILabel addLabelWithFrame:CGRectMake(ZHFit(27),label1.bottom+ ZHFit(7), ZHFit(180), ZHFit(12)) title:@"目前已完成认证  3/4" titleColor:UIColorWithRGB(0x5e5e5e, 1.0) font:ZHFontLineSize(12)];
    self.authNumberLabel = label2;
    [self addSubview:label2];
  label2.attributedText=[self setLabelSpacewithValue:label2.text Color:UIColorWithRGB(0x1865fa, 1.0) Range:NSMakeRange(label2.text.length-3, 1)];
}

-(NSMutableAttributedString*)setLabelSpacewithValue:(NSString*)str Color:(UIColor*)color Range:(NSRange)range{
    
    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:str];
    [attributeStr addAttributes:@{NSForegroundColorAttributeName:color} range:range];
    [attributeStr addAttributes:@{NSFontAttributeName:ZHFontSemibold(18)} range:NSMakeRange(str.length-3, 3)];
    return attributeStr;
}

#pragma mark 设置完成的个数
-(void)resetNumLabel{
    NSInteger number =0;
    if ([[UserTool GetUser].realname_state isEqualToString:@"1"]) {
        number++;
    }
    
    if ([[UserTool GetUser].base_state isEqualToString:@"1"]) {
        number++;
    }
    if ([[UserTool GetUser].credit_state isEqualToString:@"1"]) {
        number++;
    }
    if ([[UserTool GetUser].auth_state isEqualToString:@"1"]) {
        number++;
    }
    
    NSString * title =[NSString stringWithFormat:@"目前已完成认证  %ld/4",number];
    self.authNumberLabel.attributedText=[self setLabelSpacewithValue:title Color:ZHThemeColor Range:NSMakeRange(title.length-3, 1)];
}

@end
