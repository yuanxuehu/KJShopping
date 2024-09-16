//
//  KJShortVideoPlayerCoverVC.m
//  KJShopping
//
//  Created by TigerHu on 2024/9/16.
//

#import "KJShortVideoPlayerCoverVC.h"

@interface KJShortVideoPlayerCoverVC ()

@property (assign, nonatomic) BOOL isPlaying;
@property (assign, nonatomic) NSInteger totalTime;


@end

@implementation KJShortVideoPlayerCoverVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

#pragma mark - 外部调用
// 设置视频数据
- (void)videoDataSetting:(KJVideoInfo *)videoinfo {
    self.videoinfo = videoinfo;
    
    [self videoPlayStateSetting:YES];
    
//    self.videoNameLabel.text = self.videoinfo.shortVidelDetail;
    
//    @weakify(self);
//    [RACObserve(videoinfo, shortVideoThumbsUpCount) subscribeNext:^(id x) {
//        @strongify(self);
//        self.likeNum = [x integerValue];
//        if ([x integerValue] == 0) {
//
//            self.likeNumLabel.text = @"点赞";
//        }else {
//
//            self.likeNumLabel.text = [NSString stringWithFormat:@"%@", x];
//        }
//    }];
//
//    [RACObserve(videoinfo, shortVideoShareCount) subscribeNext:^(id x) {
//        @strongify(self);
//        if ([x integerValue] == 0) {
//
//            self.shareNumLabel.text = @"分享";
//        }else {
//
//            self.shareNumLabel.text = [NSString stringWithFormat:@"%@",x];
//        }
//    }];
//
//    [RACObserve(videoinfo, shortVideoCommentCount) subscribeNext:^(id x) {
//        @strongify(self);
//        if ([x integerValue] == 0) {
//
//            self.commentsLabel.text = @"评论";
//        }else {
//
//            self.commentsLabel.text = [NSString stringWithFormat:@"%@",x];
//        }
//    }];
}

// 播放进度条更新
- (void)changeVideoProgress:(CGFloat)progress totalTime:(NSInteger)totalTime {
    self.totalTime = totalTime;
    
    if (self.totalTime < 30) {
//        self.progressSlider.hidden = YES;
        return;
    }
    
    /*
    self.progressSlider.hidden = NO;
    NSInteger currentTime = totalTime * progress;
    NSString *totalTimeString = [self formatWithTime:totalTime];
    NSString *currentTimeString = [self formatWithTime:currentTime];
    self.totalTimeLabel.text = totalTimeString;
    if (self.progressSlider.highlighted) {
        return;
    }
    self.progressSlider.value = progress;
    self.currentTimeLabel.text = currentTimeString;
     */
}


#pragma mark - 私有方法
// 播放状态改变处理
- (void)videoPlayStateSetting:(BOOL)playing {
    self.isPlaying = playing;
    
    if (self.isPlaying) {
        self.hiddenPlayImage = YES;
    }
}


@end
