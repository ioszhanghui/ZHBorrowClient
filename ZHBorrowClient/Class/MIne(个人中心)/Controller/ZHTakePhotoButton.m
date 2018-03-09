//
//  ZHTakePhotoButton.m
//  ZHMoneyClient
//
//  Created by zhph on 2017/7/10.
//  Copyright © 2017年 正和普惠. All rights reserved.
//

#import "ZHTakePhotoButton.h"

@implementation ZHTakePhotoButton

-(instancetype)initWithFrame:(CGRect)frame WithImageName:(NSString*)ImageName TapPhotoBlock:(void (^)(UIImageView* imageView))tapBlock;{

    if (self=[super initWithFrame:frame]) {
        
        self.userInteractionEnabled=YES;
        self.layer.cornerRadius=ZHFit(6);
        self.image=[UIImage imageNamed:ImageName];
        
        self.backgroundColor=[UIColor whiteColor];
        
        self.TapPhotoBlock=tapBlock;
        
        UITapGestureRecognizer * tap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
        [self addGestureRecognizer:tap];
    }
    
    return self;
}

#pragma mark 重新点击拍照
-(void)tap:(UITapGestureRecognizer * )tap{

    if (self.TapPhotoBlock) {
        
        self.TapPhotoBlock(self);
    }
}


@end
