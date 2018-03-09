//
//  ZHItemFooterView.h
//  ZHLoanClient
//
//  Created by 小飞鸟 on 2017/10/22.
//  Copyright © 2017年 小飞鸟. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZHItemFooterView : UICollectionReusableView

@property(nonatomic,copy)void(^ ClickBtnBlock)(NSInteger tag);

@end
