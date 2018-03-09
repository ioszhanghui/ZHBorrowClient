//
//  ZHLinkPeopleModel.h
//  ZHMarket
//
//  Created by 肖亮 on 2017/2/28.
//  Copyright © 2017年 肖亮. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZHLinkPeopleModel : NSObject

/** 关系 */
@property (nonatomic , copy) NSString * contact_rel;
/** 姓名 */
@property (nonatomic , copy) NSString * contact_name;
/** 电话号码 */
@property (nonatomic , copy) NSString * contact_mobile;

@end
