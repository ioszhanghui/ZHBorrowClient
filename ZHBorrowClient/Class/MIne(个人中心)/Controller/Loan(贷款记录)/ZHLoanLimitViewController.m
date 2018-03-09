//
//  ZHLoanLimitViewController.m
//  ZHBorrowClient
//
//  Created by 小飞鸟 on 2017/12/22.
//  Copyright © 2017年 小飞鸟. All rights reserved.
//

#import "ZHLoanLimitViewController.h"
#import "ZHLimitFooterView.h"
#import "ZHLoanCell.h"
#import <MJRefresh.h>
#import "LoginSuccessView.h"
#import "ZHShopViewController.h"
#import "ZHProductModel.h"

@implementation ZHLoanLimitViewController{
    /*底部视图*/
    ZHLimitFooterView * limitFooter;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self resetNaviBar];
    [self setupTableView];
    [self resetWhiteNaviBar];
    
    limitFooter = [ZHLimitFooterView showLimitFooterViewWithFrame:CGRectMake(0, ZHScreenH-ZHFit(187)-StatusBarHeight-self.navigationController.navigationBar.height, ZHScreenW, ZHFit(187)) GoToAction:^{
        [LoginSuccessView shareLoginSuccessViewWithFrame:[UIScreen mainScreen].bounds Type:MatchResult  CancelAction:^{

        } SureAction:^{
            
           ZHShopViewController * VC = [ZHShopViewController new];
           [self.navigationController pushViewController:VC animated:YES];
        }];

    } SuperView:self.view];
    
    self.tableView.height=ZHScreenH-StatusBarHeight-self.navigationController.navigationBar.height-ZHFit(187);
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    // 禁用返回手势
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    // 开启返回手势
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}


//重写创建tableView
- (void)setupTableView{
    
    UITableView *tableView = [UITableView initWithTableView:self.view.bounds withDelegate:self];
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
        
        [self.titles removeAllObjects];
        [self LoanListRequest];
    }];
    
    [self.tableView.mj_header beginRefreshing];
}


#pragma mark tableview代理方法
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ZHLoanCell * cell =[ZHLoanCell dequeueReusableCellWithTableView:tableView Identifier:@"loan"];
    cell.indexPath=indexPath;
    [cell resetBtn];
    cell.model =[self.titles objectAtIndex:indexPath.row];
    cell.LoanDidClick = ^(ZHProductModel * model) {
        /*去提现接口*/
        [self rightNowWithdrawCash:model];
        
        [self TalkingDataAndUMData:model];
    };
    return cell;
}


#pragma mark talkingData 和友盟的统计分析
-(void)TalkingDataAndUMData:(ZHProductModel*)model{
    /*立即申请的点击统计*/
    // 例如下面代码pruchase为事件ID，而type，quantity为属性信息。
    NSDictionary *dict = @{@"product_name":model.product_name};
    [MobClick event:@"Apply_Immediately" attributes:dict];
    
    [TalkingData trackEvent:@"Apply_Immediately" label: @"立即申请" parameters:dict];
}


#pragma mark 点击立即提现
-(void)rightNowWithdrawCash:(ZHProductModel*)model{
    
    NSDictionary * params=@{
                            @"pro_id":model.ID,
                            @"cust_no":[UserTool GetUser].custno
                            };
    
    [HttpTool PostWithPath:@"/YJJQWebService/CommitLoan.spring" params:params success:^(id json) {
    
        NSLog(@"去提现接口****%@",json);
        if ([[json objectForKey:@"code"]isEqualToString:@"200"]&&!NULLString(model.product_join_url)) {

            [ZHWebViewController showWithContro:self withUrlStr:model.product_join_url withTitle:model.product_name];
        }
    } failure:^(NSError *error) {
  
    }];
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
                            @"loan_amt":@((NSInteger)[self.loan_mt floatValue]),
                            @"cust_no":[UserTool GetUser].custno
                            };
    NSLog(@"筛选条件****%@",params);
    [HttpTool PostWithPath:@"/YJJQWebService/MatchProduct.spring" params:params success:^(id json) {
        [self.tableView.mj_header endRefreshing];
        NSLog(@"匹配结果****%@",json);
         [limitFooter reloadMoneyLabel:[[json objectForKey:@"data"] objectForKey:@"loan_amt"]];
        if ([[json objectForKey:@"code"]isEqualToString:@"200"]) {
            /*更新我的额度*/
            [UserTool updateUserInfoKey:@"assess_money" Value:[[json objectForKey:@"data"] objectForKey:@"loan_amt"]];
            [self.titles addObjectsFromArray:[ZHProductModel mj_objectArrayWithKeyValuesArray:[[json objectForKey:@"data"] objectForKey:@"list"]]];
            [self.tableView reloadData];
            
        } else if([[json objectForKey:@"code"]isEqualToString:@"400"]){
            [self.tableView reloadData];
        }
        
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"加载失败"];
        [self.tableView.mj_header endRefreshing];
    }];
}

#pragma mark 重置导航条
-(void)resetNaviBar{
    
    self.title=nil;
    self.navigationItem.leftBarButtonItem=[UIBarButtonItem itemWithTarget:self action:@selector(backHome) Title:@"首页" image:@"arrow2" highImage:@"arrow2"];
}

#pragma mark 返回首页
-(void)backHome{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor clearColor] size:CGSizeMake(ZHScreenW, StatusBarHeight+self.navigationController.navigationBar.height)] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
     [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.35 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (self.RecallBlock) {
            self.RecallBlock();
        }
    });
}

@end
