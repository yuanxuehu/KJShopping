//
//  KJPlayerVC.h
//  KJShopping
//
//  Created by TigerHu on 2024/9/16.
//

#import "KJVC.h"

@protocol KJPlayerDelegate <NSObject>
// 视频播放进度
- (void)videoPlayProgress:(CGFloat)progress;
// 视频缓存进度
- (void)videoPlayCacheProgress:(CGFloat)cacheProgress;
// 视频播放结束
- (void)videoPlayEnd;
//视频播放状态改变
- (void)videoPlayStatusChange:(BOOL)isPlay;
//缓冲中
- (void)videoLoading:(BOOL)isLoading;

@end

//视频播放器VC，主要负责视频播放基础业务，基于AVPlayer
@interface KJPlayerVC : KJVC

@property (nonatomic, weak) id<KJPlayerDelegate> delegate;

// 初始化视频
- (void)playerSourceUrlSetting:(NSString *)sourceUrl;

// 视频开始播放
- (void)playerPlay;
// 视频暂停播放
- (void)playerPause;

// 设置视频速率
- (void)playerRate:(CGFloat)rate;

// 视频平铺效果设置
- (void)playerVideoGravityResize:(NSInteger)state;

// 返回视频播放状态
- (BOOL)playerCanPlay;

/// 定点播放视频
- (void)playVideoWithTime:(CGFloat)progress;

/// 获取视频时间
- (NSInteger)getVideoTime;

@end
