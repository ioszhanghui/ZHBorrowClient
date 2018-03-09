//
//  LoginSuccessView.m
//  ZHBorrowClient
//
//  Created by zhph on 2017/12/19.
//  Copyright © 2017年 小飞鸟. All rights reserved.
//

#import "LoginSuccessView.h"

@interface LoginSuccessView()
/*取消*/
@property(nonatomic,copy)void(^ CancelActionBlock)(void);
/*确定*/
@property(nonatomic,copy)void(^ SureActionBlock)(void);
/*取消按钮*/
@property(nonatomic,strong)UIButton * cancelBtn;
/*去完善按钮*/
@property(nonatomic,strong)UIButton * completeBtn;
/*提示占位图*/
@property(nonatomic,strong)UIImageView * gou;
/*大标题提示*/
@property(nonatomic,strong)UILabel * largeTitleLabel;
/*小标题提示*/
@property(nonatomic,strong)UILabel * smallTitleLabel;

@end

@implementation LoginSuccessView
/*创建分享成功的页面*/
+(void)shareLoginSuccessViewWithFrame:(CGRect)frame Type:(Alert_Type)type CancelAction:(void(^)(void))cancelBlock SureAction:(void(^)(void))sureAction{
    
    LoginSuccessView * view =[[LoginSuccessView alloc]initWithFrame:frame CancelAction:cancelBlock SureAction:sureAction];
    view.type=type;
    [kWindow addSubview:view];
}


-(instancetype)initWithFrame:(CGRect)frame CancelAction:(void(^)(void))cancelBlock SureAction:(void(^)(void))sureAction{
    
    if (self=[super initWithFrame:frame]) {
        self.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
        
        self.SureActionBlock=sureAction;
        self.CancelActionBlock=cancelBlock;
        [self layoutUI];
    }
    
    return self;
}

#pragma mark 布局UI
-(void)layoutUI{
    
    self.gou = [[UIImageView alloc]initWithFrame:CGRectMake((ZHScreenW-ZHFit(300))/2, ZHFit(172), ZHFit(300), ZHFit(252))];
    self.gou.userInteractionEnabled=YES;
    [self addSubview:self.gou];
    
    //大标题提示
    self.largeTitleLabel = [UILabel addLabelWithFrame:CGRectMake(0,ZHFit(82), self.gou.width, ZHFit(20)) title:nil titleColor:UIColorWithRGB(0x414141, 1.0) font:ZHFontBold(20)];
    self.largeTitleLabel.textAlignment=NSTextAlignmentCenter;
    [self.gou addSubview:self.largeTitleLabel];
    
    //小标题提示
    self.smallTitleLabel = [UILabel addLabelWithFrame:CGRectMake(ZHFit(49),self.largeTitleLabel.bottom+ ZHFit(13), self.gou.width-ZHFit(49)*2, ZHFit(36)) title:nil titleColor:UIColorWithRGB(0x5e5e5e, 1.0) font:ZHFontLineSize(14)];
    self.smallTitleLabel.textAlignment=NSTextAlignmentCenter;
    self.smallTitleLabel.numberOfLines=0;
    [self.gou addSubview:self.smallTitleLabel];
    
    [UIView addLineWithFrame:CGRectMake(0, self.gou.height-ZHFit(44), self.gou.width, 0.5) WithView:self.gou];
    
    self.cancelBtn=[UIButton addButtonWithFrame:CGRectMake(0, self.gou.height-ZHFit(44), self.gou.width/2, ZHFit(44)) title:@"取消" titleColor:UIColorWithRGB(0xcacdd2, 1.0) font:ZHFontLineSize(16) image:nil highImage:nil
                              backgroundColor:ZHClearColor tapAction:^(UIButton *button) {
                                  
                                  if (self.CancelActionBlock) {
                                      self.CancelActionBlock();
                                  }
                                  
                                  [self hiddenView];
                              }];
    
    [self.gou addSubview:self.cancelBtn];
    
    self.completeBtn=[UIButton addButtonWithFrame:CGRectMake(self.gou.width/2, self.gou.height-ZHFit(44), self.gou.width/2, ZHFit(44)) title:@"去完善" titleColor:ZHThemeColor font:ZHFontLineSize(16) image:nil highImage:nil
                                backgroundColor:ZHClearColor tapAction:^(UIButton *button) {
                                    if (self.SureActionBlock) {
                                        self.SureActionBlock();
                                    }
                                     [self hiddenView];
                                }];
    
    [self.gou addSubview:self.completeBtn];
    [UIView addLineWithFrame:CGRectMake(self.gou.width/2, self.gou.height-ZHFit(44),0.5, ZHFit(44)) WithView:self.gou];
    
}

#pragma mark 隐藏视图
-(void)hiddenView{
    
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha=1.0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma mark - 根据传入的值创建相应的UI
/** 根据传入的值创建相应的UI */
- (void)setType:(Alert_Type)type{
    switch (type) {
        case LogInSuccess:{
            
            UIImageView * tu = [[UIImageView alloc]initWithFrame:CGRectMake(ZHFit(33),ZHFit(30)+self.smallTitleLabel.bottom, ZHFit(11), ZHFit(13))];
            tu.image=[UIImage imageNamed:@"盾牌"];
            [self.gou addSubview:tu];
            
            UILabel * label3 = [UILabel addLabelWithFrame:CGRectMake(tu.right+ZHFit(5),ZHFit(31)+self.smallTitleLabel.bottom, ZHFit(226), ZHFit(12)) title:@"我们将会对您的个人信息进行严格保密" titleColor:UIColorWithRGB(0xcacdd2, 1.0) font:ZHFontLineSize(12)];
            [self.gou addSubview:label3];
            // 注册成功
            [self setImage:@"弹出" topLabelText:@"注册完成" bottomLabelText:@"您需要继续完善部分个人信息后才能开始借款"];
             break;
        }
        case MatchResult:{
            //智能匹配
            [self setImage:@"MacthBG" topLabelText: @"不满意吗?" bottomLabelText:@"很抱歉！\n我们的智能计算似乎没有让您满意，强烈推荐您去借款超市进行更多挑选"];
            self.smallTitleLabel.frame=CGRectMake(ZHFit(26), self.largeTitleLabel.bottom+ ZHFit(13), self.gou.width-ZHFit(26)*2, ZHFit(54));
            [self.cancelBtn setTitle:@"我再看看" forState:UIControlStateNormal];
            [self.completeBtn setTitle:@"现在就去" forState:UIControlStateNormal];
            break;
        }
        default:
            break;
    }
}

#pragma mark - 设置图片和文字
/** 设置图片和文字 */
- (void)setImage:(NSString *)imageName topLabelText:(NSString *)topLabelText bottomLabelText:(NSString *)bottomLabelText{
    self.gou.image = [UIImage imageNamed:imageName];
    self.largeTitleLabel.text = topLabelText;
    self.smallTitleLabel.text = bottomLabelText;
}

@end
