//
//  ZHMineHeader.h
//  ZHBorrowClient
//
//  Created by 小飞鸟 on 2017/12/18.
//  Copyright © 2017年 小飞鸟. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZHMineHeader : UIImageView
/*头像点击*/
@property(nonatomic,copy)void(^ HeaderImageClick)(void);
//控件内容
@property(nonatomic,strong)UIView * contentView;

/*创建TableView*/
+(ZHMineHeader*)createMineTableViewHeaderWithTableView:(UITableView*)tableView HeadImageClick:(void(^)(void))ImageClick;

/*登录之后刷新数据*/
-(void)refreshData;

@end
