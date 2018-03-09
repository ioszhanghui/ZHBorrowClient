//
//  UserTool.h
//  ShoppingDemo
//
//  Created by zhph on 2017/5/10.
//  Copyright © 2017年 正和普惠. All rights reserved.
//

#import <Foundation/Foundation.h>

@class User;
@interface UserTool : NSObject

/*更新的数据比较多*/
+(void)updateUserInfoAllKey:(NSDictionary*)info;
//需要存储的账号信息
+(void)saveAccount:(User *)user;
//返回要存储的账号信息
+(User *)GetUser;
/*清除用户信息*/
+(void)clearUserInfo;

/*更新用户数据*/
+(void)updateUserInfoKey:(NSString *)key Value:(NSString *)value;


//NSUserDefaults 存储信息
+ (void)setObject:(id)value forKey:(NSString *)defaultName;

/*保存NSInteger*/
+ (void)setIntegerValue:(NSInteger)value forKey:(NSString *)defaultName;

/*获得Integer值*/
+ (NSInteger)integerValueForKey:(NSString *)defaultName;

+ (id)objectForKey:(NSString *)defaultName;

+ (void)setValue:(id)value forKey:(NSString *)defaultName;

+ (id)valueForKey:(NSString *)defaultName;

+(void)removeObjectForKey:(NSString*)key;

+(void)clearAll;

@end
