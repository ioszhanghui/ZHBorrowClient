//
//  UserTool.m
//  ShoppingDemo
//
//  Created by zhph on 2017/5/10.
//  Copyright © 2017年 正和普惠. All rights reserved.
//

#import "UserTool.h"
#import "User.h"

@implementation UserTool

//需要存储的账号信息
+(void)saveAccount:(User *)user{
    
    // 归档
    [NSKeyedArchiver archiveRootObject:user toFile:[self archiverFilePath]];

}
//返回要存储的账号信息
+(User *)GetUser{

    User *user =[NSKeyedUnarchiver unarchiveObjectWithFile:[self archiverFilePath]];
    
    return user;
}


+(NSString*)archiverFilePath{

    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    // 这个文件后缀可以是任意的，只要不与常用文件的后缀重复即可，我喜欢用data
    NSString *filePath = [path stringByAppendingPathComponent:@"user.data"];
    
    return filePath;
}


/*更新用户数据*/
+(void)updateUserInfoKey:(NSString *)key Value:(NSString *)value{

    NSDictionary *userDict = [UserTool GetUser].mj_keyValues;
    [userDict setValue:value forKey:key];
    
    [UserTool clearUserInfo];
    //更新数据
    [UserTool saveAccount:[User mj_objectWithKeyValues:userDict]];
}

/*更新用户数据  如果需要更新的数据比较多*/
+(void)updateUserInfoAllKey:(NSDictionary*)info{
    
    NSMutableDictionary *userDict = [NSMutableDictionary dictionaryWithDictionary:[UserTool GetUser].mj_keyValues];
    [userDict addEntriesFromDictionary:info];
    [UserTool clearUserInfo];
    //更新数据
    [UserTool saveAccount:[User mj_objectWithKeyValues:userDict]];
}

#pragma mark 清除用户信息
+(void)clearUserInfo{

    NSFileManager * manager =[NSFileManager defaultManager];
    if ([manager fileExistsAtPath:[self archiverFilePath]] ) {
        
        [manager removeItemAtPath:[self archiverFilePath] error:nil];
    }
}

/*保存NSInteger*/
+ (void)setIntegerValue:(NSInteger)value forKey:(NSString *)defaultName{

    [[NSUserDefaults standardUserDefaults] setInteger:value forKey:defaultName];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

/*获得Integer值*/
+ (NSInteger)integerValueForKey:(NSString *)defaultName{

     return [[NSUserDefaults standardUserDefaults] integerForKey:defaultName];
}


+ (void)setObject:(id)value forKey:(NSString *)defaultName{
    [[NSUserDefaults standardUserDefaults] setObject:value forKey:defaultName];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

+ (id)objectForKey:(NSString *)defaultName
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:defaultName];
}

+(void)setValue:(id)value forKey:(NSString *)defaultName
{
    [[NSUserDefaults standardUserDefaults] setValue:value forKey:defaultName];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(id)valueForKey:(NSString *)defaultName
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:defaultName];
}

+(void)removeObjectForKey:(NSString *)key
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(void)clearAll {
    NSUserDefaults *userDefatluts = [NSUserDefaults standardUserDefaults];
    NSDictionary *dictionary = userDefatluts.dictionaryRepresentation;;
    for(NSString* key in [dictionary allKeys]){
        if ([key isEqualToString:@"isFirst"]) {
            continue;
        }
        [userDefatluts removeObjectForKey:key];
        [userDefatluts synchronize];
    }
}


@end
