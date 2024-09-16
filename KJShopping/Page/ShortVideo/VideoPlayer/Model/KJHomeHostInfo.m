//
//  KJHomeHostInfo.m
//  KJShopping
//
//  Created by TigerHu on 2024/9/16.
//

#import "KJHomeHostInfo.h"

@implementation KJHomeHostInfo

- (instancetype)initWithDict:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        
        NSDictionary *dicts = [KJCommonlyMethods changeType:dict];
        [self setModelForDict:dicts];
    }
    return self;
}

- (void)setModelForDict:(NSDictionary *)dict
{
    if (dict.allKeys.count == 0) {
        return;
    }
    
    self.roomId = [dict safeStringForKey:@"roomId"];
    self.anchorImg = [dict safeStringForKey:@"anchorImg"];
    self.anchorName = [dict safeStringForKey:@"anchorName"];
    self.noticeTitle = [dict safeStringForKey:@"noticeTitle"];
}

@end
