//
//  ZHChooseView.h
//  ZHLoanClient
//
//  Created by 小飞鸟 on 2017/10/22.
//  Copyright © 2017年 小飞鸟. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZHScanTypeView.h"

@protocol ZHChooseViewDelegate <NSObject>

@optional
//修改箭头的指向
-(void)removeChooseViewFromWindow;

@end

@interface ZHButtonItem:UIButton
/*箭头视图*/
@property(nonatomic,strong)UIImageView * arrowImageView;

-(instancetype)initWithFrame:(CGRect)frame;

@end


@interface ZHChooseView : UIView 
/*数据内容*/
@property(nonatomic,strong)NSArray *titles;
/*点击回调*/
@property(nonatomic,copy)void(^ChooseItem)(ZHButtonItem* item);
/**/
@property(nonatomic,assign)NSInteger selectedTag;

/*点击移除视图*/
@property(nonatomic,assign)id<ZHChooseViewDelegate> removeDelegate;

+(ZHChooseView*)shareButtonItemWithFrame:(CGRect)frame ItemChooseBlock:(void(^)(ZHButtonItem* item))chooseBlock;

@end
