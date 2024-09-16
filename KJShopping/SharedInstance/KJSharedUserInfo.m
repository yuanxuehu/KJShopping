//
//  KJSharedUserInfo.m
//  KJShopping
//
//  Created by TigerHu on 2024/4/22.
//

#import "KJSharedUserInfo.h"

@implementation KJSharedUserInfo

+ (instancetype)sharedInstance
{
    static KJSharedUserInfo *sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[KJSharedUserInfo alloc] init];
        [sharedInstance initialize];
    });
    return sharedInstance;
}

- (void)initialize
{
    RAC(self, isLogined) =
    [[RACObserve(self, accessToken) map:^id(NSString *accessToken) {
        if (IsNotNilAndEmpty(accessToken)) {
            return @YES;
        } else {
            return @NO;
        }
    }] distinctUntilChanged];
}




- (RACCommand *)refreshTokenCommand {
    if (!_refreshTokenCommand) {
        @weakify(self);
        _refreshTokenCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSDictionary *value) {
            @strongify(self);
            return [[[KJAPIManagerShared postDataWithMethod:@"api/userapi/refreshtoken" requestData:@{@"appId": [[KJNetConfig sharedInstance] envValueWithKey:kNetEnv_AppId], @"appSecret": [[KJNetConfig sharedInstance] envValueWithKey:kNetEnv_AppSecret], @"refreshToken": self.refreshToken ?: @"" }] doNext:^(id x) {
                @strongify(self);
                self.accessToken = [value safeStringForKey:@"accessToken"];
                self.refreshToken = [value safeStringForKey:@"refreshToken"];
                NSInteger expires = [[value safeStringForKey:@"accessTokenUtcExpires"] integerValue] / 1000;
                if (expires > 0) {
                    NSDate *expiresInDate = [NSDate dateWithTimeIntervalSince1970:expires];
//                    self.accessTokenUtcExpiresString = [TMDateHelper stringFromDate:expiresInDate format:@"yyyy-MM-dd HH:mm:ss"];
                }
                
                // 固态化数据
//                if (IsNotNilAndEmpty(self.accessToken)) {
//                    self.keyChainStore[kKeyChainStoreAccessToken] = self.accessToken;
//                }
//                if (IsNotNilAndEmpty(self.refreshToken)) {
//                    self.keyChainStore[kKeyChainStoreRefreshToken] = self.refreshToken;
//                }
//                if (IsNotNilAndEmpty(self.accessTokenUtcExpiresString)) {
//                    self.keyChainStore[kKeyChainStoreExpires] = self.accessTokenUtcExpiresString;
//                }
            }] doError:^(NSError *error) {
                @strongify(self);
//                [self loginOut];
            }];
        }];
    }
    return _refreshTokenCommand;
}

@end
