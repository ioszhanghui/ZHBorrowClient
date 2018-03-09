//
//  BaseTableViewCell.h
//  ZHFinancialClient
//
//  Created by 正和 on 16/11/7.
//  Copyright © 2016年 正和. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZHProductModel.h"

typedef enum : NSUInteger {
    Product,
    Product_Detail,
} Cell_Type;

@interface ZHProductTableViewCell : UITableViewCell

+(instancetype)dequeueReusableCellWithTableView:(UITableView*)tableView  Identifier:(NSString*)identifier CellType:(Cell_Type)type;

/*产品Model*/
@property(nonatomic,strong)ZHProductModel * productModel;

@end
