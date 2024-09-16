//
//  KJHomeHostInfo.h
//  KJShopping
//
//  Created by TigerHu on 2024/9/16.
//

#import <Foundation/Foundation.h>

@interface KJHomeHostInfo : NSObject

/** 房间号*/
@property (nonatomic, copy) NSString *roomId;
/** 主播名称*/
@property (nonatomic, copy) NSString *anchorName;
/** 主播头像*/
@property (nonatomic, copy) NSString *anchorImg;
/** 直播名称*/
@property (nonatomic, copy) NSString *noticeTitle;

- (instancetype)initWithDict:(NSDictionary *)dict;

@end
