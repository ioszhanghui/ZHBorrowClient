//
//  ZHBaseViewController.m
//  ZHPay
//
//  Created by 正和 on 16/8/31.
//  Copyright © 2016年 正和. All rights reserved.
//

#import "ZHBaseViewController.h"
#import "ZHHomeViewController.h"
#import "ZHMineViewController.h"
#import "UITableView+Extension.h"
#import "UIView+CLKeyboardOffsetView.h"
#import <SVProgressHUD.h>
#import "ZHCompleteViewController.h"
#import "ZHAuthViewController.h"
#import "ZHBaseInfoViewController.h"
#import "ZHWorkInfoViewController.h"
#import "ZHMoreAutheViewController.h"

@implementation ZHBaseViewController
-(instancetype)init{
    
    if (self=[super init]) {
        //计算获取导航条的高度
        Nvi_Bar_Height= StatusBarHeight+self.navigationController.navigationBar.height;
    }
    return self;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    //控制是否显示导航栏
    if ([self isKindOfClass:[ZHHomeViewController class]] ||[self isKindOfClass:[ZHMineViewController class]]||[self isKindOfClass:[ZHCompleteViewController class]]){
        [self.navigationController setNavigationBarHidden:YES animated:YES];
    }else{
        [self.navigationController setNavigationBarHidden:NO animated:YES];
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    if ([self isKindOfClass:[ZHAuthViewController class]] ||[self isKindOfClass:[ZHBaseInfoViewController class]]||[self isKindOfClass:[ZHWorkInfoViewController class]]||[self isKindOfClass:[ZHMoreAutheViewController class]]){
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            if (self.RecallBlock) {
                self.RecallBlock();
            }
        });
    }
}

#pragma mark 重置导航条
-(void)resetWhiteNaviBar{
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor] size:CGSizeMake(ZHScreenW, StatusBarHeight+self.navigationController.navigationBar.height)] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
}


- (NSMutableArray *)titles
{
    if (_titles == nil) {
        _titles = [NSMutableArray array];
    }
    return _titles;
}

- (NSMutableDictionary *)dataDictionary
{
    if (_dataDictionary == nil) {
        _dataDictionary = [NSMutableDictionary dictionary];
    }
    return _dataDictionary;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = ZHBackgroundColor;
    self.edgesForExtendedLayout=UIRectEdgeNone;
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
 }

#pragma mark 请求数据
- (void)requestData{


}

//创建tableView
- (void)setupTableView{

    UITableView *tableView = [UITableView initWithGroupTableView:self.view.bounds withDelegate:self];
    self.tableView = tableView;
    tableView.sectionHeaderHeight = 0.01;
    tableView.sectionFooterHeight=ZHFit(10);
    tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    tableView.separatorColor=kSetUpCololor(243, 243, 243, 1.0);
    tableView.backgroundColor = ZHBackgroundColor;
    [self.view addSubview:tableView];    
    //去掉头部留白
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 0.001)];
    view.backgroundColor = [UIColor clearColor];
    self.tableView.tableHeaderView = view;
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    
}

//设置tableView的组尾
- (void)setupAuthFooterWithTitle:(NSString*)title{
    
    UIButton *btn = [UIButton addCustomButtonWithFrame:CGRectMake(0,ZHScreenH-StatusBarHeight-self.navigationController.navigationBar.height-ZHFit(55), ZHScreenW, ZHFit(55)) title:title backgroundColor:ZHThemeColor titleColor:[UIColor whiteColor] tapAction:^(UIButton *button) {
        [self nextStep];
    }];
    btn.titleLabel.font = ZHFont_BtnTitle;
    self.footBtn = btn;
    btn.layer.cornerRadius = 0;
    [self.view addSubview:btn];
}

//设置tableView的组尾
-(UIView*)setupFooterWithTitle:(NSString*)title WithOffsetY:(CGFloat)offsetY TotalHeight:(CGFloat)height{
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0,0, ZHScreenW, height)];
    view.backgroundColor=[UIColor whiteColor];;
    self.tableView.tableFooterView=view;
    
    UIImageView * alert =[[UIImageView alloc]initWithFrame:CGRectMake(ZHFit(76), offsetY, ZHFit(11), ZHFit(13))];
    alert.image=[UIImage imageNamed:@"盾牌"];
    [view addSubview:alert];
    
    UILabel * label =[UILabel addLabelWithFrame:CGRectMake(alert.right+ZHFit(4),offsetY, ZHFit(223), ZHFit(12)) title:@"我们将会对您的个人信息进行严格保密" titleColor:UIColorWithRGB(0xbbbfc8, 1.0) font:ZHFontLineSize(12)];
    [view addSubview:label];
    return view;
}

//点击组尾后的操作
- (void)nextStep{

}

#pragma mark - Table view data source

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return self.titles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BaseTableViewCell *cell = [BaseTableViewCell dequeueReusableCellWithTableView:tableView Identifier:@"cell"];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return ZHFit(50);
}

//设置分割线上下去边线，
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    UIEdgeInsets UIEgde = UIEdgeInsetsMake(0, 0, 0, 0);
    [cell setSeparatorInset:UIEgde];
}

#pragma mark 退出键盘
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
    [self.view endEditing:YES];
    
}

@end
