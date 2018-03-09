//
//  NSString+null.m
//  WeiZaZhi
//
//  Created by 联动 on 15/5/30.
//  Copyright (c) 2015年 liandongzaixian. All rights reserved.
//

#import "NSString+null.h"

@implementation NSString (null)

#pragma mark 判断内容是不是为1
+(BOOL)stringIsEqualToOne:(NSString*)dicValue{
    if ([dicValue isEqualToString:@"1"]) {
        return YES;
    }
    return NO;
}
/*选择的内容  selectValue 和请求的内容  dicValue*/
+(NSString*)stringWithRequestDicValue:(id)dicValue SelectValue:(NSString*)selectValue{
    
    return !NULLString(selectValue)? selectValue:dicValue;
}

+(NSString*)stringWithRequestProvinceValue:(NSString*)provinceValue CityValue:(NSString*)cityValue AreaValue:(NSString*)areaValue{
    
    return [NSString stringWithFormat:@"%@ %@ %@",[NSString cutStringWithComma:provinceValue],[NSString cutStringWithComma:cityValue],[NSString cutStringWithComma:areaValue]];
}

+(NSString*)cutStringWithComma:(NSString*)str{

   return  [NSString stringWithRequestDicValue:[[str componentsSeparatedByString:@","] lastObject] defultValue:@""];
}

/*label的内容  selectValue 和请求的内容  dicValue*/
+(NSString*)stringLabelTextWithRequestDicValue:(id)dicValue SelectValue:(NSString*)selectValue{
    
    return NULLString(selectValue)? (NULLString(dicValue)? @"请选择":dicValue):selectValue;
}
/*联系人关系选择特用*/
+(NSString*)stringLabelTextWithSelectNilValue:(id)dicValue SelectValue:(NSString*)selectValue{
    
    return NULLString(selectValue)? (NULLString(dicValue)? nil:dicValue):selectValue;
}

/*label的内容  selectValue 和请求的内容  dicValue*/
+(NSString*)stringPhoneTextWithRequestDicValue:(id)dicValue SelectValue:(NSString*)selectValue{
    
    return NULLString(selectValue)? (NULLString(dicValue)? @"点击通讯录加载":dicValue):selectValue;
}

#pragma mark 空字符串
+(BOOL)isNullString:(NSString*)str{
    if ([str isEqualToString:@"<null>"]||str==nil||[str isEqualToString:@"null"]||[str isEqualToString:@""]||[str isEqualToString:@"(null)"]||[str isEqualToString:@"\"<null>\""]|| [str isKindOfClass:[NSNull class]]) {
        return YES;
    }
    return NO;
}

/*label的内容  selectValue 和请求的内容  dicValue*/
+(BOOL)stringTextWithRequestDicValue:(id)dicValue{
    
    return  [dicValue isEqualToString:@"1"]? YES:NO;
}

/*label的内容  selectValue 和请求的内容  dicValue*/
+(NSString*)stringFieldTextWithRequestDicValue:(id)dicValue SelectValue:(NSString*)selectValue{
    
    return selectValue? selectValue:(dicValue? dicValue:nil);
}

+(NSString*)stringWithRequestDicValue:(id)dicValue defultValue:(NSString*)defultValue
{
    
    NSString* str=[NSString stringWithFormat:@"%@",dicValue];

    if ([str isEqualToString:@"<null>"]||str==nil||[str isEqualToString:@"null"]||[str isEqualToString:@""]||[str isEqualToString:@"(null)"]||[str isEqualToString:@"\"<null>\""]|| [str isKindOfClass:[NSNull class]] ) {
        
        [defultValue stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        return defultValue;
        
        
    }else{

        return str;

    }

}

+(NSString *)stringWithFashionRequestDicValue:(id)dicValue defultValue:(NSString *)defultValue {

    NSString* str=[NSString stringWithFormat:@"%@",dicValue];
    
    if ([str isEqualToString:@"<null>"]||str==nil||[str isEqualToString:@"null"]||[str isEqualToString:@""]||[str isEqualToString:@"(null)"]|| [str isKindOfClass:[NSNull class]] ) {
        
        [defultValue stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        return defultValue;
        
        
    }else{
        
        //过滤nsstring中html标签
        NSArray *components = [str componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"&;"]];
        
        NSMutableArray *componentsToKeep = [NSMutableArray array];
        
        for (int i = 0; i < [components count]; i = i + 2) {
            
            [componentsToKeep addObject:[components objectAtIndex:i]];
            
        }
        
        NSString *plainText = [componentsToKeep componentsJoinedByString:@""];
        
        return plainText;
        
    }

}



//用于数字
+(NSString*)stringWithRequestDicValueForNumberStr:(id)dicValue
{
    
    NSString* str=[NSString stringWithFormat:@"%@",dicValue];
    
    
    
    if ([str isEqualToString:@"<null>"]||str==nil||[str isEqualToString:@"null"]|| [str isKindOfClass:[NSNull class]] ) {
        
        
        return @"0";
        
        
    }else{
        
        return str;
    }
    
    
}

//数组

+(BOOL)stringWithRequestDicValue:(id)dicValue
{
    if ([[dicValue class] isSubclassOfClass:[NSArray class]]) {
        
        return YES;
    }
    
    NSString* str=[NSString stringWithFormat:@"%@",dicValue];
    
    if ([str isEqualToString:@"<null>"]||str==nil||[str isEqualToString:@"null"]||[str isEqualToString:@""]||[str isEqualToString:@"(null)"]) {
        
        
        return NO;
        
        
    }else{
        
        return YES;
    }
}



@end
