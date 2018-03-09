//
//  ZHProductModel.h
//  ZHLoanClient
//
//  Created by 小飞鸟 on 2017/10/21.
//  Copyright © 2017年 小飞鸟. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZHProductModel : NSObject

/*用户当前的额度*/
@property(nonatomic,copy)NSString * user_average_money;
//唯一标示
@property(nonatomic,copy)NSString * ID;
/*最小天*/
@property(nonatomic,copy)NSString * product_min_day;
/*详情*/
@property(nonatomic,copy)NSString * product_detail;
/*最小贷款*/
@property(nonatomic,copy)NSString * product_min_amount;
/*排序号*/
@property(nonatomic,copy)NSString * product_order;
/*排序号*/
@property(nonatomic,copy)NSString * term;
/*最大天*/
@property(nonatomic,copy)NSString * product_max_day;
/** 名字 */
@property(nonatomic,copy)NSString * product_name;
/** 网页链接 */
@property(nonatomic,copy) NSString * product_join_url;
/*最大贷款*/
@property(nonatomic,copy)NSString * product_max_amount;
/*图标*/
@property(nonatomic,copy)NSString * product_icon_path;
/*月费利率*/
@property(nonatomic,copy)NSString * product_month_rate;
/*申请条件*/
@property(nonatomic,copy)NSString * product_apply_info;
/*特点*/
@property(nonatomic,copy)NSString * product_flag;
//优势
@property(nonatomic,copy)NSString * product_advantage;
@end
