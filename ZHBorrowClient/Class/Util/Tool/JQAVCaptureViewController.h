//
//  AVCaptureViewController.h
//  实时视频Demo
//
//  Created by HanJunqiang on 2017/2/16.
//  Copyright © 2017年 HaRi. All rights reserved.
//

#import <UIKit/UIKit.h>
@class IDInfo;
@interface JQAVCaptureViewController : UIViewController
/*识别完信息后的回调*/
@property(nonatomic,copy)void(^ CaptureInfo)(IDInfo * idInfo,UIImage * oriangImage,UIImage * subImage);
@end

