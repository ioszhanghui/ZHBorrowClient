//
//  ZHLimitFooterView.h
//  ZHBorrowClient
//
//  Created by 小飞鸟 on 2017/12/22.
//  Copyright © 2017年 小飞鸟. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZHLimitFooterView : UIView

/*创建分享成功的页面*/
+(ZHLimitFooterView *)showLimitFooterViewWithFrame:(CGRect)frame GoToAction:(void(^)(void))goToBlock SuperView:(UIView*)superView;
/*跳转回调*/
@property(nonatomic,copy)void(^ goToAction)(void);

/*刷新我的额度*/
-(void)reloadMoneyLabel:(NSString*)loan_mt;

@end
