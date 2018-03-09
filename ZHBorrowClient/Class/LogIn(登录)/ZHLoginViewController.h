//
//  ZHLoginViewController.h
//  ZHBorrowClient
//
//  Created by zhph on 2017/12/19.
//  Copyright © 2017年 小飞鸟. All rights reserved.
//

#import "ZHBaseViewController.h"

@interface ZHLoginViewController : ZHBaseViewController
/*回调*/
@property(nonatomic,copy)void(^RecallBlock)(void);
@end
