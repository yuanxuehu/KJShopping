//
//  KJAPIManager.h
//  KJShopping
//
//  Created by TigerHu on 2024/4/22.
//

#import <Foundation/Foundation.h>

#define KJAPIManagerShared [KJAPIManager shardManager]

@interface KJAPIManager : NSObject

// 初始化
+ (instancetype)shardManager;

typedef void(^progressBlock)(NSProgress * uploadProgress);


/**
 用户手机号获取短信验证码前的鉴权信息接口

 @param urlString 请求路径
 @param requestData requset body
 @param headerData headerData
 @return 请求信号
 */
- (RACSignal *)requestTenApiAuthDataWithUrl:(NSString *)urlString requestData:(NSDictionary *)requestData headerData:(NSDictionary *)headerData;

/**
 post 请求

 @param method api
 @param requestData requset body
 @return 请求信号
 */
- (RACSignal *)postDataWithMethod:(NSString *)method requestData:(NSDictionary *)requestData;
- (RACSignal *)postDataWithOtherHostMethod:(NSString *)method requestData:(NSDictionary *)requestData;


/**
 post 请求
 
 @param method api
 @param requestData requset body
 @param businessProcessError 是否业务处理错误提示
 @return 请求信号
 */
- (RACSignal *)postDataWithMethod:(NSString *)method requestData:(NSDictionary *)requestData businessProcessError:(BOOL)businessProcessError;

/**
 post 请求
 
 @param method api
 @param requestData requset body
 @param businessProcessError 是否业务处理错误提示
 @param normalContentType 请求type是否为json，yes为json
 @return 请求信号
 */
- (RACSignal *)postDataWithMethod:(NSString *)method requestData:(NSDictionary *)requestData businessProcessError:(BOOL)businessProcessError normalContentType:(BOOL)normalContentType;

/**
 get 请求
 
 @param method api
 @param requestData requset body
 @return 请求信号
 */
- (RACSignal *)getDataWithMethod:(NSString *)method requestData:(NSDictionary *)requestData;
- (RACSignal *)getDataWithOtherHostMethod:(NSString *)method requestData:(NSDictionary *)requestData;


/**
 get 请求
 
 @param method api
 @param requestData requset body
 @param businessProcessError 是否业务处理错误提示
 @return 请求信号
 */
- (RACSignal *)getDataWithMethod:(NSString *)method requestData:(NSDictionary *)requestData businessProcessError:(BOOL)businessProcessError;

/**
post 请求 上传文件

@param method api
@param requestData requset body
@param dataType 文件类型（0：图片； 1：视频）
@param businessProcessError 是否业务处理错误提示
@return 请求信号
*/
- (RACSignal *)uploadImgVideoMethod:(NSString *)method requestData:(NSData *)requestData dataType:(NSInteger)dataType businessProcessError:(BOOL)businessProcessError;

/**
post 请求 上传文件

@param method api
@param requestData requset body
@param parameters 附带参数
@param dataType 文件类型（0：图片； 1：视频）
@param businessProcessError 是否业务处理错误提示
@return 请求信号
*/
- (RACSignal *)uploadImgVideoWidthBodyMethod:(NSString *)method requestData:(NSData *)requestData parameters:(NSDictionary *)parameters dataType:(NSInteger)dataType businessProcessError:(BOOL)businessProcessError;


- (RACSignal *)uploadImgVideoWidthProgressMethod:(NSString *)method requestData:(NSData *)requestData parameters:(NSDictionary *)parameters dataType:(NSInteger)dataType progress:(progressBlock)uploadProgress businessProcessError:(BOOL)businessProcessError;

/**
 * 批量上传图片
 */
- (RACSignal *)uploadImageWidthArrayMethod:(NSString *)method requestData:(NSArray <NSData *>*)dataArray parameters:(NSDictionary *)parameters businessProcessError:(BOOL)businessProcessError;

@end
