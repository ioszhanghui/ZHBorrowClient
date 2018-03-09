//
//  UITableView+Extension.m
//  魔颜
//
//  Created by Meiyue on 16/4/9.
//  Copyright © 2016年 Meiyue. All rights reserved.
//

#import "UITableView+Extension.h"
#import "ZHNoContentView.h"

@implementation UITableView (Extension)
/** 默认 */
+ (UITableView *)initWithTableView:(CGRect)frame withDelegate:(id)delegate
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
    tableView.delegate = delegate;
    tableView.dataSource = delegate;
    tableView.tableFooterView = [[UIView alloc] init];
    return tableView;
}

+ (UITableView *)initWithGroupTableView:(CGRect)frame withDelegate:(id)delegate
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStyleGrouped];
    tableView.delegate = delegate;
    tableView.dataSource = delegate;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.showsVerticalScrollIndicator = NO;
    return tableView;
}

@end
