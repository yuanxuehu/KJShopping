//
//  KJHomeVC.m
//  KJShopping
//
//  Created by TigerHu on 2024/4/20.
//

#import "KJHomeVC.h"
#import "KJShortVideoPlayerVC.h"

#import "KJHomeHeadChooseView.h"


@interface KJHomeVC () <UIScrollViewDelegate,KJHomeHeadChooseViewDelegate,UIGestureRecognizerDelegate>
{
    
}

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *conatinerView;
@property (nonatomic, strong) NSArray *tabbarTitleArray;
@property (nonatomic, strong) NSMutableDictionary *chirdVCAddTagDic;

@property (nonatomic, strong) KJHomeHeadChooseView *navBarView;

@property (nonatomic, assign) NSInteger selectIndex;

@property (nonatomic, assign) BOOL isFirstLoad;

@end

@implementation KJHomeVC

- (void)initialize
{
    [super initialize];
    self.fd_prefersNavigationBarHidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.isFirstLoad = YES;
    
    [self addItem];
    [self createSubView:nil];
    self.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (self.isFirstLoad) {
        self.isFirstLoad = NO;
    } else {
        if (self.navBarView.currentIndex < 2) {
            
//            for (TMShortVideoPlayerVC *VC in self.childViewControllers) {
//
//                if ([VC isKindOfClass:[TMShortVideoPlayerVC class]]) {
//
//                    if (VC.view.tag == self.navBarView.currentIndex) {
//
//                        [VC backPlay];
//                    }
//                    VC.isClose = [TMVideoSettingTool sharedTools].isClose;
//                }
//            }
        }
    }
}


#pragma mark 导航按钮
- (void)addItem {
    
    //    [self.addBgView mas_makeConstraints:^(MASConstraintMaker *make) {
    //
    //        make.top.offset(0);
    //        make.left.offset(0);
    //        make.right.offset(0);
    //        make.bottom.offset(0);
    //    }];
    //
    //    [self.addView mas_makeConstraints:^(MASConstraintMaker *make) {
    //
    //        make.top.offset(NavBarHeight);
    //        make.right.offset(-SCRXFromX(10));
    //        make.width.offset(SCRXFromX(100));
    //        make.height.offset(SCRXFromX(90));
    //    }];
    
    @weakify(self);
    self.navBarView.chooseBlock = ^(NSInteger index) {
        @strongify(self);
        
        [self.scrollView setContentOffset:CGPointMake(SCREEN_WIDTH * index, 0)];
        [self addChildViewIndex:index];
        
        if (self.navBarView.isNeedWhite) {
            
            if (index == 2) {
                
//                if (self.goodsIndex > 0) {
//
//                    self.navBarView.isNeedWhite = NO;
//                }
            }
        } else {
            if (index < 2) {
                self.navBarView.isNeedWhite = YES;
            }
        }
    };
    
    //    self.addView.alertChooseBlock = ^(NSInteger index) {
    //
    //        @strongify(self);
    //        if (index == 0) {//短视频
    //
    //            [TMRouterInstance pushURL:@"TMUploadShortVideoVC" checkLogin:YES extraParams:nil];
    //        }else {//开直播
    //            if (![TMSharedUserInfo sharedInstance].isLogined) {
    //                [TMRouterInstance pushURL:@"TMLoginMobileVC" extraParams:nil];
    //                UIButton *button = (UIButton *)[self.addBgView.subviews lastObject];
    //                [self addBgButtonClick:button];
    //                return;
    //            }
    //            NSInteger auditStatus = [TMSharedUserInfo sharedInstance].userInfo.auditStatus;
    //            switch (auditStatus) {
    //                case -1:
    //                {
    //                    // 未申请
    //                    [TMCustomAlertView showAlertWithTitle:@"" content:@"你还不是主播，是否申请成为主播" cancelTitle:@"取消" sureTitle:@"确定" cancelHandler:^{
    //
    //                    } confirmHandler:^{
    //
    //                        [TMRouterInstance pushURL:@"TMBecomeAnchorVC"];
    //                    }];
    //                }
    //                    break;
    //                case 2:
    //                {
    //                    // 不通过
    //                    [TMRouterInstance pushURL:@"TMAuditInfomationVC" extraParams:@{@"auditType":[NSNumber numberWithInt:1]}];
    //                }
    //                    break;
    //                case 0:
    //                {
    //                    // 已发起
    //                    [TMRouterInstance pushURL:@"TMAuditInfomationVC" extraParams:@{@"auditType":[NSNumber numberWithInt:1]}];
    //                }
    //                    break;
    //                case 1:
    //                {
    //                    // 通过
    //                    [TMRouterInstance pushURL:@"TMCreateForeShowVC" checkLogin:YES extraParams:@{}];
    //                }
    //                    break;
    //                default:
    //                    break;
    //            }
    //        }
    //        UIButton *button = (UIButton *)[self.addBgView.subviews lastObject];
    //        [self addBgButtonClick:button];
    //    };
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:[NSNumber numberWithInt:0] forKey:@"ShortVideoIndex"];
    [param setObject:[NSNumber numberWithInt:0] forKey:@"IsFollow"];
    
    self.view.backgroundColor = NavBlackColor;
}

- (void)createSubView:(NSArray *)livegroup {
    [self addScrollView];
    NSMutableArray *lives = [[NSMutableArray alloc] init];
    [lives addObject:@{ @"groupName": @"关注", @"tabType": @"1", @"groupType": @"1" }];
    [lives addObject:@{ @"groupName": @"直播", @"tabType": @"2", @"groupType": @"1" }];
    [lives addObject:@{ @"groupName": @"短视频", @"tabType": @"2", @"groupType": @"2" }];
    if (livegroup.count) {
        [lives addObjectsFromArray:livegroup];
    }
    self.tabbarTitleArray = lives;
}

- (void)addScrollView {
    
    [self.view addSubview:self.scrollView];
    [self.view addSubview:self.navBarView];
    [self.scrollView addSubview:self.conatinerView];
 
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.offset(0);
        make.bottom.offset(0);
    }];
    [self.conatinerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
        make.height.equalTo(self.scrollView);
        make.width.equalTo(self.scrollView);
    }];
}

- (void)addChildViewIndex:(NSInteger)index {
    
    self.selectIndex = index;
    if (index < self.tabbarTitleArray.count) {
        if ([self.chirdVCAddTagDic objectForKey:@(index)]) {

            if (index == 0) {

//                if (self.isReloadFocus) {
//
//                    self.isReloadFocus = NO;
//
//                    for (TMShortVideoPlayerVC *vc in self.childViewControllers) {
//
//                        if ([vc isKindOfClass:[TMShortVideoPlayerVC class]]) {
//
//                            if (vc.IsFollow == 1) {
//
//                                [vc reloadData];
//
//                            }
//                        }
//                    }
//                }
            }
//            if (index < 2) {
//
//                for (TMShortVideoPlayerVC *vc in self.childViewControllers) {
//
//                    if ([vc isKindOfClass:[TMShortVideoPlayerVC class]]) {
//
//                        vc.isClose = [TMVideoSettingTool sharedTools].isClose;
//                    }
//                }
//            }
            return;
        }
        @weakify(self);
        if (index == 0) {//关注

            NSDictionary *params = @{@"shortVideoId": @"",
                                     @"shortVideoIndex": @(0),
                                     @"IsFollow": @(1),
                                     @"isHome":@(1),
                                     @"IsOwn":@(0),
                                     @"currentShowIndex":@(1)};
            KJShortVideoPlayerVC *childVC = [[KJShortVideoPlayerVC alloc] initWithParams:params];
            [self addChildViewController:childVC];
            [self.conatinerView addSubview:childVC.view];
//            childVC.scrollBeginDragin = ^{
//                @strongify(self);
//                if (!self.hiddenPull) {
//
//                    self.hiddenPull = YES;
//                    [UIView animateWithDuration:0.2 animations:^{
//
//                        [self.pullView mas_updateConstraints:^(MASConstraintMaker *make) {
//
//                            make.right.offset(45);
//                        }];
//                        [self.view layoutIfNeeded];
//                    }];
//                }
//            };
            childVC.view.tag = index;
            [childVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.offset(SCREEN_WIDTH * index);
                make.top.offset(0);
                make.width.offset(SCREEN_WIDTH);
                make.height.offset(SCREEN_HEIGHT);
            }];
        } else if (index == 1) {//看看
            NSDictionary *params = @{@"shortVideoId": @"",
                                     @"shortVideoIndex": @(0),
                                     @"IsFollow": @(0),
                                     @"isHome":@(1),
                                     @"IsOwn":@(0),
                                     @"currentShowIndex":@(1),
                                     @"IsSlide":@(1),
                                     @"isHomeVideo":@(1)};
            KJShortVideoPlayerVC *childVC = [[KJShortVideoPlayerVC alloc] initWithParams:params];
            [self addChildViewController:childVC];
            [self.conatinerView addSubview:childVC.view];
            childVC.view.tag = index;
//            childVC.scrollBeginDragin = ^{
//                @strongify(self);
//                if (!self.hiddenPull) {
//
//                    self.hiddenPull = YES;
//                    [UIView animateWithDuration:0.2 animations:^{
//
//                        [self.pullView mas_updateConstraints:^(MASConstraintMaker *make) {
//
//                            make.right.offset(45);
//                        }];
//                        [self.view layoutIfNeeded];
//                    }];
//                }
//            };
            [childVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.offset(SCREEN_WIDTH * index);
                make.top.offset(0);
                make.width.offset(SCREEN_WIDTH);
                make.height.offset(SCREEN_HEIGHT);
            }];
        } else {
//
//            void (^switchIndexBlock)(NSInteger index) = ^(NSInteger index) {
//                @strongify(self);
//                if (index >0) {
//
//                    self.navBarView.isNeedWhite = NO;
//                }else {
//
//                    self.navBarView.isNeedWhite = YES;
//                }
//                self.goodsIndex = index;
//            };
//            void (^homeScrollIsEnable)(BOOL isEnable) = ^(BOOL isEnable) {
//
//                self.scrollView.scrollEnabled = isEnable;
//            };
//            TMHomeGoodsVC *vc = [[TMHomeGoodsVC alloc] initWithParams:@{@"switchIndexBlock":switchIndexBlock,@"homeScrollIsEnable":homeScrollIsEnable}];
//            [self addChildViewController:vc];
//            [self.conatinerView addSubview:vc.view];
//            vc.scrollBeginDragin = ^{
//                @strongify(self);
//                if (!self.hiddenPull) {
//
//                    self.hiddenPull = YES;
//                    [UIView animateWithDuration:0.2 animations:^{
//
//                        [self.pullView mas_updateConstraints:^(MASConstraintMaker *make) {
//
//                            make.right.offset(45);
//                        }];
//                        [self.view layoutIfNeeded];
//                    }];
//                }
//            };
//            [vc.view mas_makeConstraints:^(MASConstraintMaker *make) {
//
//                make.top.offset(0);
//                make.left.offset(SCREEN_WIDTH * index);
//                make.height.offset(SCREEN_HEIGHT);
//                make.width.offset(SCREEN_WIDTH);
//            }];
        }

        [self.chirdVCAddTagDic setObject:@(YES) forKey:@(index)];
    }
}

- (void)setSelectIndex:(NSInteger)selectIndex
{
    _selectIndex = selectIndex;
    if (selectIndex < 2) {
        
        self.view.backgroundColor = MainBlackColor;
    } else {
        
        self.view.backgroundColor = [UIColor whiteColor];
    }
    
//    if (selectIndex == 2 && self.goodsIndex >0) {
//
//          [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDarkContent;
//    } else {
//        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
//    }
}

//设置字体颜色
- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)settingTabbar {
    if (self.tabbarTitleArray.count == 0) {
        return;
    }
//    NSMutableArray *tabTitleArray = [[NSMutableArray alloc] init];
//
//    for (NSDictionary *obj in self.tabbarTitleArray) {
//
//        [tabTitleArray addObject:[obj safeStringForKey:@"groupName"]];
//    }
//    self.tabbarView.tabTitleArray = tabTitleArray;
    @weakify(self);
    [self.conatinerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.height.offset(SCREEN_HEIGHT);
        make.width.offset(SCREEN_WIDTH * self.tabbarTitleArray.count);
        make.left.offset(0);
        make.centerY.equalTo(self.scrollView);
    }];
    self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH *self.tabbarTitleArray.count, 0);
    [self.scrollView setContentOffset:CGPointMake(SCREEN_WIDTH, 0)];
    [self addChildViewIndex:1];
    [self addChildViewIndex:2];
    [self.navBarView setPage:1];
}


#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == self.scrollView) {
        NSInteger page = (NSInteger)(scrollView.contentOffset.x / scrollView.frame.size.width);
        [self.navBarView setPage:page];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == self.scrollView) {
        
        NSInteger page = (NSInteger)((scrollView.contentOffset.x +scrollView.frame.size.width -1) / scrollView.frame.size.width);
        [self addChildViewIndex:page];
//        [[NSNotificationCenter defaultCenter] postNotificationName:kHomePlayForIndex object:[NSNumber numberWithInteger:page]];
    }
}

#pragma mark - KJHomeHeadChooseViewDelegate
- (void)homeHeadChooseViewButtonClick:(NSInteger)index
{
    if (index == 3) {//直播
        [KJRouterInstance pushURL:@"KJLiveStreamingPlayerVC"];
    } else if (index == 4) {//搜索
//        [TMRouterInstance pushURL:@"TMSearchVC"];
    } else {//我的
        
//        if (![TMSharedUserInfo sharedInstance].isLogined) {
//            [TMRouterInstance pushURL:@"TMLoginMobileVC" extraParams:nil];
//            return;
//        }
//        [KJRouterInstance pushURL:@"TMPersonCenterVC"];
    }
}

#pragma mark - setter
- (void)setTabbarTitleArray:(NSArray *)tabbarTitleArray {
    _tabbarTitleArray = tabbarTitleArray;
    [self settingTabbar];
}

#pragma mark - getter

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.tag = 10;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.bounces = NO;
        _scrollView.pagingEnabled = YES;
        _scrollView.delegate = self;
    }
    return _scrollView;
}

- (UIView *)conatinerView {
    if (!_conatinerView) {
        _conatinerView = [[UIView alloc] init];
    }
    return _conatinerView;
}

- (KJHomeHeadChooseView *)navBarView
{
    if (!_navBarView) {
        _navBarView = [[KJHomeHeadChooseView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NavBarHeight)];
        _navBarView.delegate = self;
    }
    return _navBarView;
}

- (NSMutableDictionary *)chirdVCAddTagDic {
    if (!_chirdVCAddTagDic) {
        _chirdVCAddTagDic = [[NSMutableDictionary alloc] init];
    }
    return _chirdVCAddTagDic;
}

@end
