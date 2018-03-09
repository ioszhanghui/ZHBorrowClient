//
//  ZHLimitFooterView.m
//  ZHBorrowClient
//
//  Created by 小飞鸟 on 2017/12/22.
//  Copyright © 2017年 小飞鸟. All rights reserved.
//

#import "ZHLimitFooterView.h"

@interface ZHLimitFooterView()
/*不满意按钮*/
@property(nonatomic,strong)UIButton * btn;
/*我的额度*/
@property(nonatomic,strong)UILabel * numberLabel;
@end

@implementation ZHLimitFooterView

-(instancetype)initWithFrame:(CGRect)frame GoToAction:(void(^)(void))goToBlock{
    
    if (self=[super initWithFrame:frame]) {
        self.backgroundColor=[UIColor whiteColor];
        self.goToAction=goToBlock;
        [self configUI];
        
    }
    
    return self;
}

#pragma mark 布局UI
-(void)configUI{
    
    UIImageView * alert =[[UIImageView alloc]initWithFrame:CGRectMake(ZHFit(91), ZHFit(10), ZHFit(12), ZHFit(12))];
    alert.image=[UIImage imageNamed:@"i"];
    [self addSubview:alert];
    UILabel * label =[UILabel addLabelWithFrame:CGRectMake(alert.right+ZHFit(7),ZHFit(10), ZHFit(260), ZHFit(12)) title:@"额度根据您填写的信息智能计算得出" titleColor:UIColorWithRGB(0xbbbfc8,1.0) font:ZHFontLineSize(12)];
    [self addSubview:label];
    
    UIImageView * BG =[UIImageView addImaViewWithFrame:CGRectMake(0,self.height-ZHFit(150), ZHScreenW, ZHFit(150)) imageName:@"底部背景"];
    BG.userInteractionEnabled=YES;
    [self addSubview:BG];
    
    UILabel * conLabel =[UILabel addLabelWithFrame:CGRectMake(ZHFit(20),ZHFit(35),ZHScreenW-ZHFit(20), ZHFit(20)) title:@"恭喜您!" titleColor:UIColorWithRGB(0xffffff,1.0) font:ZHFontHeavy(20)];
    [BG addSubview:conLabel];
    
    UILabel * label2 =[UILabel addLabelWithFrame:CGRectMake(ZHFit(20),ZHFit(5)+conLabel.bottom, ZHScreenW-ZHFit(20), ZHFit(14)) title:@"根据评估您可借款额度为:" titleColor:UIColorWithRGB(0xffffff,1.0) font:ZHFontSize(14)];
    [BG addSubview:label2];
    
    UILabel * numberLabel =[UILabel addLabelWithFrame:CGRectMake(ZHFit(20),ZHFit(17)+label2.bottom,ZHScreenW-ZHFit(20), ZHFit(32)) title:@"0.00" titleColor:UIColorWithRGB(0xffffff,1.0) font:ZHFontBoldSize(40)];
    [BG addSubview:numberLabel];
    self.numberLabel =numberLabel;
    
    self.btn = [UIButton addButtonWithFrame:CGRectMake(ZHScreenW-ZHFit(15)-ZHFit(120), ZHFit(150)-ZHFit(65), ZHFit(120), ZHFit(40)) title:nil titleColor:nil font:nil image:@"不满意" highImage:@"不满意" backgroundColor:ZHClearColor tapAction:^(UIButton *button) {
        
        if (self.goToAction) {
            
            self.goToAction();
        }
    }];
    
    [BG addSubview:self.btn];
    
}
#pragma mark 刷新我的额度
-(void)reloadMoneyLabel:(NSString*)loan_mt{
    
    self.numberLabel.text =[NSString stringWithFormat:@"%.2f",[loan_mt floatValue]];
}

/*创建分享成功的页面*/
+(ZHLimitFooterView *)showLimitFooterViewWithFrame:(CGRect)frame GoToAction:(void(^)(void))goToBlock SuperView:(UIView*)superView{
    
   ZHLimitFooterView * footerView= [[ZHLimitFooterView alloc]initWithFrame:frame GoToAction:goToBlock];
    [superView addSubview:footerView];
    return footerView;
}
@end
