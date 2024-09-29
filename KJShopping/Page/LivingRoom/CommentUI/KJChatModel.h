//
//  KJChatModel.h
//  KJShopping
//
//  Created by TigerHu on 2024/9/29.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, KJChatType) {
    KJChatTypeNormal = 0,
    KJChatTypeEnter = 1,
    KJChatTypeLeave = 2,
    KJChatTypeGift = 3,
};

@interface KJChatModel : NSObject

@property (nonatomic, assign) KJChatType chatType;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *nameColor;
@property (nonatomic, copy) NSString *chatMsg;
@property (nonatomic, copy) NSString *sysMsg;

@property (nonatomic, assign) NSInteger count; // 数量
@property (nonatomic, copy) NSString *iconUrl; // 图标

@property (nonatomic, assign) BOOL isFirstTimeComing;

@end
