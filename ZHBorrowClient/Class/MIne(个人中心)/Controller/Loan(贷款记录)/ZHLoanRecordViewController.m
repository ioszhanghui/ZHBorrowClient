//
//  ZHLoanRecordViewController.m
//  ZHBorrowClient
//
//  Created by 小飞鸟 on 2017/12/22.
//  Copyright © 2017年 小飞鸟. All rights reserved.
//

#import "ZHLoanRecordViewController.h"
#import <MJRefresh.h>
#import "ZHNoContentView.h"
#import "ZHProductModel.h"

@interface ZHLoanRecordViewController ()

@end

@implementation ZHLoanRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title=@"贷款记录";
    [self setupTableView];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor] size:CGSizeMake(ZHScreenW, StatusBarHeight+self.navigationController.navigationBar.height)] forBarMetrics:UIBarMetricsDefault];
}

//重写创建tableView
- (void)setupTableView{
    
    UITableView *tableView = [UITableView initWithTableView:CGRectMake(0, 0, ZHScreenW, ZHScreenH- StatusBarHeight-self.navigationController.navigationBar.height) withDelegate:self];
    self.tableView = tableView;
    tableView.sectionHeaderHeight = 0.01;
    tableView.sectionFooterHeight=ZHFit(10);
    tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    tableView.separatorColor=kSetUpCololor(243, 243, 243, 1.0);
    tableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:tableView];
    //去掉头部留白
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 0.001)];
    view.backgroundColor = [UIColor redColor];
    self.tableView.tableHeaderView = view;
    
    self.tableView.mj_header = [MJRefreshStateHeader  headerWithRefreshingBlock:^{
        
        currentPage=1;
        [self.titles removeAllObjects];
        [self LoanListRequest];
    }];
    
    [self.tableView.mj_header beginRefreshing];
    
    //MJRefreshAutoNormalFooter 才可以显示出来 没有更多了
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        [self LoanListRequest];
    }];
    self.tableView.mj_footer.automaticallyHidden=YES;
    
    [UIView addLineWithFrame:CGRectMake(0, 0, ZHScreenW, 0.5) WithView:self.view];
}

#pragma mark tableview代理方法
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ZHLoanCell * cell =[ZHLoanCell dequeueReusableCellWithTableView:tableView Identifier:@"loan"];
    cell.indexPath=indexPath;
    if (self.titles.count>indexPath.row) {
        cell.model=[self.titles objectAtIndex:indexPath.row];
    }
    cell.LoanDidClick = ^(ZHProductModel * model) {
        
    };
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return ZHFit(83);
}

//设置分割线上下去边线，
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    UIEdgeInsets UIEgde = UIEdgeInsetsMake(0, ZHFit(12), 0, ZHFit(12));
    [cell setSeparatorInset:UIEgde];
}

#pragma mark 贷款列表请求
-(void)LoanListRequest{
    
    NSDictionary * params=@{
                            @"page_index":@(currentPage),
                            @"page_size":@"10",
                            @"cust_no":[UserTool GetUser].custno
                            };
    
    NSLog(@"筛选条件****%@",params);
    [HttpTool PostWithPath:@"/YJJQWebService/GetLoanList.spring" params:params success:^(id json) {
        [self.tableView.mj_footer endRefreshing];
        [self.tableView.mj_header endRefreshing];
        NSLog(@"贷款记录****%@",json);
        if ([[json objectForKey:@"code"]isEqualToString:@"200"]) {
            
            self.totalPage=[[[json objectForKey:@"data"] objectForKey:@"total_page"] integerValue];
            [self.titles addObjectsFromArray:[ZHProductModel mj_objectArrayWithKeyValuesArray:[[json objectForKey:@"data"] objectForKey:@"list"]]];
            [self.tableView reloadData];
            if (self.titles.count>0&&(currentPage==self.totalPage)) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
            [[ZHNoContentView shareNoContentView] removeEmptyView];//移除占位视图
            self.tableView.mj_footer.hidden= (self.tableView.contentSize.height<self.tableView.frame.size.height&& self.totalPage==1)? YES :NO;
            currentPage++;
            
        } else if([[json objectForKey:@"code"]isEqualToString:@"400"]){
        
            [[ZHNoContentView shareNoContentView] showEmptyViewWithType:1 InSuperView:self.tableView BackAction:^{
                [self.navigationController popViewControllerAnimated:YES];
            }];
        }
        
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"加载失败"];
        [self.tableView.mj_footer endRefreshing];
        [self.tableView.mj_header endRefreshing];
    }];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (self.RecallBlock) {
                self.RecallBlock();
            }
    });
}

@end
