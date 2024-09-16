//
//  KJShowMessage.h
//  KJShopping
//
//  Created by TigerHu on 2024/4/22.
//

#import <Foundation/Foundation.h>

@interface KJShowMessage : NSObject

/**
 *单例
 */
+ (instancetype)sharedInstance;

/**
 *  toast提示方式
 *
 *  @param message 提示内容
 *  @return 返回是否有展示信息
 */
+ (BOOL)showMessage:(NSString *)message;
/**
 *  toast提示方式
 *
 *  @param message 提示内容
 *  @param completion 完成回调
 */
+ (void)showMessage:(NSString *)message completion:(void (^)(BOOL didTap))completion;

/**
 *  alerview方式的提示
 *
 *  @param message           消息内容
 *  @param title             标题内容
 *  @param cancelButtonTitle 取消按钮内容
 */
+ (void)showAlertMessage:(NSString *)message title:(NSString *)title cancelButtonTitle:(NSString *)cancelButtonTitle;

/**
 *  全屏黑色message
 *
 *  @param message 消息内容
 *  @param title   标题内容
 */
- (void)showBlackMessage:(id)message title:(NSString *)title;

- (void)showBlackMessage:(id)message title:(NSString *)title completion:(void (^)(void))completion;

/**
 * 动画message
 */
+ (BOOL)showAnimationMessage:(NSString *)message parentView:(UIView *)parentView;

@end
