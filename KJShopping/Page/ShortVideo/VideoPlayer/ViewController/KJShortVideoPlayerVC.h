//
//  KJShortVideoPlayerVC.h
//  KJShopping
//
//  Created by TigerHu on 2024/9/16.
//

#import "KJVC.h"

//短视频控制器VC，主要负责短视频容器和上下滑动
@interface KJShortVideoPlayerVC : KJVC

//短视频id(用于我的短视频播放详情)
@property (nonatomic, strong) NSString *shortVideoId;
//短视频下标识(从首页短视频列表带过来)
@property (nonatomic, assign) NSInteger shortVideoIndex;
//是否自己的短视频列表
//0:否 从首页短视频打开
//1:是 从我的短视频列表打开
@property (nonatomic, assign) NSInteger isOwn;
//是否为关注页面
//0:否
//1:是
@property (nonatomic, assign) NSInteger IsFollow;
//是否是首页和关注
//0:否
//1:是
@property (nonatomic, assign) NSInteger isHome;
//是否需要滑动
@property (nonatomic, assign) NSInteger IsSlide;
//查看用户短视频列表的用户ID
@property (nonatomic, copy) NSString *anchorId;
//小店进入
@property (nonatomic, assign) BOOL isStore;
//搜索字段
@property (nonatomic, copy) NSString *keyWord;
//父控制器当前显示索引
@property (nonatomic, assign) NSInteger currentShowIndex;
//是否是首页短视频
@property (nonatomic, assign) NSInteger isHomeVideo;
//展开、关闭
@property (nonatomic, assign) NSInteger isClose;

@property (nonatomic, copy) void(^changeFocusBlock)(BOOL focusStatus);
@property (nonatomic, copy) void (^lickVideo)(BOOL isLick);
@property (nonatomic, copy) void (^scrollBeginDragin)(void);

- (void)backPlay;
- (void)reloadData;

@end
