//
//  ZHApplyView.m
//  ZHLoanClient
//
//  Created by 小飞鸟 on 2017/10/21.
//  Copyright © 2017年 小飞鸟. All rights reserved.
//

#import "ZHApplyView.h"
@interface ZHApplyView()
/*申请条件*/
@property(nonatomic,strong)UILabel * desc;

@end

@implementation ZHApplyView

+(ZHApplyView*)shareApplyViewWIthModel:(ZHProductModel*)model{
    
    return [[ZHApplyView alloc]initWithFrame:CGRectMake(0, 0, ZHScreenW, ZHFit(390)) WIthModel:model];
}

-(instancetype)initWithFrame:(CGRect)frame WIthModel:(ZHProductModel*)model{
    if (self=[super initWithFrame:frame]) {
        
        self.backgroundColor=[UIColor whiteColor];
        UILabel*cLabel=[UILabel addLabelWithFrame:CGRectMake(ZHFit(23),ZHFit(25), ZHScreenW-ZHFit(23), ZHFit(14)) title:nil titleColor:UIColorWithRGB(0x848484,1.0) font:ZHFontLineSize(14)];
        cLabel.text=@"申请条件:";
        [self addSubview:cLabel];
        
        
        UILabel * desc=[UILabel addLabelWithFrame:CGRectMake(ZHFit(23),ZHFit(23)+cLabel.bottom, ZHScreenW-ZHFit(23)*2, ZHFit(300)) title:nil titleColor:UIColorWithRGB(0x383838,1.0) font:ZHFontLineSize(14)];
        desc.numberOfLines=0;
        desc.text=@"持中国人名居民身份证\n20-60周岁(以身份证日期为准)\n验证三方报告(运营商授权、征信报告、电商报告、芝麻分)";
       desc.attributedText= [ZHStringFilterTool setLabelSpacewithValue:desc.text withFont:desc.font LineHeight:10 TextAlignment:NSTextAlignmentLeft];
       desc.height= [ZHStringFilterTool getSpaceLabelHeight:desc.text withFont:desc.font  LineHeight:10 Range:CGSizeMake(ZHScreenW-ZHFit(23)*2, MAXFLOAT) TextAlignment:NSTextAlignmentLeft].height;
        self.desc=desc;
        [self addSubview:desc];
        
    }
    
    return self;
}

-(void)setProductModel:(ZHProductModel *)productModel{
    _productModel=productModel;
    self.desc.text=[productModel.product_apply_info stringByReplacingOccurrencesOfString:@"\\" withString:@"\n"];
    self.desc.attributedText= [ZHStringFilterTool setLabelSpacewithValue:self.desc.text withFont:self.desc.font LineHeight:10 TextAlignment:NSTextAlignmentLeft];
    self.desc.height= [ZHStringFilterTool getSpaceLabelHeight:self.desc.text withFont:self.desc.font  LineHeight:10 Range:CGSizeMake(ZHScreenW-ZHFit(23)*2, MAXFLOAT) TextAlignment:NSTextAlignmentLeft].height;
}

@end
