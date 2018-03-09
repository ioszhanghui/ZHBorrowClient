//
//  ZHMyAuthView.h
//  ZHBorrowClient
//
//  Created by 小飞鸟 on 2017/12/19.
//  Copyright © 2017年 小飞鸟. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZHMyAuthView : UIImageView
/*创建分享成功的页面*/
+(ZHMyAuthView *)shareMyAuthViewWithFrame:(CGRect)frame GoToAction:(void(^)(void))goToBlock;
/*跳转回调*/
@property(nonatomic,copy)void(^ goToAction)(void);

/*设置认证的个数*/
-(void)resetNumLabel;

@end
