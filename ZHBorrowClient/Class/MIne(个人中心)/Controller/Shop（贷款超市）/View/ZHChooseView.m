//
//  ZHChooseView.m
//  ZHLoanClient
//
//  Created by 小飞鸟 on 2017/10/22.
//  Copyright © 2017年 小飞鸟. All rights reserved.
//

#import "ZHChooseView.h"

@implementation ZHButtonItem

-(instancetype)initWithFrame:(CGRect)frame{
    
    if (self=[super initWithFrame:frame]) {
        
        self.titleLabel.lineBreakMode=NSLineBreakByTruncatingTail;
        self.arrowImageView=[[UIImageView alloc]init];
       UIImage * image= [UIImage imageNamed:@"下拉箭头"];
        self.arrowImageView.image=image;
        self.arrowImageView.size=image.size;
        [self addSubview:self.arrowImageView];
        
        _arrowImageView.y=(self.height-image.size.height)/2;
        _arrowImageView.x=self.width;
        
    }
    return self;
}

@end

@interface ZHChooseView()<ZHScanTypeViewDelegate>
//当前选中的对象
@property(nonatomic,strong)ZHButtonItem * currentItem;

/*被点选的对象*/
@property(nonatomic,strong)ZHButtonItem * lastItem;

@end

@implementation ZHChooseView{
    CGFloat width;
    CGFloat hight;
    CGFloat edgeX;
    CGFloat offsetX;
}

+(ZHChooseView*)shareButtonItemWithFrame:(CGRect)frame ItemChooseBlock:(void(^)(ZHButtonItem* item))chooseBlock{
    
   return  [[ZHChooseView alloc] initWithFrame:frame ItemChooseBlock:chooseBlock];
}


-(instancetype)initWithFrame:(CGRect)frame ItemChooseBlock:(void(^)(ZHButtonItem* item))chooseBlock{
    
    if (self=[super initWithFrame:frame]) {
        
        self.backgroundColor=[UIColor whiteColor];
        width=ZHFit(66);
        hight=ZHFit(50);
        edgeX=ZHFit(24);
        offsetX=(ZHScreenW-edgeX*2-width*3)/2;
        self.ChooseItem=chooseBlock;
        
        [UIView addLineWithFrame:CGRectMake(0, 0, ZHScreenW, 0.4) WithView:self];
    }
    return self;
}

-(void)setCurrentItem:(ZHButtonItem *)currentItem{
    _currentItem=currentItem;
}

-(void)setTitles:(NSArray *)titles{
    _titles=titles;

    for(UIView * subView in self.subviews){
        
        [subView removeFromSuperview];
    }

    for(NSInteger i=0;i<titles.count;i++){
        
        ZHButtonItem * item =[[ZHButtonItem alloc]initWithFrame:CGRectMake(edgeX+(width+offsetX)*i, 0.4, width, hight-0.4)];
        [item setTitle:[titles objectAtIndex:i] forState:UIControlStateNormal];
         [item setTitleColor:UIColorWithRGB(0x9b9b9b, 1.0) forState:UIControlStateNormal];
        [item setTitleColor:UIColorWithRGB(0x3B3B3B, 1.0) forState:UIControlStateSelected];
        item.titleLabel.font=ZHFontSize(14);
        [item addTarget:self action:@selector(chooseAction:) forControlEvents:UIControlEventTouchDown];
        [self addSubview:item];
        item.tag=2000+i;
    }
}

-(void)setSelectedTag:(NSInteger)selectedTag{
    
    _selectedTag=selectedTag;
    
    ZHButtonItem * item =  (ZHButtonItem *)[self viewWithTag:(2000+selectedTag)];
    self.currentItem=item;
}

#pragma mark 选取点击
-(void)chooseAction:(ZHButtonItem*)item{
    
    if ([item isEqual:self.currentItem]&&[self.currentItem.arrowImageView.image isEqual:[UIImage imageNamed:@"上拉箭头"]]) {
        
        //重复点击移除视图
        if ([self.removeDelegate respondsToSelector:@selector(removeChooseViewFromWindow)]&&self.removeDelegate) {
            
            [self.removeDelegate removeChooseViewFromWindow];
        }
         self.currentItem.arrowImageView.image=[UIImage imageNamed:@"下拉箭头"];
        return;
    }
    
    if (![item isEqual:self.currentItem]) {
        
        //重复点击移除视图
        if ([self.removeDelegate respondsToSelector:@selector(removeChooseViewFromWindow)]&&self.removeDelegate) {
            
            [self.removeDelegate removeChooseViewFromWindow];
        }
    }
    self.currentItem.selected=NO;
    self.currentItem.arrowImageView.image=[UIImage imageNamed:@"下拉箭头"];
    self.currentItem=item;
    self.currentItem.selected=YES;
    self.currentItem.arrowImageView.image=[UIImage imageNamed:@"上拉箭头"];
    if (self.ChooseItem) {
        self.ChooseItem(item);
    }
}

//点击选择之后 或者 点击阴影区域
-(void)changeArrowDirection:(NSString *)type{
    
    self.currentItem.arrowImageView.image=[UIImage imageNamed:@"下拉箭头"];
    self.currentItem.selected=NO;
    
//    if ([type isEqualToString:@"0"]) {
//
//
//    }else{
//        self.currentItem.selected=YES;
//    }
}
@end
