//
//  BaseTableViewCell.m
//  ZHFinancialClient
//
//  Created by 正和 on 16/11/7.
//  Copyright © 2016年 正和. All rights reserved.
//

#import "ZHProductTableViewCell.h"
@interface ZHProductTableViewCell()

/*图标*/
@property(nonatomic,strong)UIImageView * iconImageView;
/*标题*/
@property(nonatomic,strong)UILabel * titleLabel;
/*额度*/
@property(nonatomic,strong)UILabel * limitLabel;
/*时间*/
@property(nonatomic,strong)UILabel * dayLabel;
/*描述*/
@property(nonatomic,strong)UILabel * descLabel;
/*额度高*/
@property(nonatomic,strong)UILabel * highLabel;
/*下款快*/
@property(nonatomic,strong)UILabel * speedLabel;

@property(nonatomic,assign)Cell_Type type;
@end

@implementation ZHProductTableViewCell

//创建cell
+(instancetype)dequeueReusableCellWithTableView:(UITableView*)tableView  Identifier:(NSString*)identifier CellType:(Cell_Type)type{
    
    ZHProductTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell==nil) {
        
        cell=[[ZHProductTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier CellType:type] ;
        cell.accessoryType=UITableViewCellAccessoryNone;
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }

    return cell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier CellType:(Cell_Type)type
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.iconImageView=[UIImageView addImaViewWithFrame:CGRectMake(ZHFit(17), ZHFit(10), ZHFit(60), ZHFit(60)) imageName:nil];
        self.iconImageView.layer.cornerRadius=ZHFit(6);
        [self.contentView addSubview:self.iconImageView];
        
        //cell背景色
        self.backgroundColor = [UIColor whiteColor];
        self.titleLabel=[UILabel addLabelWithFrame:CGRectMake(ZHFit(12)+self.iconImageView.right, ZHFit(15), ZHFit(15), ZHFit(15)) title:nil titleColor:UIColorWithRGB(0x383838,1.0) font:ZHFont_Title];
        self.titleLabel.textAlignment=NSTextAlignmentLeft;
        self.titleLabel.backgroundColor=ZHClearColor;
        [self.contentView addSubview:self.titleLabel];
       self.titleLabel.width= [ZHStringFilterTool computeTextSizeHeight:self.titleLabel.text Range:CGSizeMake(1000, ZHFit(15)) FontSize:self.titleLabel.font].width;

        
        self.limitLabel=[UILabel addLabelWithFrame:CGRectMake(ZHFit(12)+self.iconImageView.right,self.titleLabel.bottom+ ZHFit(8), ZHFit(15), ZHFit(13)) title:nil titleColor:UIColorWithRGB(0x383838,1.0) font:ZHFontLineSize(14)];
        self.limitLabel.textAlignment=NSTextAlignmentLeft;
        [self.contentView addSubview:self.limitLabel];

        
        self.dayLabel=[UILabel addLabelWithFrame:CGRectMake(ZHFit(19)+self.limitLabel.right,self.titleLabel.bottom+ ZHFit(8), ZHFit(15), ZHFit(13)) title:nil titleColor:UIColorWithRGB(0x383838,1.0) font:ZHFontLineSize(14)];
        self.dayLabel.textAlignment=NSTextAlignmentLeft;
        [self.contentView addSubview:self.dayLabel];

        self.descLabel=[UILabel addLabelWithFrame:CGRectMake(ZHFit(12)+self.iconImageView.right, self.limitLabel.bottom+ ZHFit(6), ZHFit(15), ZHFit(12)) title:nil titleColor:UIColorWithRGB(0xc3c3c3,1.0) font:ZHFontLineSize(12)];
        self.descLabel.textAlignment=NSTextAlignmentLeft;
        self.descLabel.backgroundColor=ZHClearColor;
        self.descLabel.width=ZHScreenW-self.descLabel.left-ZHFit(12);
        [self.contentView addSubview:self.descLabel];
        self.type=type;
        
        if (type==Product_Detail) {
            
            self.iconImageView.y=ZHFit(20);
            self.titleLabel.y=ZHFit(32);
            self.highLabel.y=ZHFit(32);
            self.speedLabel.y=ZHFit(32);
            self.descLabel.y = self.titleLabel.bottom+ZHFit(8);
            [self.dayLabel removeFromSuperview];
            [self.limitLabel removeFromSuperview];
        }
        
    
    }
    return self;
}

-(void)setProductModel:(ZHProductModel *)productModel{
    _productModel=productModel;
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/YJJQWebService%@",[UserTool objectForKey:@"Base_Url"],productModel.product_icon_path]]];
    
    NSLog(@"贷款超市***%@",[NSString stringWithFormat:@"%@/YJJQWebService%@",[UserTool objectForKey:@"Base_Url"],productModel.product_icon_path]);
    
    self.limitLabel.text =[NSString stringWithFormat:@"额度: %@-%@元",productModel.product_min_amount,productModel.product_max_amount];
    self.dayLabel.text=[NSString stringWithFormat:@"期限: %@",productModel.term];
    self.descLabel.text=productModel.product_detail;
    
    self.titleLabel.text=productModel.product_name;
    self.titleLabel.width= [ZHStringFilterTool computeTextSizeHeight:self.titleLabel.text Range:CGSizeMake(1000, ZHFit(15)) FontSize:self.titleLabel.font].width;
    
    self.limitLabel.width= [ZHStringFilterTool computeTextSizeHeight:self.limitLabel.text Range:CGSizeMake(MAXFLOAT, ZHFit(13)) FontSize:self.limitLabel.font].width;
    self.limitLabel.attributedText= [ZHStringFilterTool setLabelSpacewithValue:self.limitLabel.text withFont:self.limitLabel.font LineHeight:0 TextAlignment:NSTextAlignmentLeft RangeColor:UIColorWithRGB(0x848484, 1.0) Range:NSMakeRange(0, 2)];
    
    self.dayLabel.width= [ZHStringFilterTool computeTextSizeHeight:self.dayLabel.text Range:CGSizeMake(MAXFLOAT, ZHFit(13)) FontSize:self.dayLabel.font].width;
    self.dayLabel.attributedText= [ZHStringFilterTool setLabelSpacewithValue:self.dayLabel.text withFont:self.dayLabel.font LineHeight:0 TextAlignment:NSTextAlignmentLeft RangeColor:UIColorWithRGB(0x848484, 1.0) Range:NSMakeRange(0, 2)];
    self.dayLabel.x=ZHFit(19)+self.limitLabel.right;
    

    
    [self.highLabel removeFromSuperview];
    [self.speedLabel removeFromSuperview];
    if (NULLString(productModel.product_flag)) {
        return;
    }
    
    NSArray * titles=[productModel.product_flag componentsSeparatedByString:@","];

    [[self.contentView viewWithTag:3000]removeFromSuperview];
    [[self.contentView viewWithTag:3001]removeFromSuperview];
    [self.highLabel removeFromSuperview];
    [self.speedLabel removeFromSuperview];
    
    for(NSInteger i=0;i<titles.count;i++){
        UILabel * label = [UILabel addLabelWithFrame:CGRectMake(ZHFit(15)+self.titleLabel.right, ZHFit(15), ZHFit(40), ZHFit(15)) title:nil titleColor:[UIColor whiteColor] font:ZHFontSize(11)];
        label.textAlignment=NSTextAlignmentCenter;
        label.layer.cornerRadius=2;
        label.text=[titles objectAtIndex:i];
        label.tag=3000+i;
        label.width= [ZHStringFilterTool computeTextSizeHeight:label.text Range:CGSizeMake(1000, ZHFit(15)) FontSize:label.font].width+4;
        
        if (i==0) {
            label.backgroundColor=UIColorWithRGB(0xff2244, 1.0);
            self.highLabel=label;
        }else{
            label.backgroundColor=UIColorWithRGB(0xfbaa1c, 1.0);
            self.speedLabel=label;
            self.speedLabel.frame= CGRectMake(ZHFit(5)+self.highLabel.right, ZHFit(15), label.width, ZHFit(15));
        }
        
        if (self.type==Product_Detail) {
            label.y=ZHFit(32);
        }
        
        if (label.width<ZHFit(40)) {
            label.width=ZHFit(40);
        }
        
        [self.contentView addSubview:label];
    }

}


@end
