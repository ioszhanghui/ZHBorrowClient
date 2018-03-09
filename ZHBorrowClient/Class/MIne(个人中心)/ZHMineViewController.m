//
//  ZHMineViewController.m
//  ZHBorrowClient
//
//  Created by 小飞鸟 on 2017/12/18.
//  Copyright © 2017年 小飞鸟. All rights reserved.
//

#import "ZHMineViewController.h"
#import "ZHMineHeader.h"
#import "ZHMyAuthView.h"
#import "ZHCompleteViewController.h"
#import "ZHLoanRecordViewController.h"


@implementation ZHMineViewController{
    //整体的背景
    UIImageView *imageBG;
    //带有图片的背景
    ZHMineHeader * BgView ;
    /*完成认证*/
    ZHMyAuthView * authView;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.titles=[NSMutableArray arrayWithObjects:@"贷款记录",@"常见问题",@"关于我们" ,nil];
     self.titles=[NSMutableArray arrayWithObjects:@"贷款记录",nil];
    [self setupTableView];
    [self setHeaderView];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    btn.frame=CGRectMake(20, StatusBarHeight+(self.navigationController.navigationBar.height-22)/2, 22, 22);
    // 设置图片
    [btn setImage:[UIImage imageNamed:@"Mearrow"] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"Mearrow"] forState:UIControlStateHighlighted];
    btn.size = btn.currentImage.size;
     [btn setTitle:@"首页" forState:UIControlStateNormal];
    [btn setImageEdgeInsets:UIEdgeInsetsMake(0, -8, 0, 0)];
    btn.titleLabel.font= ZHFontLineSize(14);
    [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, -5)];
    btn.size = CGSizeMake(ZHFit(58), btn.currentImage.size.height);
    [self.view addSubview:btn];
    
    
      AdjustsScrollViewInsetNever(self, self.tableView);
    [self setupBaseFooterWithTitle:@"退出登录"];
    self.tableView.tableHeaderView=[UIView CreateViewWithFrame:CGRectMake(0, 0, ZHScreenW, ZHFit(61)) BackgroundColor:[UIColor whiteColor] InteractionEnabled:YES];
    authView =  [ZHMyAuthView shareMyAuthViewWithFrame:CGRectMake(ZHFit(8), -ZHFit(45), ZHScreenW-2*ZHFit(8), ZHFit(100)) GoToAction:^{
        
        ZHCompleteViewController * VC =[ZHCompleteViewController new];
        VC.type =HomeChannel;
        [self.navigationController pushViewController:VC animated:YES];
    }];
    [self.tableView addSubview:authView];
}

#pragma mark 返回页面
-(void)backAction{
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

//创建tableView
- (void)setupTableView{
    
    UITableView *tableView = [UITableView initWithTableView:self.view.bounds withDelegate:self];
    self.tableView = tableView;
    tableView.sectionHeaderHeight = 0.01;
    tableView.sectionFooterHeight=0.01;
    tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    tableView.separatorColor=UIColorWithRGB(0xf1f2f4, 1.0);
    tableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:tableView];
    //去掉头部留白
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 0.001)];
    view.backgroundColor = [UIColor redColor];
    self.tableView.tableHeaderView = view;
    self.tableView.contentInset=UIEdgeInsetsMake(ZHFit(315), 0, 0, 0);

}

#pragma mark 初始化header
-(void)setHeaderView{
    
    UIImageView *view = [[UIImageView alloc] initWithFrame:CGRectMake(0, -ZHFit(315), self.view.width, ZHFit(315))];
    view.backgroundColor = [UIColor orangeColor];
    view.userInteractionEnabled=YES;
    imageBG=view;
    BgView= [ZHMineHeader createMineTableViewHeaderWithTableView:self.tableView HeadImageClick:^{
        //头像点击
        NSLog(@"头像点击");        
    }];
    
    [view addSubview:BgView];
    
    [self.tableView addSubview:view];
}

#pragma mark 滑动刷新
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat yOffset  = scrollView.contentOffset.y;
    CGFloat xOffset = (yOffset + ZHFit(315))/2;
    if (yOffset < -ZHFit(315)) {
        CGRect rect = imageBG.frame;
        rect.origin.y = yOffset;
        rect.size.height =  -yOffset ;
        rect.origin.x = xOffset;
        rect.size.width = ZHScreenW + fabs(xOffset)*2;
        imageBG.frame = rect;
        BgView.frame=CGRectMake((rect.size.width-ZHScreenW)/2,0, rect.size.width , imageBG.height);
        BgView.contentView.frame=CGRectMake(0, BgView.bottom-ZHFit(315), ZHScreenW, ZHFit(315));
    }
}


#pragma mark UITableView代理
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell * mineCell =[tableView dequeueReusableCellWithIdentifier:@"Mine"];
    if (mineCell ==nil) {
        mineCell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Mine"];
        mineCell.textLabel.font=ZHFontSize(14);
        mineCell.detailTextLabel.font=ZHFontLineSize(14);
        mineCell.textLabel.textColor=UIColorWithRGB(0x5e5e5e, 1.0);
        mineCell.detailTextLabel.textColor=UIColorWithRGB(0x1865fa, 1.0);
        mineCell.accessoryView = ArrowView;
        mineCell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    mineCell.textLabel.text = [self.titles objectAtIndex:indexPath.row];
    return mineCell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return ZHFit(50);
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:{
            //贷款记录
            
            ZHLoanRecordViewController * VC =[ZHLoanRecordViewController new] ;
            VC.RecallBlock = ^{
                [self resetNaviBar];
            };
            [self.navigationController pushViewController:VC animated:NO];
        }
            
            break;
            
        default:
            break;
    }
    
}
#pragma mark 重置导航条
-(void)resetNaviBar{
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor clearColor] size:CGSizeMake(ZHScreenW, StatusBarHeight+self.navigationController.navigationBar.height)] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
}

//设置tableView的组尾
- (void)setupBaseFooterWithTitle:(NSString*)title{
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, ZHFit(120))];
    self.tableView.tableFooterView = view;
    view.backgroundColor=ZHClearColor;
    
   UIView * line = [UIView addLineWithFrame:CGRectMake(0, 0, ZHScreenW, 0.3) WithView:view];
    line.backgroundColor=UIColorWithRGB(0xf1f2f4, 1.0);
    
    UIButton * btn = [UIButton addCustomButtonWithFrame:CGRectMake(ZHFit(12), ZHFit(52), ZHScreenW-2*ZHFit(12), ZHFit(45)) title:title backgroundColor:ZHThemeColor  titleColor:[UIColor whiteColor] tapAction:^(UIButton *button) {
        
        [AlertViewTool showAlertView:self title:nil message:@"确定退出" cancelTitle:@"取消" otherTitle:@"确认" cancelBlock:^{
            
        } confrimBlock:^{
            //移除存储的数据
            [UserTool clearUserInfo];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }];
    }];
    btn.titleLabel.font = ZHFont_Middle;
    self.footBtn = btn;
    [view addSubview:btn];
    
    UILabel * versionLabel=[UILabel addLabelWithFrame:CGRectMake(0, btn.bottom+ZHFit(10), ZHScreenW, ZHFit(12)) title:[NSString stringWithFormat:@"版本号 v%@",KVersion] titleColor:UIColorWithRGB(0xbbbfcb, 1.0) font:ZHFontLineSize(12)];
    [view addSubview:versionLabel];
    versionLabel.textAlignment=NSTextAlignmentCenter;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //设置认证完场的状态
    [authView resetNumLabel];
    [BgView refreshData];
}


-(UIStatusBarStyle)preferredStatusBarStyle{
    
    return UIStatusBarStyleLightContent;
}

@end
