//
//  ZHLoginViewController.m
//  ZHBorrowClient
//
//  Created by zhph on 2017/12/19.
//  Copyright © 2017年 小飞鸟. All rights reserved.
//

#import "ZHLoginViewController.h"
#import "LoginSuccessView.h"
#import "ZHCompleteViewController.h"
#import "ZHMineViewController.h"
#import "TYAttributedLabel.h"

@interface ZHLoginViewController ()<UITextFieldDelegate,TYAttributedLabelDelegate>

/*手机输入框*/
@property(nonatomic,strong)UITextField * phoneTextField;
/*验证码*/
@property(nonatomic,strong)UITextField * CodeField;
/*验证码按钮*/
@property(nonatomic,strong)UIButton * codeBtn;
/** 倒计时数字 */
@property (nonatomic, assign) NSInteger number;
/*手机号*/
@property(nonatomic,copy)NSString * phone;
/*用户协议*/
@property(nonatomic,strong) TYAttributedLabel * protocolLabel;

@end

@implementation ZHLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"登录";
    self.view.backgroundColor=[UIColor whiteColor];
    [self resetWhiteNaviBar];
    [self configUI];    
}

#pragma mark 布局UI
-(void)configUI{
    
    UILabel * textLabel=[UILabel addLabelWithFrame:CGRectMake(ZHFit(22),ZHFit(30), ZHScreenW, ZHFit(19)) title:@"欢迎您登录" titleColor:UIColorWithRGB(0x252c32, 1.0) font:ZHFontBold(20)];
    textLabel.textAlignment=NSTextAlignmentLeft;
    [self.view addSubview:textLabel];
    
    UIView * view1= [UIView CreateHaveRadiousViewWithFrame:CGRectMake(ZHFit(23), textLabel.bottom+ZHFit(46), ZHScreenW-ZHFit(23)*2, ZHFit(45)) BackgroundColor:ZHClearColor InteractionEnabled:YES];
    [self.view addSubview:view1];
    
    UILabel * phone = [UILabel addLabelWithFrame:CGRectMake(ZHFit(20), 0, ZHFit(42), ZHFit(45)) title:@"+ 86" titleColor:UIColorWithRGB(0x232c33, 1.0) font:ZHFontSize(14)];
    [view1 addSubview:phone];
    
   UIView * line = [UIView addLineWithFrame:CGRectMake(ZHFit(63), (view1.height-ZHFit(26))/2, 0.5, ZHFit(26)) WithView:view1];
    line.backgroundColor=UIColorWithRGB(0xcacdd2, 1.0);
    self.phoneTextField=[UITextField addFieldWithFrame:CGRectMake(line.right+ZHFit(15), 0, view1.width-line.right-ZHFit(35), ZHFit(45)) placeholder:@"请输入手机号码" delegate:self];
    self.phoneTextField.keyboardType=UIKeyboardTypeNumberPad;
    self.phoneTextField.clearButtonMode=UITextFieldViewModeNever;
    self.phoneTextField.textAlignment=NSTextAlignmentLeft;
    self.phoneTextField.textColor=UIColorWithRGB(0x232c33, 1.0);
    [view1 addSubview:self.phoneTextField];
    
    
    UIView * view2 =[UIView CreateHaveRadiousViewWithFrame:CGRectMake(ZHFit(23), view1.bottom+ZHFit(10), ZHScreenW-ZHFit(23)*2, ZHFit(45)) BackgroundColor:ZHClearColor InteractionEnabled:YES];
    [self.view addSubview:view2];
    
    self.CodeField=[UITextField addFieldWithFrame:CGRectMake(ZHFit(20), 0, ZHFit(215), ZHFit(45)) placeholder:@"请输入验证码" delegate:self];
    self.CodeField.clearButtonMode=UITextFieldViewModeNever;
    self.CodeField.keyboardType=UIKeyboardTypeNumberPad;
    self.CodeField.textAlignment=NSTextAlignmentLeft;
    self.CodeField.textColor=UIColorWithRGB(0x232c33, 1.0);
    [self.CodeField addTarget:self action:@selector(loginBtnClick) forControlEvents:UIControlEventEditingChanged];
    [view2 addSubview:self.CodeField];
    
    //用户协议
    
    self.protocolLabel = [[TYAttributedLabel alloc] initWithFrame:CGRectMake(ZHFit(23), view2.bottom+ZHFit(20),ZHScreenW-ZHFit(23)*2, ZHFit(40))];
    self.protocolLabel.delegate = self;
    self.protocolLabel.font=ZHFontSize(12);
    self.protocolLabel.numberOfLines=0;
    self.protocolLabel.backgroundColor=ZHClearColor;
    [self.view addSubview:self.protocolLabel];
    
    
    // 规则声明
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:@"注册即代表您同意"];
    [attributedString addAttributeTextColor:UIColorWithRGB(0x848484, 1.0)];
    [attributedString addAttributeFont:ZHFontSize(12)];
    [self.protocolLabel appendTextAttributedString:attributedString];
    
    [self.protocolLabel appendLinkWithText:@"《用户注册协议》" linkFont:ZHFontSize(12) linkColor:UIColorWithRGB(0x1869FF, 1.0) linkData:[NSString stringWithFormat:@"%@/YJJQWebService/H5APP/yjjq_regist_protcol.html",[UserTool objectForKey:@"Base_Url"]]];
    NSMutableAttributedString *attributedAndString = [[NSMutableAttributedString alloc]initWithString:@"及"];
    [attributedAndString addAttributeTextColor:UIColorWithRGB(0x848484, 1.0)];
    [attributedAndString addAttributeFont:ZHFontSize(12)];
    [self.protocolLabel appendTextAttributedString:attributedAndString];
    
    // 增加链接 Privacy Polices
    [self.protocolLabel appendLinkWithText:@"《用户授权协议》" linkFont:ZHFontSize(12) linkColor:UIColorWithRGB(0x1869FF, 1.0) linkData:[NSString stringWithFormat:@"%@/YJJQWebService/H5APP/yjjq_accredit.html",[UserTool objectForKey:@"Base_Url"]]];
    
    
    self.codeBtn=[UIButton addButtonWithFrame:CGRectMake(view2.width-ZHFit(20)-ZHFit(77), 0, ZHFit(77), ZHFit(45)) title:@"发送验证码" titleColor:UIColorWithRGB(0x1869ff, 1.0) font:ZHFontSize(14) image:nil highImage:nil
                              backgroundColor:ZHClearColor tapAction:^(UIButton *button) {
                                  [self getPhoneCode];
                              }];
    [view2 addSubview:self.codeBtn];
}

#pragma mark - Delegate
//TYAttributedLabelDelegate
- (void)attributedLabel:(TYAttributedLabel *)attributedLabel textStorageClicked:(id<TYTextStorageProtocol>)TextRun atPoint:(CGPoint)point {
    if ([TextRun isKindOfClass:[TYLinkTextStorage class]]) {
        NSString *linkStr = ((TYLinkTextStorage*)TextRun).linkData;
        NSLog(@"linkStr === %@",linkStr);
        NSString * title =@"用户注册协议";
        if ([linkStr containsString:@"yjjq_accredit.html"]) {
            title =@"用户授权协议";
        }
        
        [ZHWebViewController showWithContro:self withUrlStr:linkStr withTitle:title];
    }
}

#pragma mark - / ************获取验证码 ****************/
- (void)getPhoneCode {
    
    if (NULLString(self.phoneTextField.text)) {
        
        [SVProgressHUD showInfoWithStatus:@"请输入手机号"];
        return;
    }
    
    self.phone=self.phoneTextField.text;
    //2.获取验证码
    NSString* str = [NSString stringWithFormat:@"%@: %@",NSLocalizedString(@"我们将会发送验证码到手机", nil),self.phoneTextField.text];
    
    [AlertViewTool showAlertView:self title:@"确认手机号码" message:str cancelTitle:@"取消" otherTitle:@"确认" cancelBlock:^{
        
    } confrimBlock:^{
        
        //1.请求
        NSDictionary *params = @{
                                 @"phoneNum" : self.phoneTextField.text
                                 };
        
        [HttpTool PostWithPath:@"/YJJQWebService/GetPhoneCode.spring" params:params success:^(id json) {
            
            if ([json[@"code"] isEqualToString:@"200"]) {
                
                //2.添加倒计时
                self.number = 60;
                NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateTime:) userInfo:nil repeats:YES];
                [timer fire];
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    
                    [SVProgressHUD showSuccessWithStatus:@"验证码发送成功"];
                });
            }
            
        } failure:^(NSError *error) {
            
        }];
    }];
}

//计算定时器时间
-(void)updateTime:(NSTimer *)Timer {
    
    self.number --;
    self.codeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [self.codeBtn setTitle:[NSString stringWithFormat:@"%lds",(long)self.number] forState:UIControlStateNormal];
    self.codeBtn.userInteractionEnabled = NO;
    
    if (self.number == 0){
        [self.codeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        self.codeBtn.userInteractionEnabled = YES;
        self.codeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [Timer invalidate];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    //敲删除键
    if ([string length]==0) {
        return YES;
    }
    
    //账号
    if (textField == _phoneTextField) {
        if (textField.text.length > 10) return NO;
    }
    //验证码
    if (textField == _CodeField) {
        if (textField.text.length > 5) return NO;
    }
    
    return YES;
    
}

/**
 *  登录
 */
- (void)loginBtnClick {
    
    if (NULLString(self.phoneTextField.text)) {
        
        [SVProgressHUD showInfoWithStatus:@"请输入手机号"];
        return;
    }
    if (![ZHStringFilterTool filterByPhoneNumber:self.phoneTextField.text]) {
        
        [SVProgressHUD showInfoWithStatus:@"手机号格式错误"];
        return;
    }
    
    if (NULLString(self.CodeField.text)) {
        
        [SVProgressHUD showInfoWithStatus:@"请输入验证码"];
        return;
    }
    
    if (self.CodeField.text.length==6) {
        //登录
        [self.CodeField resignFirstResponder];
        
        NSDictionary *params = @{
                                 @"phone_num":self.phoneTextField.text,
                                 @"newCode":self.CodeField.text
                                 };
        
        [HttpTool postWithPath:@"/YJJQWebService/Login.spring" params:params success:^(id json) {
            if ([json[@"code"] isEqualToString:@"200"]) {
                NSLog(@"登录的****%@",json);
                
                //保存用户信息data
                [UserTool saveAccount:[User mj_objectWithKeyValues:[json objectForKey:@"data"]]];
                
                if ([[UserTool GetUser].realname_state isEqualToString:@"1"]) {
                    [self.navigationController popViewControllerAnimated:YES];
                }else{
                    [LoginSuccessView shareLoginSuccessViewWithFrame:[UIScreen mainScreen].bounds Type:LogInSuccess  CancelAction:^{
                        //取消
                        [self.navigationController popViewControllerAnimated:YES];
                    } SureAction:^{

                        ZHCompleteViewController * VC =[ZHCompleteViewController new];
                        VC.type=LoginChannel;
                        [self.navigationController pushViewController:VC animated:YES];
                    }];
                }
            }
        } failure:^(NSError *error) {
            
            [SVProgressHUD showErrorWithStatus:@"登录 失败"];
        }];
    }
    
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (self.RecallBlock) {
            self.RecallBlock();
        }
    });
}

@end
