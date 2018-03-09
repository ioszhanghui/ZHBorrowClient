//
//  BaseInfoCell.h
//  ZHLoanClient
//
//  Created by 正和 on 2017/10/24.
//  Copyright © 2017年 小飞鸟. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^BtnBlock)(NSInteger tag);

@interface BaseInfoCell : UITableViewCell

/** 文本输入框 */
@property (strong, nonatomic)  UITextField *textField;

/** 左按钮表示有 */
@property (strong, nonatomic)  UIButton *leftBtn;

/** 右按钮表示无 */
@property (strong, nonatomic)  UIButton *rightBtn;
/*当前的按钮*/
@property(nonatomic,strong)UIButton * currentBtn;
/*当前的indexPath*/
@property(nonatomic,strong)NSIndexPath * indexPath;
/** 选择的按钮类型 */
@property (copy, nonatomic)  BtnBlock btnBlock;

+ (instancetype)cellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath;

@end
