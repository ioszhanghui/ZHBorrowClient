//
//  ZHAuthCell.m
//  ZHBorrowClient
//
//  Created by 小飞鸟 on 2017/12/20.
//  Copyright © 2017年 小飞鸟. All rights reserved.
//

#import "ZHAuthCell.h"

@implementation ZHAuthCell

//创建cell
+(instancetype)dequeueReusableCellWithTableView:(UITableView*)tableView  Identifier:(NSString*)identifier{
    
    ZHAuthCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell==nil) {
        
        cell=[[ZHAuthCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
        cell.accessoryType=UITableViewCellAccessoryNone;
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    return cell;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        
        self.backgroundColor=ZHClearColor;
        self.content=[[UIImageView alloc]initWithFrame:CGRectMake(ZHFit(20), ZHFit(10), ZHScreenW-ZHFit(20)*2, ZHFit(92))];
        self.content.userInteractionEnabled=YES;
        self.content.image=[UIImage imageNamed:@"底背景"];
        [self.contentView addSubview:self.content];
        
        self.titleLabel=[UILabel addLabelWithFrame:CGRectMake(ZHFit(24), ZHFit(28), ZHFit(79), ZHFit(18)) title:@"基本信息" titleColor:[UIColor whiteColor] font:ZHFontHeavy(18)];
        [self.content addSubview:self.titleLabel];
        
        self.markView =[[UIImageView alloc]initWithFrame:CGRectMake(self.titleLabel.right+ZHFit(4), ZHFit(28), ZHFit(51), ZHFit(15))];
        self.markView.image=[UIImage imageNamed:@"必选项"];
        [self.content addSubview:self.markView];
        self.markView.y=self.titleLabel.bottom-ZHFit(15);
        
        
        self.detailLabel =[UILabel addLabelWithFrame:CGRectMake(ZHFit(24), self.titleLabel.bottom +ZHFit(8), ZHFit(184), ZHFit(18)) title:@"基本信息" titleColor:[UIColor whiteColor] font:ZHFontSize(12)];
        self.detailLabel.alpha=0.6;
        [self.content addSubview:self.detailLabel];
        
        self.authBtn = [UIButton addButtonWithFrame:CGRectMake(self.content.width-ZHFit(15)-ZHFit(82), ZHFit(31), ZHFit(82), ZHFit(30)) title:@"去认证" titleColor:UIColorWithRGB(0x292c48, 1.0) font:ZHFontSize(14) image:nil highImage:nil backgroundColor:ZHClearColor tapAction:^(UIButton *button) {
                  if (self.authAction) {
                      self.authAction(self.indexPath);
                  }
        }];
        [self.authBtn setBackgroundImage:[UIImage imageNamed:@"btnBg"] forState:UIControlStateNormal];
        [self.content addSubview:self.authBtn];
        
        self.authStatusView =[[UIImageView alloc]initWithFrame:CGRectMake(self.content.width-ZHFit(73), 0, ZHFit(73), ZHFit(32))];
        self.authStatusView.image=[UIImage imageNamed:@"已认证"];
        [self.content addSubview:self.authStatusView];
        
    }
    return self;
}

/*初始化CEll*/
-(void)setCellWithLargeTitles:(NSArray*)largeTitles SmallTitle:(NSArray*)smallTitles AtIndexPath:(NSIndexPath*)indexPath StatusArray:(NSArray*)statusArr{
    
    self.titleLabel.text=[largeTitles objectAtIndex:indexPath.row];
    self.detailLabel.text=[smallTitles objectAtIndex:indexPath.row];
    NSArray * auths=@[@"去认证",@"去完善",@"去完善",@"去认证"];
    [self.authBtn setTitle:[auths objectAtIndex:indexPath.row] forState:UIControlStateNormal];
    self.markView.hidden = indexPath.row==0 ? NO:YES;
    self.authBtn.hidden = [[statusArr objectAtIndex:indexPath.row] isEqualToString:@"1"]? YES:NO;
    self.authStatusView.hidden = [[statusArr objectAtIndex:indexPath.row] isEqualToString:@"1"]? NO:YES;
}

@end
