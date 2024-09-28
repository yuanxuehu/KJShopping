//
//  KJShortVideoPlayerVC.m
//  KJShopping
//
//  Created by TigerHu on 2024/9/16.
//

#import "KJShortVideoPlayerVC.h"
#import "KJPlayerVC.h"
#import "KJShortVideoPlayerCoverVC.h"
#import "KJHomeVC.h"

#import "KJHomeHostModelView.h"
#import "KJVideoView.h"
#import "KJLiveNumView.h"
#import "KJHostListView.h"

#import "KJHomeHostInfo.h"
#import "KJVideoInfo.h"
#import "KJVideoAnchorInfo.h"


#define kVideoViewTag 1000

@interface KJShortVideoPlayerVC () <KJPlayerDelegate, KJPlayerCoverDelegate, UIScrollViewDelegate>
{
    CGFloat beginDraggingOffset;
    CGFloat endDraggingOffset;
}

//@property (nonatomic, strong) TencentLBSLocationManager *locationManager;

@property (nonatomic, strong) UIScrollView *scrollView;
//视频信息
@property (nonatomic, strong) NSMutableArray *videoArray;
//视频发布者信息
@property (nonatomic, strong) NSMutableArray *anchorArray;
//已缓存发布者信息的视频ID集合
@property (nonatomic, strong) NSMutableArray *anchorVideoIDArray;
//视频商品信息
@property (nonatomic, strong) NSMutableArray *spuArray;
//已缓存商品的视频ID集合
@property (nonatomic, strong) NSMutableArray *spuVideoIDArray;
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, strong) KJVideoView *currentVideoView;

@property (nonatomic, strong) KJLiveNumView *numView;
@property (nonatomic, strong) KJHostListView *listView;

@property (nonatomic, strong) UIView *alphaBackView;

//@property (nonatomic, strong) TMFocusPromptView *promptView;

@property (nonatomic, strong) NSTimer *timer;

//@property (nonatomic, strong) TMVideoCommentsView *commentsView;


//已经浏览过的视频id数组
@property (nonatomic, strong) NSMutableArray *haveBeenIdArray;

@property (nonatomic, copy) NSString *userId;

//@property (nonatomic, strong) TencentLBSPoi *currentPoi;

//播放进度
@property (nonatomic, assign) CGFloat playProgress;
//是否全部播完
@property (nonatomic, assign) BOOL playComplete;

@property (nonatomic, assign) NSInteger currentPage;

@property (nonatomic, assign) NSInteger sliderType;

@end

@implementation KJShortVideoPlayerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.fd_prefersNavigationBarHidden = YES;
    [self addScrollView];
    self.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    
    if (!self.isHome) {
        [self addBackButton];
    }
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = NavBlackColor;
  
    //模拟假数据
    KJVideoInfo *videoInfo1 = [[KJVideoInfo alloc] init];
    videoInfo1.shortVideoId = @"111";
    videoInfo1.anchorId = @"111";
    videoInfo1.shortVideoUrl = @"https://vd2.bdstatic.com/mda-mki7h67gag5wcev9/720p/h264/1637299107495714243/mda-mki7h67gag5wcev9.mp4";
    
    KJVideoInfo *videoInfo2 = [[KJVideoInfo alloc] init];
    videoInfo2.shortVideoId = @"222";
    videoInfo2.anchorId = @"222";
    videoInfo2.shortVideoUrl = @"https://vd4.bdstatic.com/mda-mkn4iq79ihtufbc1/sc/cae_h264/1637639849265611965/mda-mkn4iq79ihtufbc1.mp4";
    
    KJVideoInfo *videoInfo3 = [[KJVideoInfo alloc] init];
    videoInfo3.shortVideoId = @"333";
    videoInfo3.anchorId = @"333";
    videoInfo3.shortVideoUrl = @"https://vd2.bdstatic.com/mda-mkv7cbzq5xdtf9ms/sc/cae_h264/1638478442002383579/mda-mkv7cbzq5xdtf9ms.mp4";
    
    [self.videoArray addObject:videoInfo1];
    [self.videoArray addObject:videoInfo2];
    [self.videoArray addObject:videoInfo3];
    
    [self p_homeLoadViewSuccessAddView];
    
}

- (void)addBackButton {
    UIButton *backButton = [[UIButton alloc] init];
    [backButton setImage:[UIImage imageNamed:@"back_white"] forState:UIControlStateNormal];
    backButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [self.view addSubview:backButton];
    @weakify(self)
    backButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        [self.currentVideoView.playerVC playerPause];
        [KJRouterInstance popToViewModelAnimated:YES];
        return [RACSignal empty];
    }];
    [backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(SCREEN_STATUSBAR_HEIGHT);
        make.left.offset(15);
        make.width.height.offset(44);
    }];
}

#pragma mark - layout

- (void)addScrollView {
    [self.view addSubview:self.scrollView];
    [self.listView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.left.right.offset(0);
        make.height.offset(0);
    }];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.listView.mas_bottom).offset(0);
        make.left.right.offset(0);
        make.height.offset(SCREEN_HEIGHT);
    }];
    [self.scrollView setContentOffset:CGPointMake(0, 0) animated:NO];
    
    CGFloat width = [KJCommonlyMethods calculateLengthOfText:@"0个直播" font:SCRXFromX(14)].width +SCRXFromX(35);
    [self.numView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.width.offset(width);
        make.height.offset(SCRXFromX(25));
        make.top.offset(SCRXFromX(20) + NavBarHeight);
    }];
    
    self.numView.hidden = YES;
    @weakify(self);
    self.numView.openHostListBlock = ^{
        @strongify(self);
//        [self showHostList];
    };
    
//    [self.promptView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.offset(NavBarHeight);
//        make.left.right.bottom.offset(0);
//    }];
    
//    [self getFollowHostList];
}

#pragma mark - Private
// 第一次数据加载成功，加载view
- (void)p_homeLoadViewSuccessAddView {
    
    [self p_removeAllVideo];
    
    if (self.videoArray.count == 0) {
        return;
    }
    
    if (self.scrollView.subviews.count >= 3) {
        return;
    }
//    self.promptView.hidden = YES;
    NSInteger count = self.videoArray.count >= 3 ? 3 : self.videoArray.count;
    self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT * count);
    
    @weakify(self);
    for (NSInteger index = 0; index < count; index ++) {
        KJVideoInfo *info = [self.videoArray objectAtIndex:index];
        KJVideoView *videoView = [[KJVideoView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT * index, SCREEN_WIDTH, SCREEN_HEIGHT)];
        [self.scrollView addSubview:videoView];
        videoView.tag = kVideoViewTag + index;
        [videoView.imageView sd_setImageWithURL:[NSURL URLWithString:info.shortPicUrl]];
        
        //短视频Player图层
        KJPlayerVC *playerVC = [[KJPlayerVC alloc] init];
        playerVC.delegate = self;
        [self addChildViewController:playerVC];
        [videoView addSubview:playerVC.view];
        playerVC.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        videoView.playerVC = playerVC;
        [playerVC playerSourceUrlSetting:info.shortVideoUrl];
        if (index == 0) {
            if ([[KJCommonlyMethods currentViewController] isKindOfClass:[KJHomeVC class]]) {
                if (self.isHome) {
                    if (self.currentShowIndex == self.view.tag) {
                        [playerVC playerPlay];
                    }
                }
            } else if ([[KJCommonlyMethods currentViewController] isKindOfClass:[KJShortVideoPlayerVC class]]) {
                [playerVC playerPlay];
            }

            self.currentVideoView = videoView;
            self.currentIndex = 0;
        }
        
        //短视频Cover图层
        KJShortVideoPlayerCoverVC *coverVC = [[KJShortVideoPlayerCoverVC alloc] init];
        coverVC.delegate = self;
        coverVC.isHome = self.isHome;
        coverVC.closeOrOpenBar = ^(NSInteger close) {
            @strongify(self);
            self.isClose = close;
        };
        [self addChildViewController:coverVC];
        [videoView addSubview:coverVC.view];
        coverVC.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        videoView.coverVC = coverVC;
        coverVC.isStore = self.isStore;
        [coverVC videoDataSetting:info];
        KJVideoAnchorInfo *anchorInfo = [[KJVideoAnchorInfo alloc] init];
        if (self.IsFollow) {
            anchorInfo.isFollow = YES;
            coverVC.IsFollow = YES;
        }
        videoView.coverVC.anchorInfo = anchorInfo;
        videoView.coverVC.goodsList = [[NSArray alloc] init];
        [self getCurrentVideoData:index type:0 videoView:videoView];
        [self getCurrentVideoData:index type:1 videoView:videoView];

        coverVC.changeFocusBlock = ^(BOOL isFocus) {
            @strongify(self);
            for (KJVideoAnchorInfo *info in self.anchorArray) {
                info.isFollow = isFocus;
            }

            if (self.changeFocusBlock) {
                self.changeFocusBlock(isFocus);
            }
        };
        
        coverVC.likeVideo = ^(BOOL isLike) {
            @strongify(self);
            if (self.lickVideo) {
                self.lickVideo(isLike);
            }
        };
    }
    
//    self.isClose = [TMVideoSettingTool sharedTools].isClose;
    
    if (!self.isHome) {
        for (int i =0 ; i < self.videoArray.count; i ++) {
            KJVideoInfo *info = self.videoArray[i];
            if (info.isCurrentVod) {
                break;
            }
            
            [self scrollViewDidEndScrolling:YES];
        }
    }
    
}

- (void)p_removeAllVideo {
    for (KJVideoView *videoView in self.scrollView.subviews) {
        if ([videoView isKindOfClass:[KJVideoView class]]) {
            [videoView removeFromSuperview];
        }
    }
    [self.childViewControllers makeObjectsPerformSelector:@selector(removeFromParentViewController)];
    self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, 0);
}


#pragma mark - KJPlayerDelegate
// 视频播放进度
- (void)videoPlayProgress:(CGFloat)progress {
    [self.currentVideoView.coverVC changeVideoProgress:progress totalTime:[self.currentVideoView.playerVC getVideoTime]];
    self.playProgress = progress;
}

//视频播放状态改变
- (void)videoPlayStatusChange:(BOOL)isPlay {
    [self.currentVideoView.coverVC videoPlayStateSetting:isPlay];
}

//是否在缓冲
- (void)videoLoading:(BOOL)isLoading {
    self.currentVideoView.coverVC.isLoading = isLoading;
}

// 视频缓存进度
- (void)videoPlayCacheProgress:(CGFloat)cacheProgress {
    
}

// 视频播放结束
- (void)videoPlayEnd {

    if (self.isHome && !self.IsFollow && self.isStore) {
        self.playComplete = YES;
    }
    if ([[KJCommonlyMethods currentViewController] isKindOfClass:[KJHomeVC class]]) {
        
        if (self.isHome) {
            if (self.currentShowIndex == self.view.tag) {
                [self.currentVideoView.playerVC playVideoWithTime:0];
                [self.currentVideoView.coverVC changeVideoState];
                [self.currentVideoView.playerVC playerPlay];
            }
        }
    } else if ([[KJCommonlyMethods currentViewController] isKindOfClass:[KJShortVideoPlayerVC class]]) {
        
        KJShortVideoPlayerVC *VC = (KJShortVideoPlayerVC *)[KJCommonlyMethods currentViewController];
        [VC.currentVideoView.playerVC playVideoWithTime:0];
        [VC.currentVideoView.coverVC changeVideoState];
        [VC.currentVideoView.playerVC playerPlay];
    }
}


#pragma mark - KJPlayerCoverDelegate

- (void)videoPlayStateChange:(BOOL)playing {
    if (playing) {
        [self.currentVideoView.playerVC playerPlay];
    } else {
        [self.currentVideoView.playerVC playerPause];
    }
}

// 视频播放进度
- (void)videoProgressSetting:(CGFloat)progress {
    [self.currentVideoView.playerVC playVideoWithTime:progress];
}

//查看评论
- (void)videoCommentsButtonClick:(NSString *)videoId commentsNum:(NSInteger)num
{
//    if (self.commentsView != nil && [self.commentsView.videoId isEqualToString:videoId]) {
//
//        [self.commentsView popupToComments];
//        return;
//    }
//
//    if (self.commentsView != nil) {
//
//        [self.commentsView removeFromSuperview];
//    }
//
//    self.commentsView = [TMVideoCommentsView showVideoCommentsWithShordVideoId:videoId commentsNum:num superView:self.parentViewController.view];
//    @weakify(self);
//    self.commentsView.changeCommentsNum = ^(NSInteger num) {
//        @strongify(self);
//        [self.currentVideoView.coverVC changeCommentsNum:num];
//    };
}

#pragma mark - UIScrollViewDelegate
//开始拖拽
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    beginDraggingOffset = scrollView.contentOffset.y;
    if (self.isHome) {
        [self.timer invalidate];
        self.timer = nil;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"首页不可以切换界面" object:@{@"isScroll":@(NO)}];
    }
    
    if (self.isHome) {
        if (self.scrollBeginDragin) {
            self.scrollBeginDragin();
        }
    }
}

//结束拖拽
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView
                  willDecelerate:(BOOL)decelerate {
    endDraggingOffset = scrollView.contentOffset.y;//记录结束拖拽的位置
    if (decelerate == NO && beginDraggingOffset != endDraggingOffset) {
        [self scrollViewDidEndScrolling:(endDraggingOffset > beginDraggingOffset)];
    }
    
    if (scrollView.contentOffset.y < -SCRXFromX(30)) {
        if (self.isHome) {
            [self reloadData];
        } else {
            [KJShowMessage showMessage:@"已经到顶了"];
        }
    }
}

- (void)reloadData
{
    if (self.isHome && !self.IsFollow && self.isStore) {
        self.currentPage = 1;
    }
    [self.anchorArray removeAllObjects];
    [self.anchorVideoIDArray removeAllObjects];
    [self.spuArray removeAllObjects];
    [self.spuVideoIDArray removeAllObjects];
//    [self.videoArray removeAllObjects];
//    [self firstEnterGetVideoData];
//    [self getFollowHostList];
}

//开始减速
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    scrollView.scrollEnabled = NO;
}

//结束减速
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    scrollView.scrollEnabled = YES;
    //NSLog(@"111=====%f",scrollView.contentOffset.y);
    
    if (beginDraggingOffset < scrollView.contentOffset.y && (scrollView.contentOffset.y-beginDraggingOffset) >= SCREEN_HEIGHT) {
        NSLog(@"=====向上滚动=====");
        self.sliderType = 0;
        if (self.currentIndex < self.videoArray.count - 1) {
            [self scrollViewDidEndScrolling:YES];
        }
        
        if (self.isHomeVideo) {
            if (self.currentIndex + 7 > self.videoArray.count) {
//                [[self nextVideoDataCommand] execute:nil];
            }
        } else {
            if (self.currentIndex + 3 > self.videoArray.count && self.currentIndex + 1 <self.videoArray.count) {
//                [[self nextVideoDataCommand] execute:nil];
            }
        }
        
    } else if (beginDraggingOffset > scrollView.contentOffset.y && (beginDraggingOffset-scrollView.contentOffset.y) >= SCREEN_HEIGHT) {
        NSLog(@"=====向下滚动=====");
        
        self.sliderType = 1;
        if (self.currentIndex > 0) {
            [self scrollViewDidEndScrolling:NO];
        }
        
        if (!self.isHome) {
            if (self.currentIndex <= 1) {
//                [[self nextVideoDataCommand] execute:nil];
            }
        }
    }
    
    if (self.isHome) {
//        [self startCodeTime:0.3];
    }
}

- (void)scrollViewDidEndScrolling:(BOOL)isUp {
    if (isUp) {
        self.currentIndex++;
    } else {
        self.currentIndex--;
    }
    if (self.isHome && !self.IsFollow && self.isStore) {
        
        if (self.playProgress >=0.3 || self.playComplete == YES) {
            
            NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
            [param setObject:[KJUtils nullToString:self.currentVideoView.coverVC.videoinfo.tag] forKey:@"userTag"];
            [param setObject:[KJUtils nullToString:self.currentVideoView.coverVC.videoinfo.classification] forKey:@"userClassfication"];
            [param setObject:[KJUtils nullToString:self.currentVideoView.coverVC.videoinfo.anchor] forKey:@"anchor"];
            NSNumber *progress;
            if (self.playComplete == YES) {
                progress = @(1);
            }else {
                progress = @(self.playProgress);
            }
            [param setObject:progress forKey:@"videoElapsedTimePercentage"];
            [param setObject:self.userId forKey:@"userId"];
//            [[TMAPIManagerShared postDataWithOtherHostMethod:@"api/uservideohistory/addorupdate" requestData:param] subscribeNext:^(id x) {
//
//                NSLog(@"--------%@",x);
//
//            } error:^(NSError *error) {
//                NSLog(@"-------%@",error);
//            }];
        }
        self.playComplete = NO;
        self.playProgress = 0;
    }
    
    KJVideoView *firstVideoView = [self.scrollView viewWithTag:kVideoViewTag];
    KJVideoView *sencondVideoView = [self.scrollView viewWithTag:kVideoViewTag + 1];
    KJVideoView *thirdVideoView = [self.scrollView viewWithTag:kVideoViewTag + 2];
    // 全部暂停播放
    [firstVideoView.playerVC playerPause];
    [sencondVideoView.playerVC playerPause];
    [thirdVideoView.playerVC playerPause];
    
    firstVideoView.coverVC.isStore = self.isStore;
    firstVideoView.coverVC.hiddenPlayImage = YES;
    sencondVideoView.coverVC.isStore = self.isStore;
    sencondVideoView.coverVC.hiddenPlayImage = YES;
    thirdVideoView.coverVC.isStore = self.isStore;
    thirdVideoView.coverVC.hiddenPlayImage = YES;
    
    if (self.currentIndex == 0) {
        self.currentVideoView = firstVideoView;
    } else if (self.currentIndex == self.videoArray.count - 1) {
        self.currentVideoView = thirdVideoView;
        if (self.videoArray.count >= 3) {
            self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT * 3);
        } else {
            self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT *self.videoArray.count);
        }
    } else if ((self.currentIndex == 1 && isUp) || (self.currentIndex == self.videoArray.count - 2 && !isUp)) {
        self.currentVideoView = sencondVideoView;
        self.scrollView.contentOffset = CGPointMake(0, SCREEN_HEIGHT);
    } else {
        // 设置中间view
        KJVideoView *centerVideoView = isUp ? thirdVideoView : firstVideoView;
        centerVideoView.tag = kVideoViewTag + 1;
        centerVideoView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT);
        self.currentVideoView = centerVideoView;
        
        // 第一个设置
        KJVideoView *beginVideoView = nil;
        if (isUp) {
            beginVideoView = sencondVideoView;
            [beginVideoView.playerVC playVideoWithTime:0];
        } else {
            beginVideoView = thirdVideoView;
            // 需要设置数据
            KJVideoInfo *firstVideoInfo = [self.videoArray objectAtIndex:self.currentIndex - 1];
            [beginVideoView.imageView sd_setImageWithURL:[NSURL URLWithString:firstVideoInfo.shortPicUrl]];
            [beginVideoView.coverVC videoDataSetting:firstVideoInfo];
            [beginVideoView.playerVC playerSourceUrlSetting:firstVideoInfo.shortVideoUrl];
            KJVideoAnchorInfo *anchorInfo = [[KJVideoAnchorInfo alloc] init];
            if (self.IsFollow) {
                anchorInfo.isFollow = YES;
            }
            beginVideoView.coverVC.anchorInfo = anchorInfo;
            beginVideoView.coverVC.goodsList = [[NSArray alloc] init];
            [self getCurrentVideoData:self.currentIndex -1 type:0 videoView:beginVideoView];
            [self getCurrentVideoData:self.currentIndex -1 type:1 videoView:beginVideoView];
        }
        beginVideoView.tag = kVideoViewTag;
        beginVideoView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        
        // 第三个设置
        KJVideoView *endVideoView = nil;
        if (isUp) {
            endVideoView = firstVideoView;
            // 需要设置数据
            KJVideoInfo *thirdVideoInfo = [self.videoArray objectAtIndex:self.currentIndex + 1];
            [endVideoView.imageView sd_setImageWithURL:[NSURL URLWithString:thirdVideoInfo.shortPicUrl]];
            [endVideoView.coverVC videoDataSetting:thirdVideoInfo];
            [endVideoView.playerVC playerSourceUrlSetting:thirdVideoInfo.shortVideoUrl];
            KJVideoAnchorInfo *anchorInfo = [[KJVideoAnchorInfo alloc] init];
            if (self.IsFollow) {
                
                anchorInfo.isFollow = YES;
            }
            endVideoView.coverVC.anchorInfo = anchorInfo;
            endVideoView.coverVC.goodsList = [[NSArray alloc] init];
            [self getCurrentVideoData:self.currentIndex +1 type:0 videoView:endVideoView];
            [self getCurrentVideoData:self.currentIndex +1 type:1 videoView:endVideoView];
        } else {
            endVideoView = sencondVideoView;
            [endVideoView.playerVC playVideoWithTime:0];
        }
        endVideoView.tag = kVideoViewTag + 2;
        endVideoView.frame = CGRectMake(0, SCREEN_HEIGHT * 2, SCREEN_WIDTH, SCREEN_HEIGHT);
        
        self.scrollView.contentOffset = CGPointMake(0, SCREEN_HEIGHT);
    }
    [self.currentVideoView.playerVC playerPlay];
    
    KJVideoAnchorInfo *anchorInfo = [[KJVideoAnchorInfo alloc] init];
    if (self.IsFollow) {
        anchorInfo.isFollow = YES;
    }
    self.currentVideoView.coverVC.anchorInfo = anchorInfo;
    self.currentVideoView.coverVC.goodsList = [[NSArray alloc] init];
    [self getCurrentVideoData:self.currentIndex type:0 videoView:self.currentVideoView];
    [self getCurrentVideoData:self.currentIndex type:1 videoView:self.currentVideoView];
    
}

/** 获取当前视频用户/商品信息*/
- (void)getCurrentVideoData:(NSInteger)index type:(NSInteger)type videoView:(KJVideoView *)videoView
{
    @weakify(self);
    if (self.videoArray.count < index + 1) {
        return;
    }
    
    KJVideoInfo *info = self.videoArray[index];
    if (self.isHomeVideo) {
        if (self.currentIndex == index) {
            if (![self.haveBeenIdArray containsObject:info.shortVideoId]) {
                
                [self.haveBeenIdArray addObject:info.shortVideoId];
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                NSMutableArray *defaultArray = [[NSMutableArray alloc] initWithArray:[defaults objectForKey:@"homeVideoIdArray"]];
                NSDictionary *dicts = @{@"videoId":info.shortVideoId,@"time":[KJCommonlyMethods getCurrentDay]};
                [defaultArray addObject:dicts];
                [defaults setObject:defaultArray forKey:@"homeVideoIdArray"];
                [defaults synchronize];
            }
        }
    }
    if (type == 0) {//用户信息
        if ([self.anchorVideoIDArray containsObject:info.shortVideoId]) {

            KJVideoAnchorInfo *anchorInfo = [self.anchorArray objectAtIndex:[self.anchorVideoIDArray indexOfObject:info.shortVideoId]];
            videoView.coverVC.anchorInfo = anchorInfo;
            return;
        }
        NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
        [param setObject:info.shortVideoId forKey:@"shortVideoId"];
        [param setObject:info.anchorId forKey:@"anchorId"];
//        [[TMAPIManagerShared postDataWithMethod:@"api/live/shortvideoanchor" requestData:param] subscribeNext:^(id x) {
//            @strongify(self);
//            TMVideoAnchorInfo *anchorInfo = [TMVideoAnchorInfo yy_modelWithDictionary:x];
//            if (![self.anchorVideoIDArray containsObject:info.shortVideoId]) {
//
//                [self.anchorArray addObject:anchorInfo];
//                [self.anchorVideoIDArray addObject:info.shortVideoId];
//            }
//            videoView.coverVC.anchorInfo = anchorInfo;
//        }];
    } else {//商品信息
        
        if ([self.spuVideoIDArray containsObject:info.shortVideoId]) {

            NSArray *goodsArray = [self.spuArray objectAtIndex:[self.spuVideoIDArray indexOfObject:info.shortVideoId]];
            videoView.coverVC.goodsList = goodsArray;
            return;
        }
        NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
        [param setObject:info.shortVideoId forKey:@"shortVideoId"];
//        [[TMAPIManagerShared postDataWithMethod:@"api/live/shortvideospulist" requestData:param] subscribeNext:^(id x) {
//            @strongify(self);
//            NSMutableArray *goodArray = [[NSMutableArray alloc] init];
//            for (NSDictionary *dict in [x objectForKey:@"goodsList"]) {
//
//                TMVideoGoodsInfo *goodsInfo = [TMVideoGoodsInfo yy_modelWithDictionary:dict];
//                [goodArray addObject:goodsInfo];
//            }
//
//            if (![self.spuVideoIDArray containsObject:info.shortVideoId]) {
//
//                [self.spuArray addObject:[[NSArray alloc] initWithArray:goodArray]];
//                [self.spuVideoIDArray addObject:info.shortVideoId];
//            }
//            videoView.coverVC.goodsList = goodArray;
//        }];
    }
}

#pragma mark - getter
- (NSMutableArray *)videoArray {
    if (!_videoArray) {
        _videoArray = [[NSMutableArray alloc] init];
    }
    return _videoArray;
}

- (NSMutableArray *)anchorArray
{
    if (!_anchorArray) {
        
        _anchorArray = [[NSMutableArray alloc] init];
    }
    return _anchorArray;
}

- (NSMutableArray *)anchorVideoIDArray
{
    if (!_anchorVideoIDArray) {
        
        _anchorVideoIDArray = [[NSMutableArray alloc] init];
    }
    return _anchorVideoIDArray;
}

- (NSMutableArray *)spuArray
{
    if (!_spuArray) {
        
        _spuArray = [[NSMutableArray alloc] init];
    }
    return _spuArray;
}

- (NSMutableArray *)spuVideoIDArray
{
    if (!_spuVideoIDArray) {
        
        _spuVideoIDArray = [[NSMutableArray alloc] init];
    }
    return _spuVideoIDArray;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.userInteractionEnabled = YES;
        _scrollView.pagingEnabled = YES;//设为YES当滚动的时候会自动跳页
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator =NO;
        _scrollView.delegate = self;
//        _scrollView.scrollsToTop = NO;
        _scrollView.backgroundColor = [UIColor clearColor];
    }
    return _scrollView;
}

- (KJLiveNumView *)numView
{
    if (!_numView) {
        _numView = [[KJLiveNumView alloc] init];
        [self.view addSubview:_numView];
    }
    return _numView;
}

- (KJHostListView *)listView
{
    if (!_listView) {
        _listView = [[KJHostListView alloc] init];
        [self.view addSubview:_listView];
    }
    return _listView;
}

- (UIView *)alphaBackView {
    if (!_alphaBackView) {
        _alphaBackView = [[UIView alloc] initWithFrame:CGRectMake(0, NavBarHeight + SCRXFromX(100), SCREEN_WIDTH, SCREEN_HEIGHT - (NavBarHeight + SCRXFromX(100)))];
        _alphaBackView.backgroundColor = [UIColor clearColor];
        UIButton *button = [[UIButton alloc] initWithFrame:_alphaBackView.bounds];
        [button addTarget:self action:@selector(hideHostList) forControlEvents:UIControlEventTouchUpInside];
        [_alphaBackView addSubview:button];
    }
    return _alphaBackView;
}


//- (KJFocusPromptView *)promptView
//{
//    if (!_promptView) {
//        _promptView = [[KJFocusPromptView alloc] init];
//        _promptView.hidden = YES;
//        [self.view addSubview:_promptView];
//    }
//    return _promptView;
//}

//- (TencentLBSLocationManager *)locationManager {
//    if (!_locationManager) {
//
//        _locationManager = [[TencentLBSLocationManager alloc] init];
//
//        [_locationManager setDelegate:self];
//
//        [_locationManager setApiKey:@"SAVBZ-TUIW2-WMLUD-C5RPR-25Z6K-OPFGT"];
//
//        [_locationManager setPausesLocationUpdatesAutomatically:NO];
//
//        // 需要后台定位的话，可以设置此属性为YES。
//        [_locationManager setAllowsBackgroundLocationUpdates:NO];
//
//        // 如果需要POI信息的话，根据所需要的级别来设定，定位结果将会根据设定的POI级别来返回，如：
//        [_locationManager setRequestLevel:TencentLBSRequestLevelName];
//
//        // 申请的定位权限，得和在info.list申请的权限对应才有效
//        CLAuthorizationStatus authorizationStatus = [CLLocationManager authorizationStatus];
//        if (authorizationStatus == kCLAuthorizationStatusNotDetermined) {
//            [_locationManager requestWhenInUseAuthorization];
//        }
//    }
//    return _locationManager;
//}

@end
