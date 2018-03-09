//
//  ZHScanTypeView.m
//  ZHLoanClient
//
//  Created by 小飞鸟 on 2017/10/22.
//  Copyright © 2017年 小飞鸟. All rights reserved.
//

#import "ZHScanTypeView.h"
#import "ZHButtonItemView.h"
#import "ZHItemFooterView.h"
#import "ZHTypeInstance.h"

@interface ButtonItem()

@end

@implementation ButtonItem

-(instancetype)initWithFrame:(CGRect)frame{
    
    if (self=[super initWithFrame:frame]) {
        
        self.itemLabel=[UILabel addLabelWithFrame:CGRectMake(0, 0, self.width, ZHFit(28)) title:nil titleColor:[UIColor whiteColor] font:ZHFontSize(14)];
        self.itemLabel.textAlignment=NSTextAlignmentCenter;
        self.layer.cornerRadius=ZHFit(14);
        self.clipsToBounds=YES;
        [self.contentView addSubview:self.itemLabel];
        
    }
    return self;
}

#pragma mark 初始化数据
-(void)setTypeModel:(ZHTypeModel *)typeModel{
    _typeModel=typeModel;
    self.itemLabel.text=typeModel.name;
}

#pragma mark 颜色的修改改变
-(void)setSelected:(BOOL)Selected{
    
    _Selected=Selected;
    
    if (Selected) {
        self.backgroundColor=ZHThemeColor;
        self.itemLabel.textColor=[UIColor whiteColor];
    }else{
        self.backgroundColor=[UIColor whiteColor];
        self.itemLabel.textColor=UIColorWithRGB(0x393939, 1.0);
    }
}

@end

@interface ZHScanTypeView()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,UIGestureRecognizerDelegate,ZHChooseViewDelegate>

/*选择视图*/
@property(nonatomic,strong)UICollectionView * collectionView;

/* 第一组当前选中的  用来删除Item项*/
@property(nonatomic,strong) ButtonItem * firstCurrentItem;
/* 第一组当前选中的*/
@property(nonatomic,strong) ButtonItem * secondCurrentItem;

@end


@implementation ZHScanTypeView


-(instancetype)initWithFrame:(CGRect)frame ItemChooseBlock:(void(^)(ButtonItem * item))chooseBlock LoanItemChooseBlock:(void(^)(NSArray * item1,ButtonItem* item2))loanItemBlock{
    
    if (self=[super initWithFrame:frame]) {
        
        self.y=-ZHScreenH;

        self.ChooseItem=chooseBlock;
        self.ChooseTwoItem=loanItemBlock;
        
        self.height=ZHScreenH-ZHFit(50)-64;

        self.collectionView.backgroundColor=[UIColor whiteColor];
         self.backgroundColor=ZHClearColor;
        
        [UIView addLineWithFrame:CGRectMake(0,0.5, ZHScreenW, 0.5) WithView:self];
        
        UITapGestureRecognizer * tap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hiddenInWindow)];
        [self addGestureRecognizer:tap];
        tap.delegate = self;
    
    }
    
    return self;
}

#pragma mark 点击范围的代理方法
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    
    CGPoint point = [gestureRecognizer locationInView:gestureRecognizer.view];
    if (CGRectContainsPoint(self.collectionView.frame, point)){
        return NO;
    }
    return YES;
}

#pragma mark 点击空白区域
-(void)hiddenInWindow{
    
    //修改箭头的方向
    if (self.changeDelegate&&[self.changeDelegate respondsToSelector:@selector(changeArrowDirection:)]) {
        [self.changeDelegate changeArrowDirection:@"0"];
        [self removeItemInWindow];
    }
}

#pragma mark 移除视图
-(void)removeItemInWindow{
    
    [UIView animateWithDuration:0.3 animations:^{
        
        self.alpha=0;
        
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
    }];
}

#pragma mark - LazyLoad
- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing=0;
        layout.minimumInteritemSpacing=ZHFit(5);
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, ZHScreenW, 80) collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.allowsMultipleSelection=YES;
        _collectionView.showsVerticalScrollIndicator = NO;        //注册
        [_collectionView registerClass:[ButtonItem class] forCellWithReuseIdentifier:@"ButtonItem"];
        [_collectionView registerClass:[ZHItemFooterView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"ZHItemFooterView"];
        [_collectionView registerClass:[ZHButtonItemView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"SectionHeader"];
        
        [self addSubview:_collectionView];
    }
    return _collectionView;
}

-(void)setSourceArr:(NSMutableArray *)sourceArr{
    _sourceArr=sourceArr;
    [UIView animateWithDuration:0.3 animations:^{
        
        self.y=64+ZHFit(50);
        
        if (KIsiPhoneX) {
            self.y=StatusBarHeight+44+ZHFit(50);
            self.height=ZHScreenH-ZHFit(50)-44-StatusBarHeight;
        }
        
    } completion:^(BOOL finished) {
        
        self.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
        [kWindow addSubview:self];
        [self.collectionView reloadData];
    }];
    
}

#pragma mark - <UICollectionViewDataSource>
- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return self.sourceArr.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    if (self.sourceArr.count>section) {
        NSString * key =[[((NSDictionary*)[self.sourceArr objectAtIndex:section]) allKeys] firstObject];
        NSArray * sectionTitle = [((NSDictionary*)[self.sourceArr objectAtIndex:section]) objectForKey:key];
        return sectionTitle.count;
    }
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ButtonItem *gridcell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ButtonItem" forIndexPath:indexPath];
    
    if (self.sourceArr.count>indexPath.section) {
        NSString * key =[[((NSDictionary*)[self.sourceArr objectAtIndex:indexPath.section]) allKeys] firstObject];
        NSArray * sectionTitle=[((NSDictionary*)[self.sourceArr objectAtIndex:indexPath.section]) objectForKey:key];
        NSString * name =((ZHTypeModel*)[sectionTitle objectAtIndex:indexPath.item]).name;
        gridcell.typeModel=(ZHTypeModel*)[sectionTitle objectAtIndex:indexPath.item];
        gridcell.itemLabel.text=name;

        if (self.sourceArr.count==1) {
            gridcell.Selected=[self shouldSelectedAtIndexPath:indexPath Name:name];;
        }else{

            gridcell.Selected= [self resetItem:gridcell IndexPath:indexPath];
        }
    }
   
    [UIView animateWithDuration:0.3 animations:^{
         _collectionView.height=collectionView.contentSize.height;
    }];
    
    return gridcell;
}

#pragma mark 是否应该被选中
-(BOOL)shouldSelectedAtIndexPath:(NSIndexPath *)indexPath Name:(NSString*)name{
    if ([ZHTypeInstance sharedInstance].typeModel.name.length==0) {
        if (self.sourceArr.count==1 &&indexPath.row==0) {
            return YES;
        }else{
            
            return NO;
        }
    }else{
        
        if ([[ZHTypeInstance sharedInstance].typeModel.name isEqualToString:name]) {
            return YES;
        }else{
            
            return NO;
        }
    }

    return NO;
}

#pragma mark - item宽高
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGSize itemSize=CGSizeZero;
    
    if (self.sourceArr.count>indexPath.section) {
        
        NSString * key =[[((NSDictionary*)[self.sourceArr objectAtIndex:indexPath.section]) allKeys] firstObject];
        NSArray * sectionTitle=[((NSDictionary*)[self.sourceArr objectAtIndex:indexPath.section]) objectForKey:key];
        NSString * name =((ZHTypeModel*)[sectionTitle objectAtIndex:indexPath.item]).name;
       CGFloat width= [ZHStringFilterTool computeTextSizeHeight:name Range:CGSizeMake(MAXFLOAT, ZHFit(28)) FontSize:ZHFontSize(14)].width;
        itemSize=CGSizeMake(width+ZHFit(24), ZHFit(28));
    }
    
    return itemSize;
}

#pragma mark - head宽高
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {

    return self.sourceArr.count==1? CGSizeZero:CGSizeMake(self.width, ZHFit(55)) ;
}
#pragma mark - foot宽高
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {

    return self.sourceArr.count==1? CGSizeZero:(section==1? CGSizeMake(ZHScreenW, ZHFit(72)):CGSizeZero);
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    if (kind == UICollectionElementKindSectionHeader){
        ZHButtonItemView * headerView =[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"SectionHeader" forIndexPath:indexPath];
        if (self.sourceArr.count>indexPath.section) {
       
            NSString * key =[[((NSDictionary*)[self.sourceArr objectAtIndex:indexPath.section]) allKeys] firstObject];
            headerView.itemLabel.text=key;
        }
        headerView.topLine.hidden= !indexPath.section;

        return headerView;
      }
    
    if (kind == UICollectionElementKindSectionFooter) {
        ZHItemFooterView *footview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"ZHItemFooterView" forIndexPath:indexPath];

        footview.ClickBtnBlock = ^(NSInteger tag) {

            if (tag==2000) {

                [self resetAllItems];
                if (self.ChooseTwoItem) {
                    self.ChooseTwoItem([ZHTypeInstance sharedInstance].btnItems, self.secondCurrentItem);
                }
                //修改箭头的方向
                if (self.changeDelegate&&[self.changeDelegate respondsToSelector:@selector(changeArrowDirection:)]) {
                    [self.changeDelegate changeArrowDirection:@"1"];
                }
                [self removeItemInWindow];


            }else{

                //修改箭头的方向
                if (self.changeDelegate&&[self.changeDelegate respondsToSelector:@selector(changeArrowDirection:)]) {
                    [self.changeDelegate changeArrowDirection:@"1"];
                }
                //贷款类型 回调值
                if (self.ChooseItem) {
                    self.ChooseTwoItem([ZHTypeInstance sharedInstance].btnItems, self.secondCurrentItem);
                }

                [self removeItemInWindow];
            }
        };
        return footview;
    }
    
    return nil;
}

#pragma mark 重置所有的item项
-(void)resetAllItems{

    for(ButtonItem *cell in self.collectionView.visibleCells) {
        cell.Selected=NO;
        [self.collectionView deselectItemAtIndexPath:[self.collectionView indexPathForCell:cell] animated:YES];
    }
    /*全部删除*/
    [[ZHTypeInstance sharedInstance].btnItems removeAllObjects];
    [ZHTypeInstance sharedInstance].needModel=nil;
    self.firstCurrentItem=nil;
    self.secondCurrentItem=nil;
}

#pragma mark - 偏移
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    if (self.sourceArr.count==1) {
        
        return UIEdgeInsetsMake(ZHFit(18), ZHFit(20), ZHFit(20), ZHFit(18));
    }
    
    switch (section) {
        case 0:
            return UIEdgeInsetsMake(0, ZHFit(20), ZHFit(20), ZHFit(20));
            break;
            
        case 1:
            return UIEdgeInsetsMake(0, ZHFit(20), ZHFit(25), ZHFit(20));
            break;
            
        default:
            break;
    }
    return UIEdgeInsetsZero;

}
#pragma mark  每个item之间的间距
#pragma mark - X间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {

    CGFloat value=(ZHScreenW-4*ZHFit(75)-2*ZHFit(20))/3;

    return value;
}
#pragma mark - Y间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    CGFloat value=ZHFit(18);
    return value;
}

#pragma mark 点击选项
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

    [self itemDidClick:(ButtonItem *)[collectionView cellForItemAtIndexPath:indexPath] AtIndexPath:indexPath];
}

#pragma mark item点击处理
-(void)itemDidClick:(ButtonItem *)item AtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.sourceArr.count==1) {
        //修改箭头的方向
        if (self.changeDelegate&&[self.changeDelegate respondsToSelector:@selector(changeArrowDirection:)]) {
            [self.changeDelegate changeArrowDirection:@"1"];
        }
        //回调值
        if (self.ChooseItem) {
            
            self.ChooseItem(item);
        }
        
        [self removeItemInWindow];
        return;
    }
    
    if (self.sourceArr.count==2) {
        
        if (indexPath.section==0) {
            //先查找需要反选的
            [self deselectItem:item];
            
        }else{
            
            if ([item.itemLabel.text isEqualToString: self.secondCurrentItem.itemLabel.text]) {
                self.secondCurrentItem.Selected = NO;
              [self.collectionView deselectItemAtIndexPath:[self.collectionView indexPathForCell:self.secondCurrentItem] animated:YES];
                self.secondCurrentItem=nil;
                [ZHTypeInstance sharedInstance].needModel=nil;
                
            }else{
                
                [self.collectionView deselectItemAtIndexPath:[self.collectionView indexPathForCell:self.secondCurrentItem] animated:YES];
                self.secondCurrentItem.Selected = NO;
                self.secondCurrentItem=item;
                [self.collectionView selectItemAtIndexPath:[self.collectionView indexPathForCell:self.secondCurrentItem] animated:YES scrollPosition:UICollectionViewScrollPositionNone];
                self.secondCurrentItem.Selected=YES;
                [ZHTypeInstance sharedInstance].needModel=self.secondCurrentItem.typeModel;

            }
        }
    }
}

#pragma mark 重置 点击效果
-(BOOL)resetItem:(ButtonItem *)item IndexPath:(NSIndexPath*)indexPath{

    BOOL isSelected =NO;

    switch (indexPath.section) {
        case 1:{
            //第一个分组
            if ([[ZHTypeInstance sharedInstance].needModel.name isEqualToString:item.typeModel.name]) {
                isSelected=YES;

                //获取上一次 选中的cell
                [self.collectionView performBatchUpdates:^{
                    [self.collectionView reloadItemsAtIndexPaths:@[indexPath]];
                } completion:^(BOOL finished) {
                    self.secondCurrentItem=(ButtonItem *)[self.collectionView cellForItemAtIndexPath:indexPath];
                }];
                return isSelected;
            }
            break;
        }
        case 0:{
            //第二个分组
            for(ButtonItem * InItem in [ZHTypeInstance sharedInstance].btnItems){

                if ([InItem.itemLabel.text isEqualToString:item.itemLabel.text]) {
                    isSelected=YES;
                }
            }
            break;
        }

        default:
            break;
    }

    return isSelected;
}

#pragma mark 查找当前点击的进行反选
-(void)deselectItem:(ButtonItem *)item{

    BOOL isSame=NO;
    for(ButtonItem * InItem in [ZHTypeInstance sharedInstance].btnItems){

        if ([InItem.itemLabel.text isEqualToString:item.itemLabel.text]) {

             [self.collectionView deselectItemAtIndexPath:[self.collectionView indexPathForCell:item] animated:YES];
            InItem.Selected=NO;
            self.firstCurrentItem=InItem;
            isSame=YES;
        }
    }
    if (!isSame) {
           [[ZHTypeInstance sharedInstance].btnItems addObject:item];
        [self.collectionView selectItemAtIndexPath:[self.collectionView indexPathForCell:item] animated:YES scrollPosition:UICollectionViewScrollPositionNone];
        item.Selected=YES;
    }else{

       [[ZHTypeInstance sharedInstance].btnItems removeObject:self.firstCurrentItem];
    }
}

+(ZHScanTypeView*)shareButtonItemWithFrame:(CGRect)frame ItemChooseBlock:(void(^)(ButtonItem* item))chooseBlock LoanItemChooseBlock:(void (^)(NSArray *, ButtonItem *))loanItemBlock{
    
    return  [[ZHScanTypeView alloc] initWithFrame:frame ItemChooseBlock:chooseBlock LoanItemChooseBlock:loanItemBlock];
}

//修改箭头的指向
-(void)removeChooseViewFromWindow{
    
    [self hiddenInWindow];
    
}


@end
