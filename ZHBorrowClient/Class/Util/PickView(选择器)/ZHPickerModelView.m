//
//  ZHPickerModelView.m
//  ZHLoanClient
//
//  Created by 正和 on 2017/10/31.
//  Copyright © 2017年 小飞鸟. All rights reserved.
//

#import "ZHPickerModelView.h"
#import "BasicModel.h"
@interface ZHPickerModelView()<UIPickerViewDelegate,UIPickerViewDataSource,UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UIButton *confirmButton;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, copy) confirmButtonAction confrimButtonActionBlock;
@property (nonatomic, copy) cancelButtonAction cancelButtonActionBlock;
@property (nonatomic, copy) maskClickAction maskClickActionBlock;

@property (nonatomic, copy) NSArray *dataArray;
@end

@implementation ZHPickerModelView

const int pickerHeight = 220;

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
        
        UITapGestureRecognizer * tap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(backgroundClickAction)];
        [self addGestureRecognizer:tap];
        tap.delegate = self;
        
        [self layoutViews];
    }
    return self;
}

#pragma mark - interface

+ (ZHPickerModelView *)showPickerViewAddedTo :(UIView *)view dataArray: (NSArray *)array
                          confirmAction :(confirmButtonAction)confrimButtonAction
                           cancelAction :(cancelButtonAction)cancelButtonAction
                              maskClick :(maskClickAction)maskClickAction {
    ZHPickerModelView * myPickerView = [[ZHPickerModelView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    
    // 设置属性
    myPickerView.confrimButtonActionBlock = confrimButtonAction;
    myPickerView.cancelButtonActionBlock = cancelButtonAction;
    myPickerView.maskClickActionBlock = maskClickAction;
    
    myPickerView.dataArray = array;
    
    // 淡出动画
    myPickerView.alpha = 0.0;
    myPickerView.containerView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, pickerHeight);
    [view addSubview:myPickerView];
    [UIView animateWithDuration:0.5f animations:^{
        myPickerView.containerView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height - pickerHeight, [UIScreen mainScreen].bounds.size.width, pickerHeight);
        myPickerView.alpha = 1.0;
    } completion:^(BOOL finished) {
        
    }];
    
    return myPickerView;
}


#pragma mark 点击范围的代理方法
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    
    CGPoint point = [gestureRecognizer locationInView:gestureRecognizer.view];
    if (CGRectContainsPoint(self.containerView.frame, point)){
        return NO;
    }
    return YES;
}

#pragma mark - lazy load

- (UIPickerView *)pickerView {
    if (_pickerView == nil) {
        _pickerView = [[UIPickerView alloc]init];
        _pickerView.delegate = self;
        _pickerView.dataSource = self;
        _pickerView.backgroundColor = [UIColor whiteColor];
    }
    return _pickerView;
}

- (UIView *)containerView {
    if (_containerView == nil) {
        _containerView = [[UIView alloc]init];
        _containerView.backgroundColor = [UIColor whiteColor];
        [self containerViewLayoutViews];
    }
    return _containerView;
}

- (UIButton *)confirmButton {
    if (_confirmButton == nil) {
        _confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_confirmButton setTitle:@"确认" forState:UIControlStateNormal];
        [_confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_confirmButton addTarget:self action:@selector(confirmButtonClickAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _confirmButton;
}

- (UIButton *)cancelButton {
    if (_cancelButton == nil) {
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_cancelButton addTarget:self action:@selector(cancelButtonClickAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelButton;
}

#pragma mark - layout

- (void)layoutViews {
    self.containerView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height - pickerHeight, [UIScreen mainScreen].bounds.size.width, pickerHeight);
    [self addSubview:self.containerView];
}

- (void)containerViewLayoutViews {
    // UIPickerView
    self.pickerView.frame = CGRectMake(0, 30, [UIScreen mainScreen].bounds.size.width, pickerHeight - 30);
    [self.containerView addSubview:self.pickerView];
    
    UIView * bg =[UIView CreateViewWithFrame:CGRectMake(0, 0, ZHScreenW, 40) BackgroundColor:ZHThemeColor InteractionEnabled:YES];
    [self.containerView addSubview:bg];
    
    // 确认button
    self.confirmButton.frame = CGRectMake(ZHScreenW - 40-14, 0, 40, 40);
    [bg addSubview:self.confirmButton];
    
    // 取消button
    self.cancelButton.frame = CGRectMake(14, 0, 40, 40);
    [bg addSubview:self.cancelButton];
}

#pragma mark - actions

- (void)confirmButtonClickAction {
    [UIView animateWithDuration:0.5f animations:^{
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        
        BasicModel *model = self.dataArray[[self.pickerView selectedRowInComponent:0]];
        self.confrimButtonActionBlock(model);
        [self removeFromSuperview];
    }];
}

- (void)cancelButtonClickAction {
    [UIView animateWithDuration:0.5f animations:^{
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
      
        self.cancelButtonActionBlock();
        [self removeFromSuperview];
    }];
}

- (void)backgroundClickAction {
    [UIView animateWithDuration:0.5f animations:^{
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
    
        self.maskClickActionBlock();
        [self removeFromSuperview];
    }];
}

#pragma mark - delegate

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return ZHFit(30);
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    
    //设置分割线的颜色
    for(UIView *singleLine in pickerView.subviews){
        if (singleLine.frame.size.height < 1){
            singleLine.backgroundColor = ZHLineColor;
        }
    }
    
    BasicModel *model = self.dataArray[row];
    
    //设置文字的属性
    UILabel *genderLabel = [UILabel new];
    genderLabel.textAlignment = NSTextAlignmentCenter;
    genderLabel.font = ZHFontSize(17);
    genderLabel.text = model.name;
    genderLabel.textColor = [UIColor colorWithWhite:0.0 alpha:0.87];
    
    return genderLabel;
}

#pragma mark - dataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return self.dataArray.count;
}

@end
