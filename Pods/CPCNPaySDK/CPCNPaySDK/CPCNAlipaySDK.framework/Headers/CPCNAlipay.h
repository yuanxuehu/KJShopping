//
//  CPCNAlipay.h
//  CPCNAlipaySDK
//
//  Created by zj_baiyijing on 2019/12/3.
//  Copyright © 2019 cpcn. All rights reserved.
//

#import <Foundation/Foundation.h>


NS_ASSUME_NONNULL_BEGIN

@interface CPCNAlipay : NSObject


/**
 单例方法

 @return 返回一个单例对象
 */
+ (CPCNAlipay *)shared;


/**
 调支付宝支付

 @param authCode 授权码
 @param schemeStr Info中配置的url scheme
 @param completionBlock 支付结果回调Block，用于wap支付结果回调
 跳转支付宝支付时只有当processOrderWithPaymentResult接口的completionBlock为nil时会使用这个block
 @return 调用成功或失败
 */
- (BOOL)aliPayWithAuthCode:(NSString *)authCode
                fromScheme:(NSString *)schemeStr
               wapcallback:(void (^ __nullable)(NSDictionary *resultDict))completionBlock;


@end

NS_ASSUME_NONNULL_END
