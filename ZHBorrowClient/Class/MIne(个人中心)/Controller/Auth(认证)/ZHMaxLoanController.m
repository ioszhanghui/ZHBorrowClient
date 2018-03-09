//
//  ZHMaxLoanController.m
//  ZHBorrowClient
//
//  Created by 小飞鸟 on 2017/12/20.
//  Copyright © 2017年 小飞鸟. All rights reserved.
//

#import "ZHMaxLoanController.h"
#import "ZHLoanLimitViewController.h"
#import "ZHGIFImageView.h"

#define kRadianToDegrees(radian) (radian*180.0)/(M_PI)

@interface ZHMaxLoanController ()
/*最外围旋转动画*/
@property(nonatomic,strong)UIImageView * loadingImage1;
/*中间层的旋转动画*/
@property(nonatomic,strong)UIImageView * loadingImage2;
/*最里层的旋转动画*/
@property(nonatomic,strong)UIImageView * loadingImage3;
/*文字抖动*/
@property(nonatomic,strong)UIImageView * shareImage4;

@end

@implementation ZHMaxLoanController{
    
    /*动画实体*/
    ZHGIFImageView* imageView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.layer.contents= (id)[UIImage imageNamed:@"BG"].CGImage;
    
    [self configUI];
}

#pragma mark 布局UI
-(void)configUI{
    
    UILabel * textLabel = [UILabel addLabelWithFrame:CGRectMake(0,StatusBarHeight+ZHFit(44), ZHScreenW, ZHFit(24)) title:@"额度计算" titleColor:[UIColor whiteColor] font:ZHFontHeavy(24)];
    textLabel.textAlignment=NSTextAlignmentCenter;
    [self.view addSubview:textLabel];
    
//    imageView = [[ZHGIFImageView alloc] initWithFrame:CGRectMake((ZHScreenW-ZHFit(325))/2,textLabel.bottom+ZHFit(63),ZHFit(325), ZHFit(325))];
//    NSData *gifData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"动画.gif" ofType:nil]];
//    imageView.gifData=gifData;
//    [imageView startGIF];
//
//    [self.view addSubview:imageView];
    
    [self addsubviews:textLabel];

    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        /*跳转我的额度*/
       ZHLoanLimitViewController * VC = [ZHLoanLimitViewController new];
        VC.loan_mt=self.loan_mt;
        [self.navigationController pushViewController:VC animated:YES];
    });
    
}

#pragma mark 添加动画
-(void)addsubviews:(UILabel*)textLabel{
    //第1个动画
    self.loadingImage1 =[[UIImageView alloc]initWithFrame:CGRectMake((ZHScreenW-ZHFit(314))/2,textLabel.bottom+ZHFit(63),ZHFit(314), ZHFit(322))];
    self.loadingImage1.image=[UIImage imageNamed:@"1"];
    [self.loadingImage1.layer addAnimation:[self rotation:0.4 degree:kRadianToDegrees(160) direction:1.0 repeatCount:MAXFLOAT] forKey:nil];
    [self.view addSubview:self.loadingImage1];
    
    //第2个动画
    self.loadingImage2 =[[UIImageView alloc]initWithFrame:CGRectMake((ZHScreenW-ZHFit(230))/2,textLabel.bottom+ZHFit(63),ZHFit(230), ZHFit(219))];
    self.loadingImage2.image=[UIImage imageNamed:@"3"];
    [self.loadingImage2.layer addAnimation:[self rotation:0.4 degree:kRadianToDegrees(180) direction:1.0 repeatCount:MAXFLOAT] forKey:nil];
    [self.view addSubview:self.loadingImage2];
    self.loadingImage2.centerY= self.loadingImage1.centerY;
    
//    //第3个动画
    self.loadingImage3 =[[UIImageView alloc]initWithFrame:CGRectMake((ZHScreenW-ZHFit(161))/2,(self.loadingImage1.height-ZHFit(164))/2,ZHFit(161), ZHFit(164))];
    self.loadingImage3.image=[UIImage imageNamed:@"2"];
    [self.loadingImage3.layer addAnimation:[self rotation:0.4 degree:kRadianToDegrees(160) direction:1.0 repeatCount:MAXFLOAT] forKey:nil];
    [self.view addSubview:self.loadingImage3];
    self.loadingImage3.centerY= self.loadingImage1.centerY;
    
//
//    //第4个动画
    self.shareImage4 =[[UIImageView alloc]initWithFrame:CGRectMake((ZHScreenW-ZHFit(88))/2,(self.loadingImage1.height-ZHFit(33))/2,ZHFit(88), ZHFit(33))];
    self.shareImage4.image=[UIImage imageNamed:@"4"];
    //抖动动画
    [self.shareImage4.layer addAnimation:[self opacityForever_Animation:0.7] forKey:nil];
    [self.view addSubview:self.shareImage4];
    self.shareImage4.centerY= self.loadingImage1.centerY;
    
}

#pragma mark === 永久闪烁的动画 ======
-(CABasicAnimation* )opacityForever_Animation:(float)time
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];//必须写opacity才行。
    animation.fromValue = [NSNumber numberWithFloat:1.0f];
    animation.toValue = [NSNumber numberWithFloat:0.0f];//这是透明度。
    animation.autoreverses = YES;
    animation.duration = time;
    animation.repeatCount = MAXFLOAT;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];///没有的话是均匀的动画。
    
    return animation;
}

#pragma ,mark 旋转的动画
#pragma mark ====旋转动画======
-(CABasicAnimation *)rotation:(float)dur degree:(float)degree direction:(int)direction repeatCount:(int)repeatCount
{
    CATransform3D rotationTransform = CATransform3DMakeRotation(degree, 0, 0, direction);
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    animation.toValue = [NSValue valueWithCATransform3D:rotationTransform];
    animation.duration  =  dur;
    //是否反转
    animation.autoreverses = NO;
    animation.cumulative = YES;
    animation.fillMode = kCAFillModeForwards;
    animation.repeatCount = repeatCount;
    return animation;
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

@end
