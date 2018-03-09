//
//  BaseTableViewCell.h
//  ZHFinancialClient
//
//  Created by 正和 on 16/11/7.
//  Copyright © 2016年 正和. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZHLableButton.h"

@interface BaseTableViewCell : UITableViewCell

/*标题label*/
@property(nonatomic,strong)UILabel * titleLabel;

/*详情label*/
@property(nonatomic,strong) ZHLableButton * detailLabel;

/*初始化title*/
- (void)setUpTitleWithArr:(NSArray*)title IndexPath:(NSIndexPath*)indexPath;


+(instancetype)dequeueReusableCellWithTableView:(UITableView*)tableView  Identifier:(NSString*)identifier;

@end
