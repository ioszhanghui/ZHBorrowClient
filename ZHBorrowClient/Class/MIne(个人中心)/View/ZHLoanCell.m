//
//  ZHLoanCell.m
//  ZHBorrowClient
//
//  Created by 小飞鸟 on 2017/12/22.
//  Copyright © 2017年 小飞鸟. All rights reserved.
//

#import "ZHLoanCell.h"
#import "ZHProductModel.h"

@interface ZHLoanCell()
/*LOGO*/
@property(nonatomic,strong)UIImageView * logoView;
/*名字*/
@property(nonatomic,strong)UILabel * nameLabel;
/*名字*/
@property(nonatomic,strong)UILabel * desLabel;
/*额度*/
@property(nonatomic,strong)UILabel * mountLabel;
/*去体现 或者已申请*/
@property(nonatomic,strong)UIButton * cashBtn;
@end

@implementation ZHLoanCell

+(instancetype)dequeueReusableCellWithTableView:(UITableView*)tableView  Identifier:(NSString*)identifier{
    
    ZHLoanCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell==nil) {
        
        cell=[[ZHLoanCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
        cell.accessoryType=UITableViewCellAccessoryNone;
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    return cell;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.logoView=[UIImageView addImaViewWithFrame:CGRectMake(ZHFit(15), ZHFit(10), ZHFit(60), ZHFit(60)) imageName:@"缺省图"];
        [self.contentView addSubview:self.logoView];
       
        self.nameLabel=[UILabel addLabelWithFrame:CGRectMake(self.logoView.right+ZHFit(20), self.logoView.top+ZHFit(5), ZHFit(280), ZHFit(14)) title:@"动感地贷-校园贷" titleColor:UIColorWithRGB(0x414141, 1.0) font: ZHFontHeavy(14)];
        [self.contentView addSubview:self.nameLabel];
        
        self.desLabel = [UILabel addLabelWithFrame:CGRectMake(self.logoView.right+ZHFit(20), self.nameLabel.bottom+ZHFit(4), ZHFit(280), ZHFit(12)) title:@"期限:  24期   年利率:  36%" titleColor:UIColorWithRGB(0x5e5e5e,0.6) font: ZHFontLineSize(12)];
        [self.contentView addSubview:self.desLabel];
        
        self.mountLabel = [UILabel addLabelWithFrame:CGRectMake(self.logoView.right+ZHFit(20), self.desLabel.bottom+ZHFit(7), ZHFit(280), ZHFit(13)) title:@"额度: 1000.00" titleColor:ZHThemeColor font:ZHFontLineSize(12)];
        
        [self.contentView addSubview:self.mountLabel];
        
       self.mountLabel.attributedText= [ZHStringFilterTool setLabelSpacewithValue:self.mountLabel.text withNumberFont:ZHFontLineSize(12) Range:NSMakeRange(0, 3) TextFont:ZHFontBoldSize(20) TextRange:NSMakeRange(3, self.mountLabel.text.length-3)];
        
        self.cashBtn=[UIButton addButtonWithFrame:CGRectMake(ZHScreenW-ZHFit(12)-ZHFit(82), (ZHFit(83)-ZHFit(31))/2, ZHFit(82), ZHFit(31)) title:nil titleColor:nil font:nil image:@"已申请" highImage:@"已申请" backgroundColor:ZHClearColor tapAction:^(UIButton *button) {
            
            if (self.LoanDidClick) {
                self.LoanDidClick(self.model);
            }
        }];
        [self.contentView addSubview:self.cashBtn];
        
    }
    return self;
}
#pragma mark 重置按钮
-(void)resetBtn{
    [self.cashBtn setImage:[UIImage imageNamed:@"去提现"] forState:UIControlStateNormal];
}

#pragma mark 初始化数据
-(void)setModel:(ZHProductModel *)model{
    _model=model;
    
    //LOGO
    [self.logoView sd_setImageWithURL:[ZHStringFilterTool appendUrlString:model.product_icon_path] placeholderImage:[UIImage imageNamed:@"缺省图"] options:SDWebImageRefreshCached];
    self.nameLabel.text = model.product_name;
    self.desLabel.text = [NSString stringWithFormat:@"期限:  %@   利率:  %@",model.term,model.product_month_rate];
    self.mountLabel.text =[NSString stringWithFormat:@"额度: %.2f",[model.user_average_money floatValue]];
    self.mountLabel.attributedText= [ZHStringFilterTool setLabelSpacewithValue:self.mountLabel.text withNumberFont:ZHFontLineSize(12) Range:NSMakeRange(0, 3) TextFont:ZHFontBoldSize(20) TextRange:NSMakeRange(3, self.mountLabel.text.length-3)];
}

@end
