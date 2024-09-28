//
//  KJAudienceRoomVC.m
//  KJShopping
//
//  Created by TigerHu on 2024/9/18.
//

#import "KJAudienceRoomVC.h"
#import "KJAudienceRoomCoverView.h"
#import <SVGA.h>

@interface KJAudienceRoomVC () <KJAudienceRoomCoverViewDelegate, SVGAPlayerDelegate>
{
    
}

@property (nonatomic, copy) NSString *roomId;
//@property (nonatomic, strong) KJRoom *liveRoom;

// 直播间遮盖view
@property (nonatomic, strong) KJAudienceRoomCoverView *roomCoverView;

//加载动画
//@property (nonatomic, strong) XLBallLoading *ballLoadingView;
@property (nonatomic, strong) UIImageView *imgRoomBg;   // 直播间背景图
@property (nonatomic, strong) SVGAPlayer *giftAnimation; // 特殊礼物
@property (nonatomic, strong) UIImageView *animationGif; // 特殊礼物 gif
@property (nonatomic, strong) NSOperationQueue *queue; // 特效礼物多线程

@property (nonatomic, assign) BOOL loginState;

// 跳转 商品详情或个人d商店详情
@property (nonatomic, assign) BOOL isBackFromGoodsDetailVC;

//关闭按钮（隐藏coverview时显示）
@property (nonatomic, strong) UIButton *closeButton;

// 禁播/警告 coverView
@property (nonatomic, strong) UIView *warningCoverView;
@property (nonatomic, strong) UILabel *warningLabel;

@property (nonatomic, copy) void (^getBackBlock)(void);


// 重试UI
@property (nonatomic, strong) UILabel *leaveLabel;
@property (nonatomic, strong) UIButton *reTryButton;

//来了
@property (nonatomic, strong) UILabel *commingLabel;
@property (nonatomic, assign) BOOL isSomebodyComeingNew;
@property (nonatomic, assign) BOOL iamShowing;

@end

@implementation KJAudienceRoomVC

#pragma mark - Life Cycle

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.fd_prefersNavigationBarHidden = YES;
    self.fd_interactivePopDisabled = YES;
    
    @weakify(self)
    // 直播间背景图
    [self.view addSubview:self.imgRoomBg];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        @strongify(self)
        // 背景图加毛玻璃效果
        UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        UIVisualEffectView *effectview = [[UIVisualEffectView alloc] initWithEffect:blur];
        effectview.frame = self.imgRoomBg.frame;
        [self.imgRoomBg addSubview:effectview];
    });
    
    [self initCoverView];
    
}

#pragma mark - Init CoverUI

- (void)initCoverView
{
    self.roomCoverView = [[KJAudienceRoomCoverView alloc] initWithFrame:self.view.frame];
    self.roomCoverView.delegate = self;
    self.roomCoverView.roomId = self.roomId;
    [self.view addSubview:self.roomCoverView];
}


- (void)multiLiveRoomPlayInfoSetting:(KJLiveRoomPlayInfo *)liveRoomPlayInfo WithInView:(UIView *)inView withKJAudienceRoomVC:(KJAudienceRoomVC *)audienceRoomVC
{
    
    
}

- (void)multiLiveRoomWithStopLastRoom
{
    
}

- (void)multiLiveRoomHideKeyboard
{
    //[self.roomCoverView resignFirstResponderForTextField];
}

- (void)multiLiveRoomNetworkConnectedFail
{
    //[self.roomCoverView resignFirstResponderForTextField];
}

#pragma mark - Lazy loading
//背景图片
- (UIImageView *)imgRoomBg
{
    if (!_imgRoomBg) {
        _imgRoomBg = [[UIImageView alloc] initWithFrame:self.view.bounds];
        _imgRoomBg.image = [UIImage imageNamed:@"livingRoom_bg_image"];
    }
    return _imgRoomBg;
}

@end
