//
//  ZHLoanCell.h
//  ZHBorrowClient
//
//  Created by 小飞鸟 on 2017/12/22.
//  Copyright © 2017年 小飞鸟. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZHProductModel;

@interface ZHLoanCell : UITableViewCell
/*去提现的按钮点击*/
@property(nonatomic,copy)void(^LoanDidClick)(ZHProductModel * model);
/*每一个cell对应的索引*/
@property(nonatomic,strong)NSIndexPath * indexPath;
/*创建Cell*/
+(instancetype)dequeueReusableCellWithTableView:(UITableView*)tableView  Identifier:(NSString*)identifier;
/*初始化Model*/
@property(nonatomic,strong)ZHProductModel * model;

/*重置按钮*/
-(void)resetBtn;

@end
