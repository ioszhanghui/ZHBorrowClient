//
//  ZHLinkPeopleCell.h
//  ZHBorrowClient
//
//  Created by 小飞鸟 on 2017/12/22.
//  Copyright © 2017年 小飞鸟. All rights reserved.
//


#import "BaseTableViewCell.h"

@interface ZHLinkPeopleCell : BaseTableViewCell<UITextFieldDelegate>
/*请选择的*/
@property(nonatomic,strong)UILabel * selectLabel;
/*姓名*/
@property(nonatomic,strong)UILabel * nameLabel;
/*姓名显示框*/
@property(nonatomic,strong)UITextField * nameTextField;
/*联系电话*/
@property(nonatomic,strong)UILabel * linkLabel;
/*联系人输入框*/
@property(nonatomic,strong)UITextField * linkTextField;
/*联系人按钮*/
@property(nonatomic,strong)UIButton * linkBtn;
/*Cell的索引*/
@property(nonatomic,strong)NSIndexPath * indexPath;
/*联系人姓名回调*/
@property(nonatomic,copy)void(^ linkNameRecall)(NSString * name);
/*联系人电话回调*/
@property(nonatomic,copy)void(^ linkPhoneRecall)(NSString * phone);
/*点击吊起通讯录*/
@property(nonatomic,copy)void(^ callAddressBookBlock)(NSIndexPath * indexPath);
/*点击选择关系的回调*/
@property(nonatomic,copy)void(^ relationShipRecall)(NSIndexPath * indexPath);

/*创建Cell*/
+(instancetype)dequeueReusableCellWithTableView:(UITableView*)tableView  Identifier:(NSString*)identifier;

@end
