//
//  ZHTakePhotoButton.h
//  ZHMoneyClient
//
//  Created by zhph on 2017/7/10.
//  Copyright © 2017年 正和普惠. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZHTakePhotoButton : UIImageView
/*点击拍照回调imageView*/
@property(nonatomic,copy)void(^TapPhotoBlock)(UIImageView * imageView);

-(instancetype)initWithFrame:(CGRect)frame WithImageName:(NSString*)ImageName TapPhotoBlock:(void (^)(UIImageView* imageView))tapBlock;
@end
