//
//  HttpTool.h
//  05-二次封装AFN
//
//  Created by 大欢 on 16/8/4.
//  Copyright © 2016年 大欢. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void (^HttpSuccessBlock)(id json);
typedef void (^HttpFailureBlock)(NSError * error);
typedef void (^HttpDownloadProgressBlock)(CGFloat progress);
typedef void (^HttpUploadProgressBlock)(CGFloat progress);

typedef void (^failureBlocks)(NSError *error);

@interface HttpTool : NSObject

/**
 *
 *  JSON方式获取数据
 *
 */
+ (void)PostJSONDataWithUrl:(NSString *)url Params:(NSDictionary*)params success:(void (^)(id json))success fail:(void (^)())fail;


/*没有弹框提示*/
+ (void)PostWithPath:(NSString *)path
              params:(NSDictionary *)dict
             success:(HttpSuccessBlock)success
             failure:(HttpFailureBlock)failure;

/**
 *  get网络请求
 *
 *  @param path    url地址
 *  @param params  url参数  NSDictionary类型
 *  @param success 请求成功 返回NSDictionary或NSArray
 *  @param failure 请求失败 返回NSError
 */

+ (void)getWithPath:(NSString *)path
             params:(NSDictionary *)params
            success:(HttpSuccessBlock)success
            failure:(HttpFailureBlock)failure;

/**
 *  post网络请求
 *
 *  @param path    url地址
 *  @param params  url参数  NSDictionary类型
 *  @param success 请求成功 返回NSDictionary或NSArray
 *  @param failure 请求失败 返回NSError
 */

+ (void)postWithPath:(NSString *)path
              params:(NSDictionary *)params
             success:(HttpSuccessBlock)success
             failure:(HttpFailureBlock)failure;

/**
 *  下载文件
 *
 *  @param path     url路径
 *  @param success  下载成功
 *  @param failure  下载失败
 *  @param progress 下载进度
 */

+ (void)downloadWithPath:(NSString *)path
                 success:(HttpSuccessBlock)success
                 failure:(HttpFailureBlock)failure
                progress:(HttpDownloadProgressBlock)progress;

/**
 *  上传图片
 *
 *  @param path     url地址
 *  @param image    UIImage对象
 *  @param imagekey    imagekey
 *  @param params  上传参数
 *  @param success  上传成功
 *  @param failure  上传失败
 *  @param progress 上传进度
 */

+ (void)uploadImageWithPath:(NSString *)path
                     params:(NSDictionary *)params
                  thumbName:(NSString *)imagekey
                      image:(UIImage *)image
                    success:(HttpSuccessBlock)success
                    failure:(HttpFailureBlock)failure
                   progress:(HttpUploadProgressBlock)progress;


//人脸识别接口
+ (void)postWithUrl:(NSString *)url
             params:(NSDictionary *)params
          imageData:(NSData *)imageData
           nodImage:(UIImage *)image
       imageNameArr:(NSArray *)imageNameArr
            success:(void (^)(id responseObject))success
            failure:(void (^)(NSError *error))failure;

/***多图片上传***/
+(void)uploadImageArrWithPath:(NSString *)path
                       params:(NSDictionary *)params
                    thumbName:(NSArray *)imagekeys
                        image:(NSArray*)images
                      success:(HttpSuccessBlock)success
                      failure:(HttpFailureBlock)failure
                     progress:(HttpUploadProgressBlock)progress;


@end
