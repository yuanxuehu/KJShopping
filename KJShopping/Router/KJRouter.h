//
//  KJRouter.h
//  KJShopping
//
//  Created by TigerHu on 2024/4/22.
//

#import <Foundation/Foundation.h>
#import "UIViewController+PVCMotal.h"

#define KJRouterInstance [KJRouter sharedInstance]

@interface KJRouter : NSObject

/// 特殊跳转
@property (nonatomic, strong) NSString *routerScheme;

/// 跳转映射
@property (nonatomic, strong) NSDictionary *routerMap;

/// web类名
@property (nonatomic, strong) NSString *webName;

/// 原生host
@property (nonatomic, strong) NSString *nativeHost;


/// 外部判断特殊情况下不能跳转等（如已登录还跳转登录）
@property (nonatomic, copy) BOOL (^routerSpecialHandler)(NSString *pageCode, NSDictionary *params);

/// 外部处理未登录情况下跳转登录页面
@property (nonatomic, copy) BOOL (^routerCheckLoginHandler)(NSString *url, NSDictionary *params);

/// 外部处理跳转web情况
@property (nonatomic, copy) NSDictionary * (^routerWebParamsAssemblyHandler)(NSString *url, NSDictionary *params);

+ (instancetype)sharedInstance;

/**
 以push打开URL
 
 @param url 链接地址
 @return BOOL
 */
- (BOOL)pushURL:(NSString *)url;

/**
 以push打开URL
 
 @param url 链接地址
 @param extraParams 控制器的附加参数
 @return BOOL
 */
- (BOOL)pushURL:(NSString *)url extraParams:(NSDictionary *)extraParams;


/**
 以push打开URL
 
 @param url 链接地址
 @param checkLogin 是否需要判断登录
 @param extraParams 控制器的附加参数
 @return BOOL
 */
- (BOOL)pushURL:(NSString *)url checkLogin:(BOOL)checkLogin extraParams:(NSDictionary *)extraParams;


/**
 以push打开pageCode，特殊处理push同时移除前面视图控制器情况，无规则判断，只能传pageCode
 
 @param pageCode 跳转页面pageCode
 @param extraParams 控制器的附加参数
 @param number 需要移除视图控制器数量，移除栈尾
 @return BOOL
 */
- (BOOL)pushPage:(NSString *)pageCode extraParams:(NSDictionary *)extraParams removeViewControllerNum:(NSInteger)number;

/**
 以push打开pageCode，特殊处理push同时移除前面视图控制器情况，无规则判断，只能传pageCode
 
 @param pageCode 跳转页面pageCode
 @param extraParams 控制器的附加参数
 @param number 需要移除视图控制器数量，移除栈尾
 @param vcArray 需要移除视图控制器
 @return BOOL
 */
- (BOOL)pushPage:(NSString *)pageCode extraParams:(NSDictionary *)extraParams removeViewControllerNum:(NSInteger)number removeViewControllers:(NSArray *)vcArray;

/**
 返回
 
 @param animated 是否动画
 */
- (void)popToViewModelAnimated:(BOOL)animated;

- (void)popToRootViewModelAnimated:(BOOL)animated;

- (void)popNumberOfStack:(NSInteger)number animated:(BOOL)animated;
- (void)popViewControllers:(NSArray *)vcArray animated:(BOOL)animated;


/**
 以present打开pageCode
 
 @param pageCode 跳转页面pageCode
 @param extraParams 控制器的附加参数
 @return BOOL
 */
- (BOOL)presentPage:(NSString *)pageCode extraParams:(NSDictionary *)extraParams completion:(void (^)(void))completion;

/**
 关闭present视图
 @return BOOL
 */
- (BOOL)dismissPageWithCompletion:(void (^)(void))completion;


- (BOOL)dismissPageWithCompletion:(void (^)(void))completion animate:(BOOL)animate;

/**
 半屏弹出，使用系统动画
 */
- (void)presentHalfScreen:(NSString *)pageCode extraParams:(NSDictionary *)extraParams inSize:(CGSize)size direction:(PVCDirection)direction completion:(void (^)(void))completion;

/**
 半屏弹出，使用系统动画，包裹一层NavigationController
 */
- (void)presentNavigationHalfScreen:(NSString *)pageCode extraParams:(NSDictionary *)extraParams inSize:(CGSize)size direction:(PVCDirection)direction completion:(void (^)(void))completion;


/**
 打开alert等
 */
- (void)presentViewController:(UIViewController *)viewController completion:(void (^)(void))completion;

- (void)presentViewController:(UIViewController *)viewController animate:(BOOL)animate completion:(void (^)(void))completion;

@end
