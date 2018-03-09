//
//  ZHCompleteViewController.m
//  ZHBorrowClient
//
//  Created by zhph on 2017/12/20.
//  Copyright © 2017年 小飞鸟. All rights reserved.
//

#import "ZHCompleteViewController.h"
#import "ZHAuthCell.h"
#import "ZHAuthViewController.h"
#import "ZHWorkInfoViewController.h"
#import "ZHMoreAutheViewController.h"
#import "ZHBaseInfoViewController.h"
#import "ZHMineViewController.h"
#import "ZHMaxLoanController.h"

@interface ZHCompleteViewController ()
/*副标题*/
@property(nonatomic,strong)NSMutableArray * subTitles;
/*状态数组*/
@property(nonatomic,strong)NSArray * statusArray;

@end

@implementation ZHCompleteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupTableView];
    [self initData];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    btn.frame=CGRectMake(20, StatusBarHeight+(self.navigationController.navigationBar.height-22)/2, 22, 22);
    // 设置图片
    [btn setImage:[UIImage imageNamed:@"arrow2"] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"arrow2"] forState:UIControlStateHighlighted];
    
    // 设置尺寸
    btn.size = btn.currentImage.size;
    [btn setImageEdgeInsets:UIEdgeInsetsMake(0, -8, 0, 0)];
    
    [self.view addSubview:btn];
    
    self.view.backgroundColor=UIColorWithRGB(0xf3f4f8, 1.0);
    self.tableView.tableHeaderView=[self createTableHeaderView];
    self.tableView.backgroundColor=ZHClearColor;
    self.tableView.sectionFooterHeight=0.01;
    [self setupAuthFooterWithTitle:@"立即一键借钱"];
    self.tableView.y=StatusBarHeight+self.navigationController.navigationBar.height;
    [self setupFooterWithTitle:@"立即一键借钱" WithOffsetY:ZHFit(48) TotalHeight:ZHFit(130)];
     AdjustsScrollViewInsetNever(self, self.tableView);
    self.footBtn.y=ZHScreenH-ZHFit(55);
    self.tableView.tableFooterView.backgroundColor=ZHClearColor;
    self.tableView.height=ZHScreenH-ZHFit(55)-StatusBarHeight-self.navigationController.navigationBar.height;
}

#pragma mark 返回
-(void)backAction{
    
    if (self.type==LoginChannel) {
        ZHMineViewController * VC =[ZHMineViewController new];
        [self.navigationController pushViewController:VC animated:YES];
    }else{
         [self.navigationController popViewControllerAnimated:YES];
    }
}

//点击组尾后的操作
- (void)nextStep{

    //如果是登录过来的 直接返回到首页
    [self.navigationController popToRootViewControllerAnimated:YES];
//    if (self.type == LoginChannel) {
//        //如果是登录过来的 直接返回到首页
//        [self.navigationController popToRootViewControllerAnimated:YES];
//    }else{
//        //跳转到动画页面
//        [self.navigationController pushViewController:[ZHMaxLoanController new] animated:YES];
//    }
}

#pragma mark 创建头部视图
-(UIView*)createTableHeaderView{
    
    UIView * BGView =[UIView CreateViewWithFrame:CGRectMake(0, 0, ZHScreenW, ZHFit(65)) BackgroundColor:ZHClearColor InteractionEnabled:YES];
    UILabel * textLabel = [UILabel addLabelWithFrame:CGRectMake(0, ZHFit(25), ZHScreenW, ZHFit(20)) title:@"完善个人信息" titleColor:UIColorWithRGB(0x252c32, 1.0) font:ZHFontSemibold(20)];
    textLabel.textAlignment=NSTextAlignmentCenter;
    [BGView addSubview:textLabel];
    
    UIImageView * line1 =[UIImageView addImaViewWithFrame:CGRectMake(ZHFit(61), ZHFit(34), ZHFit(50), 0.5) imageName:@"线"];
    [BGView addSubview:line1];
    
    UIImageView * line2 =[UIImageView addImaViewWithFrame:CGRectMake(ZHScreenW-ZHFit(50)-ZHFit(61), ZHFit(34), ZHFit(50), 0.5) imageName:@"线"];
    [BGView addSubview:line2];
    
    return BGView;
}


#pragma mark 初始化数据
-(void)initData{
    
    self.titles=[NSMutableArray arrayWithObjects:@"实名认证", @"基本信息",@"单位信息",@"更多认证",nil];
    self.subTitles=[NSMutableArray arrayWithObjects:@"完成认证通过率提升至50%", @"完善基本信息通过率提升至70%",@"完善单位信息通过率提升至80%",@"完成更多认证通过率提升至99%",nil];
    [self.tableView reloadData];
}

#pragma mark UITableView代理
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ZHAuthCell * mineCell =[ZHAuthCell dequeueReusableCellWithTableView:tableView Identifier:@"auth"];
    mineCell.indexPath=indexPath;
    
    self.statusArray=@[[UserTool GetUser].realname_state,[UserTool GetUser].base_state,[UserTool GetUser].credit_state,[UserTool GetUser].auth_state];
    
    [mineCell setCellWithLargeTitles:self.titles SmallTitle:self.subTitles AtIndexPath:indexPath StatusArray:self.statusArray];
    mineCell.authAction = ^(NSIndexPath *indexPath) {
        //认证点击
        [self authActionAtIndexPath:indexPath];
    };

    return mineCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return ZHFit(102);
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.statusArray.count>indexPath.row&&[[self.statusArray objectAtIndex:indexPath.row]isEqualToString:@"1"]) {
        [self authActionAtIndexPath:indexPath];
    }
}

#pragma mark 认证授权点击
-(void)authActionAtIndexPath:(NSIndexPath*)indexPath{
    
    ZHBaseViewController * VC ;
    switch (indexPath.row) {
        case 0:{
            VC = [ZHAuthViewController new];
            //实名认证
            break;
        }
        case 1:{
            
            VC = [ZHBaseInfoViewController new] ;
            //基本信息
            break;
        }
        case 2:{
            VC = [ZHWorkInfoViewController new];
            //单位信息
            break;
        }
        case 3:{
            VC = [ZHMoreAutheViewController new];
            //更多认证
            break;
        }
            
        default:
            break;
    }
    VC.RecallBlock = ^{
        [self resetNaviBar];
    };
    
    [self.navigationController pushViewController:VC animated:YES];
    
}

#pragma mark 重置导航条
-(void)resetNaviBar{
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor clearColor] size:CGSizeMake(ZHScreenW, StatusBarHeight+self.navigationController.navigationBar.height)] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
    
    if (![[UserTool GetUser].realname_state isEqualToString:@"1"]) {
        [self.footBtn setTitle:@"必选项没有认证" forState:UIControlStateNormal];
        self.footBtn.backgroundColor=UIColorWithRGB(0xbbbfcb, 1.0);
        self.footBtn.userInteractionEnabled=NO;
    }else{
        
        [self.footBtn setTitle:@"立即一键借钱" forState:UIControlStateNormal];
        self.footBtn.backgroundColor=ZHThemeColor;
        self.footBtn.userInteractionEnabled=YES;
    }
}

@end
