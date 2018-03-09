//
//  ZHBaseViewController.h
//  ZHPay
//
//  Created by 正和 on 16/8/31.
//  Copyright © 2016年 正和. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTableViewCell.h"


#define TextFiedFrame CGRectMake(ZHFit(100), 0, ZHScreenW-ZHFit(100)-ZHFit(16), ZHFit(50))

#define BaseRighText(section,row)   ((BaseTableViewCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:section]]).detailLabel.text

#define BaseCell(section,row)   ((BaseTableViewCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:section]])

#define SystemCell(section,row)   ([self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:section]])

#define ArrowView  [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"向右"]]


typedef enum : NSUInteger {
    LoginChannel,
    HomeChannel,

} Channel_Type;

@interface ZHBaseViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>{
    
    /*导航条的高度*/
    CGFloat Nvi_Bar_Height;
}

/** 标题数组 */
@property (strong, nonatomic) NSMutableArray *titles;

/** 组尾 */
@property (strong, nonatomic) UIButton *footBtn;

/** tableView */
@property (strong, nonatomic) UITableView *tableView;

/** 请求下来的数据的字典 */
@property (strong, nonatomic)  NSMutableDictionary *dataDictionary;

/*回调*/
@property(nonatomic,copy)void(^RecallBlock)(void);

/*创建tableView*/
- (void)setupTableView;

/*请求数据*/
- (void)requestData;

/*基本信息 单位信息 认证信息的组尾*/
- (void)setupAuthFooterWithTitle:(NSString*)title;

/*创建分组的组尾*/
-(UIView*)setupFooterWithTitle:(NSString*)title WithOffsetY:(CGFloat)offsetY TotalHeight:(CGFloat)height;
/*导航条重新设置成白色*/
-(void)resetWhiteNaviBar;
@end
