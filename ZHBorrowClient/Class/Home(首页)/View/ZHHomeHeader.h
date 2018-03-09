//
//  ZHHomeHeader.h
//  ZHBorrowClient
//
//  Created by zhph on 2017/12/19.
//  Copyright © 2017年 小飞鸟. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZHHomeHeader : UIImageView
/*LOGO*/
@property(nonatomic,strong)UIImageView * logoView;
/*个人中心*/
@property(nonatomic,strong)UIButton * personBtn;
/*提示文字*/
@property(nonatomic,strong)UILabel * textLabel;
/*数据值*/
@property(nonatomic,strong)UILabel * numberLabel;
/*提示文字*/
@property(nonatomic,strong)UILabel * alertLabel;
/*个人中心点击*/
@property(nonatomic,copy)void(^PersonBtnClick)(void);
/*个人中心点击*/
@property(nonatomic,copy)void(^detailBtnClick)(void);
/*详情页面*/
@property(nonatomic,strong)UIImageView * detailView;
/*查看详情的按钮*/
@property(nonatomic,strong) UILabel * moneyLabel1;
/*详情按钮*/
@property(nonatomic,strong)UIButton * detailBtn;
/*上次借款的金额*/
@property(nonatomic,strong)UILabel * moneyLabel;

/*创建Header*/
+(ZHHomeHeader*)createHomeHeaderWithFrame:(CGRect)frame PersonClick:(void(^)(void))personClick DetailClick:(void(^)(void))detailClick;

/*重新加载视图*/
-(void)loadSubViews:(UIView*)superView;

/*设置上次借款金额*/
-(void)reloadMoneyLabel;
/*移除提示框*/
-(void)removeDetailView;

@end
