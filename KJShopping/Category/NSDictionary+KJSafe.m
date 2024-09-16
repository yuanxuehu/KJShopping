//
//  NSDictionary+KJSafe.m
//  KJShopping
//
//  Created by TigerHu on 2024/4/22.
//

#import "NSDictionary+KJSafe.h"

@implementation NSDictionary (KJSafe)

- (NSString *)getStringValueForKey:(NSString *)key defaultValue:(NSString *)defaultValue
{
    return [self objectForKey:key] == nil || [self objectForKey:key] == [NSNull null] ? defaultValue : [NSString stringWithFormat:@"%@", [self objectForKey:key]];
}

- (NSString *)safeStringForKey:(NSString *)key
{
    return [self getStringValueForKey:key defaultValue:@""];
}


- (NSArray *)safeArrayForKey:(NSString *)key
{
    if (key == nil || [key isEqualToString:@""]) {
    }
    id data = [self objectForKey:key];
    if ([data isKindOfClass:[NSArray class]]) {
        return data;
    } else {
        return @[];
    }
}

- (NSDictionary *)safeDictionaryForKey:(NSString *)key
{
    id data = [self objectForKey:key];
    if ([data isKindOfClass:[NSDictionary class]]) {
        return data;
    } else {
        return @{};
    }
}

@end
