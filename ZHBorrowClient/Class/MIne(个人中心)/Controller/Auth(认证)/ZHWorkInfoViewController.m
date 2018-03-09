//
//  ZHWorkInfoViewController.m
//  ZHMoneyClient
//
//  Created by zhph on 2017/7/14.
//  Copyright © 2017年 正和普惠. All rights reserved.
//

#import "ZHWorkInfoViewController.h"
#import "ZHMyTextView.h"
#import <objc/runtime.h>// 导入运行时文件
#import "BasicModel.h"
#import "ZHPickerModelView.h"
#import "MOFSPickerManager.h"

@interface ZHWorkInfoViewController ()<UITextFieldDelegate>
/** 单位名称 */
@property (copy, nonatomic) NSString *workunit;
/** 单位电话 */
@property (copy, nonatomic) NSString *unittel;
/** 单位名称 */
@property (strong, nonatomic) UITextField *workunitField;
/** 单位电话 */
@property (strong, nonatomic) UITextField *unittelField;
/** 客户职位 */
@property (copy, nonatomic) NSString *workjob;
/** 客户职位 */
@property (copy, nonatomic) NSString *workJobCode;
/*所属行业*/
@property(nonatomic,copy)NSString * inductoryName;
/*所属行业Code*/
@property(nonatomic,copy)NSString * inductoryCode;

/** 详细地址 */
@property (copy, nonatomic) NSString *workPlace;
/** 详细地址 */
@property (strong, nonatomic) ZHMyTextView *workTextView;
/*个人收入值*/
@property(nonatomic,copy)NSString * incomeString;
///** 月收入 */
//@property (strong, nonatomic) UITextField *incomeField;
/*个人收入值*/
@property(nonatomic,copy)NSString * jobTime;
/*个人收入值*/
@property(nonatomic,copy)NSString * jobTimeCode;
/** 选择数据的数组 */
@property (strong, nonatomic)  NSMutableArray *dataArr;
//户籍(工作)省的基本信息
@property(nonatomic,copy)NSString *  workProvinceStr;
//户籍(工作)市的基本信息
@property(nonatomic,copy)NSString * workCityStr;
//户籍(工作)区的基本信息
@property(nonatomic,copy)NSString * workAreaStr;
/** 户籍省市 */
@property (copy, nonatomic) NSString * workProvinceCity;
/** 职位级别 */
@property (strong, nonatomic) UITextField * workJobField;

@end

@implementation ZHWorkInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title=@"单位信息";
    [self resetWhiteNaviBar];

    self.titles=[NSMutableArray arrayWithObjects:@[@"单位名称",@"单位电话"],@[@"所属行业"],@[@"单位省市",@"详细地址"],@[@"职位级别",@"月薪资"],nil];
    [self setupTableView];
    [self setupAuthFooterWithTitle:@"提交保存"];
    self.tableView.height=ZHScreenH-StatusBarHeight-self.navigationController.navigationBar.height;
    [self setupFooterWithTitle:@"提交保存" WithOffsetY:ZHFit(58) TotalHeight:ZHFit(140)];
    [self requestData];
}

#pragma mark 工作信息请求数据
- (void)requestData{
    
    if ([[UserTool GetUser].credit_state isEqualToString:@"1"]) {

        [HttpTool postWithPath:@"/YJJQWebService/GetCompanyInfo.spring" params: @{@"cust_no":[UserTool GetUser].custno} success:^(id json) {
            if ([json[@"code"] isEqualToString:@"200"]){
                NSLog(@"工作信息****%@",json);
                self.dataDictionary =[NSMutableDictionary dictionaryWithDictionary:[json objectForKey:@"data"]];
                [self.tableView reloadData];
                
            }if ([json[@"message"] isEqualToString:@"贷款信息不存在"]) {
                [self.tableView reloadData];
            }
            
        } failure:^(NSError *error) {
            
        }];
    }
  
}

#pragma mark tableView的代理方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.titles.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return ((NSArray*)[self.titles objectAtIndex:section]).count;
}


-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static  NSString *ID = @"Work";
    
    BaseTableViewCell * cell =[BaseTableViewCell dequeueReusableCellWithTableView:tableView Identifier:ID];
    
    NSArray * sectionTitles=[self.titles objectAtIndex:indexPath.section];
    cell.titleLabel.text=[sectionTitles objectAtIndex:indexPath.row];
    if (indexPath.section==0&&indexPath.row==0) {
       
        _workunitField = [UITextField addFieldWithFrame:TextFiedFrame placeholder:@"请输入单位名称" delegate:self];
        [_workunitField addTarget:self action:@selector(textFieldWorkDidChange:) forControlEvents:UIControlEventEditingChanged];
        [cell.contentView addSubview:_workunitField];
        _workunitField.text=[NSString stringFieldTextWithRequestDicValue:self.dataDictionary[@"comp_name"] SelectValue:self.workunit];
        
    }
    
    if (indexPath.section==0&&indexPath.row==1) {
        _unittelField = [UITextField addFieldWithFrame:TextFiedFrame placeholder:@"请输入单位电话" delegate:self];
        [_unittelField addTarget:self action:@selector(textFieldWorkDidChange:) forControlEvents:UIControlEventEditingChanged];
        _unittelField.keyboardType=UIKeyboardTypeNumberPad;
        [cell.contentView addSubview:_unittelField];
        _unittelField.text=[NSString stringFieldTextWithRequestDicValue:self.dataDictionary[@"comp_mobile"] SelectValue:self.unittel];
    }
    
    if (indexPath.section==1&&indexPath.row==0) {
        cell.accessoryView=ArrowView;
        
        self.inductoryName=[NSString stringWithRequestDicValue:[NSString cutStringWithComma:self.dataDictionary[@"industry"]] SelectValue:self.inductoryName];
        self.inductoryCode=[NSString stringWithRequestDicValue:self.dataDictionary[@"industry"] SelectValue:self.inductoryCode];
        cell.detailLabel.text=[NSString stringLabelTextWithRequestDicValue:[NSString cutStringWithComma:self.dataDictionary[@"industry"]] SelectValue:self.inductoryName];
    }
    
    if (indexPath.section==2&&indexPath.row==0) {
        
        cell.accessoryView=ArrowView;
        
        NSString * str =[NSString stringWithRequestProvinceValue:self.dataDictionary[@"comp_prov"] CityValue:self.dataDictionary[@"comp_city"] AreaValue:self.dataDictionary[@"comp_area"]];
        
        self.workProvinceStr=[NSString stringWithRequestDicValue:self.dataDictionary[@"comp_prov"] SelectValue:self.workProvinceStr];
        self.workCityStr=[NSString stringWithRequestDicValue:self.dataDictionary[@"comp_city"] SelectValue:self.workCityStr];
        self.workAreaStr=[NSString stringWithRequestDicValue:self.dataDictionary[@"comp_area"] SelectValue:self.workAreaStr];
        
        self.workProvinceCity=[NSString stringWithRequestDicValue:str SelectValue:self.workProvinceCity];
        
        cell.detailLabel.text=[NSString stringLabelTextWithRequestDicValue:str SelectValue:self.workProvinceCity];
    }

    if (indexPath.section==2&&indexPath.row==1) {
        
        _workTextView=[ZHMyTextView createTextViewWithFrame:CGRectMake(ZHFit(100), ZHFit(16), (ZHScreenW-ZHFit(100)-ZHFit(20)), ZHFit(64)) TextBlock:^(NSString *text) {
            self.workPlace=text;
        }];
        _workTextView.placeholder = @"请输入详细地址";
         [cell.contentView addSubview:_workTextView];        
        _workTextView.text=[NSString stringFieldTextWithRequestDicValue:self.dataDictionary[@"comp_town"] SelectValue:self.workPlace];
    }
    
    if (indexPath.section==3&&indexPath.row==0) {
        
        _workJobField = [UITextField addFieldWithFrame:TextFiedFrame placeholder:@"请输入职位级别" delegate:self];
        [_workJobField addTarget:self action:@selector(textFieldWorkDidChange:) forControlEvents:UIControlEventEditingChanged];
        [cell.contentView addSubview:_workJobField];
        _workJobField.text=[NSString stringFieldTextWithRequestDicValue:self.dataDictionary[@"comp_job"] SelectValue:self.workjob];
    }
    if (indexPath.section==3&&indexPath.row==1) {

        cell.accessoryView=ArrowView;
        self.jobTime=[NSString stringWithRequestDicValue:[NSString cutStringWithComma:self.dataDictionary[@"month_salary"]] SelectValue:self.jobTime];
        self.jobTimeCode=[NSString stringWithRequestDicValue:self.dataDictionary[@"month_salary"] SelectValue:self.jobTimeCode];
        cell.detailLabel.text=[NSString stringLabelTextWithRequestDicValue:[NSString cutStringWithComma:self.dataDictionary[@"month_salary"]] SelectValue:self.jobTime];
    }
    
//    if (indexPath.section==3&&indexPath.row==2) {
//        _incomeField = [UITextField addFieldWithFrame:TextFiedFrame placeholder:@"请输入其他收入" delegate:self];
//        [_incomeField addTarget:self action:@selector(textFieldWorkDidChange:) forControlEvents:UIControlEventEditingChanged];
//        _incomeField.keyboardType=UIKeyboardTypeNumberPad;
//        [cell.contentView addSubview:_incomeField];
//
//        _incomeField.text=[NSString stringFieldTextWithRequestDicValue:self.dataDictionary[@"other_income"] SelectValue:self.incomeString];
//    }

    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    CGFloat cellHight=ZHFit(50);
    cellHight= (indexPath.section==2&&indexPath.row==1)? ZHFit(80):ZHFit(50);
    return cellHight;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return section==self.titles.count-1? 0.01:ZHFit(10);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section==1&&indexPath.row==0) {
        [self.view endEditing:YES];
        //所属行业
          [self requestIndustryAtIndexPath:indexPath];
    }

    if (indexPath.section==3&&indexPath.row==1) {
        //月薪资
       [self requestListWithKey:@"month_amt" andIndexPath:indexPath];
    }

    if (indexPath.section==2&&indexPath.row==0) {
        [self.view endEditing:YES];
        //单位省市
        [[MOFSPickerManager shareManger] showMOFSAddressPickerWithTitle:nil cancelTitle:@"取消" commitTitle:@"完成" commitBlock:^(NSString *address, NSString *zipcode) {
            
            self.workProvinceCity = [address stringByReplacingOccurrencesOfString:@"-" withString:@" "];
            BaseRighText(indexPath.section, indexPath.row)=self.workProvinceCity;
            //地址的数组
            NSArray * addressArr=(NSArray*)[address componentsSeparatedByString:@"-"];
            //Code的数组
            NSArray * codeArr = (NSArray*)[zipcode componentsSeparatedByString:@"-"];
            self.workProvinceStr = [NSString stringWithFormat:@"%@,%@",[codeArr objectAtIndex:0],[addressArr objectAtIndex:0]];
            self.workCityStr = [NSString stringWithFormat:@"%@,%@",[codeArr objectAtIndex:1],[addressArr objectAtIndex:1]];
            self.workAreaStr = [NSString stringWithFormat:@"%@,%@",[codeArr objectAtIndex:2],[addressArr objectAtIndex:2]];
            
        } cancelBlock:^{
            
        }];
    }
}

#pragma mark 获取所属行业
-(void)requestIndustryAtIndexPath:(NSIndexPath *)indexPath{
    
    [HttpTool PostWithPath:@"/YJJQWebService/GetIndustry.spring" params:nil success:^(id json) {
        if ([[json objectForKey:@"code"]isEqualToString:@"200"]) {
            NSLog(@"所属行业数据***%@",json);
            
            self.dataArr = [BasicModel mj_objectArrayWithKeyValuesArray:json[@"data"]];
            
            [ZHPickerModelView showPickerViewAddedTo:kWindow dataArray:self.dataArr confirmAction:^(BasicModel *model) {
                
                ((BaseTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath]).detailLabel.text = model.name;
                
                if (indexPath.section==1&&indexPath.row==0) {
                    self.inductoryName = model.name;
                    self.inductoryCode=[NSString stringWithFormat:@"%@,%@",model.code,model.name];
                }

                NSLog(@"选了code=%@,name=%@",model.code,model.name);
                
            } cancelAction:^{
            } maskClick:^{
            }];
        }
    } failure:^(NSError *error) {
        
    }];
    
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
                
                ((BaseTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath]).detailLabel.text = model.name;
                
                if (indexPath.section==1&&indexPath.row==0) {
                    self.inductoryName = model.name;
                    self.inductoryCode=[NSString stringWithFormat:@"%@,%@",model.code,model.name];
                }
                
                if (indexPath.section==3&&indexPath.row==0) {
                    self.workjob = model.name;
                    self.workJobCode=[NSString stringWithFormat:@"%@,%@",model.code,model.name];
                }
                if (indexPath.section==3&&indexPath.row==1) {
                    self.jobTime = model.name;
                    self.jobTimeCode=[NSString stringWithFormat:@"%@,%@",model.code,model.name];
                }
                NSLog(@"选了code=%@,name=%@",model.code,model.name);
                
            } cancelAction:^{
            } maskClick:^{
            }];
        }
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark 文字修改
-(void)textFieldWorkDidChange:(UITextField*)textField{
    
    NSString *text = [textField text];
    if (self.workunitField==textField) {
        self.workunit=text;
        return;
    }
    
    if (self.unittelField==textField) {
        self.unittel=text;
        return;
    }

//    if (self.incomeField==textField) {
//        self.incomeString=text;
//        return;
//    }
    if (self.workJobField==textField) {
        self.workjob =text;
    }
}

#pragma mark textfield的代理方法
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    //敲删除键
    if ([string length] == 0) {
        return YES;
    }

    //住宅电话
    if (textField == self.unittelField) {
        
        if (textField.text.length > 11) return NO;
    }
    //住宅电话
    if (textField == self.workJobField) {
        
        if (textField.text.length > 18) return NO;
    }
    
    return YES;
}

//点击组尾后的操作
- (void)nextStep{

    if ([self checkWorkInfo]) {

        NSDictionary * params = @{
                                  @"cust_no":[UserTool GetUser].custno,
                                  @"comp_name":self.workunitField.text,
                                  @"comp_mobile":self.unittelField.text,
                                  @"industry":self.inductoryCode,
                                  @"comp_prov":self.workProvinceStr,
                                  @"comp_city":self.workCityStr,
                                  @"comp_area":self.workAreaStr,
                                  @"comp_town":self.workTextView.text,
                                  @"comp_job":self.workJobField.text,
                                  @"month_salary":self.jobTimeCode,
                                  @"other_income":@"0"
                                  };

        [HttpTool postWithPath:@"/YJJQWebService/SaveCompanyInfo.spring" params:params success:^(id json) {
            
            if ([[json objectForKey:@"code"]isEqualToString:@"200"]) {
                
                [SVProgressHUD showSuccessWithStatus:@"保存成功"];
                [UserTool updateUserInfoKey:@"credit_state" Value:@"1"];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.navigationController popViewControllerAnimated:YES];
                });
            }

        } failure:^(NSError *error) {
            [SVProgressHUD showInfoWithStatus:@"保存失败"];
        }];
    }
}

#pragma mark 工作信息监测
-(BOOL)checkWorkInfo{
    
    if (NULLString(self.workunitField.text)) {
        
        [SVProgressHUD showInfoWithStatus:@"请输入单位名称"];
        return NO;
    }
    if (NULLString(self.unittelField.text)) {
        
        [SVProgressHUD showInfoWithStatus:@"请输入单位电话"];
        return NO;
    }
    
    if (![ZHStringFilterTool filterByPhoneNumber:self.unittelField.text]) {
        
        [SVProgressHUD showInfoWithStatus:@"请输入合法的单位电话"];
        return NO;
    }
    
    if ([BaseRighText(1, 0) isEqualToString:@"请选择"]) {
        
        [SVProgressHUD showInfoWithStatus:@"请选择所属行业类型"];
        return NO;
    }
    
    if ([BaseRighText(2, 0) isEqualToString:@"请选择"]) {
        
        [SVProgressHUD showInfoWithStatus:@"请选择单位省市区"];
        return NO;
    }
    
    if (NULLString(self.workTextView.text)) {
        
        [SVProgressHUD showInfoWithStatus:@"请输入单位详细地址"];
        return NO;
    }
    
    if (NULLString(self.workJobField.text)) {
        
        [SVProgressHUD showInfoWithStatus:@"请输入职位级别"];
        return NO;
    }
    
    if (NULLString(self.jobTime)) {
        
        [SVProgressHUD showInfoWithStatus:@"请选择月薪资"];
        return NO;
    }
//    if (NULLString(self.incomeField.text)) {
//
//        [SVProgressHUD showInfoWithStatus:@"请输入其他收入"];
//        return NO;
//    }
    
    return YES;

}

@end
