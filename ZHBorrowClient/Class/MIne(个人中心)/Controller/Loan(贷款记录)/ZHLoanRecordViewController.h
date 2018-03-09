//
//  ZHLoanRecordViewController.h
//  ZHBorrowClient
//
//  Created by 小飞鸟 on 2017/12/22.
//  Copyright © 2017年 小飞鸟. All rights reserved.
//

#import "ZHBaseViewController.h"
#import "ZHLoanCell.h"
#import "ZHLoanModel.h"

@interface ZHLoanRecordViewController : ZHBaseViewController{
    /*当前页面*/
    NSInteger currentPage;
}

#pragma mark 贷款列表请求
-(void)LoanListRequest;
/*总页数*/
@property(nonatomic,assign)NSInteger totalPage;
/*回调*/
@property(nonatomic,copy)void(^RecallBlock)(void);

@end
