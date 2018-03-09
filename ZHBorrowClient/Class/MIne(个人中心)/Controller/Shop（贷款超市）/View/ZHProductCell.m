//
//  ZHProductCell.m
//  ZHLoanClient
//
//  Created by 小飞鸟 on 2017/10/21.
//  Copyright © 2017年 小飞鸟. All rights reserved.
//

#import "ZHProductCell.h"
#import "ZHProductModel.h"

@interface ZHProductCell()

/*额度*/
@property(nonatomic,strong)UILabel * limitLabel;
/*时间*/
@property(nonatomic,strong)UILabel * dayLabel;
/*费率*/
@property(nonatomic,strong)UILabel * feeLabel;
/*优势*/
@property(nonatomic,strong)UILabel * advanceLabel;


@end

@implementation ZHProductCell
//创建cell
+(instancetype)dequeueReusableCellWithTableView:(UITableView*)tableView  Identifier:(NSString*)identifier{
    
    ZHProductCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell==nil) {
        
        cell=[[ZHProductCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
        cell.accessoryType=UITableViewCellAccessoryNone;
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    
    return cell;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.limitLabel=[UILabel addLabelWithFrame:CGRectMake(ZHFit(23), ZHFit(25), ZHScreenW-ZHFit(23)*2, ZHFit(14)) title:nil titleColor:UIColorWithRGB(0x383838,1.0) font:ZHFontLineSize(14)];
        self.limitLabel.textAlignment=NSTextAlignmentLeft;
        [self.contentView addSubview:self.limitLabel];
 
        self.dayLabel=[UILabel addLabelWithFrame:CGRectMake(ZHFit(23), ZHFit(17)+self.limitLabel.bottom, ZHScreenW-ZHFit(23)*2, ZHFit(14)) title:nil titleColor:UIColorWithRGB(0x383838,1.0) font:ZHFontLineSize(14)];
        self.dayLabel.textAlignment=NSTextAlignmentLeft;
        [self.contentView addSubview:self.dayLabel];

        self.feeLabel=[UILabel addLabelWithFrame:CGRectMake(ZHFit(23),ZHFit(17)+self.dayLabel.bottom, ZHScreenW-ZHFit(23), ZHFit(14)) title:nil titleColor:UIColorWithRGB(0x383838,1.0) font:ZHFontLineSize(14)];
        self.feeLabel.textAlignment=NSTextAlignmentLeft;
        [self.contentView addSubview:self.feeLabel];

        
        self.advanceLabel=[UILabel addLabelWithFrame:CGRectMake(ZHFit(23), ZHFit(17)+self.feeLabel.bottom, ZHScreenW-ZHFit(23), ZHFit(14)) title:nil titleColor:UIColorWithRGB(0x383838,1.0) font:ZHFontLineSize(14)];
        self.advanceLabel.textAlignment=NSTextAlignmentLeft;
        [self.contentView addSubview:self.advanceLabel];

    }
    
    return self;
    
}

-(void)setProductModel:(ZHProductModel *)productModel{
    _productModel=productModel;
    self.limitLabel.text =[NSString stringWithFormat:@"额度范围: %@-%@元",productModel.product_min_amount,productModel.product_max_amount];
    self.dayLabel.text=[NSString stringWithFormat:@"借款期限: %@",productModel.term];
     self.feeLabel.text=[NSString stringWithFormat:@"月税率: %@",productModel.product_month_rate];
    self.advanceLabel.text=[NSString stringWithFormat:@"产品优势: %@",productModel.product_advantage];
    self.limitLabel.attributedText= [ZHStringFilterTool setLabelSpacewithValue:self.limitLabel.text withFont:self.limitLabel.font LineHeight:0 TextAlignment:NSTextAlignmentLeft RangeColor:UIColorWithRGB(0x848484, 1.0) Range:NSMakeRange(0, 5)];
    self.dayLabel.attributedText= [ZHStringFilterTool setLabelSpacewithValue:self.dayLabel.text withFont:self.dayLabel.font LineHeight:0 TextAlignment:NSTextAlignmentLeft RangeColor:UIColorWithRGB(0x848484, 1.0) Range:NSMakeRange(0, 5)];
    self.feeLabel.attributedText= [ZHStringFilterTool setLabelSpacewithValue:self.feeLabel.text withFont:self.feeLabel.font LineHeight:0 TextAlignment:NSTextAlignmentLeft RangeColor:UIColorWithRGB(0x848484, 1.0) Range:NSMakeRange(0, 4)];
    self.advanceLabel.attributedText= [ZHStringFilterTool setLabelSpacewithValue:self.advanceLabel.text withFont:self.advanceLabel.font LineHeight:0 TextAlignment:NSTextAlignmentLeft RangeColor:UIColorWithRGB(0x848484, 1.0) Range:NSMakeRange(0, 5)];
}


@end
