//
//  ZHHomeViewController.m
//  ZHBorrowClient
//
//  Created by 小飞鸟 on 2017/12/18.
//  Copyright © 2017年 小飞鸟. All rights reserved.
//

#import "ZHHomeViewController.h"
#import "ZHHomeHeader.h"
#import "TTScrollRulerView.h"
#import "ZHLoginViewController.h"
#import "ZHMineViewController.h"
#import "ZHLoanLimitViewController.h"
#import "ZHCompleteViewController.h"
#import "ZHMaxLoanController.h"

@interface ZHHomeViewController ()<rulerDelegate>
/*滚动视图*/
@property(nonatomic,strong)UIScrollView * SC;

@end

@implementation ZHHomeViewController{
    /*头部视图*/
    ZHHomeHeader * homeHeader;
    /*滑动刻度尺*/
    TTScrollRulerView *rulerCustom;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self configUI];
    [self resetNaviBar];
}
#pragma mark 重置导航条
-(void)resetNaviBar{
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor clearColor] size:CGSizeMake(ZHScreenW, StatusBarHeight+self.navigationController.navigationBar.height)] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    /*刷新状态信息*/
    [self requestHomeInfo];
    
}

#pragma mark 请求首页的信息
-(void)requestHomeInfo{
    
    if (!NULLString([UserTool GetUser].custno)) {
        
        [HttpTool PostWithPath:@"/YJJQWebService/GetMainInfo.spring" params:@{@"cust_no":[UserTool GetUser].custno} success:^(id json) {
            NSLog(@"首页查询****%@",json);
            if ([[json objectForKey:@"code"]isEqualToString:@"200"]) {
                
                [UserTool updateUserInfoAllKey:[json objectForKey:@"data"]];
                
                if (!(NULLString([UserTool GetUser].assess_money)||[[UserTool GetUser].assess_money isEqualToString:@"0"])) {
                    [homeHeader loadSubViews:self.view];
                    [homeHeader reloadMoneyLabel];
                }
            }
            
        } failure:^(NSError *error) {
            
        }];
    }else{
        /*退出登录 移除*/
        [homeHeader removeDetailView];
    }
}

#pragma mark 布局UI
-(void)configUI{
    
    self.SC=[[UIScrollView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:self.SC];
    
    homeHeader=[ZHHomeHeader createHomeHeaderWithFrame:CGRectMake(0, 0, ZHScreenW, ZHFit(444)) PersonClick:^{
        
        if (NULLString([UserTool GetUser].phoneno)) {
                ZHLoginViewController * VC = [ZHLoginViewController new];
                 [self.navigationController pushViewController:VC animated:YES];
                VC.RecallBlock = ^{
                     [self resetNaviBar];
                };
        }else{
            
             [self.navigationController pushViewController:[ZHMineViewController new] animated:YES];
        }
        
    } DetailClick:^{
        
            ZHLoanLimitViewController * VC= [ZHLoanLimitViewController new];
            VC.loan_mt =[UserTool GetUser].assess_money;
            [self.navigationController pushViewController:VC animated:YES];
            VC.RecallBlock = ^{
               [self resetNaviBar];
            };
    }];
    [self.SC addSubview:homeHeader];
    AdjustsScrollViewInsetNever(self, self.SC);
    
    //
    rulerCustom = [[TTScrollRulerView alloc] initWithFrame:CGRectMake(0, homeHeader.bottom, ZHScreenW, ZHFit(95))];
    [self.SC addSubview:rulerCustom];
    rulerCustom.rulerDelegate = self;
    //在执行此方法前，可先设定参数：最小值，最大值，横向，纵向等等   ------若不设定，则按照默认值绘制
    [rulerCustom customRulerWithLineColor:customColorMake(232, 232, 232) NumColor:UIColorFromRGB(0xd7d7d7) scrollEnable:YES];
    [self.SC addSubview:rulerCustom];
    
    [rulerCustom scrollToValue:[@"50000" integerValue] animation:YES];
    homeHeader.numberLabel.text=@"50000.00";
    
    if ([ZHStringFilterTool getIsIpad]) {
        self.SC.contentSize = CGSizeMake(ZHScreenW, self.SC.height+80);
    }
    [self.SC addSubview:[self setupFooterWithTitle:@"一键借钱"]];
    
}


-(void)tapAction{
    
    
}
#pragma mark 一键借钱
- (void)nextStep{
    
    if (NULLString([UserTool GetUser].phoneno)) {
        ZHLoginViewController * VC = [ZHLoginViewController new];
        [self.navigationController pushViewController:VC animated:YES];
        VC.RecallBlock = ^{
            [self resetNaviBar];
        };
        return;
    }
    
    if (![[UserTool GetUser].realname_state isEqualToString:@"1"]) {
        //没有实名认证
        ZHCompleteViewController * VC =[ZHCompleteViewController new];
        VC.type=HomeChannel;
        [self.navigationController pushViewController:VC animated:YES];
        return;
    }
    
    ZHMaxLoanController * VC =[ZHMaxLoanController new];
    VC.loan_mt = homeHeader.numberLabel.text;
    VC.RecallBlock = ^{
        [self resetNaviBar];
    };
    [self.navigationController pushViewController:VC animated:YES];    
}

//设置tableView的组尾
-(UIView*)setupFooterWithTitle:(NSString*)title{
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0,rulerCustom.bottom, ZHScreenW, ZHScreenH-rulerCustom.bottom)];
    view.backgroundColor=ZHClearColor;
    
    UIButton * btn =[UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame=CGRectMake(ZHFit(12), ZHFit(35), ZHScreenW - ZHFit(12)*2, ZHFit(45));
    [btn setTitle:title forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(nextStep) forControlEvents:UIControlEventTouchDown];
    btn.backgroundColor=ZHThemeColor;
    btn.clipsToBounds = YES;
    btn.titleLabel.textAlignment = NSTextAlignmentCenter;
    btn.layer.cornerRadius = 3;
    btn.layer.masksToBounds = YES;
    [view addSubview:btn];
    
    if ([ZHStringFilterTool getIsIpad]) {
        view.height=ZHFit(80);
    }
    
    UIImageView * alert =[[UIImageView alloc]initWithFrame:CGRectMake(ZHFit(105), btn.bottom+ZHFit(10), ZHFit(12), ZHFit(12))];
    alert.image=[UIImage imageNamed:@"i"];
    [view addSubview:alert];
    
    UILabel * label =[UILabel addLabelWithFrame:CGRectMake(alert.right+ZHFit(7),btn.bottom+ZHFit(10), ZHFit(160), ZHFit(12)) title:@"最终额度以评估后显示为准" titleColor:UIColorFromRGB(0xbbbfc8) font:ZHFontLineSize(12)];
   [view addSubview:label];
    
    return view;
}




#pragma mark 标尺代理方法
- (void)rulerWith:(NSInteger)days {
    //即时打印出标尺滑动位置的数值
    homeHeader.numberLabel.text = [NSString stringWithFormat:@"%ld.00",days];
    [UserTool setObject:homeHeader.numberLabel.text forKey:Loan];//保存额度
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    
    return UIStatusBarStyleLightContent;
}

@end
