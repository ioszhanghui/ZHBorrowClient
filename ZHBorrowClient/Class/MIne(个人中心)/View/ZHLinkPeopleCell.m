//
//  ZHLinkPeopleCell.m
//  ZHBorrowClient
//
//  Created by 小飞鸟 on 2017/12/22.
//  Copyright © 2017年 小飞鸟. All rights reserved.
//

#import "ZHLinkPeopleCell.h"

@implementation ZHLinkPeopleCell
+(instancetype)dequeueReusableCellWithTableView:(UITableView*)tableView  Identifier:(NSString*)identifier{
    
    ZHLinkPeopleCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell==nil) {
        
        cell=[[ZHLinkPeopleCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
        cell.accessoryType=UITableViewCellAccessoryNone;
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    return cell;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
     
        CGFloat lineWidth =0.5;
        
        //第几个联系人
        self.titleLabel = [UILabel addLabelWithFrame:CGRectMake(ZHFit(15), 0, ZHFit(85), ZHFit(50)) title:@"联系人" titleColor:UIColorWithRGB(0x414141, 1.0) font:ZHFontBold(14)];
        //竖线
        [self.contentView addSubview:self.titleLabel];

        //右箭头
       UIImageView * rightArrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"向右"]];
        rightArrow.frame=CGRectMake(ZHScreenW-ZHFit(15)-ZHFit(6), (ZHFit(50)-ZHFit(11))/2, ZHFit(6), ZHFit(11));
        [self.contentView addSubview:rightArrow];
        //联系人关系
        ZHLableButton *detailLabel=[ZHLableButton addLabelWithFrame:CGRectMake(ZHFit(115), 0, ZHScreenW-ZHFit(30)-ZHFit(15)-self.titleLabel.right, ZHFit(50)) title:nil titleColor:UIColorWithRGB(0x5e5e5e, 1.0)  font:ZHFont_Detitle];
        self.detailLabel = detailLabel;
        self.detailLabel.textAlignment=NSTextAlignmentLeft;
        UITapGestureRecognizer * tap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(relationShipAction)];
        [self.detailLabel addGestureRecognizer:tap];
        self.detailLabel.backgroundColor=ZHClearColor;
        [self.contentView addSubview:detailLabel];
        
        UILabel * selectLabel =[UILabel addLabelWithFrame:CGRectMake(ZHFit(115), 0, ZHScreenW-ZHFit(30)-ZHFit(15)-self.titleLabel.right, ZHFit(50)) title:@"请选择" titleColor:UIColorWithRGB(0xc3c3c3, 1.0) font:ZHFont_Detitle];
        selectLabel.backgroundColor=ZHClearColor;
        selectLabel.textAlignment=NSTextAlignmentRight;
        [self.contentView addSubview:selectLabel];
        self.selectLabel= selectLabel;
        
        //联系人姓名
        self.nameLabel = [UILabel addLabelWithFrame:CGRectMake(ZHFit(15), self.titleLabel.bottom,  ZHFit(85), ZHFit(50)) title:@"姓名" titleColor:UIColorWithRGB(0x5e5e5e, 1.0) font:ZHFont_Detitle];
        [self.contentView addSubview:self.nameLabel];
        
        //联系人姓名输入框
        self.nameTextField = [UITextField addFieldWithFrame:CGRectMake(ZHFit(115), self.titleLabel.bottom, ZHFit(175), ZHFit(50)) placeholder:@"点击通讯录加载" delegate:self ];
        self.nameTextField.textAlignment=NSTextAlignmentCenter;
        [self.contentView addSubview:self.nameTextField];
        
        //联系人电话
        self.linkLabel = [UILabel addLabelWithFrame:CGRectMake(ZHFit(15), self.nameLabel.bottom,  ZHFit(85), ZHFit(50)) title:@"联系电话" titleColor:UIColorWithRGB(0x5e5e5e, 1.0) font:ZHFont_Detitle];
        [self.contentView addSubview:self.linkLabel];
        
        //联系人电话输入框
        self.linkTextField = [UITextField addFieldWithFrame:CGRectMake(ZHFit(115), self.nameLabel.bottom, ZHFit(175), ZHFit(50)) placeholder:@"点击通讯录加载" delegate:self ];
        self.linkTextField.textAlignment=NSTextAlignmentCenter;
        self.linkTextField.keyboardType=UIKeyboardTypeNumberPad;
        [self.contentView addSubview:self.linkTextField];
        //横线
        UIView * HC_line =[UIView CreateViewWithFrame:CGRectMake(ZHFit(15), ZHFit(50), ZHScreenW-ZHFit(15), lineWidth) BackgroundColor:ZHLineColor InteractionEnabled:YES];
        HC_line.backgroundColor=kSetUpCololor(243, 243, 243, 1.0);
        [self.contentView addSubview:HC_line];

        UIView * HD_line =[UIView CreateViewWithFrame:CGRectMake(0, ZHFit(100), ZHScreenW-ZHFit(85), lineWidth) BackgroundColor:ZHLineColor InteractionEnabled:YES];
        HD_line.backgroundColor=kSetUpCololor(243, 243, 243, 1.0);
        [self.contentView addSubview:HD_line];
        
        
        UIView * line =[UIView CreateViewWithFrame:CGRectMake(ZHFit(100), ZHFit(5), lineWidth, ZHFit(40)) BackgroundColor:ZHLineColor InteractionEnabled:YES];
        line.backgroundColor=kSetUpCololor(243, 243, 243, 1.0);
        [self.contentView addSubview:line];
        
        //通讯录按钮
        self.linkBtn=[UIButton addButtonWithFrame:CGRectMake(ZHScreenW-ZHFit(25)-ZHFit(30), ZHFit(50)+(ZHFit(100)-ZHFit(25))/2, ZHFit(25), ZHFit(25)) title:nil titleColor:nil font:nil image:@"通讯录" highImage:@"通讯录" backgroundColor:ZHClearColor tapAction:^(UIButton *button) {
            if (self.callAddressBookBlock) {
                self.callAddressBookBlock(self.indexPath);
            }            
        }];
        [self.contentView addSubview:self.linkBtn];
        
    }
    return self;
}

#pragma mark 点击关系的回调
-(void)relationShipAction{
    if (self.relationShipRecall) {
        self.relationShipRecall(self.indexPath);
    }
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    self.linkTextField.userInteractionEnabled= NULLString(self.linkTextField.text) ? NO: YES;
    self.nameTextField.userInteractionEnabled= NULLString(self.nameTextField.text) ? NO: YES;
}

@end
