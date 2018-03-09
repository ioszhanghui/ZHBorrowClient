//
//  ZHShopViewController.m
//  ZHLoanClient
//
//  Created by 小飞鸟 on 2017/10/21.
//  Copyright © 2017年 小飞鸟. All rights reserved.
//

#import "ZHShopViewController.h"
#import "ZHChooseView.h"
#import "ZHScanTypeView.h"
#import "ZHPickerView.h"
#import <MJRefresh.h>
#import "ZHProductModel.h"
#import "ZHTypeInstance.h"
#import "ZHProductTableViewCell.h"
#import "ZHProductDetailController.h"

@interface ZHShopViewController ()

/*类型选择框*/
@property(nonatomic,strong)ZHChooseView * chooseView;
/*内容选择框弹出*/
@property(nonatomic,strong)ZHScanTypeView * scanTypeView;
/*金额择框弹出*/
@property(nonatomic,strong)ZHPickerView * pickerView;
/*身份的数据*/
@property(nonatomic,strong)NSMutableArray * statusArr;
/*贷款类型*/
@property(nonatomic,strong)NSMutableArray * loanArray;
/*总页数*/
@property(nonatomic,assign)NSInteger totalPage;

/*请求的参数*/
@property(nonatomic,strong)NSMutableDictionary * loanParams;
/*创建的button 文字*/
@property(nonatomic,strong)NSMutableArray * chooseTitles;

@end

@implementation ZHShopViewController{
    /*当前页面*/
    NSInteger currentPage;
}

-(instancetype)init{
    if (self=[super init]) {
        
        [self initData];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"贷款超市";
    [self setupTableView];
    [self resetWhiteNaviBar];
    [self loanTypeRequest];
    [self loanPersonRequest];
    [self configUI];
    [UIView addLineWithFrame:CGRectMake(0,0, ZHScreenW, 0.4) WithView:self.view];
    
    self.tableView.mj_header = [MJRefreshStateHeader  headerWithRefreshingBlock:^{
        
        currentPage=1;
        [self.titles removeAllObjects];
        [self.loanParams setObject:@(1) forKey:@"pager_index"];
        [self shopListRequest];
    }];
    
    [self.tableView.mj_header beginRefreshing];
    
    //MJRefreshAutoNormalFooter 才可以显示出来 没有更多了
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self.loanParams setObject:@(currentPage) forKey:@"pager_index"];
        [self shopListRequest];
    }];
    self.tableView.mj_footer.automaticallyHidden=YES;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.scanTypeView removeFromSuperview];
    
}
#pragma mark 初始化数据
-(void)initData{
    
    currentPage=1;
    // 筛选条件的按钮
    self.chooseTitles=[NSMutableArray arrayWithObjects:@"身份不限",@"金额不限",@"贷款类型", nil];
    
    //请求 的默认参数
    self.loanParams=[NSMutableDictionary dictionaryWithDictionary:@{
                                                                    @"pager_index":@(currentPage),
                                                                    @"pager_size":@"10",
                                                                    @"loan_money":@"",
                                                                    @"loan_day":@"",
                                                                    @"condition":@""
                                                                    }];
    self.loanArray=[NSMutableArray array];
    self.statusArr=[NSMutableArray array];
}

#pragma mark 类型的请求
-(void)loanTypeRequest{
    
    if (self.loanArray.count!=0) {
        return;
    }
    
    [HttpTool PostWithPath:@"/YJJQWebService/GetTypeInfo.spring" params:@{@"type":@"user_type"} success:^(id json) {
        if ([[json objectForKey:@"code"]isEqualToString:@"200"]) {
            ZHTypeModel * model1 =[[ZHTypeModel alloc]init];
            model1.name=@"身份不限";
            model1.code=@"";
            NSMutableArray * perKinds=[NSMutableArray array];
            [perKinds addObject:model1];
            [perKinds addObjectsFromArray:[ZHTypeModel mj_objectArrayWithKeyValuesArray:[[json objectForKey:@"data"] objectForKey:@"user_type"]]];
            [self.loanArray addObject:@{@"one":perKinds}];
            
        }
        
    } failure:^(NSError *error) {
        
    }];
}
#pragma mark 身份类型的请求
-(void)loanPersonRequest{
    if (self.statusArr.count!=0) {
        return;
    }
    [HttpTool PostWithPath:@"/YJJQWebService/GetTypeInfo.spring" params:@{@"type":@"repay_type,third_type"} success:^(id json) {
        if ([[json objectForKey:@"code"]isEqualToString:@"200"]) {
            
        [self.statusArr addObject:@{@"我有":[ZHTypeModel mj_objectArrayWithKeyValuesArray:[[json objectForKey:@"data"] objectForKey:@"third_type"]]}];
        [self.statusArr addObject:@{@"我需要":[ZHTypeModel mj_objectArrayWithKeyValuesArray:[[json objectForKey:@"data"] objectForKey:@"repay_type"]]}];
        }
    } failure:^(NSError *error) {
        
    }];
    
}

#pragma mark 贷款超时列表请求
-(void)shopListRequest{

    [HttpTool PostWithPath:@"/YJJQWebService/MarchProductInfo.spring" params:self.loanParams success:^(id json) {
        [self.tableView.mj_footer endRefreshing];
        [self.tableView.mj_header endRefreshing];
        if ([[json objectForKey:@"code"]isEqualToString:@"200"]) {
            
            NSLog(@"贷款超市****%@",json);
            self.totalPage=[[[json objectForKey:@"data"] objectForKey:@"total_pager"] integerValue];
            [self.titles addObjectsFromArray:[ZHProductModel mj_objectArrayWithKeyValuesArray:[[json objectForKey:@"data"] objectForKey:@"list"]]];
            [self.tableView reloadData];
            if (self.titles.count>0&&(currentPage==self.totalPage)) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
            self.tableView.mj_footer.hidden= (self.tableView.contentSize.height<self.tableView.frame.size.height&& self.totalPage==1)? YES :NO;
            currentPage++;
        } else if([[json objectForKey:@"code"]isEqualToString:@"300"]){
            [self.tableView reloadData];
        }
        
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"加载失败"];
        [self.tableView.mj_footer endRefreshing];
        [self.tableView.mj_header endRefreshing];
    }];
}


#pragma mark home的代理方法
-(void)HomeTypeSelected:(ZHTypeModel *)typeModel Type:(NSString *)type{
    
    if ([type isEqualToString:@"类型"]) {
        
        self.chooseView.titles= [self getChooseButtonTitlesWithTypeModel:typeModel];
        self.loanParams=[self getListRequestParams];
        self.chooseView.selectedTag=0;
    }
    [self.tableView.mj_header beginRefreshing];
}


#pragma mark 布局UI
-(void)configUI{
    
    self.chooseView=[ZHChooseView shareButtonItemWithFrame:CGRectMake(0, 0, ZHScreenW, ZHFit(50)) ItemChooseBlock:^(ZHButtonItem *item) {
        [self alertViewDeal:item];
    }];
    
    self.chooseView.titles = [self getChooseButtonTitlesWithTypeModel:[ZHTypeInstance sharedInstance].typeModel];
    [self.view addSubview:self.chooseView];
    
    self.tableView.height=ZHScreenH-64-ZHFit(50);
    self.tableView.y=ZHFit(50);
    
    if (KIsiPhoneX) {
         self.tableView.height=ZHScreenH-StatusBarHeight-self.navigationController.navigationBar.frame.size.height-ZHFit(50);
    }
    
}

#pragma mark 身份类型选择
-(void)dealWithButtonItem:(ButtonItem *)item{
    
    ZHTypeModel * typeModel = item.typeModel;
    [ZHTypeInstance sharedInstance].typeModel=typeModel;

    self.chooseView.titles= [self getChooseButtonTitlesWithTypeModel:typeModel];
    self.chooseView.selectedTag=0;
    self.loanParams=[self getListRequestParams];
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark 获取筛选条件的请求参数
-(NSMutableDictionary*)getListRequestParams{
    
    NSString * perCode = (NULLString([ZHTypeInstance sharedInstance].typeModel.name)||[[ZHTypeInstance sharedInstance].typeModel.name isEqualToString:@"身份不限"])? @"" : [ZHTypeInstance sharedInstance].typeModel.code;
    //贷款的实际金额
    NSString * loanAmount = [self getLoanAmountValue];
    //贷款的code
    NSString * loanCode=[self getLoanType];
    
    [self.loanParams setObject:loanAmount forKey:@"loan_money"];
    [self.loanParams setObject:[self appendConditionString:perCode LoanCode:loanCode] forKey:@"condition"];
    
    return self.loanParams;
}

#pragma mark 拼接筛选的条件
-(NSString*)appendConditionString:(NSString*)perCode LoanCode:(NSString*)loanCode{
    
    NSMutableString * condition=[NSMutableString string];
    if (!NULLString(perCode)) {
        [condition appendString:perCode];
        if (!NULLString(loanCode)) {
            [condition appendString:@","];
        }
    }
    if (!NULLString(loanCode)) {
        
        [condition appendString:loanCode];
    }
    
    return condition;
}

#pragma mark 获取筛选的贷款类型 code
-(NSString*)getLoanType{
    
    NSString * haveCondition=[self haveCondition:[ZHTypeInstance sharedInstance].btnItems];
    ZHTypeModel * typeModel=[ZHTypeInstance sharedInstance].needModel;
    
    if (!NULLString(typeModel.code)) {
        haveCondition= [haveCondition stringByAppendingString:typeModel.code];
    }else{
        if (haveCondition.length>1) {
            haveCondition=[haveCondition stringByReplacingCharactersInRange:NSMakeRange(haveCondition.length-1, 1) withString:@""];
        }
    }
    
    return haveCondition;
}

#pragma mark 获取筛选的金额的条件
-(NSString*)getLoanAmountValue{
    
    NSString * loan =[ZHTypeInstance sharedInstance].loanMoney;
    
    if (NULLString(loan)||[loan isEqualToString:@"金额不限"]) {
        return @"";
    }
    if ([loan containsString:@"万"]) {
        
        NSString * value =[loan stringByReplacingOccurrencesOfString:@"万元" withString:@""];
        return [NSString stringWithFormat:@"%ld",[value integerValue]*10000];
    }
    
    if ([loan containsString:@"元"]) {
      return   [loan stringByReplacingOccurrencesOfString:@"元" withString:@""];
    }
    
    return @"";
}

#pragma mark 获取筛选条件的 标题数组
-(NSArray*)getChooseButtonTitlesWithTypeModel:(ZHTypeModel*)typeModel{
    
    //身份类型
    NSString * perType = typeModel.name.length==0? @"身份不限":typeModel.name;
    //贷款金额
    NSString * loanAmount = NULLString([ZHTypeInstance sharedInstance].loanMoney)? @"金额不限":[ZHTypeInstance sharedInstance].loanMoney;
    //贷款条件
    NSString * condition = NULLString([self haveConditionName:[ZHTypeInstance sharedInstance].btnItems])? (NULLString([ZHTypeInstance sharedInstance].needModel.name)? @"贷款类型":[ZHTypeInstance sharedInstance].needModel.name):((NULLString([ZHTypeInstance sharedInstance].needModel.name)? [self haveConditionName:[ZHTypeInstance sharedInstance].btnItems]:[NSString stringWithFormat:@"%@%@",[self haveConditionName:[ZHTypeInstance sharedInstance].btnItems],[ZHTypeInstance sharedInstance].needModel.name]));
    
   self.chooseTitles=[NSMutableArray arrayWithObjects:perType,loanAmount,condition, nil];
    
    return self.chooseTitles;
    
}

#pragma mark 点击贷款类型筛选
-(void)loanTypeDidClickDeal:(NSArray*)items Item:(ButtonItem*)item2{
    
    self.chooseView.titles= [self getChooseButtonTitlesWithTypeModel:[ZHTypeInstance sharedInstance].typeModel];
    
    self.loanParams=[self getListRequestParams];
    self.chooseView.selectedTag=2;
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark 我有的筛选条件处理
-(NSString*)haveCondition:(NSArray*)items{
    
    NSString* string=@""; // 结果字符串
    for(ButtonItem * it in items){
        if (!NULLString(it.itemLabel.text)) {
           string= [string stringByAppendingString:it.typeModel.code];
            string=[string stringByAppendingString:@","];
        }
        NSLog(@"condition***%@",string);
    }
    return string;
}
#pragma mark 获取筛选文字
-(NSString*)haveConditionName:(NSArray*)items{
    
    NSString* string=@""; // 结果字符串
    for(ButtonItem * it in items){
        if (!NULLString(it.itemLabel.text)) {
            string= [string stringByAppendingString:it.typeModel.name];
        }
    }
    return string;
}
#pragma mark 弹出框处理
-(void)alertViewDeal:(ZHButtonItem *)item{
    
    ZHScanTypeView * scanTypeView =[ZHScanTypeView shareButtonItemWithFrame:CGRectMake(0, 64+ZHFit(50), ZHScreenW, ZHScreenH-64-ZHFit(50)) ItemChooseBlock:^(ButtonItem *item) {
        //身份选择的回调
        [self dealWithButtonItem:item];
        
    } LoanItemChooseBlock:^(NSArray *item1, ButtonItem *item2) {
        //贷款类型的回调
        [self loanTypeDidClickDeal:item1 Item:item2];
    }];

    self.scanTypeView=scanTypeView;
    
    if (KIsiPhoneX) {
        self.scanTypeView.y=StatusBarHeight+self.navigationController.navigationBar.frame.size.height;
        self.scanTypeView.height=ZHScreenH-ZHFit(50)-self.navigationController.navigationBar.frame.size.height-StatusBarHeight;
    }
    
    scanTypeView.changeDelegate=self.chooseView;
    self.chooseView.removeDelegate=self.scanTypeView;
    
    if (item.tag==2000) {
        self.scanTypeView.sourceArr=self.loanArray;
        return;
    }
    
    if (item.tag==2002) {
        self.scanTypeView.sourceArr=self.statusArr;
        return;
    }
    
    if (item.tag==2001) {
        
        self.pickerView = [ZHPickerView showPickerViewAddedTo:kWindow
                                  dataArray:(NSArray*)[self GetloanAmount]
                              confirmAction:^(NSString *string) {
                                  
                                  NSLog(@"贷款的金额%@",string);
                                  if (!NULLString(string)) {
                                      //保留筛选条件
                                      [ZHTypeInstance sharedInstance].loanMoney=string;
                                      
                                      self.chooseView.titles= [self getChooseButtonTitlesWithTypeModel:[ZHTypeInstance sharedInstance].typeModel];
                                      self.loanParams=[self getListRequestParams];
                                      self.chooseView.selectedTag=1;
                                      [self.tableView.mj_header beginRefreshing];
                                  }

                              } cancelAction:^{
                                  
                              } maskClick:^{
                                  
                              }];
        
        self.pickerView.changeDelegate=self.chooseView;
    }
    
}

#pragma mark 获取贷款额度
-(NSArray*)GetloanAmount{

    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"loan" ofType:@"plist"];
    NSMutableArray *loans = [[NSMutableArray alloc] initWithContentsOfFile:filePath];
    return loans;
}

#pragma mark - Table view data source

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.titles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ZHProductTableViewCell *cell = [ZHProductTableViewCell dequeueReusableCellWithTableView:tableView Identifier:@"cell" CellType:Product];
    
    if (self.titles.count>indexPath.row) {
        
        ZHProductModel * proModel =[self.titles objectAtIndex:indexPath.row];
        cell.productModel= proModel;
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.titles.count>indexPath.row) {
        
        ZHProductModel * proModel =[self.titles objectAtIndex:indexPath.row];
        ZHProductDetailController * VC =[ZHProductDetailController new];
        VC.productModel=proModel;
        VC.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:VC animated:NO];
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return ZHFit(80);
}


@end
