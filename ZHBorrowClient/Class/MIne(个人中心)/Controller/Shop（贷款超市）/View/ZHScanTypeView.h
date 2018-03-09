//
//  ZHScanTypeView.h
//  ZHLoanClient
//
//  Created by 小飞鸟 on 2017/10/22.
//  Copyright © 2017年 小飞鸟. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZHChooseView.h"
#import "ZHTypeModel.h"

@protocol ZHScanTypeViewDelegate <NSObject>

@optional
//修改箭头的指向
-(void)changeArrowDirection:(NSString*)type;

@end

@interface ButtonItem : UICollectionViewCell
/*是不是被选中*/
@property(nonatomic,assign)BOOL Selected;

@property(nonatomic,strong)UILabel * itemLabel;
/*type数据*/
@property(nonatomic,strong)ZHTypeModel * typeModel;

@end

@interface ZHScanTypeView : UIView

/*数据源*/
@property(nonatomic,strong) NSMutableArray * sourceArr;

//用来修改箭头的指向
@property(nonatomic,weak)id<ZHScanTypeViewDelegate>changeDelegate;
/* 一个item项点击回调*/
@property(nonatomic,copy)void(^ChooseItem)(ButtonItem* item);
/* 两个item项点击回调*/
@property(nonatomic,copy)void(^ChooseTwoItem)(NSArray * item1,ButtonItem* item2);

+(ZHScanTypeView*)shareButtonItemWithFrame:(CGRect)frame ItemChooseBlock:(void(^)(ButtonItem* item))chooseBlock LoanItemChooseBlock:(void(^)(NSArray * item1,ButtonItem* item2))loanItemBlock;

@end
