//
//  ZHMoreAutheViewController.h
//  ZHLoanClient
//
//  Created by 正和 on 2017/10/24.
//  Copyright © 2017年 小飞鸟. All rights reserved.
//

#import "ZHBaseViewController.h"

@interface ZHMoreAutheViewController: ZHBaseViewController

/*贷款金额*/
@property(nonatomic,copy)NSString * loanMoney;
/*贷款时间*/
@property(nonatomic,copy)NSString * loanTime;

/** 京东账号 */
@property (copy, nonatomic)  NSString *jd_id;

/** 淘宝账号 */
@property (copy, nonatomic)  NSString *tb_id;

/** 人行征信 */
@property (copy, nonatomic)  NSString *pbc_id;

/** 社保缴纳 1,连续12个月无断续 */
@property (copy, nonatomic)  NSString *social_fund;

@property (copy, nonatomic)  NSString *social_fund_name;

/** 公积金缴纳 0,连续6个月无断续 */
@property (copy, nonatomic)  NSString *gjj_fund;
@property (copy, nonatomic)  NSString *gjj_fund_name;

/** 芝麻信用 3,601~700 */
@property (copy, nonatomic)  NSString *zhima_fund;
@property (copy, nonatomic)  NSString *zhima_fund_name;

@end
