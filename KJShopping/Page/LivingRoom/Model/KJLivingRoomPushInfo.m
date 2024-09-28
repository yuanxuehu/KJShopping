//
//  KJLivingRoomPushInfo.m
//  KJShopping
//
//  Created by TigerHu on 2024/9/18.
//

#import "KJLivingRoomPushInfo.h"

@implementation KJGoodsInfo

@end

@implementation KJLivingRoomPushInfo

+ (NSDictionary *)modelContainerPropertyGenericClass
{
    return @{
             @"goodsList": [KJGoodsInfo class],
             };
}

@end
