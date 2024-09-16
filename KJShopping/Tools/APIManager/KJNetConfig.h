//
//  KJNetConfig.h
//  KJShopping
//
//  Created by TigerHu on 2024/4/22.
//

#import <Foundation/Foundation.h>

// ------------------  环境值key ----------------------------
FOUNDATION_EXTERN NSString *const kNetEnv_Http;
FOUNDATION_EXTERN NSString *const kNetEnv_newHttp;
FOUNDATION_EXTERN NSString *const kNetEnv_WXOpen_Http;
FOUNDATION_EXTERN NSString *const kNetEnv_VerifyCode_Http;

FOUNDATION_EXTERN NSString *const kNetEnv_AppId;
FOUNDATION_EXTERN NSString *const kNetEnv_AppSecret;
FOUNDATION_EXTERN NSString *const kNetEnv_ApiType;
FOUNDATION_EXTERN NSString *const kNetEnv_Soure;

typedef enum : NSUInteger {
    KJ_NET_ENV_RELEASE = 0,     // 正式环境
    KJ_NET_ENV_DEBUG = 1,     // 测试环境 - release (wiki这么称呼)
} KJ_NET_ENV;

@interface KJNetConfig : NSObject

/**
 *  网络环境
 */
@property (nonatomic, assign) KJ_NET_ENV envMode;

+ (instancetype)sharedInstance;

/// 根据key获取对应的环境中的某个配置
- (NSString *)envValueWithKey:(NSString *)key;

@end
