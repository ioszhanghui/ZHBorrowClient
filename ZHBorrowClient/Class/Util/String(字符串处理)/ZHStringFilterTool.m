//
//  ZHStringFilterTool.m
//  ZHPay
//
//  Created by admin on 16/8/28.
//  Copyright © 2016年 admin. All rights reserved.
//

#import "ZHStringFilterTool.h"

@implementation ZHStringFilterTool

/*截断字符串获取最后一部分*/
+(NSString*)cutOffStringWithLastObj:(NSString*)str{
    
    if (NULLString(str)) {
        return nil;
    }
    return [[str componentsSeparatedByString:@","] lastObject];
}

/*截断字符串获取最后一部分*/
+(NSString*)cutOffStringWithFirstObj:(NSString*)str{
    
    if (NULLString(str)) {
        return nil;
    }
    return [[str componentsSeparatedByString:@","] firstObject];
}

+(NSURL*)appendUrlString:(NSString*)urlStr{
    
//    NSLog(@"*****%@",[NSString stringWithFormat:@"%@/YJJQWebService%@",[UserTool objectForKey:@"Base_Url"],urlStr]);
    
    NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/YJJQWebService%@",[UserTool objectForKey:@"Base_Url"],urlStr]];
    
    return url;
}

+(NSMutableAttributedString*)setLabelSpacewithValue:(NSString*)str Color:(UIColor*)color Range:(NSRange)range{
    
    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:str];
    [attributeStr addAttributes:@{NSForegroundColorAttributeName:color} range:range];
    return attributeStr;
}

/*
 @brief 登陆密码
 */
+ (BOOL)filterByLoginPassWord:(NSString *)passWord{
    
    NSString *regex = @"^[A-Za-z0-9]{6,16}$";
//    NSString *regex = @"/(?!^[0-9]+$)(?!^[A-z]+$)(?!^[^A-z0-9]+$)^.{6,16}$/";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch = [pred evaluateWithObject:passWord];
    return isMatch;
}

/**
 @breif 从plist中取出版本号
 */
+ (NSString *)getCurrentVersion {
    
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    
    return version;
}


/*
 @brief 男女判断
 */
+(BOOL)getIdentityCardSex:(NSString *)numberStr
{
    int sexInt=[[numberStr substringWithRange:NSMakeRange(16,1)] intValue];
    
    if(sexInt%2!=0)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}


/*
 @brief 输入是不是中文
 */
+ (BOOL)filterByUserNameChinese:(NSString *)userName{
    
    NSString * user =[[userName stringByReplacingOccurrencesOfString:@"." withString:@""] stringByReplacingOccurrencesOfString:@"·" withString:@""];
    NSString *regex = @"^[\u4e00-\u9fa5\\.·]{1,16}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch = [pred evaluateWithObject:user];
    return isMatch;

}




/**
 * 手机正则匹配
 */
//#define PHONENO  @"\\b(1)[34578][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]\\b"

#define PHONENO  @"^(1[0123456789]{10})|((0[0-9]{2,3}){0,1}([2-9][0-9]{6,7}))$"

+(BOOL)filterByPhoneNumber:(NSString *)phone{

    NSPredicate * telePhoneNumberPred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", PHONENO];
    BOOL isTelephoneNumber = [telePhoneNumberPred evaluateWithObject:phone];
    return isTelephoneNumber;
    
}

/**
 匹配手机号是不是正确
 **/
+(BOOL)checkPhoneNumRight:(NSString*)phoneNum{

    NSString *MOBILE = @"^1(3[0-9]|4[0-9]|5[0-9]|8[0-9]|7[0-9])\\d{8}$";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    return [regextestmobile evaluateWithObject:phoneNum];
}

/**
 检验密码位数
 **/
+(BOOL)checkNumOfPassword:(NSString*)pwd{
    
    NSString *MOBILE = @"^[0-9a-zA-Z_]{6,16}$";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    return [regextestmobile evaluateWithObject:pwd];
}


/**
 *  身份证号
 */
+ (BOOL) filterByIdentityCard: (NSString *)identityCard{
    BOOL flag;
    if (identityCard.length <= 0) {
        flag = NO;
        return flag;
    }
    NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[X])$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    return [identityCardPredicate evaluateWithObject:identityCard];
}

/** 银行卡号有效性问题Luhn算法
 *  现行 16 位银联卡现行卡号开头 6 位是 622126～622925 之间的，7 到 15 位是银行自定义的，
 *  可能是发卡分行，发卡网点，发卡序号，第 16 位是校验码。
 *  16 位卡号校验位采用 Luhm 校验方法计算：
 *  1，将未带校验位的 15 位卡号从右依次编号 1 到 15，位于奇数位号上的数字乘以 2
 *  2，将奇位乘积的个十位全部相加，再加上所有偶数位上的数字
 *  3，将加法和加上校验位能被 10 整除。
 */
+ (BOOL) filterBybankCardluhmCheck: (NSString *)bankCard{
    
    NSString *bankCardRegex = @"^(\\d{15}|\\d{16}|\\d{19}|\\d{18}|\\d{21})$";
    
    NSPredicate *bankCardTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", bankCardRegex];
    
    return [bankCardTest evaluateWithObject:bankCard];
}

/**
 *  @brief 把格式化的JSON格式的字符串转换成字典
 *
 *  @param jsonString JSON格式的字符串
 *
 *  @return 返回字典
 */

+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    
    if (jsonString == nil) {
        
        return nil;
        
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError *err;
    
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                         
                                                        options:NSJSONReadingMutableContainers
                         
                                                          error:&err];
    
    if(err) {
        
        NSLog(@"json解析失败：%@",err);
        
        return nil;
        
    }
    
    return dic;
    
}


/**
 *  字典转换为字符串
 *
 *  @param dic 字典
 *
 *  @return 返回字符串
 */
+ (NSString*)dictionaryToJson:(NSDictionary *)dic

{
    
    NSError *parseError = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:0 error:&parseError];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
}

/** 获取拼音首字母(传入汉字字符串, 返回大写拼音首字母) */
+ (NSString *)firstCharactor:(NSString *)aString
{
    //转成了可变字符串
    NSMutableString *str = [NSMutableString stringWithString:aString];
    //先转换为带声调的拼音
    CFStringTransform((CFMutableStringRef)str,NULL, kCFStringTransformMandarinLatin,NO);
    //再转换为不带声调的拼音
    CFStringTransform((CFMutableStringRef)str,NULL, kCFStringTransformStripDiacritics,NO);
    //转化为大写拼音
    NSString *pinYin = [str capitalizedString];
    //获取并返回首字母
    return [pinYin substringToIndex:1];
}


/** 按首字母分组排序数组 */
+ (NSMutableArray *)sortObjectsAccordingToInitialWith:(NSArray *)arr Model:(NSObject *)model keyStr:(NSString *)keyStr{
    
    // 初始化UILocalizedIndexedCollation
    UILocalizedIndexedCollation *collation = [UILocalizedIndexedCollation currentCollation];
    
    //得出collation索引的数量，这里是27个（26个字母和1个#）
    NSInteger sectionTitlesCount = [[collation sectionTitles] count];
    //初始化一个数组newSectionsArray用来存放最终的数据，我们最终要得到的数据模型应该形如@[@[以A开头的数据数组], @[以B开头的数据数组], @[以C开头的数据数组], ... @[以#(其它)开头的数据数组]]
    NSMutableArray *newSectionsArray = [[NSMutableArray alloc] initWithCapacity:sectionTitlesCount];
    
    //初始化27个空数组加入newSectionsArray
    for (NSInteger index = 0; index < sectionTitlesCount; index++) {
        
        NSMutableArray *array = [[NSMutableArray alloc] init];
        [newSectionsArray addObject:array];
    }
    
    SEL sel = NSSelectorFromString(keyStr);//无参数
    
    //将每个名字分到某个section下
    for (NSObject *obj in arr) {
        
        //获取name属性的值所在的位置，比如"林丹"，首字母是L，在A~Z中排第11（第一位是0），sectionNumber就为11
        NSInteger sectionNumber = [collation sectionForObject:obj collationStringSelector:sel];
        //把name为“林丹”的p加入newSectionsArray中的第11个数组中去
        NSMutableArray *sectionNames = newSectionsArray[sectionNumber];
        [sectionNames addObject:obj];
    }
    
    //对每个section中的数组按照name属性排序
    for (NSInteger index = 0; index < sectionTitlesCount; index++) {
        NSMutableArray *personArrayForSection = newSectionsArray[index];
        NSArray *sortedPersonArrayForSection = [collation sortedArrayFromArray:personArrayForSection collationStringSelector:sel];
        newSectionsArray[index] = sortedPersonArrayForSection;
    }
    
    //删除空的数组
    NSMutableArray *finalArr = [NSMutableArray new];
    for (NSInteger index = 0; index < sectionTitlesCount; index++) {
        if (((NSMutableArray *)(newSectionsArray[index])).count != 0) {
            [finalArr addObject:newSectionsArray[index]];
        }
    }
    
    return finalArr;
    
}


#pragma mark 判断是不是大写字母
+(BOOL)isCatipalLetter:(NSString *)str{
    
    if ([str characterAtIndex:0] >= 'A' && [str characterAtIndex:0] <= 'Z') {
        
        return YES;
    }
    
    return NO;
    
}

#pragma mark 是否为纯数字
+(BOOL)isPureInt:(NSString*)string{
    
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return[scan scanInt:&val] && [scan isAtEnd];
}

#pragma mark 判断电话号码是不是合法
+(BOOL)isFixedNumError:(NSString*)fixNum{
    
    NSString *pattern = @"^(\\d{3,4}-)\\d{7,8}$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",pattern];
    return [identityCardPredicate evaluateWithObject:fixNum];
}


//邮箱
+ (BOOL)validateEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

#pragma mark 身份证号码检测正确
+ (BOOL)validateIDCardNumber:(NSString *)value {
    value = [value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    NSInteger length =0;
    if (!value) {
        return NO;
    }else {
        
        length = value.length;
        
        if (length !=15 && length !=18) {
            return NO;
        }
    }
    // 省份代码
    NSArray *areasArray =@[@"11",@"12", @"13",@"14", @"15",@"21", @"22",@"23", @"31",@"32", @"33",@"34", @"35",@"36", @"37",@"41", @"42",@"43", @"44",@"45", @"46",@"50", @"51",@"52", @"53",@"54", @"61",@"62", @"63",@"64", @"65",@"71", @"81",@"82", @"91"];
    
    NSString *valueStart2 = [value substringToIndex:2];
    BOOL areaFlag =NO;
    for (NSString *areaCode in areasArray) {
        if ([areaCode isEqualToString:valueStart2]) {
            areaFlag =YES;
            break;
        }
    }
    
    if (!areaFlag) {
        return false;
    }
    
    
    NSRegularExpression *regularExpression;
    NSUInteger numberofMatch;
    
    int year =0;
    switch (length) {
        case 15:
            year = [value substringWithRange:NSMakeRange(6,2)].intValue +1900;
            
            if (year %4 ==0 || (year %100 ==0 && year %4 ==0)) {
                
                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}$"
                                                                        options:NSRegularExpressionCaseInsensitive
                                                                          error:nil];//测试出生日期的合法性
            }else {
                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}$"
                                                                        options:NSRegularExpressionCaseInsensitive
                                                                          error:nil];//测试出生日期的合法性
            }
            numberofMatch = [regularExpression numberOfMatchesInString:value
                                                               options:NSMatchingReportProgress
                                                                 range:NSMakeRange(0, value.length)];
            
            if(numberofMatch >0) {
                return YES;
            }else {
                return NO;
            }
        case 18:
            
            year = [value substringWithRange:NSMakeRange(6,4)].intValue;
            if (year %4 ==0 || (year %100 ==0 && year %4 ==0)) {
                
                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}19[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}[0-9Xx]$"
                                                                        options:NSRegularExpressionCaseInsensitive
                                                                          error:nil];//测试出生日期的合法性
            }else {
                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}19[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}[0-9Xx]$"
                                                                        options:NSRegularExpressionCaseInsensitive
                                                                          error:nil];//测试出生日期的合法性
            }
            numberofMatch = [regularExpression numberOfMatchesInString:value
                                                               options:NSMatchingReportProgress
                                                                 range:NSMakeRange(0, value.length)];
            
            if(numberofMatch >0) {
                int S = ([value substringWithRange:NSMakeRange(0,1)].intValue + [value substringWithRange:NSMakeRange(10,1)].intValue) *7 + ([value substringWithRange:NSMakeRange(1,1)].intValue + [value substringWithRange:NSMakeRange(11,1)].intValue) *9 + ([value substringWithRange:NSMakeRange(2,1)].intValue + [value substringWithRange:NSMakeRange(12,1)].intValue) *10 + ([value substringWithRange:NSMakeRange(3,1)].intValue + [value substringWithRange:NSMakeRange(13,1)].intValue) *5 + ([value substringWithRange:NSMakeRange(4,1)].intValue + [value substringWithRange:NSMakeRange(14,1)].intValue) *8 + ([value substringWithRange:NSMakeRange(5,1)].intValue + [value substringWithRange:NSMakeRange(15,1)].intValue) *4 + ([value substringWithRange:NSMakeRange(6,1)].intValue + [value substringWithRange:NSMakeRange(16,1)].intValue) *2 + [value substringWithRange:NSMakeRange(7,1)].intValue *1 + [value substringWithRange:NSMakeRange(8,1)].intValue *6 + [value substringWithRange:NSMakeRange(9,1)].intValue *3;
                int Y = S %11;
                NSString *M =@"F";
                NSString *JYM =@"10X98765432";
                M = [JYM substringWithRange:NSMakeRange(Y,1)];// 判断校验位
                if ([M isEqualToString:[value substringWithRange:NSMakeRange(17,1)]]) {
                    return  YES;// 检测ID的校验位
                }else {
                    return NO;
                }
                
            }else {
                return NO;
            }
        default:
            return false;
    }
}

#pragma mark 保存文件的路径
+(void)saveFilePathWithFileName:(NSString*)fileName File:(NSData*)data FilePath:(void(^)(NSString *))filePath{

    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    //保存路径
    NSString *rootPath = [paths objectAtIndex:0] ;
    //根据路径删除文件或文件夹
    [[NSFileManager defaultManager] removeItemAtPath:rootPath error:nil];
    NSString *fileFullPath = [rootPath  stringByAppendingPathComponent:fileName];
    [data writeToFile:fileFullPath atomically:YES];
    
    NSFileManager * manager = [NSFileManager
                     defaultManager];
    
    if ([manager fileExistsAtPath:fileFullPath]) {
        
        filePath(fileFullPath);
    }

}

#pragma mark base64解密
+(NSData*)Base64DecodeWithCodeString:(NSString*)codeString{
    
    NSData *nsdataFromBase64String = [[NSData alloc]
                                      initWithBase64EncodedString:codeString options:0];
    
    return nsdataFromBase64String;

}

#pragma mark 计算文字的高度
+(CGSize)computeTextSizeHeight:(NSString*)text Range:(CGSize)size FontSize:(UIFont*)font{
    
    return [text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size;
}

#pragma mark 设置文字的行间距
+(NSAttributedString*)setLabelSpacewithValue:(NSString*)str withFont:(UIFont*)font LineHeight:(CGFloat)lineHight TextAlignment:(NSTextAlignment)textAlign{
    
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paraStyle.alignment = textAlign;
    paraStyle.lineSpacing = lineHight; //设置行间距
    //设置字间距 NSKernAttributeName:@1.5f
    NSDictionary *dic = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paraStyle
                          };
    
    NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithString:str attributes:dic];
    
    return attributeStr;
}

+(NSMutableAttributedString*)setLabelSpacewithValue:(NSString*)str withFont:(UIFont*)font LineHeight:(CGFloat)lineHight TextAlignment:(NSTextAlignment)textAlign RangeColor:(UIColor*)color Range:(NSRange)range{
    
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paraStyle.alignment = textAlign;
    paraStyle.lineSpacing = lineHight; //设置行间距
    //设置字间距 NSKernAttributeName:@1.5f
    NSDictionary *dic = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paraStyle,
                          };
    
    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:str attributes:dic];
    [attributeStr addAttributes:@{NSForegroundColorAttributeName:color} range:range];
    
    return attributeStr;
}

+(NSMutableAttributedString*)setLabelSpacewithValue:(NSString*)str withNumberFont:(UIFont*)font Range:(NSRange)range1 TextFont:(UIFont*)textFont TextRange:(NSRange)range2{
    
    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:str];
    [attributeStr addAttributes:@{NSFontAttributeName:font} range:range1];
     [attributeStr addAttributes:@{NSFontAttributeName:textFont} range:range2];
    return attributeStr;
}


#pragma mark 计算有行间距的高度
+(CGSize)getSpaceLabelHeight:(NSString*)str withFont:(UIFont*)font LineHeight:(CGFloat)lineHight  Range:(CGSize)size TextAlignment:(NSTextAlignment)textAlign{
    
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paraStyle.alignment = textAlign;
    paraStyle.lineSpacing = lineHight;
    NSDictionary *dic = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paraStyle
                          };
    
    CGSize textSize = [str boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    return textSize;
}

#pragma mark 如果想要判断设备是ipad，要用如下方法
+ (BOOL)getIsIpad
{
    NSString *deviceType = [UIDevice currentDevice].model;
    
    if([deviceType containsString:@"iPhone"]) {
        //iPhone
        return NO;
    }
    else if([deviceType containsString:@"iPod touch"]) {
        //iPod Touch
        return NO;
    }
    else if([deviceType containsString:@"iPad"]) {
        //iPad
        return YES;
    }
    return NO;
}


@end
