//
//  ZHAuthCell.h
//  ZHBorrowClient
//
//  Created by 小飞鸟 on 2017/12/20.
//  Copyright © 2017年 小飞鸟. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZHAuthCell : UITableViewCell

/*标题label*/
@property(nonatomic,strong)UILabel * titleLabel;
/*详情label*/
@property(nonatomic,strong) UILabel * detailLabel;
/*认证或者完善按钮*/
@property(nonatomic,strong)UIButton * authBtn;
/*背景*/
@property(nonatomic,strong)UIImageView * content;
/*必选标记*/
@property(nonatomic,strong)UIImageView * markView;
/*必选标记*/
@property(nonatomic,strong)UIImageView * authStatusView;
/*认证按钮点击回到*/
@property(nonatomic,copy)void(^authAction)(NSIndexPath* indexPath);
/*当前的索引*/
@property(strong,nonatomic)NSIndexPath * indexPath;

+(instancetype)dequeueReusableCellWithTableView:(UITableView*)tableView  Identifier:(NSString*)identifier;
/*初始化CEll*/
-(void)setCellWithLargeTitles:(NSArray*)largeTitles SmallTitle:(NSArray*)smallTitles AtIndexPath:(NSIndexPath*)indexPath StatusArray:(NSArray*)statusArr;

@end
