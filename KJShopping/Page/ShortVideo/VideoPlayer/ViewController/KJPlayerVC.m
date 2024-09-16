//
//  KJPlayerVC.m
//  KJShopping
//
//  Created by TigerHu on 2024/9/16.
//

#import "KJPlayerVC.h"
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>

static NSString * const kPlayerItemStatusContext = @"PlayerItemStatusContext";
static NSString * const kPlayerItemLoadedTimeRangesContext = @"PlayerItemLoadedTimeRangesContext";

@interface KJPlayerVC ()

@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong) AVPlayerItem *playerItem;
@property (nonatomic, strong) AVPlayerLayer *playerLayer;

@property (nonatomic, strong) id timeObser;

@end

@implementation KJPlayerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
    self.fd_prefersNavigationBarHidden = YES;
    self.fd_interactivePopDisabled = YES;
    
    
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self playerPause];
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
    if (self.playerLayer) {
        self.playerLayer.frame = self.view.bounds;
    }
}

- (void)dealloc
{
    NSLog(@"销毁 %s",__func__);
    
    /// 移除监听
    [self playerItemRemoveObserver];
    [self.player removeTimeObserver:self.timeObser];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)playerSourceUrlSetting:(NSString *)sourceUrl {
    if (self.player) {
        [self changeVideoSoure:sourceUrl];
    } else {
        [self initializePlayerWithSourceUrl:sourceUrl];
        [self videoPlayProgress];
    }
}


// 初始化视频
- (void)initializePlayerWithSourceUrl:(NSString *)sourceUrl {
    NSURL *url = [NSURL URLWithString:sourceUrl];
    self.playerItem = [[AVPlayerItem alloc] initWithURL:url];
    // 增加监听
    [self playerItemAddObserver];
    
    self.player = [[AVPlayer alloc] initWithPlayerItem:self.playerItem];
    self.playerLayer = [[AVPlayerLayer alloc] init];
    // 设置
    self.playerLayer.player = self.player;
    self.playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
    self.playerLayer.contentsScale = [UIScreen mainScreen].scale;
    // 添加到页面
    [self.view.layer addSublayer:self.playerLayer];
    self.playerLayer.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
}

// 视频播放进度监听
- (void)videoPlayProgress {
    /*
     AVPlayer提供一个block，当播放进度改变时，则会自动调取block,
     @param interval 在正常回放期间，根据播放机当前时间的进度，调用块的间隔。
     */;
    @weakify(self);
    self.timeObser = [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1, 10) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        @strongify(self);
        BOOL isPlay;
        if ([self playerCanPlay]) {
            NSTimeInterval  current = CMTimeGetSeconds(time);
            /// 总时间
            NSTimeInterval  total = CMTimeGetSeconds(self.player.currentItem.duration);
            CGFloat progress = current * 1.0 / total;
            [self videoPlayProgress:progress];
            isPlay = NO;
        } else {
            isPlay = YES;
        }
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(videoLoading:)]) {
            [self.delegate videoLoading:isPlay];
        }
    }];
    
    /// 监听视频是否播放完成
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(videoPlayEndNoti:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
}

#pragma mark - 需要处理UI回调事件
/// 视频播放进度处理
- (void)videoPlayProgress:(CGFloat)progress {
    if ([self.delegate respondsToSelector:@selector(videoPlayProgress:)]) {
        [self.delegate videoPlayProgress:progress];
    }
}
/// 视频缓存进度处理
- (void)videoPlayCacheProgress:(CGFloat)progress {
    if ([self.delegate respondsToSelector:@selector(videoPlayCacheProgress:)]) {
        [self.delegate videoPlayCacheProgress:progress];
    }
}

/// 视频播放完毕
- (void)videoPlayEndNoti:(NSNotification *)noti {
    if ([self.delegate respondsToSelector:@selector(videoPlayEnd)]) {
        [self.delegate videoPlayEnd];
    }
}

#pragma mark - 操作视频事件
// 视频开始播放
- (void)playerPlay {
    if (!self.player) {
        return;
    }

    if (self.delegate && [self.delegate respondsToSelector:@selector(videoPlayStatusChange:)]) {
        
        [self.delegate videoPlayStatusChange:YES];
    }
    [self.player play];
}
// 视频暂停播放
- (void)playerPause {
    if (!self.player) {
        return;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(videoPlayStatusChange:)]) {
        
        [self.delegate videoPlayStatusChange:NO];
    }
    [self.player pause];
}

// 设置视频速率
- (void)playerRate:(CGFloat)rate {
    if (!self.player) {
        return;
    }
    self.player.rate = rate;
}

// 视频平铺效果设置
- (void)playerVideoGravityResize:(NSInteger)state {
    if (!self.playerLayer) {
        return;
    }
    switch (state) {
        case 0: // AVLayerVideoGravityResizeAspect ： 默认原画（不拉伸，不平铺）
            self.playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
            break;
        case 1: // AVLayerVideoGravityResizeAspectFill ： 不拉伸，平铺
            self.playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
            break;
        case 2: // AVLayerVideoGravityResize ： 拉伸平铺
            self.playerLayer.videoGravity = AVLayerVideoGravityResize;
            break;
        default:
            break;
    }
}

// 返回视频播放状态
- (BOOL)playerCanPlay {
    if (!self.playerItem) {
        return NO;
    }
    return self.playerItem.status == AVPlayerItemStatusReadyToPlay;
}

// 切换视频源
- (void)changeVideoSoure:(NSString *)sourceUrl {
    // 1、先移除监听，避免崩溃
    [self playerItemRemoveObserver];
    NSURL *url = [NSURL URLWithString:sourceUrl];
    // 2、重写playerItem
    self.playerItem = [AVPlayerItem playerItemWithURL:url];
    // 3、替换
    [self.player replaceCurrentItemWithPlayerItem:self.playerItem];
    // 4、添加监听
    [self playerItemAddObserver];
}

/// 定点播放视频
- (void)playVideoWithTime:(CGFloat)progress {
    CMTime time = CMTimeMake(CMTimeGetSeconds(self.player.currentItem.duration) * progress, 1);
    [self.player seekToTime:time completionHandler:^(BOOL finished) {
        
    }];
}

/// 获取视频时间
- (NSInteger)getVideoTime {
    if (!self.player) {
        return 0;
    }
    return CMTimeGetSeconds(self.player.currentItem.duration);
}

#pragma mark - playItem监听
/// playItem 增加监听
- (void)playerItemAddObserver {
    [self.playerItem addObserver:self
                      forKeyPath:@"status"
                         options:0
                         context:(__bridge void *)(kPlayerItemStatusContext)];
    
    // 监听当前视频的缓存程度
    [self.playerItem addObserver:self
                      forKeyPath:@"loadedTimeRanges"
                         options:0
                         context:(__bridge void *)kPlayerItemLoadedTimeRangesContext];
}


/// playerItem 移除监听
- (void)playerItemRemoveObserver {
    [self.playerItem removeObserver:self
                         forKeyPath:@"status"
                            context:(__bridge void *)(kPlayerItemStatusContext)];
    
    [self.playerItem removeObserver:self
                         forKeyPath:@"loadedTimeRanges"
                            context:(__bridge void *)(kPlayerItemLoadedTimeRangesContext)];
}

//监听回调
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    AVPlayerItem *item = (AVPlayerItem *)object;
    if (context == (__bridge void *)(kPlayerItemStatusContext)) {
        NSLog(@"item.status  -> %zd",item.status);
    }
    
    if (context == (__bridge void *)kPlayerItemLoadedTimeRangesContext) {
        NSArray *loadedTimeRanges = [item loadedTimeRanges];
        CMTimeRange timeRange = [loadedTimeRanges.firstObject CMTimeRangeValue];// 获取缓冲区域
        NSTimeInterval loadedTime = CMTimeGetSeconds(timeRange.start) + CMTimeGetSeconds(timeRange.duration);
        NSTimeInterval total = CMTimeGetSeconds(self.player.currentItem.duration);
        CGFloat progress = loadedTime * 1.0 / total;
        [self videoPlayCacheProgress:progress];
    }
}

@end
