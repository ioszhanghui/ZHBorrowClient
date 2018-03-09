//
//  ZHApplyView.h
//  ZHLoanClient
//
//  Created by 小飞鸟 on 2017/10/21.
//  Copyright © 2017年 小飞鸟. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZHProductModel.h"

@interface ZHApplyView : UIView

+(ZHApplyView*)shareApplyViewWIthModel:(ZHProductModel*)model;

/*产品Model*/
@property(nonatomic,strong)ZHProductModel * productModel;

@end
