//
//  ZHAuthViewController.m
//  ZHBorrowClient
//
//  Created by zhph on 2017/12/20.
//  Copyright © 2017年 小飞鸟. All rights reserved.
//

#import "ZHAuthViewController.h"
#import "ZHTakePhotoButton.h"
#import "AVCaptureViewController.h"
#import "IDInfo.h"
#import "JQAVCaptureViewController.h"

@interface ZHAuthViewController ()
/*名字输入*/
@property(nonatomic,strong)UITextField * nameFiled;
/*证件号码*/
@property(nonatomic,strong)UITextField * cardNumFiled;
/*用户名字*/
@property(nonatomic,copy)NSString * userName;
/*证件号码*/
@property(nonatomic,copy)NSString * cardNum;
/*正面的拍照*/
@property(nonatomic,strong)ZHTakePhotoButton * fontButton;
/*反面的拍照*/
@property(nonatomic,strong)ZHTakePhotoButton * backButton;
/*身份证扫描的信息*/
@property(nonatomic,strong)IDInfo * cardInfo;

@end

@implementation ZHAuthViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=UIColorWithRGB(0xf3f4f8, 1.0);
    self.title=@"实名认证";
    
    [self resetWhiteNaviBar];
    
    [self setupTableView];
    self.titles=[NSMutableArray arrayWithObjects:@"真实姓名",@"身份证号", nil];
     self.tableView.tableHeaderView=[self createTableHeaderView];
     self.tableView.sectionFooterHeight=0.01;
    AdjustsScrollViewInsetNever(self, self.tableView);
    
    [self requestCardInfo];
    
    [self setupAuthFooterWithTitle:@"提交保存"];
    [self setupFooterWithTitle:@"提交保存" WithOffsetY:ZHFit(16) TotalHeight:ZHFit(100)];
    self.tableView.height=ZHScreenH-ZHFit(55)-StatusBarHeight-self.navigationController.navigationBar.height;
}

#pragma mark 请求身份证信息
-(void)requestCardInfo{
    
    if ([[UserTool GetUser].realname_state isEqualToString:@"1"]) {
        
        NSDictionary * params = @{@"cust_no":[UserTool GetUser].custno};
        [HttpTool postWithPath:@"YJJQWebService/GetRealNameInfo.spring" params:params success:^(id json) {
            if ([json[@"code"] isEqualToString:@"200"]){
                NSLog(@"身份证认证回显****%@",json);
                [self.backButton sd_setImageWithURL:[ZHStringFilterTool appendUrlString:[[json objectForKey:@"data"] objectForKey:@"imageSFZFM"]] placeholderImage:[UIImage imageNamed:@"背面"] options:SDWebImageRefreshCached];
                [self.fontButton sd_setImageWithURL:[ZHStringFilterTool appendUrlString:[[json objectForKey:@"data"] objectForKey:@"imageSFZZM"]] placeholderImage:[UIImage imageNamed:@"正面"] options:SDWebImageRefreshCached];
        
                self.dataDictionary =[NSMutableDictionary dictionaryWithDictionary:[json objectForKey:@"data"]];
                [self.tableView reloadData];
            }
        } failure:^(NSError *error) {
            
        }];
    }
}

#pragma mark 创建头部视图
-(UIView*)createTableHeaderView{
    
    UIView * BG =[UIView CreateViewWithFrame:CGRectMake(0, 0, ZHScreenW, ZHFit(403)) BackgroundColor:UIColorWithRGB(0xf3f4f8, 1.0) InteractionEnabled:YES];
    self.fontButton=[[ZHTakePhotoButton alloc]initWithFrame:CGRectMake((ZHScreenW-ZHFit(275))/2, ZHFit(20), ZHFit(275), ZHFit(174)) WithImageName:@"正面" TapPhotoBlock:^(UIImageView *imageView) {
        NSLog(@"正面拍照");
        [self fontIDCardInfoAction];
    }];
    
    [BG addSubview:self.fontButton];
    
    self.backButton=[[ZHTakePhotoButton alloc]initWithFrame:CGRectMake((ZHScreenW-ZHFit(275))/2, ZHFit(15)+ self.fontButton.bottom, ZHFit(275), ZHFit(174)) WithImageName:@"背面" TapPhotoBlock:^(UIImageView *imageView) {
        
        NSLog(@"反面拍照");
        [self backIDCardInfoAction];
        
    }];
    
    [BG addSubview:self.backButton];
    
    return BG;
}
#pragma mark 点击正面拍照
-(void)fontIDCardInfoAction{
    
    AVCaptureViewController *AVCaptureVC = [[AVCaptureViewController alloc] init];
    AVCaptureVC.CaptureInfo = ^(IDInfo *idInfo, UIImage *oriangImage, UIImage *subImage) {
        self.fontButton.image = oriangImage;
        self.nameFiled.text = idInfo.name;
        self.cardNumFiled.text = idInfo.num;
        self.userName=idInfo.name;
        self.cardNum=idInfo.num;
    };
    [self.navigationController pushViewController:AVCaptureVC animated:YES];
    
}

#pragma mark 点击正面拍照
-(void)backIDCardInfoAction{
    
    JQAVCaptureViewController *AVCaptureVC = [[JQAVCaptureViewController alloc] init];
    [self.navigationController pushViewController:AVCaptureVC animated:YES];
    AVCaptureVC.CaptureInfo = ^(IDInfo *idInfo, UIImage *oriangImage, UIImage *subImage) {
        self.backButton.image = oriangImage;
        self.cardInfo=idInfo;
    };
}

#pragma mark tableView的代理方法
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static  NSString *ID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.font=ZHFont_Detitle;
        cell.textLabel.textColor=UIColorWithRGB(0x5e5e5e, 1.0);
    }else{
        
        for(UIView * subView in cell.contentView.subviews){
            if ([subView isKindOfClass:[UITextField class]]) {
                [subView removeFromSuperview];
            }
        }
    }
    cell.textLabel.text=[self.titles objectAtIndex:indexPath.row];

    if (indexPath.row==0) {
        
        _nameFiled = [UITextField addFieldWithFrame:CGRectMake(ZHFit(100), 0, ZHScreenW-ZHFit(100)-ZHFit(15), ZHFit(50)) delegate:self];
        _nameFiled.placeholder=@"请输入证件姓名";
        _nameFiled.textAlignment=NSTextAlignmentRight;
        [_nameFiled addTarget:self action:@selector(textFieldLiveHomeDidChange:) forControlEvents:UIControlEventEditingChanged];
        [cell.contentView addSubview:_nameFiled];
        
        self.userName=[NSString stringWithRequestDicValue:self.dataDictionary[@"realname"] SelectValue:self.userName];
        _nameFiled.text=[NSString stringFieldTextWithRequestDicValue:self.dataDictionary[@"realname"] SelectValue:self.userName];
    }
    
    if (indexPath.row==1) {
        
        _cardNumFiled = [UITextField addFieldWithFrame:CGRectMake(ZHFit(100), 0, ZHScreenW-ZHFit(100)-ZHFit(15), ZHFit(50)) delegate:self];
        _cardNumFiled.placeholder=@"请输入身份证号码";
        _cardNumFiled.keyboardType=UIKeyboardTypeAlphabet;
        _cardNumFiled.textAlignment=NSTextAlignmentRight;
        [_cardNumFiled addTarget:self action:@selector(textFieldLiveHomeDidChange:) forControlEvents:UIControlEventEditingChanged];
        [cell.contentView addSubview:_cardNumFiled];
        self.cardNum=[NSString stringWithRequestDicValue:self.dataDictionary[@"idcardno"] SelectValue:self.cardNum];
        _cardNumFiled.text=[NSString stringFieldTextWithRequestDicValue:self.dataDictionary[@"idcardno"] SelectValue:self.cardNum];
    }
    
    return cell;
}

#pragma mark 保存基本信息
- (void)nextStep{
    if ([self checkUserInfo]) {
        [self authRequest];
    }
}

#pragma mark 实名认证请求
-(void)authRequest{
    
    NSDictionary * params =@{
                             @"realname":self.nameFiled.text,
                             @"idcardno":self.cardNumFiled.text,
                             @"cust_no":[UserTool GetUser].custno,
                             };
    
    [HttpTool uploadImageArrWithPath:@"YJJQWebService/AuthRealName.spring" params:params thumbName:@[@"SFZZM,身份证正面",@"SFZFM,身份证反面"]  image:@[self.fontButton.image,self.backButton.image] success:^(id json) {
        NSLog(@"身份认证json%@",json);
        if ([[json objectForKey:@"code"]isEqualToString:@"200"]) {
            
            [UserTool updateUserInfoKey:@"realname_state" Value:@"1"];
             [UserTool updateUserInfoKey:@"realname" Value:self.nameFiled.text];
            [SVProgressHUD showSuccessWithStatus:@"身份认证成功"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }
    } failure:^(NSError *error) {
        
         [SVProgressHUD showInfoWithStatus:@"身份认证失败"];
    } progress:^(CGFloat progress) {
        
    }];
}

#pragma mark 文字改变
-(void)textFieldLiveHomeDidChange:(UITextField*)textField{
    
    NSString *text = [textField text];
    
    if (textField == self.nameFiled) {
        
        self.userName = text;
    }
    
    if (textField == self.cardNumFiled) {
        
        self.cardNum = text;
    }
    
}
#pragma mark textfield的代理方法
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    //敲删除键
    if ([string length] == 0) {
        return YES;
    }
    
    //姓名
    if (textField == self.nameFiled) {
        
        if (textField.text.length > 30) return NO;
    }
    
    //证件号码
    if (textField == self.cardNumFiled) {
        
        if (textField.text.length > 17) return NO;
    }
    
    return YES;
}

#pragma mark 检查用户信息
-(BOOL)checkUserInfo{
    
    if ([self.fontButton.image isEqual:[UIImage imageNamed:@"正面"]]) {
        [SVProgressHUD showInfoWithStatus:@"请拍摄身份证正面照片"];
        return NO;
    }
    
    if ([self.backButton.image isEqual:[UIImage imageNamed:@"背面"]]) {
        
        [SVProgressHUD showInfoWithStatus:@"请拍摄身份证背面照片"];
        return NO;
    }
    
    if (NULLString(self.nameFiled.text)) {
        
        [SVProgressHUD showInfoWithStatus:@"请输入证件姓名"];
        
        return NO;
    }
    
    if (![ZHStringFilterTool filterByUserNameChinese:self.nameFiled.text]) {
        
        [SVProgressHUD showInfoWithStatus:@"请输入合法的证件姓名"];
        
        return NO;
    }
    
    if (NULLString(self.cardNumFiled.text)) {
        
        [SVProgressHUD showInfoWithStatus:@"请输入身份证号码"];
        
        return NO;
    }
    
    if (![ZHStringFilterTool validateIDCardNumber:[self.cardNumFiled.text uppercaseString]]) {
        
        [SVProgressHUD showInfoWithStatus:@"请输入合法的身份证号码"];
        
        return NO;
    }
    
    return YES;
}


@end
