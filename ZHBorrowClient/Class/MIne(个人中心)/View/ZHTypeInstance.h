//
//  ZHTypeInstance.h
//  ZHLoanClient
//
//  Created by zhph on 2017/10/24.
//  Copyright © 2017年 小飞鸟. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ZHTypeModel;
@class ButtonItem;

@interface ZHTypeInstance : NSObject
//单例对象
+(instancetype)sharedInstance;

/*首页点击的typeModel*/
@property(nonatomic,strong)ZHTypeModel * typeModel;

/*快速通道*/
@property(nonatomic,strong)ZHTypeModel * channelModel;

/*筛选的贷款类型  筛选的第一个分组*/
@property(nonatomic,strong)NSMutableArray * btnItems;

/*  贷款类型 筛选的第二个分组*/
@property(nonatomic,strong) ZHTypeModel * needModel;
/*选择的贷款金额*/
@property(nonatomic,copy) NSString * loanMoney;

@end
