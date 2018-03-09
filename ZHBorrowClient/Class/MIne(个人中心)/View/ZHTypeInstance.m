//
//  ZHTypeInstance.m
//  ZHLoanClient
//
//  Created by zhph on 2017/10/24.
//  Copyright © 2017年 小飞鸟. All rights reserved.
//

#import "ZHTypeInstance.h"

@implementation ZHTypeInstance

-(instancetype)init{
    if (self=[super init]) {
        
        self.btnItems=[NSMutableArray array];
    }
    return self;
}

+(instancetype)sharedInstance {
    static ZHTypeInstance *_instance = nil;
    static dispatch_once_t  token;
    dispatch_once(&token, ^{
        if (_instance == nil ) {
            _instance = [[ZHTypeInstance alloc] init];
        }
    });
    return _instance;
}

@end
