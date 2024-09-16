//
//  KJUtils.h
//  KJShopping
//
//  Created by TigerHu on 2024/9/16.
//

#import <Foundation/Foundation.h>

@interface KJUtils : NSObject

/**
 *  手机号插入空格
 *
 *  @param str 输入example：13811112222
 *
 *  @return 输出example：138 1111 2222
 */

+ (NSString *)dealWithMobileNumber:(NSString *)str;

/// 处理null字符串
/// @param string 异常返回空
+ (NSString *)nullToString:(id)string;

/// image转base64字符串
/// @param image base64字符串
+ (NSString *)imageToString:(UIImage *)image;

/// 分转换位元
/// sub 分
+ (NSString *)convertSubToYuan:(NSInteger)sub;

/// 字段转json字符串
/// @param dict 字典
+ (NSString *)convertToJsonData:(NSDictionary *)dict;

/// 创建label方法
/// @param text 文案
/// @param color 颜色
/// @param font 字体大小
+ (UILabel *)createLabel:(NSString *)text textColor:(UIColor *)color Font:(UIFont *)font;

@end
