//
//  ZHNoContentView.m
//  ZHBorrowClient
//
//  Created by 小飞鸟 on 2017/12/22.
//  Copyright © 2017年 小飞鸟. All rights reserved.
//

#import "ZHNoContentView.h"

@interface ZHNoContentView()
/*占位图片*/
@property (nonatomic,strong) UIImageView *imageView;
/*文字描述*/
@property (nonatomic,strong) UILabel *topLabel;
/*文字提示*/
@property (nonatomic,strong) UILabel *bottomLabel;
/*返回按钮*/
@property(nonatomic,strong)UIButton * backBtn;
/*返回的回调*/
@property(nonatomic,copy)void(^ BackActionBlock)(void);

@end

@implementation ZHNoContentView

+(instancetype)shareNoContentView{
    
    static ZHNoContentView * _noContentView;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (_noContentView == nil) {
            _noContentView = [[ZHNoContentView alloc]initWithFrame:CGRectZero];
        }
    });
    return _noContentView;
}


#pragma mark - 构造方法
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        // UI搭建
        [self setUpUI];
    }
    return self;
}

#pragma mark - UI搭建
/** UI搭建 */
- (void)setUpUI{
    
    self.backgroundColor =UIColorWithRGB(0xf3f4f8, 1.0);
    //------- 图片 -------//
    self.imageView = [[UIImageView alloc]initWithFrame:CGRectMake((ZHScreenW-ZHFit(132))/2, ZHFit(53), ZHFit(132), ZHFit(163))];
    [self addSubview:self.imageView];
    
    //------- 内容描述 -------//
    self.topLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, self.imageView.bottom+ZHFit(53), ZHScreenW, ZHFit(20))];
    [self addSubview:self.topLabel];
    self.topLabel.textColor=UIColorWithRGB(0x5e5e5e, 1.0);
    self.topLabel.textAlignment = NSTextAlignmentCenter;
    self.topLabel.font = ZHFontBold(20);
    
    //------- 提示点击重新加载 -------//
    self.bottomLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, self.topLabel.bottom+ZHFit(11), ZHScreenW, ZHFit(12))];
    [self addSubview:self.bottomLabel];
    self.bottomLabel.textAlignment = NSTextAlignmentCenter;
    self.bottomLabel.font =ZHFontSize(12);
    self.bottomLabel.textColor=UIColorWithRGB(0x5e5e5e, 1.0);
    
    self.backBtn=[UIButton addButtonWithFrame:CGRectMake((ZHScreenW-ZHFit(135))/2, self.bottomLabel.bottom+ZHFit(20), ZHFit(135), ZHFit(40)) title:nil titleColor:nil font:nil image:@"Backbtn" highImage:@"Backbtn" backgroundColor:ZHClearColor tapAction:^(UIButton *button) {
        
        if (self.BackActionBlock) {
            self.BackActionBlock();
        }
        [self removeEmptyView];
    }];
    [self addSubview:self.backBtn];
    
}

#pragma mark - 根据传入的值创建相应的UI
/** 根据传入的值创建相应的UI */
- (void)setType:(NSInteger)type{
    switch (type) {
            
        case NoContentTypeNetwork:{
            // 没网
            [self setImage:@"网络异常" topLabelText:@"貌似没有网络" bottomLabelText:@"点击重试"];
        }
            break;
            
        case NoContentTypeOrder:{
            //没有任何记录
            [self setImage:@"插图" topLabelText: @"暂时没有记录" bottomLabelText:@"很抱歉，您还没有任何申请记录哦!"];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - 设置图片和文字
/** 设置图片和文字 */
- (void)setImage:(NSString *)imageName topLabelText:(NSString *)topLabelText bottomLabelText:(NSString *)bottomLabelText{
    self.imageView.image = [UIImage imageNamed:imageName];
    self.topLabel.text = topLabelText;
    self.bottomLabel.text = bottomLabelText;
}

/**
 展示无数据占位图
 @param emptyViewType 无数据占位图的类型
 */
- (void)showEmptyViewWithType:(NSInteger)emptyViewType InSuperView:(UIView*)view BackAction:(void(^)(void))backActionBlock{
    
    [view addSubview:self];
    self.type = emptyViewType;
    self.frame = CGRectMake(0, 0, ZHScreenW, view.bounds.size.height);
    self.BackActionBlock=backActionBlock;
}

/* 移除无数据占位图 */
-(void)removeEmptyView{
    [self removeFromSuperview];
}

@end
