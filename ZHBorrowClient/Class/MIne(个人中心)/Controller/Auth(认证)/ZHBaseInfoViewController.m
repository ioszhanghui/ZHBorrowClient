//
//  ZHBaseInfoViewController.m
//  ZHBorrowClient
//
//  Created by 小飞鸟 on 2017/12/22.
//  Copyright © 2017年 小飞鸟. All rights reserved.
//

#import "ZHBaseInfoViewController.h"
#import "ZHMyTextView.h"
#import "ZHLinkPeopleCell.h"
#import "BasicModel.h"
#import "ZHPickerModelView.h"
#import "CLocationManager.h"
#import <AddressBookUI/ABPeoplePickerNavigationController.h>
#import <AddressBookUI/ABPersonViewController.h>
#import "ZHLinkPeopleModel.h"
#import "MOFSPickerManager.h"

#define LinkCell(section,row)   ((ZHLinkPeopleCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:section]])

@interface ZHBaseInfoViewController ()<ABPeoplePickerNavigationControllerDelegate>
/*学历名字*/
@property(nonatomic,copy)NSString * educationName;
/*学历Code*/
@property(nonatomic,copy)NSString * educationCode;
/** 婚姻状况 已婚有子女:(007002) 未婚:(019002) */
@property (copy, nonatomic) NSString *mar_status;
@property (copy, nonatomic)  NSString *mar_status_name;
/** 详细地址 */
@property (copy, nonatomic) NSString * livePlace;
/** 详细地址 */
@property (strong, nonatomic) ZHMyTextView * liveTextView;
/** 选择数据的数组 */
@property (strong, nonatomic)  NSMutableArray *dataArr;
/*定位地址*/
@property(nonatomic,copy)NSString * address;
/*联系人姓名1*/
@property(nonatomic,copy)NSString * lineName1;
/*联系人电话1*/
@property(nonatomic,copy)NSString * linePhone1;
/*联系人关系1*/
@property(nonatomic,copy)NSString * linkConnection1;
/*联系人关系Code*/
@property(nonatomic,copy)NSString * linkConnection1Code;
/*联系人姓名2*/
@property(nonatomic,copy)NSString * lineName2;
/*联系人电话2*/
@property(nonatomic,copy)NSString * linePhone2;
/*联系人关系2*/
@property(nonatomic,copy)NSString * linkConnection2;
/*联系人关系Code*/
@property(nonatomic,copy)NSString * linkConnection2Code;
/*联系人姓名3*/
@property(nonatomic,copy)NSString * lineName3;
/*联系人电话3*/
@property(nonatomic,copy)NSString * linePhone3;
/*联系人关系3*/
@property(nonatomic,copy)NSString * linkConnection3;
/*联系人关系Code*/
@property(nonatomic,copy)NSString * linkConnection3Code;
/*联系人姓名4*/
@property(nonatomic,copy)NSString * lineName4;
/*联系人电话4*/
@property(nonatomic,copy)NSString * linePhone4;
/*联系人关系4*/
@property(nonatomic,copy)NSString * linkConnection4;
/*联系人关系Code*/
@property(nonatomic,copy)NSString * linkConnection4Code;
/*联系人当前选中项的*/
@property(nonatomic,strong)NSIndexPath * currentIndexPath;
/*用户联系人数组*/
@property(nonatomic,strong)NSMutableArray * dataArray;
/** 其他关系模型 */
@property (nonatomic , strong) ZHLinkPeopleModel * linkModel;

@end

@implementation ZHBaseInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title=@"基本信息";
    
    [self resetWhiteNaviBar];
    self.dataArray=[NSMutableArray array];
    [self setupTableView];
    self.titles = [NSMutableArray arrayWithObjects:@[@"学历",@"婚姻状况"],@[@"居住省市",@"详细地址"],@[@"联系人一"],@[@"联系人二"],@[@"联系人三"],@[@"联系人四"] ,nil];

    self.tableView.height=ZHScreenH-StatusBarHeight-self.navigationController.navigationBar.height;
    //回显数据
    [self requestData];
    
    if (![[UserTool GetUser].base_state isEqualToString:@"1"]) {
        
        [self InitLocationInfo];
    }
    //测试
    [self setupAuthFooterWithTitle:@"提交保存"];
    [self setupFooterWithTitle:@"提交保存" WithOffsetY:ZHFit(58) TotalHeight:ZHFit(140)];
     [UIView addLineWithFrame:CGRectMake(0, 0, ZHScreenW, 0.5) WithView:self.view];
}

#pragma mark 重新定位信息
-(void)InitLocationInfo{
    
        if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusRestricted) {
    
        }else{
            //保存定位信息
            [self saveLocationPlace];
        }

}

#pragma mark 保存定位信息
-(void)saveLocationPlace{
    //保存GPS信息
    [[CLocationManager shareLocation] getLocationCoordinate:^(CLLocationCoordinate2D locationCorrrdinate) {
        
    } withAddress:^(NSString *addressString) {
        [UserTool setObject:addressString forKey:Location];
        self.address =addressString;
        BaseRighText(1, 0)=addressString;
    } FirstTime:^{
        
    }];
}


#pragma mark - 去掉电话号中的空格和横线
-(NSString*)clearVLineAndSpaseWithPhone:(NSString*)phone{
    NSString * str = [phone stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString * phoneNum = [str stringByReplacingOccurrencesOfString:@"-" withString:@""];
    return phoneNum;
}

//设置上传参数
-(NSArray * )getOtherContract{
    NSArray * data = [NSArray array];
    
    NSString * phone0 = [self clearVLineAndSpaseWithPhone:self.linePhone1];
    NSString * phone1 = [self clearVLineAndSpaseWithPhone:self.linePhone2];
    NSString * phone2 = [self clearVLineAndSpaseWithPhone:self.linePhone3];
    NSString * phone3 = [self clearVLineAndSpaseWithPhone:self.linePhone4];
    
    if (self.titles.count==6) {//4个联系人
        data = @[
                 @{@"contact_mobile":phone0,
                   @"contact_name":self.lineName1,
                   @"contact_rel":self.linkConnection1Code,
                   @"contract_index":@"1"},
                 @{@"contact_name":self.lineName2,
                   @"contact_rel":self.linkConnection2Code,
                   @"contact_mobile":phone1,
                   @"contract_index":@"2"},
                 @{@"contact_name":NULLString(self.lineName3)? @"":self.lineName3,
                   @"contact_rel":NULLString(self.linkConnection3Code)? @"":self.linkConnection3Code,
                   @"contact_mobile":NULLString(phone2)? @"":phone2,
                   @"contract_index":@"3"},
                 @{@"contact_name":NULLString(self.lineName4)?@"":self.lineName4,
                   @"contact_rel":NULLString(self.linkConnection4Code)? @"":self.linkConnection4Code,
                   @"contact_mobile":NULLString(phone3)? @"":phone3,
                   @"contract_index":@"4"},
                 ];
    }else{
            if (self.dataArray.count>3) {//上次回显4个数据，然后修改婚姻状态，只修改后三个关系
                data = @[
                         @{@"contact_name":self.lineName1,
                           @"contact_rel":self.linkConnection1Code,
                           @"contact_mobile":phone0,
                           @"contract_index":@"1"},
                         @{@"contact_name":NULLString(self.lineName2)? @"":self.lineName2,
                           @"contact_rel":NULLString(self.linkConnection2Code)? @"":self.linkConnection2Code,
                           @"contact_mobile":NULLString(phone1)? @"":phone1,
                           @"contract_index":@"2"},
                         @{@"contact_name":NULLString(self.lineName3)?@"":self.lineName3,
                           @"contact_rel":NULLString(self.linkConnection3Code)?@"":self.linkConnection3Code,
                           @"contact_mobile":NULLString(phone2)?@"":phone2,
                           @"contract_index":@"3"},
                         ];
            }else{
                data = @[
                         @{@"contact_name":self.lineName1,
                           @"contact_rel":self.linkConnection1Code,
                           @"contact_mobile":phone0,
                           @"contract_index":@"1"},
                         @{@"contact_name":NULLString(self.lineName2)? @"":self.lineName2,
                           @"contact_rel":NULLString(self.linkConnection2Code)? @"":self.linkConnection2Code,
                           @"contact_mobile":NULLString(phone1)?@"":phone1,
                           @"contract_index":@"2"},
                         @{@"contact_name":NULLString(self.lineName3)? @"":self.lineName3,
                           @"contact_rel":NULLString(self.linkConnection3Code)? @"":self.linkConnection3Code,
                           @"contact_mobile":NULLString(phone2)?@"":phone2,
                           @"contract_index":@"3"},
                         ];
            }
        }
    return data;
}

#pragma mark 保存基本信息
-(void)nextStep{
    
    if ([self checkUserInfo]) {

        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:@{
                                                                                      @"cust_no":[UserTool GetUser].custno,
                                                                                      @"contracts":[self getOtherContract],
                                                                                      @"education":self.educationCode,
                                                                                      @"mar_status":self.mar_status,
                                                                                      @"live_prov_city":self.address,
                                                                                      @"live_detail":_liveTextView.text,
                                                                                      }];
        
        [HttpTool postWithPath:@"YJJQWebService/SaveBaseInfo.spring" params:params success:^(id json) {
            NSLog(@"=====%@",json);
            if ([json[@"code"] isEqualToString:@"200"]) {

                [SVProgressHUD showSuccessWithStatus:@"保存成功"];
                [UserTool updateUserInfoKey:@"base_state" Value:@"1"];
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    
                    [self.navigationController popViewControllerAnimated:YES];
                });
            }
        } failure:^(NSError *error) {
            
        }];
    }
}

#pragma mark 检查用户信息
-(BOOL)checkUserInfo{
    if (NULLString(self.educationCode)) {
        [SVProgressHUD showInfoWithStatus:@"请选择学历"];
        return NO;
    }
    
    if (NULLString(self.mar_status)) {
        [SVProgressHUD showInfoWithStatus:@"请选择婚姻状况"];
        return NO;
    }
    
    if ([self.address isEqualToString:@"请选择"]) {
        [SVProgressHUD showInfoWithStatus:@"请点击获取定位"];
        return NO;
    }
    
    if (NULLString(self.liveTextView.text)) {
        [SVProgressHUD showInfoWithStatus:@"请输入详细地址"];
        return NO;
    }
    
    if (NULLString(self.linkConnection1)||NULLString(self.linkConnection2)||NULLString(self.linkConnection3)) {
        [SVProgressHUD showInfoWithStatus:@"请选择联系人关系"];
        return NO;
    }
    
    if (self.titles.count==6&&NULLString(self.linkConnection4)) {
        [SVProgressHUD showInfoWithStatus:@"请选择联系人关系"];
        return NO;
    }
    
    if (NULLString(self.lineName1)||NULLString(self.lineName2)||NULLString(self.lineName3)) {
        [SVProgressHUD showInfoWithStatus:@"请填写联系人姓名"];
        return NO;
    }
    
    if (self.titles.count==6&&NULLString(self.lineName4)) {
        [SVProgressHUD showInfoWithStatus:@"请填写联系人姓名"];
        return NO;
    }
    
    if (![ZHStringFilterTool filterByUserNameChinese:self.lineName1]||![ZHStringFilterTool filterByUserNameChinese:self.lineName2]||![ZHStringFilterTool filterByUserNameChinese:self.lineName3]) {
        [SVProgressHUD showInfoWithStatus:@"请填写合法的联系人姓名"];
        return NO;
    }
    
    if (self.titles.count==6&&![ZHStringFilterTool filterByUserNameChinese:self.lineName4]) {
        [SVProgressHUD showInfoWithStatus:@"请填写联系人姓名"];
        return NO;
    }
    
    if (NULLString(self.linePhone1)||NULLString(self.linePhone2)||NULLString(self.linePhone3)) {
        [SVProgressHUD showInfoWithStatus:@"请填写联系人电话"];
        return NO;
    }
    
    if (self.titles.count==6&&NULLString(self.linePhone4)) {
        [SVProgressHUD showInfoWithStatus:@"请填写联系人电话"];
        return NO;
    }
    
    if (![ZHStringFilterTool checkPhoneNumRight:self.linePhone1]||![ZHStringFilterTool checkPhoneNumRight:self.linePhone1]||![ZHStringFilterTool checkPhoneNumRight:self.linePhone1]) {
        [SVProgressHUD showInfoWithStatus:@"请填写合法的联系人电话"];
        return NO;
    }
    
    if (self.titles.count==6&&![ZHStringFilterTool checkPhoneNumRight:self.linePhone4]) {
        
        [SVProgressHUD showInfoWithStatus:@"请填写合法的联系人电话"];
        return NO;
    }
    
    if ([self.linePhone1 isEqualToString:self.linePhone2]||[self.linePhone2 isEqualToString:self.linePhone3]||[self.linePhone1 isEqualToString:self.linePhone3]) {
        
        [SVProgressHUD showInfoWithStatus:@"请填写不同的联系人电话"];
        return NO;
    }
    
    if (self.titles.count==6&&([self.linePhone1 isEqualToString:self.linePhone4]||[self.linePhone4 isEqualToString:self.linePhone3])) {
        [SVProgressHUD showInfoWithStatus:@"请填写不同的联系人电话"];
        return NO;
    }
    return YES;
}

#pragma mark 提示用户获取权限
-(void)alertPersonLocation{
    
    //单位省市
    [[MOFSPickerManager shareManger] showMOFSAddressPickerWithTitle:nil cancelTitle:@"取消" commitTitle:@"完成" commitBlock:^(NSString *address, NSString *zipcode) {
        
        self.address = [address stringByReplacingOccurrencesOfString:@"-" withString:@" "];
        BaseRighText(1, 0)=self.address;
        [UserTool setObject:self.address forKey:Location];
        
    } cancelBlock:^{
        
    }];
}

#pragma mark tableView的代理方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.titles.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return ((NSArray*)[self.titles objectAtIndex:section]).count;
}


-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    BaseTableViewCell * cell;
    
    if (indexPath.section<2) {
        
        static  NSString *ID = @"Work";
        cell =[BaseTableViewCell dequeueReusableCellWithTableView:tableView Identifier:ID];
        cell.titleLabel.text=[((NSArray*)[self.titles objectAtIndex:indexPath.section]) objectAtIndex:indexPath.row];
        if (indexPath.section==0&&indexPath.row==0) {
            cell.accessoryView=ArrowView;
            self.educationName=[NSString stringWithRequestDicValue:[NSString cutStringWithComma:self.dataDictionary[@"baseinfo"][@"education"]] SelectValue:self.educationName];
            self.educationCode=[NSString stringWithRequestDicValue:self.dataDictionary[@"baseinfo"][@"education"] SelectValue:self.educationCode];
            
            cell.detailLabel.text=[NSString stringLabelTextWithRequestDicValue:[NSString cutStringWithComma:self.dataDictionary[@"baseinfo"][@"education"]] SelectValue:self.educationName];
        }
        
        if (indexPath.section==0&&indexPath.row==1) {
            
            cell.accessoryView = ArrowView;
            self.mar_status_name=[NSString stringWithRequestDicValue:[NSString cutStringWithComma:self.dataDictionary[@"baseinfo"][@"mar_status"]]SelectValue:self.mar_status_name];
            self.mar_status=[NSString stringWithRequestDicValue:self.dataDictionary[@"baseinfo"][@"mar_status"] SelectValue:self.mar_status];
            
            cell.detailLabel.text=[NSString stringLabelTextWithRequestDicValue:[NSString cutStringWithComma:self.dataDictionary[@"baseinfo"][@"mar_status"]]SelectValue:self.mar_status_name];
        }
        
        if (indexPath.section==1&&indexPath.row==0) {
            
            UIImageView * locationView=[[UIImageView alloc]initWithFrame:CGRectMake(0,0, ZHFit(17), ZHFit(17))];
            locationView.image=[UIImage imageNamed:@"位置"];
            cell.accessoryView=locationView;
            
            cell.detailLabel.text = [NSString stringLabelTextWithRequestDicValue:[NSString cutStringWithComma:self.dataDictionary[@"baseinfo"][@"live_prov_city"]]SelectValue:self.address];
            self.address=[NSString stringWithRequestDicValue:[NSString cutStringWithComma:self.dataDictionary[@"baseinfo"][@"live_prov_city"]]SelectValue:self.address];
        }
        
        if (indexPath.section==1&&indexPath.row==1) {
            
            _liveTextView=[ZHMyTextView createTextViewWithFrame:CGRectMake(ZHFit(102), ZHFit(16), (ZHScreenW-ZHFit(100)-ZHFit(34)), ZHFit(64)) TextBlock:^(NSString *text) {
                self.livePlace=text;
            }];
            _liveTextView.placeholder = @"请输入详细地址";
            [cell.contentView addSubview:_liveTextView];
            _liveTextView.text=[NSString stringFieldTextWithRequestDicValue:self.dataDictionary[@"baseinfo"][@"live_detail"] SelectValue:self.livePlace];
        }
        
        return  cell;
    }else{
        
        static  NSString *ID = @"Link";
        cell =[ZHLinkPeopleCell dequeueReusableCellWithTableView:tableView Identifier:ID];
        cell.titleLabel.text=[((NSArray*)[self.titles objectAtIndex:indexPath.section]) objectAtIndex:indexPath.row];
        ((ZHLinkPeopleCell*)cell).indexPath=indexPath;
        ((ZHLinkPeopleCell*)cell).selectLabel.hidden = (self.titles.count==6&&indexPath.section==2&&!NULLString(self.mar_status_name))? YES:NO;
        ((ZHLinkPeopleCell*)cell).callAddressBookBlock = ^(NSIndexPath *indexPath) {
            
            if (NULLString(self.mar_status_name)) {
                [SVProgressHUD showInfoWithStatus:@"请选择婚姻状况"];
                return;
            } //选择婚姻关系
            //吊起通讯录的授权
            [self addressBookAuth];
            self.currentIndexPath = indexPath;
        };
        
        ((ZHLinkPeopleCell*)cell).relationShipRecall = ^(NSIndexPath *indexPath) {
            
            if (NULLString(self.mar_status_name)) {
                [SVProgressHUD showInfoWithStatus:@"请选择婚姻状况"];
                return;
            } //选择婚姻关系
            
            //点击关系的回调
            [self didSelectRelationShip:indexPath];
        };
        [self getLoadDataAtIndexPath:indexPath];
        //监控输入变化
        [((ZHLinkPeopleCell*)cell).linkTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        
        //姓名监控输入变化
        [((ZHLinkPeopleCell*)cell).nameTextField addTarget:self action:@selector(textFieldNameDidChange:) forControlEvents:UIControlEventEditingChanged];

        /*初始化数据*/
        switch (indexPath.section) {
            case 2:{
                //联系人一
                 [self loadCellValue:((ZHLinkPeopleCell*)cell) Name:self.lineName1 PhoneNumber:self.linePhone1 Relation:self.linkConnection1];
                break;
            }
            case 3:{
                //联系人二
                 [self loadCellValue:((ZHLinkPeopleCell*)cell) Name:self.lineName2 PhoneNumber:self.linePhone2 Relation:self.linkConnection2];
                break;
            }
            case 4:{
                //联系人三
                [self loadCellValue:((ZHLinkPeopleCell*)cell) Name:self.lineName3 PhoneNumber:self.linePhone3 Relation:self.linkConnection3];
                break;
            }
            case 5:{
                //联系人四
                [self loadCellValue:((ZHLinkPeopleCell*)cell) Name:self.lineName4 PhoneNumber:self.linePhone4 Relation:self.linkConnection4];
                break;
            }
                
            default:
                break;
        }
    }

    return cell;
}

#pragma mark 获取请求的联系人信息
-(void)getLoadDataAtIndexPath:(NSIndexPath*)indexPath{
    //回显的数据
    if (self.titles.count==6) {
        //4个联系人
        if (self.dataArray.count==4) {
            self.linkModel= self.dataArray.count>0? [self.dataArray objectAtIndex:indexPath.section-2]:nil;
        }else{
            self.linkModel = self.dataArray.count>0?( indexPath.section==2? nil:([self.dataArray objectAtIndex:indexPath.section-3])):nil;
        }
    }else{
        
        if (self.dataArray.count==4) {
            
            self.linkModel= self.dataArray.count>0? [self.dataArray objectAtIndex:indexPath.section-1]:nil;
        }else{
            
            self.linkModel = self.dataArray.count>0? [self.dataArray objectAtIndex:indexPath.section-2]:nil;
        }
    }
}

#pragma mark 点击关系调用
-(void)didSelectRelationShip:(NSIndexPath*)indexPath{
    
    NSInteger section =indexPath.section;
    
    if (self.titles.count == 6) {
        section =section-1;
    }
    switch (section) {
        case 2:{
            //四个联系人 第二个  包含父母的
            [self reloadPlistFile:indexPath FileName:@"parent.plist"];
            
            break;
        }
        case 3:
        case 4: {
            //四个联系人 第二个  包含同事的
            [self reloadPlistFile:indexPath FileName:@"otherLink.plist"];
            break;
        }
            
        default:
            break;
    }
   
}

#pragma mark 读取文件加载数据
-(void)reloadPlistFile:(NSIndexPath*)indexPath FileName:(NSString*)fileName{
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:fileName ofType:nil];
    NSMutableArray * data1 = [[NSMutableArray alloc] initWithContentsOfFile:filePath];
    self.dataArr = [BasicModel mj_objectArrayWithKeyValuesArray:data1];
    
    [ZHPickerModelView showPickerViewAddedTo:kWindow dataArray:self.dataArr confirmAction:^(BasicModel *model) {
        
        BaseRighText(indexPath.section, indexPath.row)=model.name;
        if(indexPath.row==0&&indexPath.section==2 ){
            self.linkConnection1Code=[NSString stringWithFormat:@"%@,%@",model.code,model.name];
            self.linkConnection1= model.name;
        } else if (indexPath.row==0 &&indexPath.section==3){
            self.linkConnection2Code = [NSString stringWithFormat:@"%@,%@",model.code,model.name];
            self.linkConnection2 = model.name;
        }else if (indexPath.row==0&&indexPath.section==4){
            
            self.linkConnection3Code = [NSString stringWithFormat:@"%@,%@",model.code,model.name];
            self.linkConnection3 = model.name;
        }else if (indexPath.row==0&&indexPath.section==5){
            
            self.linkConnection4Code = [NSString stringWithFormat:@"%@,%@",model.code,model.name];
            self.linkConnection4 = model.name;
        }
        NSLog(@"选了code=%@,name=%@",model.code,model.name);
        
    } cancelAction:^{
        
    } maskClick:^{
        
    }];
}

#pragma mark 加载cell的数据
-(void)loadCellValue:(ZHLinkPeopleCell*)cell Name:(NSString*)name PhoneNumber:(NSString*)phone Relation:(NSString*)relation{
    cell.nameTextField.text = [NSString stringFieldTextWithRequestDicValue:self.linkModel.contact_name SelectValue:name];
    cell.linkTextField.text = [NSString stringFieldTextWithRequestDicValue:self.linkModel.contact_rel SelectValue:phone];
    cell.detailLabel.text=[NSString stringLabelTextWithSelectNilValue:[ZHStringFilterTool cutOffStringWithLastObj:self.linkModel.contact_rel] SelectValue:relation];
}

#pragma mark - 请求回显数据
-(void)requestData{
    
    if ([[UserTool GetUser].base_state isEqualToString:@"1"]) {
        
        NSDictionary * params = @{@"cust_no":[UserTool GetUser].custno};
        [HttpTool postWithPath:@"YJJQWebService/GetBaseInfo.spring" params:params success:^(id json) {

            if ([json[@"code"] isEqualToString:@"200"]){
                NSLog(@"基本信息****%@",json);
                
                for (NSDictionary * dict in json[@"data"][@"contracts"]) {
                    ZHLinkPeopleModel * model = [ZHLinkPeopleModel mj_objectWithKeyValues:dict];
                    [self.dataArray addObject:model];
                }
                NSArray * dictArray = [NSArray arrayWithArray:json[@"data"][@"contracts"]];
                if (dictArray.count==0) {
                    return ;
                }
                
                NSString * marrayStatus =[[[json objectForKey:@"data"] objectForKey:@"baseinfo"] objectForKey:@"mar_status"];
                if ([marrayStatus containsString:@"已婚"]) {
                    self.titles = [NSMutableArray arrayWithObjects:@[@"学历",@"婚姻状况"],@[@"居住省市",@"详细地址"],@[@"联系人一"],@[@"联系人二"],@[@"联系人三"],@[@"联系人四"] ,nil];
                    self.linkConnection1Code=@"200205,配偶";
                    self.linkConnection1=@"配偶";
                    self.mar_status = marrayStatus;
                }else{
                    
                    self.titles = [NSMutableArray arrayWithObjects:@[@"学历",@"婚姻状况"],@[@"居住省市",@"详细地址"],@[@"联系人一"],@[@"联系人二"],@[@"联系人三"],nil];
                }
                
                [self saveDataWithNetData:dictArray];
                
                self.dataDictionary =[NSMutableDictionary dictionaryWithDictionary:[json objectForKey:@"data"]];
                [self.tableView reloadData];
                
            }if ([json[@"message"] isEqualToString:@"贷款信息不存在"]) {
                [self.tableView reloadData];
            }
            
        } failure:^(NSError *error) {
            
        }];
    }
    
}
#pragma mark  textField编辑代理方法
-(void)textFieldNameDidChange:(UITextField*)textField{
    
    ZHLinkPeopleCell * cell = (ZHLinkPeopleCell*)textField.superview.superview;
    switch (cell.indexPath.section) {
        case 2:{
            self.lineName1 = textField.text;
        }
            break;
        case 3:{
            self.lineName2 = textField.text;
        }
            break;
        case 4:{
            self.lineName3 = textField.text;
        }
            break;
        case 5:{
            self.lineName4 = textField.text;
        }
            break;
            
        default:
            break;
    }
}

#pragma mark textField编辑代理方法
-(void)textFieldDidChange:(UITextField*)textField{
    
    ZHLinkPeopleCell * cell = (ZHLinkPeopleCell*)textField.superview.superview;
    switch (cell.indexPath.section) {
        case 2:{
            self.linePhone1 = textField.text;
        }
            break;
        case 3:{
            self.linePhone2 = textField.text;
        }
            break;
        case 4:{
            self.linePhone3 = textField.text;
        }
            break;
        case 5:{
            self.linePhone4 = textField.text;
        }
            break;
            
        default:
            break;
    }

}

#pragma mark 保存回显数据
-(void)saveDataWithNetData:(NSArray*)arr{
    
    if ([self.mar_status containsString:@"已婚"]) {
        if (arr.count<4) {
            self.lineName1=nil;
            self.linePhone1 = nil;
            //之前选择的三个 现在 保存四个
            self.lineName2 = arr[0][@"contact_name"];
            self.linePhone2 = arr[0][@"contact_mobile"];
            self.linkConnection2Code = arr[0][@"contact_rel"];
            self.linkConnection2=[ZHStringFilterTool cutOffStringWithLastObj:arr[0][@"contact_rel"]];
            self.lineName3 = arr[1][@"contact_name"];
            self.linePhone3 = arr[1][@"contact_mobile"];
            self.linkConnection3Code = arr[1][@"contact_rel"];
            self.linkConnection3 = [ZHStringFilterTool cutOffStringWithLastObj:arr[1][@"contact_rel"]];
            self.lineName4 = arr[2][@"contact_name"];
            self.linePhone4 = arr[2][@"contact_mobile"];
            self.linkConnection4Code = arr[2][@"contact_rel"];
            self.linkConnection4 = [ZHStringFilterTool cutOffStringWithLastObj:arr[2][@"contact_rel"]];
            
        }else{
            
            self.lineName1 = arr[0][@"contact_name"];
            self.linePhone1 = arr[0][@"contact_mobile"];
            self.linkConnection1Code = @"200205,配偶";//四个的数据 固定
            self.linkConnection1 = @"配偶";
            self.lineName2 = arr[1][@"contact_name"];
            self.linePhone2 = arr[1][@"contact_mobile"];
            self.linkConnection2Code = arr[1][@"contact_rel"];
            self.linkConnection2 = [ZHStringFilterTool cutOffStringWithLastObj:arr[1][@"contact_rel"]];
            self.lineName3 = arr[2][@"contact_name"];
            self.linePhone3 = arr[2][@"contact_mobile"];
            self.linkConnection3Code = arr[2][@"contact_rel"];
            self.linkConnection3 = [ZHStringFilterTool cutOffStringWithLastObj:arr[2][@"contact_rel"]];
            self.lineName4 = arr[3][@"contact_name"];
            self.linePhone4 = arr[3][@"contact_mobile"];
            self.linkConnection4Code = arr[3][@"contact_rel"];
            self.linkConnection4 = [ZHStringFilterTool cutOffStringWithLastObj:arr[3][@"contact_rel"]];
        }
        
    }else{
        
        if (arr.count>3) {
            self.lineName1 = arr[1][@"contact_name"];
            self.linePhone1 = arr[1][@"contact_mobile"];
            self.linkConnection1Code = arr[1][@"contact_rel"];
            self.linkConnection1 = [ZHStringFilterTool cutOffStringWithLastObj:arr[1][@"contact_rel"]];
            self.lineName2 = arr[2][@"contact_name"];
            self.linePhone2 = arr[2][@"contact_mobile"];
            self.linkConnection2Code = arr[2][@"contact_rel"];
             self.linkConnection2 = [ZHStringFilterTool cutOffStringWithLastObj:arr[2][@"contact_rel"]];
            self.lineName3 = arr[3][@"contact_name"];
            self.linePhone3 = arr[3][@"contact_mobile"];
            self.linkConnection3Code = arr[3][@"contact_rel"];
            self.linkConnection3 = [ZHStringFilterTool cutOffStringWithLastObj:arr[3][@"contact_rel"]];
        }else{
            self.lineName1 = arr[0][@"contact_name"];
            self.linePhone1 = arr[0][@"contact_mobile"];
            self.linkConnection1Code = arr[0][@"contact_rel"];
            self.linkConnection1 = [ZHStringFilterTool cutOffStringWithLastObj:arr[0][@"contact_rel"]];
            self.lineName2 = arr[1][@"contact_name"];
            self.linePhone2 = arr[1][@"contact_mobile"];
            self.linkConnection2Code = arr[1][@"contact_rel"];
            self.linkConnection2 = [ZHStringFilterTool cutOffStringWithLastObj:arr[1][@"contact_rel"]];
            self.lineName3 = arr[2][@"contact_name"];
            self.linePhone3 = arr[2][@"contact_mobile"];
            self.linkConnection3Code = arr[2][@"contact_rel"];
            self.linkConnection3 = [ZHStringFilterTool cutOffStringWithLastObj:arr[2][@"contact_rel"]];
        }
        
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return indexPath.section>1 ? ZHFit(150):(indexPath.section==1&&indexPath.row==1)? ZHFit(80):ZHFit(50);
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return section==self.titles.count-1? 0.01:ZHFit(10);
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 && indexPath.row == 0) {//学历
        [self requestListWithKey:@"education" andIndexPath:indexPath];
        return;
    }
    
    if (indexPath.section==0&&indexPath.row==1) {
        //婚姻状况
        [self requestListWithKey:@"mar_status" andIndexPath:indexPath];
        return;
    }
    if (indexPath.section==1&&indexPath.row==0) {
        //保存GPS信息
        [self alertPersonLocation];
    }
  
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
                BaseRighText(indexPath.section, indexPath.row)=model.name;
                
                if (indexPath.row == 0 && indexPath.section == 0) {
                    self.educationName = model.name;
                    self.educationCode=[NSString stringWithFormat:@"%@,%@",model.code,model.name];
                } else if (indexPath.row == 1 && indexPath.section == 0) {
                    self.mar_status = [NSString stringWithFormat:@"%@,%@",model.code,model.name];
                    self.mar_status_name=model.name;
                    [self dealMarrageStatus];
                }
                NSLog(@"选了code=%@,name=%@",model.code,model.name);
                
            } cancelAction:^{
            } maskClick:^{
            }];
        }
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark 婚姻状况选择的处理
-(void)dealMarrageStatus{
    
    if ([self.mar_status_name containsString:@"已婚"]) {
        self.titles = [NSMutableArray arrayWithObjects:@[@"学历",@"婚姻状况"],@[@"居住省市",@"详细地址"],@[@"联系人一"],@[@"联系人二"],@[@"联系人三"],@[@"联系人四"] ,nil];
        self.linkConnection1Code=@"200205,配偶";
        self.linkConnection1=@"配偶";
        [self saveDataWithNetData:self.dataDictionary[@"contracts"]];
    }else{
        
        self.titles = [NSMutableArray arrayWithObjects:@[@"学历",@"婚姻状况"],@[@"居住省市",@"详细地址"],@[@"联系人一"],@[@"联系人二"],@[@"联系人三"],nil];
          [self saveDataWithNetData:self.dataDictionary[@"contracts"]];
    }
    [self.tableView reloadData];
}

#pragma mark 通讯录授权
-(void)addressBookAuth{
    
    ABAddressBookRef addressBookRef = ABAddressBookCreateWithOptions(NULL, NULL);
    if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusNotDetermined) {
        ABAddressBookRequestAccessWithCompletion(addressBookRef, ^(bool granted, CFErrorRef error){
            if (granted) {//请求授权页面用户同意授权
                //吊起通讯录页面
                ABPeoplePickerNavigationController *picker =[[ABPeoplePickerNavigationController alloc] init];
                picker.peoplePickerDelegate = self;
                [picker.navigationBar setTintColor:[UIColor whiteColor]];
                [self presentViewController:picker animated:YES completion:nil];
            }
        });
    }else if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized){
        //吊起通讯录页面
        ABPeoplePickerNavigationController *picker =[[ABPeoplePickerNavigationController alloc] init];
        picker.peoplePickerDelegate = self;
        [picker.navigationBar setTintColor:[UIColor whiteColor]];
        [self presentViewController:picker animated:YES completion:nil];
        
    }else {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            // 没有GPS权限，
            // 更新界面
            [AlertViewTool showAlertWithTitle:@"提示" message:@"设置-一键借钱-通讯录”选项中，允许访问您的通讯录" clickAtIndex:^(UIAlertView *alertView, NSInteger buttonIndex) {
                if (buttonIndex==1) {
                    
                    NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                    if ([[UIApplication sharedApplication] canOpenURL:url])
                    {
                        [[UIApplication sharedApplication] openURL:url];
                    }
                }
                
            } cancleButtonTitle:@"取消" otherButtonTitles:@"去设置", nil];
            return;
        });
    }
}

#pragma mark - 通讯录相关代理方法
//这个方法在用户取消选择时调用
- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker {
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}
//这个方法在用户选择一个联系人后调用
-(void)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker didSelectPerson:(ABRecordRef)person{
    [self displayPerson:person];
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}

//获得选中person的信息
- (void)displayPerson:(ABRecordRef)person {
    
    NSString *firstName = (__bridge_transfer NSString*)ABRecordCopyValue(person, kABPersonFirstNameProperty);
    NSString *middleName = (__bridge_transfer NSString*)ABRecordCopyValue(person, kABPersonMiddleNameProperty);
    NSString *lastname = (__bridge_transfer NSString*)ABRecordCopyValue(person, kABPersonLastNameProperty);
    NSMutableString *nameStr = [NSMutableString string];
    if (lastname!=nil) {
        [nameStr appendString:lastname];
    }
    if (middleName!=nil) {
        [nameStr appendString:middleName];
    }
    if (firstName!=nil) {
        [nameStr appendString:firstName];
    }
    
    NSString* phone = nil;
    ABMultiValueRef phoneNumbers = ABRecordCopyValue(person,kABPersonPhoneProperty);
    if (ABMultiValueGetCount(phoneNumbers) > 0) {
        phone = (__bridge_transfer NSString*)ABMultiValueCopyValueAtIndex(phoneNumbers, 0);
    } else {
        phone = @"[None]";
    }
    
    //可以把-、+86、空格这些过滤掉
    NSString *phoneStr = [phone stringByReplacingOccurrencesOfString:@"-" withString:@""];
    phoneStr = [phoneStr stringByReplacingOccurrencesOfString:@"+86" withString:@""];
    phoneStr = [phoneStr stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    /*处理回调的数据*/
    LinkCell(_currentIndexPath.section, _currentIndexPath.row).nameTextField.text=nameStr;//姓名
    LinkCell(_currentIndexPath.section, _currentIndexPath.row).linkTextField.text=phoneStr;//联系电话
    LinkCell(_currentIndexPath.section, _currentIndexPath.row).linkTextField.userInteractionEnabled=YES;
    LinkCell(_currentIndexPath.section, _currentIndexPath.row).nameTextField.userInteractionEnabled=YES;
    LinkCell(_currentIndexPath.section, _currentIndexPath.row).nameTextField.textColor =UIColorWithRGB(0x5e5e5e, 1.0);
    
    switch (_currentIndexPath.section) {
        case 2:{
            //联系人1
            self.lineName1= nameStr;
            self.linePhone1=phoneStr;
            
            break;
        }
        case 3:{
            //联系人2
            self.lineName2 = nameStr;
            self.linePhone2 =phoneStr;
            
            break;
        }
        case 4:{
            //联系人3
            self.lineName3 = nameStr;
            self.linePhone3 = phoneStr;
            
            break;
        }
        case 5:{
            //联系人4
            self.lineName4 = nameStr;
            self.linePhone4 = phoneStr;
            
            break;
        }
            
        default:
            break;
    }
    
}


@end
