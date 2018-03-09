//
//  ZHHomeHeader.m
//  ZHBorrowClient
//
//  Created by zhph on 2017/12/19.
//  Copyright © 2017年 小飞鸟. All rights reserved.
//

#import "ZHHomeHeader.h"


@implementation ZHHomeHeader

/*创建Header*/
+(ZHHomeHeader*)createHomeHeaderWithFrame:(CGRect)frame PersonClick:(void(^)(void))personClick DetailClick:(void(^)(void))detailClick{
    
    return [[ZHHomeHeader alloc]initWithFrame:frame PersonClick:personClick DetailClick:detailClick];
}

-(instancetype)initWithFrame:(CGRect)frame PersonClick:(void(^)(void))personClick DetailClick:(void(^)(void))detailClick{
    if (self=[super initWithFrame:frame]) {
        
        self.PersonBtnClick=personClick;
        self.detailBtnClick=detailClick;
        self.userInteractionEnabled=YES;
        self.image=[UIImage imageNamed:@"背景"];
        //LOGO
        self.logoView=[[UIImageView alloc]initWithFrame:CGRectMake((ZHScreenW-ZHFit(115))/2, StatusBarHeight+ZHFit(13), ZHFit(115), ZHFit(35))];
        self.logoView.image=[UIImage imageNamed:@"一键借钱LOGO"];
        [self addSubview:self.logoView];
        //个人中心
        self.personBtn=[UIButton addButtonWithFrame:CGRectMake(ZHScreenW-ZHFit(20)-ZHFit(25), StatusBarHeight+ZHFit(19), ZHFit(25), ZHFit(25)) title:nil titleColor:nil font:nil image:@"我的" highImage:@"我的" backgroundColor:ZHClearColor tapAction:^(UIButton *button) {
            if (self.PersonBtnClick) {
                self.PersonBtnClick();
            }
        }];
        [self addSubview:self.personBtn];
        //提示
        self.textLabel=[UILabel addLabelWithFrame:CGRectMake(0, ZHFit(190), ZHScreenW, ZHFit(15)) title:@"我要借款(元)" titleColor:[UIColor whiteColor] font:ZHFontSize(14)];
        self.textLabel.textAlignment=NSTextAlignmentCenter;
        [self addSubview:self.textLabel];
        
        //借款数额
        self.numberLabel=[UILabel addLabelWithFrame:CGRectMake(0,self.textLabel.bottom+ZHFit(13), ZHScreenW, ZHFit(44)) title:@"3000.00" titleColor:[UIColor whiteColor] font:ZHFontBold(55)];
        self.numberLabel.textAlignment=NSTextAlignmentCenter;
        [self addSubview:self.numberLabel];
        
        UIImageView * alert=[[UIImageView alloc]initWithFrame:CGRectMake((ZHScreenW-ZHFit(175))/2, self.height-ZHFit(10)-ZHFit(27), ZHFit(175), ZHFit(27))];
        alert.image=[UIImage imageNamed:@"提示"];
        [self addSubview:alert];

    }
    return self;
}

/*重新加载视图*/
-(void)loadSubViews:(UIView*)superView{
    
    [self.detailView removeFromSuperview];
    /*详情页面*/
    self.detailView=[[UIImageView alloc]initWithFrame:CGRectMake(0, StatusBarHeight+ZHFit(347), ZHScreenW, ZHFit(89))];
    self.detailView.image=[UIImage imageNamed:@"背景1"];
    self.detailView.backgroundColor=ZHClearColor;
    self.detailView.userInteractionEnabled=YES;
    [superView addSubview:self.detailView];

    UILabel * moneyLabel=[UILabel addLabelWithFrame:CGRectMake(ZHFit(84), ZHFit(34), ZHScreenW, ZHFit(15)) title:@"您上次借款5000.00元" titleColor:UIColorWithRGB(0x414141, 1.0) font:ZHFontBold(14)];
    [self.detailView addSubview:moneyLabel];
    self.moneyLabel=moneyLabel;
    
     self.moneyLabel1=[UILabel addLabelWithFrame:CGRectMake(ZHFit(84),moneyLabel.bottom+ZHFit(5), ZHFit(196), ZHFit(12)) title:@"已为您做智能计算，点击查看详情" titleColor:UIColorWithRGB(0x5e5e5e, 1.0) font:ZHFontSize(12)];
    self.moneyLabel1.attributedText=[ZHStringFilterTool setLabelSpacewithValue:self.moneyLabel1.text Color:ZHThemeColor Range:NSMakeRange(self.moneyLabel1.text.length-4, 4)];
    self.moneyLabel1.userInteractionEnabled=YES;
    [self.detailView addSubview:self.moneyLabel1];
    
    UITapGestureRecognizer * tap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(seeDetail)];
    [self.detailView addGestureRecognizer:tap];
}
#pragma mark 查看详情
-(void)seeDetail{
    if (self.detailBtnClick) {
        self.detailBtnClick();
    }
}

#pragma mark 设置借款金额
-(void)reloadMoneyLabel{
    self.moneyLabel.text=[NSString stringWithFormat:@"您上次借款%@元",[UserTool GetUser].assess_money];
}

#pragma mark 移除提示框
-(void)removeDetailView{
    
    [self.detailView removeFromSuperview];
}

@end
