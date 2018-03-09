//
//  ZHProductDetailController.m
//  ZHLoanClient
//
//  Created by 小飞鸟 on 2017/10/21.
//  Copyright © 2017年 小飞鸟. All rights reserved.
//

#import "ZHProductDetailController.h"
#import "ZHProductCell.h"
#import "ZHApplyView.h"
#import "ZHProductTableViewCell.h"

@interface ZHProductDetailController ()

@end

@implementation ZHProductDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"产品详情";
    [self setupTableView];
    self.tableView.tableFooterView=[ZHApplyView shareApplyViewWIthModel:self.productModel];
    [(ZHApplyView*)self.tableView.tableFooterView setProductModel:self.productModel];
//    [self addNvi];

        UIButton *btn = [UIButton addCustomButtonWithFrame:CGRectMake(0, ZHScreenH-ZHFit(50)-64, ZHScreenW, ZHFit(50)) title:@"立即申请" backgroundColor:ZHThemeColor titleColor:[UIColor whiteColor] tapAction:^(UIButton *button) {
            
            [self rightApplyAction];
        }];
        btn.titleLabel.font = ZHFont_BtnTitle;
        [self.view addSubview:btn];
        
        if (KIsiPhoneX) {
            btn.y= ZHScreenH-ZHFit(50)-StatusBarHeight-self.navigationController.navigationBar.height;
        }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

#pragma mark 立即申请的方法
-(void)rightApplyAction{
    
    [self TalkingDataAndUMData:self.productModel];
    /*立即申请的点击统计*/
    if (!NULLString(self.productModel.product_join_url)) {
        [self rightNowWithdrawCash:self.productModel];
    }
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
                            @"pro_no":model.ID,
                            @"cust_no":[UserTool GetUser].custno
                            };
    
    [HttpTool PostWithPath:@"/YJJQWebService/InsertApplyLog.spring" params:params success:^(id json) {
        
        NSLog(@"去提现接口****%@",json);
        if ([[json objectForKey:@"code"]isEqualToString:@"200"]&&!NULLString(model.product_join_url)) {
            
            [ZHWebViewController showWithContro:self withUrlStr:model.product_join_url withTitle:model.product_name];
        }
    } failure:^(NSError *error) {
        
    }];
}

-(void)setProductModel:(ZHProductModel *)productModel{
    _productModel=productModel;
    
    [self.tableView reloadData];
}

#pragma mark 分享
-(void)addNvi{
    
    self.navigationItem.rightBarButtonItem=[UIBarButtonItem  itemWithTarget:self action:@selector(ShareAction) image:@"分享" highImage:@"分享"];
}

#pragma mark 分享
-(void)ShareAction{
   
}

#pragma mark - Table view data source

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section==0) {
        
        ZHProductTableViewCell *cell = [ZHProductTableViewCell dequeueReusableCellWithTableView:tableView Identifier:@"cell" CellType:Product_Detail];
        cell.productModel=self.productModel;
        return cell;
    }
    if (indexPath.section==1) {
        
        ZHProductCell *cell = [ZHProductCell dequeueReusableCellWithTableView:tableView Identifier:@"pro"];
         cell.productModel=self.productModel;
        
        return cell;
    }
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section==0) {
        
        return ZHFit(100);
    }
    
    if (KIsiPhoneX) {
        return ZHFit(170);
    }
    
    return ZHFit(153);
}


@end
