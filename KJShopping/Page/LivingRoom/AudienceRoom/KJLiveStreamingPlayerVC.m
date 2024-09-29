//
//  KJLiveStreamingPlayerVC.m
//  KJShopping
//
//  Created by TigerHu on 2024/9/18.
//

#import "KJLiveStreamingPlayerVC.h"
#import "KJAudienceRoomVC.h"
#import "KJLiveView.h"
#import "KJLivingRoomPlayInfo.h"

#define kLiveViewTag 2000

@interface KJLiveStreamingPlayerVC () <UIScrollViewDelegate>
{
    CGFloat beginDraggingOffset;
    CGFloat endDraggingOffset;
    CGRect _viewOriginalFrame;
}

@property (nonatomic, strong) NSMutableArray *liveArray;
@property (nonatomic, assign) NSInteger currentIndex;

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) KJLiveView *currentLiveView;

@end

@implementation KJLiveStreamingPlayerVC

#pragma mark - Life Cycle

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addScrollView];
    
    self.fd_prefersNavigationBarHidden = YES;
    self.fd_interactivePopDisabled = YES;
    self.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
     
    //模拟假数据
    [self p_firstEnterGetVideoData];
    
}

- (void)addScrollView {
    [self.view addSubview:self.scrollView];

    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(0);
        make.left.right.offset(0);
        make.height.offset(SCREEN_HEIGHT);
    }];
    
    [self.scrollView setContentOffset:CGPointMake(0, 0) animated:NO];

}

#pragma mark - Private

- (void)p_firstEnterGetVideoData {
    [self.liveArray removeAllObjects];
    
    //首次获取数据
    KJLivingRoomPlayInfo *liveInfo1 = [[KJLivingRoomPlayInfo alloc] init];
    liveInfo1.playUrl = @"playUrl";
    liveInfo1.anchorImg = @"defaultHead";
    liveInfo1.anchorName = @"主播名称";
    liveInfo1.onlineUserCount = 1234;
    liveInfo1.isFollow = NO;
    
    
    KJLivingRoomPlayInfo *liveInfo2 = [[KJLivingRoomPlayInfo alloc] init];
    liveInfo2.playUrl = @"playUrl";
    KJLivingRoomPlayInfo *liveInfo3 = [[KJLivingRoomPlayInfo alloc] init];
    liveInfo3.playUrl = @"playUrl";
    
    [self.liveArray addObject:liveInfo1];
    [self.liveArray addObject:liveInfo2];
    [self.liveArray addObject:liveInfo3];
    
    [self p_loadViewSuccessAddView];
}

- (void)p_updateLivingListData {
   
    //追加数据
    KJLivingRoomPlayInfo *liveInfo1 = [[KJLivingRoomPlayInfo alloc] init];
    liveInfo1.playUrl = @"playUrl";
    KJLivingRoomPlayInfo *liveInfo2 = [[KJLivingRoomPlayInfo alloc] init];
    liveInfo2.playUrl = @"playUrl";
    
    [self.liveArray addObject:liveInfo1];
    [self.liveArray addObject:liveInfo2];
}


- (void)p_loadViewSuccessAddView {
    if (self.liveArray.count == 0) {
        return;
    }
    
    NSInteger count = self.liveArray.count >= 3 ? 3 : self.liveArray.count;
    self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT * count);

    for (NSInteger index = 0; index < count; index++) {

        KJLiveView *liveView = [[KJLiveView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT * index, SCREEN_WIDTH, SCREEN_HEIGHT)];
        [self.scrollView addSubview:liveView];
        liveView.tag = kLiveViewTag + index;
        
        //直播图层
        KJAudienceRoomVC *playerVC = [[KJAudienceRoomVC alloc] init];
        playerVC.isFromMultiLiveRoom = YES;
        playerVC.liveNumber = self.liveArray.count;
        [self addChildViewController:playerVC];
        playerVC.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        [liveView addSubview:playerVC.view];
        liveView.coverVC = playerVC;
        if (index == 0) {
            self.currentLiveView = liveView;
            self.currentIndex = 0;
        }
    }
    
    [self.currentLiveView.coverVC multiLiveRoomPlayInfoSetting:self.liveArray[0] WithInView:self.currentLiveView.coverVC.videoParentView withKJAudienceRoomVC:self.currentLiveView.coverVC];
}

#pragma mark - UIScrollViewDelegate
//开始拖拽
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    beginDraggingOffset = scrollView.contentOffset.y;
    
    //隐藏键盘
    [self.currentLiveView.coverVC multiLiveRoomHideKeyboard];
}
//结束拖拽
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView
                  willDecelerate:(BOOL)decelerate
{
    endDraggingOffset = scrollView.contentOffset.y;//记录结束拖拽的位置

}

//开始减速
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    scrollView.scrollEnabled = NO;
}

//结束减速
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    scrollView.scrollEnabled = YES;
        
    if (beginDraggingOffset < scrollView.contentOffset.y && (scrollView.contentOffset.y-beginDraggingOffset) >= SCREEN_HEIGHT) {
        NSLog(@"=====向上滚动=====");
        if (self.currentIndex < self.liveArray.count - 1) {
            [self scrollViewDidEndScrollingWithIsUp:YES];
        }
        
    } else if(beginDraggingOffset > scrollView.contentOffset.y && (beginDraggingOffset-scrollView.contentOffset.y) >= SCREEN_HEIGHT) {
        NSLog(@"=====向下滚动=====");
        if (self.currentIndex > 0) {
            [self scrollViewDidEndScrollingWithIsUp:NO];
        }
    }
    
    if (!self.currentIndex) {
        self.currentIndex = 0;
    }
    
    if (self.currentIndex + 4 > self.liveArray.count) {
        [self p_updateLivingListData];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
 
}

- (void)scrollViewDidEndScrollingWithIsUp:(BOOL)isUp {
    if (isUp) {
        self.currentIndex++;
    } else {
        self.currentIndex--;
    }
    
    KJLiveView *firstLiveView = [self.scrollView viewWithTag:kLiveViewTag];
    KJLiveView *secondLiveView = [self.scrollView viewWithTag:kLiveViewTag + 1];
    KJLiveView *thirdLiveView = [self.scrollView viewWithTag:kLiveViewTag + 2];
    
    //进直播前先退出上个直播间
    [self.currentLiveView.coverVC multiLiveRoomWithStopLastRoom];

    //根据索引赋值对应的KJLiveView
    if (self.currentIndex == 0) {
        self.currentLiveView = firstLiveView;
    } else if (self.currentIndex == self.liveArray.count - 1) {
        //特殊情况处理：如果只有2个
        self.currentLiveView = (self.liveArray.count == 2) ? secondLiveView: thirdLiveView;
    } else if ((self.currentIndex == 1 && isUp) || (self.currentIndex == self.liveArray.count - 2 && !isUp)) {
        self.currentLiveView = secondLiveView;
    } else {
        // 设置中间view
        KJLiveView *centerVideoView = isUp ? thirdLiveView : firstLiveView;
        centerVideoView.tag = kLiveViewTag + 1;
        centerVideoView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT);
        self.currentLiveView = centerVideoView;

        // 第一个设置
        KJLiveView *beginVideoView = nil;
        if (isUp) {
            beginVideoView = secondLiveView;
        } else {
            beginVideoView = thirdLiveView;
        }
        beginVideoView.tag = kLiveViewTag;
        beginVideoView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        
        // 第三个设置
        KJLiveView *endVideoView = nil;
        if (isUp) {
            endVideoView = firstLiveView;
        } else {
            endVideoView = secondLiveView;
        }
        endVideoView.tag = kLiveViewTag + 2;
        endVideoView.frame = CGRectMake(0, SCREEN_HEIGHT * 2, SCREEN_WIDTH, SCREEN_HEIGHT);
        
        self.scrollView.contentOffset = CGPointMake(0, SCREEN_HEIGHT);
    }
    
    if (self.currentIndex < self.liveArray.count) {
        [self.currentLiveView.coverVC multiLiveRoomPlayInfoSetting:self.liveArray[self.currentIndex] WithInView:self.currentLiveView.coverVC.videoParentView withKJAudienceRoomVC:self.currentLiveView.coverVC];
    }
}

#pragma mark - Lazy loading

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.userInteractionEnabled = YES;
        _scrollView.pagingEnabled = YES;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.alwaysBounceVertical = YES;
        _scrollView.alwaysBounceHorizontal = NO;
        _scrollView.delegate = self;
        _scrollView.scrollsToTop = NO;
        _scrollView.backgroundColor = [UIColor clearColor];
    }
    return _scrollView;
}

- (NSMutableArray *)liveArray
{
    if (!_liveArray) {
        _liveArray = [[NSMutableArray alloc] init];
    }
    return _liveArray;
}

@end
