//
//  KJRoom.h
//  KJShopping
//
//  Created by TigerHu on 2024/9/29.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(int, KJRoomRole) {
    KJRoomRoleCreator = 0,//房主
    KJRoomRoleMember  = 1 //观众
};

@class KJLivingRoomPushInfo, KJLivingRoomPlayInfo;

@interface KJRoom : NSObject

// 主播端直播间详情
@property (nonatomic, strong) KJLivingRoomPushInfo *roomPushInfo;
// 观众端直播间详情
@property (nonatomic, strong) KJLivingRoomPlayInfo *roomPlayInfo;


#pragma mark - 基础函数
+ (instancetype)sharedInstance;

/**
 * 进入房间（观众调用）
 *
 * 观众观看直播的正常调用流程是：
 * 1.【观众】调用 getRoomList() 刷新最新的直播房间列表，并通过 completion 回调拿到房间列表。
 * 2.【观众】选择一个直播间以后，调用 enterRoom() 进入该房间。
 *
 * @param roomId 直播间Id
 * @param view 承载视频画面的控件
 * @param completion 进入房间的结果回调
 *
 */
- (void)enterRoomWithView:(NSString *)roomId
                   inView:(UIView *)view
               completion:(void(^)(NSInteger errCode, NSString *errMsg))completion;




@end
