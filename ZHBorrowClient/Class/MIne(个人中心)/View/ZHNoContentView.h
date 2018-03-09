//
//  ZHNoContentView.h
//  ZHBorrowClient
//
//  Created by 小飞鸟 on 2017/12/22.
//  Copyright © 2017年 小飞鸟. All rights reserved.
//

#import <UIKit/UIKit.h>
// 无数据占位图的类型
typedef NS_ENUM(NSInteger, NoContentType) {
    /** 无网络 */
    NoContentTypeNetwork = 0,
    /** 无数据 */
    NoContentTypeOrder   = 1
};
@interface ZHNoContentView : UIView
/** 无数据占位图的类型 */
@property (nonatomic,assign) NSInteger type;
/*创建单例对象*/
+(instancetype)shareNoContentView;
/* 移除无数据占位图 */
- (void)removeEmptyView;
/* 显示无数据占位图 */
- (void)showEmptyViewWithType:(NSInteger)emptyViewType InSuperView:(UIView*)view BackAction:(void(^)(void))backActionBlock;

@end
