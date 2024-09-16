//
//  CPCNWeixinPay.h
//  CPCNWeixinPaySDK
//
//  Created by zj_baiyijing on 2019/12/3.
//  Copyright © 2019 cpcn. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CPCNWeixinPay : NSObject
/**
 单例方法

 @return 返回一个单例对象
 */
+ (CPCNWeixinPay *)shared;

/**
 调微信支付

 @param authCode 授权码
 @param completion 调用结果回调block
 */
- (void)wxPayWithAuthCode:(NSString *)authCode completion:(void (^ __nullable)(BOOL success))completion;
@end

NS_ASSUME_NONNULL_END
