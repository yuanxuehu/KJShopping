//
//  KJNetConfig.m
//  KJShopping
//
//  Created by TigerHu on 2024/4/22.
//

#import "KJNetConfig.h"

NSString *const kNetEnv_Http = @"kNetEnv_Http";
NSString *const kNetEnv_newHttp = @"kNetEnv_newHttp";
NSString *const kNetEnv_WXOpen_Http = @"kNetEnv_WXOpen_Http";
NSString *const kNetEnv_VerifyCode_Http = @"kNetEnv_VerifyCode_Http";

NSString *const kNetEnv_AppId = @"kNetEnv_AppId";
NSString *const kNetEnv_AppSecret = @"kNetEnv_AppSecret";
NSString *const kNetEnv_ApiType = @"kNetEnv_ApiType";
NSString *const kNetEnv_Soure = @"kNetEnv_Soure";

@implementation KJNetConfig

+ (instancetype)sharedInstance
{
    static KJNetConfig *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[KJNetConfig alloc] init];
    });
    return sharedInstance;
}


#pragma mark - 配置获取
- (NSString *)envValueWithKey:(NSString *)key
{
    NSDictionary *env = [[self netEnvMaps] objectForKey:@(self.envMode)];
    return [env safeStringForKey:key];
}

- (NSDictionary *)netEnvMaps
{
    static NSDictionary *_map = nil;
    
    if (_map) {
        return _map;
    }
    
    //提交前需删除
    
    _map =
    @{
      @(KJ_NET_ENV_DEBUG) : @{
              kNetEnv_newHttp : @"https://index.xinhaokuai.cn",
              kNetEnv_Http : @"https://api.xinhaokuai.cn",
              kNetEnv_WXOpen_Http : @"http://wxopen.teamax-cn.cn/api/User/TenApiAuth",
              kNetEnv_VerifyCode_Http : @"http://service-jj54exnq-1251048739.ap-guangzhou.apigateway.myqcloud.com/release/zbsendverify",
              kNetEnv_AppId : @"tm000001",
              kNetEnv_AppSecret : @"Tm@w0,1,*Apphdn@7r48u6g4b1v0f6y4",
              kNetEnv_ApiType : @"zhiBo",
              kNetEnv_Soure : @"ZbApp",
              },
      @(KJ_NET_ENV_RELEASE) : @{
              kNetEnv_newHttp : @"https://index.xinhaokuai.cn",
              kNetEnv_Http : @"https://api.xinhaokuai.cn",
              kNetEnv_WXOpen_Http : @"http://wxopen.teamax-cn.cn/api/User/TenApiAuth",
              kNetEnv_VerifyCode_Http : @"http://service-jj54exnq-1251048739.ap-guangzhou.apigateway.myqcloud.com/release/zbsendverify",
              kNetEnv_AppId : @"tm000001",
              kNetEnv_AppSecret : @"Tm@w0,1,*Apphdn@7r48u6g4b1v0f6y4",
              kNetEnv_ApiType : @"zhiBo",
              kNetEnv_Soure : @"ZbApp",
              },
      };
    
    return _map;
}

@end
