//
//  KJShortVideoPlayerCoverVC.h
//  KJShopping
//
//  Created by TigerHu on 2024/9/16.
//

#import "KJVC.h"

@class KJVideoInfo;
@class KJVideoAnchorInfo;

@protocol KJPlayerCoverDelegate <NSObject>
// 视频播放进度
- (void)videoProgressSetting:(CGFloat)progress;
// 视频播放状态改变
- (void)videoPlayStateChange:(BOOL)playing;
// 视频评论事件
- (void)videoCommentsButtonClick:(NSString *)videoId commentsNum:(NSInteger)num;

@end

//短视频CoverVC，主要负责短视频控制面板事件处理
@interface KJShortVideoPlayerCoverVC : KJVC

@property (nonatomic, weak) id <KJPlayerCoverDelegate> delegate;

@property (nonatomic, assign) NSInteger isHome;
@property (nonatomic, assign) NSInteger isLoading;

@property (nonatomic, strong) KJVideoAnchorInfo *anchorInfo;
@property (nonatomic, strong) KJVideoInfo *videoinfo;
@property (nonatomic, copy) NSArray *goodsList;

@property (nonatomic, copy) void (^changeFocusBlock)(BOOL isFocus);
@property (nonatomic, copy) void (^likeVideo)(BOOL isLike);

//关闭点赞的交互
@property (nonatomic, assign) NSInteger isClose;
@property (nonatomic, assign) NSInteger IsFollow;

@property (nonatomic, assign) BOOL hiddenPlayImage;
//小店进入
@property (nonatomic, assign) BOOL isStore;
@property (nonatomic, assign) BOOL isShow;
@property (nonatomic, copy) void (^closeOrOpenBar)(NSInteger close);


// 初始化状态
- (void)videoDataSetting:(KJVideoInfo *)videoinfo;

// 更新播放进度
- (void)changeVideoProgress:(CGFloat)progress totalTime:(NSInteger)totalTime;
// 播放结束，显示重新播放状态
- (void)changeVideoState;
// 播放状态改变处理
- (void)videoPlayStateSetting:(BOOL)playing;

//设置评论数
- (void)changeCommentsNum:(NSInteger)num;

@end
