//
//  KJUtils.m
//  KJShopping
//
//  Created by TigerHu on 2024/9/16.
//

#import "KJUtils.h"

@implementation KJUtils

#pragma mark 手机号空格处理
+ (NSString *)dealWithMobileNumber:(NSString *)str
{
    NSString *mobileNumber = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (mobileNumber.length > 11) {
        mobileNumber = [mobileNumber substringToIndex:11];
    }
    if (mobileNumber.length > 3) {
        NSString *str1 = [mobileNumber substringToIndex:3];
        NSString *str2 = [mobileNumber substringFromIndex:3];
        int size = (int)str2.length / 4;
        NSMutableArray *arr = [[NSMutableArray alloc] initWithCapacity:0];
        for (int i = 0; i < size; i++) {
            [arr addObject:[str2 substringWithRange:NSMakeRange(i * 4, 4)]];
        }
        if (str2.length > size * 4) {
            [arr addObject:[str2 substringWithRange:NSMakeRange(size * 4, str2.length % 4)]];
        }
        str2 = [arr componentsJoinedByString:@" "];
        return [NSString stringWithFormat:@"%@ %@", [str1 substringToIndex:3], str2];
    } else {
        int size = (int)mobileNumber.length / 3;
        NSMutableArray *arr = [[NSMutableArray alloc] initWithCapacity:0];
        for (int i = 0; i < size; i++) {
            [arr addObject:[mobileNumber substringWithRange:NSMakeRange(i * 3, 3)]];
        }
        if (mobileNumber.length > size * 3) {
            [arr addObject:[mobileNumber substringWithRange:NSMakeRange(size * 3, mobileNumber.length % 3)]];
        }
        mobileNumber = [arr componentsJoinedByString:@" "];
        return mobileNumber;
    }
}

+ (NSString *)nullToString:(id)string
{
    if ([string isEqual:@"NULL"] || [string isKindOfClass:[NSNull class]] || [string isEqual:[NSNull null]] || [string isEqual:NULL] || [[string class] isSubclassOfClass:[NSNull class]] || string == nil || string == NULL || [string isKindOfClass:[NSNull class]] || [[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]==0 || [string isEqualToString:@"<null>"] || [string isEqualToString:@"(null)"]) {
        return @"";
    } else {
        return (NSString *)string;
    }
}

+ (NSString *)imageToString:(UIImage *)image
{
    NSData *imagedata = UIImagePNGRepresentation(image);
    NSString *image64 = [imagedata base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    
    return image64;
}

+ (NSString *)convertSubToYuan:(NSInteger)sub {
    if (sub == 0) {
        return @"0";
    }
    
    if (sub < 10) {
        return [NSString stringWithFormat:@"0.0%ld", sub];
    }
    
    if (sub < 100) {
        return [NSString stringWithFormat:@"0.%ld", sub];
    }
    
    NSMutableString *subString = [NSMutableString stringWithFormat:@"%ld", sub];
    [subString insertString:@"." atIndex:subString.length - 2];
    return [KJCommonlyMethods removeSuffix:(NSString *)subString];
}

+ (NSString *)convertToJsonData:(NSDictionary *)dict
{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];

    NSString *jsonString;

    if (!jsonData) {
        NSLog(@"%@",error);
    } else {
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    }

    NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];
    NSRange range = {0,jsonString.length};
    
    //去掉字符串中的空格
    [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];
    NSRange range2 = {0,mutStr.length};

    //去掉字符串中的换行符
    [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];

    return mutStr;
}

+ (UILabel *)createLabel:(NSString *)text textColor:(UIColor *)color Font:(UIFont *)font
{
    UILabel *label = [[UILabel alloc] init];
    label.text = text;
    label.textColor = color;
    label.font = font;
    
    return label;
}

@end
