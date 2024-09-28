//
//  KJAudienceRoomVC.h
//  KJShopping
//
//  Created by TigerHu on 2024/9/18.
//

#import "KJVC.h"

@class KJLiveRoomPlayInfo;

typedef void(^KJAudienceRoomBlock)(void);

@interface KJAudienceRoomVC : KJVC

// 视频画面
@property (nonatomic, strong) UIView *videoParentView;
@property (nonatomic, assign) NSInteger liveNumber; // 当前直播间数量
@property (nonatomic, copy) KJAudienceRoomBlock block;

//多直播间专用
@property (nonatomic, assign) BOOL isFromMultiLiveRoom;

- (void)multiLiveRoomPlayInfoSetting:(KJLiveRoomPlayInfo *)liveRoomPlayInfo WithInView:(UIView *)inView withKJAudienceRoomVC:(KJAudienceRoomVC *)audienceRoomVC;

- (void)multiLiveRoomWithStopLastRoom;

- (void)multiLiveRoomHideKeyboard;

@end
