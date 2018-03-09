//
//  ZHMoreAutheViewController.m
//  ZHLoanClient
//
//  Created by 正和 on 2017/10/24.
//  Copyright © 2017年 小飞鸟. All rights reserved.
//

#import "ZHMoreAutheViewController.h"
#import "BaseInfoCell.h"
#import "BasicModel.h"
#import "ZHPickerModelView.h"

@interface ZHMoreAutheViewController ()
/** 选择数据的数组 */
@property (strong, nonatomic)  NSMutableArray *dataArr;

@end

@implementation ZHMoreAutheViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"更多认证";
    [self resetWhiteNaviBar];
    self.titles = [NSMutableArray arrayWithArray:@[
                                                   
              @[@"京东账号",@"淘宝账号",@"人行征信"],
                                                   
              @[@"社保缴纳",@"公积金缴纳",@"芝麻信用"]
                                                   
                                               ]];
    [self setupTableView];
    
    [self requestData];
    
    if (![[UserTool GetUser].auth_state isEqualToString:@"1"]) {
        
        self.jd_id=@"1";
        self.tb_id=@"1";
        self.pbc_id=@"1";
    }
    
    [self setupAuthFooterWithTitle:@"提交保存"];
    [self setupFooterWithTitle:@"提交保存" WithOffsetY:ZHFit(208) TotalHeight:ZHFit(280)];
    
    self.tableView.height=ZHScreenH-StatusBarHeight-self.navigationController.navigationBar.height-ZHFit(55);
    
}

- (void)requestData {

    if ([[UserTool GetUser].auth_state isEqualToString:@"1"]) {
        
        NSDictionary *params = @{
                                 @"cust_no" :[UserTool GetUser].custno
                                 };
        [HttpTool PostWithPath:@"/YJJQWebService/GetAuthInfo.spring" params:params success:^(id json) {
            if ([[json objectForKey:@"code"]isEqualToString:@"200"]) {
                NSLog(@"更多认证***%@",json);
                self.dataDictionary = json[@"data"];
                [self.tableView reloadData];
            }
        } failure:^(NSError *error) {
            
        }];
    }
}

#pragma mark 点击的复选
-(void)setBtnChoose:(BaseInfoCell*)cell Type:(NSString*)type{
    
    if ([type isEqualToString:@"1"]) {
        cell.leftBtn.selected=YES;
        cell.rightBtn.selected=NO;
    }else{
        cell.leftBtn.selected=NO;
        cell.rightBtn.selected=YES;
    }
}

#pragma mark - Table view dataSource
#pragma mark - Table view data source

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.titles.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return ((NSArray*)[self.titles objectAtIndex:section]).count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BaseInfoCell *cell = [BaseInfoCell cellWithTableView:tableView indexPath:indexPath];
    
    cell.textLabel.text = self.titles[indexPath.section][indexPath.row];
    
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            [cell.contentView addSubview:cell.leftBtn];
            [cell.contentView addSubview:cell.rightBtn];
            self.jd_id= self.jd_id? self.jd_id:self.dataDictionary[@"jd_id"];
            [self setBtnChoose:cell Type:self.jd_id];
            
            cell.btnBlock = ^(NSInteger tag) {
                self.jd_id = [NSString stringWithFormat:@"%ld",(long)tag];
            };
        }
        
        if (indexPath.row == 1) {
            [cell.contentView addSubview:cell.leftBtn];
            [cell.contentView addSubview:cell.rightBtn];
            
            self.tb_id= self.tb_id? self.tb_id:self.dataDictionary[@"tb_id"];
            [self setBtnChoose:cell Type:self.tb_id];
            cell.btnBlock = ^(NSInteger tag) {
                self.tb_id = [NSString stringWithFormat:@"%ld",(long)tag];
            };
        }
    
        if (indexPath.row == 2) {
            [cell.contentView addSubview:cell.leftBtn];
            [cell.contentView addSubview:cell.rightBtn];
            
            self.pbc_id= self.pbc_id? self.pbc_id:self.dataDictionary[@"pbc_id"];
            [self setBtnChoose:cell Type:self.pbc_id];
            
            cell.btnBlock = ^(NSInteger tag) {
                self.pbc_id = [NSString stringWithFormat:@"%ld",(long)tag];
            };
        }
    }
    if (indexPath.section == 1) {
        
        if (indexPath.row == 0) {
            
            self.social_fund_name=[NSString stringWithRequestDicValue:[NSString cutStringWithComma:self.dataDictionary[@"social_fund"]]SelectValue:self.social_fund_name];
            self.social_fund=[NSString stringWithRequestDicValue:self.dataDictionary[@"social_fund"] SelectValue:self.social_fund];
            
            cell.detailTextLabel.text=[NSString stringLabelTextWithRequestDicValue:[NSString cutStringWithComma:self.dataDictionary[@"social_fund"]]SelectValue:self.social_fund_name];
            cell.accessoryView = ArrowView;
        }
        
        if (indexPath.row == 1) {
            
            self.gjj_fund_name=[NSString stringWithRequestDicValue:[NSString cutStringWithComma:self.dataDictionary[@"gjj_fund"]]SelectValue:self.gjj_fund_name];
            self.gjj_fund=[NSString stringWithRequestDicValue:self.dataDictionary[@"gjj_fund"] SelectValue:self.gjj_fund];
            cell.detailTextLabel.text=[NSString stringLabelTextWithRequestDicValue:[NSString cutStringWithComma:self.dataDictionary[@"gjj_fund"]]SelectValue:self.gjj_fund_name];
            cell.accessoryView = ArrowView;
        }
        
        if (indexPath.row == 2) {
            
            self.zhima_fund_name=[NSString stringWithRequestDicValue:[NSString cutStringWithComma:self.dataDictionary[@"zhima_fund"]]SelectValue:self.zhima_fund_name];
            self.zhima_fund=[NSString stringWithRequestDicValue:self.dataDictionary[@"zhima_fund"] SelectValue:self.zhima_fund];
            cell.detailTextLabel.text=[NSString stringLabelTextWithRequestDicValue:[NSString cutStringWithComma:self.dataDictionary[@"zhima_fund"]]SelectValue:self.zhima_fund_name];
            cell.accessoryView = ArrowView;
            
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 1 && indexPath.row == 0) {//社保缴纳
        [self requestListWithKey:@"social_fund" andIndexPath:indexPath];
    }
    if (indexPath.section == 1 && indexPath.row == 1) {//工积金
        [self requestListWithKey:@"gjj_fund" andIndexPath:indexPath];
    }
    if (indexPath.section == 1 && indexPath.row == 2) {//芝麻信用
        [self requestListWithKey:@"zhima_fund" andIndexPath:indexPath];
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return section==self.titles.count-1? 0.01:ZHFit(10);
}

/**
 请求不同类型的数据
 @param str 数据类型
 */
- (void)requestListWithKey:(NSString *)str andIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *param = @{
                            @"type" : str,
                            @"isOnly" : @"1"
                            };
    [HttpTool PostWithPath:@"/YJJQWebService/GetTypeInfo.spring" params:param success:^(id json) {
        if ([[json objectForKey:@"code"]isEqualToString:@"200"]) {
            NSLog(@"banner数据***%@",json);
            
            self.dataArr = [BasicModel mj_objectArrayWithKeyValuesArray:json[@"data"]];
            
            [ZHPickerModelView showPickerViewAddedTo:kWindow dataArray:self.dataArr confirmAction:^(BasicModel *model) {
                
              ((BaseInfoCell *)[self.tableView cellForRowAtIndexPath:indexPath]).detailTextLabel.text = model.name;
                
                if (indexPath.row == 0) {
                    self.social_fund_name = model.name;
                    self.social_fund=[NSString stringWithFormat:@"%@,%@",model.code,model.name];
                } else if (indexPath.row == 1) {
                    self.gjj_fund_name = model.name;
                    self.gjj_fund=[NSString stringWithFormat:@"%@,%@",model.code,model.name];
                } else {
                    self.zhima_fund_name=model.name;
                    self.zhima_fund = [NSString stringWithFormat:@"%@,%@",model.code,model.name];
                }
                NSLog(@"选了%@,%@",model.name,model.code);
                
            } cancelAction:^{
            } maskClick:^{
            }];
        }
    } failure:^(NSError *error) {
        
    }];
}

//点击组尾后的操作
- (void)nextStep {
    
    if ([self checkInput] == NO) {
        return;
    }
    
    NSDictionary *params = @{
                             @"cust_no" : [UserTool GetUser].custno,
                             @"jd_id" : self.jd_id,
                             @"tb_id" : self.tb_id,
                             @"pbc_id" : self.pbc_id,
                             @"social_fund" : self.social_fund,
                             @"gjj_fund" : self.gjj_fund,
                             @"zhima_fund" : self.zhima_fund
                             };
    [HttpTool postWithPath:@"/YJJQWebService/SaveAuthInfo.spring" params:params success:^(id json) {

        if ([[json objectForKey:@"code"]isEqualToString:@"200"]) {
            NSLog(@"更多认证保存成功");
            [SVProgressHUD showSuccessWithStatus:@"保存成功"];
            [UserTool updateUserInfoKey:@"auth_state" Value:@"1"];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [self.navigationController popViewControllerAnimated:YES];
            });
        }
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"保存失败"];
    }];
}

/** 检查输入是否正确*/
- (BOOL)checkInput {
    
    if (NULLString(self.jd_id)) {
        
        [SVProgressHUD showInfoWithStatus:@"请选择是否有京东账号"];
        return NO;
    }
    
    if (NULLString(self.tb_id)) {
        [SVProgressHUD showInfoWithStatus:@"请选择是否有淘宝账号"];
        return NO;
    }
    
    if (NULLString(self.pbc_id)) {
        [SVProgressHUD showInfoWithStatus:@"请选择是否有人行征信"];
        return NO;
    }
    
    if (NULLString(self.social_fund_name)) {
        [SVProgressHUD showInfoWithStatus:@"请选择社保缴纳"];
        return NO;
    }
    
    if (NULLString(self.gjj_fund_name)) {
        [SVProgressHUD showInfoWithStatus:@"请选择公积金缴纳"];
        return NO;
    }
    
    if (NULLString(self.zhima_fund_name)) {
        [SVProgressHUD showInfoWithStatus:@"请选择芝麻信用"];
        return NO;
    }

    return YES;
}
@end
