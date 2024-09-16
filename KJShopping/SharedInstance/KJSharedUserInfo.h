//
//  KJSharedUserInfo.h
//  KJShopping
//
//  Created by TigerHu on 2024/4/22.
//

#import <Foundation/Foundation.h>

@interface KJSharedUserInfo : NSObject

/**
 登录状态
 */
@property (nonatomic, assign, readonly) BOOL isLogined;

/**
 授权票据
 */
@property (nonatomic, strong) NSString *accessToken;
@property (nonatomic, assign) NSString *accessTokenUtcExpiresString;
@property (nonatomic, strong) NSString *refreshToken;

/**
 im信息
 */
@property (nonatomic, strong) NSString *imAppID;
@property (nonatomic, strong) NSString *imUserSig;
@property (nonatomic, strong) NSString *imUserId;


// userID
@property (nonatomic, strong) NSString *userId;

// 刷新token
@property (nonatomic, strong) RACCommand *refreshTokenCommand;



+ (instancetype)sharedInstance;

@end
