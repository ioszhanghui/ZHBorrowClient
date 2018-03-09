//
//  ZHMineHeader.m
//  ZHBorrowClient
//
//  Created by 小飞鸟 on 2017/12/18.
//  Copyright © 2017年 小飞鸟. All rights reserved.
//

#import "ZHMineHeader.h"

@interface ZHMineHeader()
/*头像*/
@property(nonatomic,strong) UIImageView * headerImage;
/*手机号*/
@property(nonatomic,strong)UILabel * phoneLabel;
/*姓名*/
@property(nonatomic,strong)UILabel * nameLabel;
@end

@implementation ZHMineHeader
+(ZHMineHeader*)createMineTableViewHeaderWithTableView:(UITableView*)tableView HeadImageClick:(void(^)(void))ImageClick{
    
    ZHMineHeader * header =[[ZHMineHeader alloc]initWithFrame:CGRectMake(0, 0, ZHScreenW, ZHFit(315)) HeadImageClick:ImageClick];    
    return header;
}

-(instancetype)initWithFrame:(CGRect)frame  HeadImageClick:(void(^)(void))ImageClick{
    
    if (self=[super initWithFrame:frame]) {
        
        self.image=[UIImage imageNamed:@"meBG"];
        self.userInteractionEnabled=YES;
        
        self.HeaderImageClick=ImageClick;
        
        self.contentView=[UIView CreateViewWithFrame:self.bounds BackgroundColor:[UIColor clearColor] InteractionEnabled:YES];
        [self addSubview:self.contentView];
        
        self.headerImage=[[UIImageView alloc]initWithFrame:CGRectMake((ZHScreenW-ZHFit(70))/2, ZHFit(77)+StatusBarHeight, ZHFit(70), ZHFit(70))];
        self.headerImage.image=[UIImage imageNamed:@"我的"];
        self.headerImage.userInteractionEnabled=YES;
        UITapGestureRecognizer * tap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(ClickImageAction)];
        [self.headerImage addGestureRecognizer:tap];
        [self.contentView addSubview:self.headerImage];
        
        self.nameLabel=[UILabel addLabelWithFrame:CGRectMake(0, self.headerImage.bottom+ZHFit(30), ZHScreenW, ZHFit(20)) title:@"王健林" titleColor:[UIColor whiteColor] font:ZHFontSemibold(20)];
        self.nameLabel.textAlignment=NSTextAlignmentCenter;
        [self.contentView addSubview:self.nameLabel];

        self.phoneLabel=[UILabel addLabelWithFrame:CGRectMake(0, self.nameLabel.bottom+ZHFit(7), ZHScreenW, ZHFit(14)) title:@"13552188475" titleColor:[UIColor whiteColor] font:ZHFontSize(14)];
        self.phoneLabel.textAlignment=NSTextAlignmentCenter;
        [self.contentView addSubview:self.phoneLabel];
   
    }
    
    return self;
    
}

#pragma mark 头像点击
-(void)ClickImageAction{
    if (self.HeaderImageClick) {
        self.HeaderImageClick();
    }
}

/*登录之后刷新数据*/
-(void)refreshData{
    
    self.nameLabel.text=[UserTool GetUser].realname;
    self.phoneLabel.text=[UserTool GetUser].phoneno;
}

#pragma mark 处理手机号码
-(NSString*)dealPhoneNumber:(NSString*)phone{
    if (NULLString(phone)||phone.length !=11) {
        return @"";
    }
    return [NSString stringWithFormat:@"%@****%@",[phone  substringToIndex:3],[phone  substringFromIndex:7]];
}

@end
