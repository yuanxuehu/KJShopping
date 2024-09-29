//
//  KJRouter.m
//  KJShopping
//
//  Created by TigerHu on 2024/4/22.
//

#import "KJRouter.h"
#import "KJVC.h"
#import <StoreKit/StoreKit.h>

@interface KJRouter () <SKStoreProductViewControllerDelegate>

@end

@implementation KJRouter

+ (instancetype)sharedInstance
{
    static KJRouter *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)initialize
{
    // 监听 WebViewModel、以及 转账充值 跳转 银行 App 的通知
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"openRouterUrl" object:nil]
     subscribeNext:^(NSNotification *noti) {
         [self openRouterUrlWithObject:noti.object];
     }];
}


#pragma mark - push模式
- (BOOL)pushURL:(NSString *)url
{
    return [self pushURL:url extraParams:nil];
}

- (BOOL)pushURL:(NSString *)url extraParams:(NSDictionary *)extraParams
{
    return [self pushURL:url checkLogin:NO extraParams:extraParams];
}

- (BOOL)pushURL:(NSString *)url checkLogin:(BOOL)checkLogin extraParams:(NSDictionary *)extraParams
{
    if (!IsNotNilAndEmpty(url)) {
        NSLog(@"跳转url为空");
        return NO;
    }
   
    if (self.routerCheckLoginHandler && checkLogin) {
        return self.routerCheckLoginHandler(url, extraParams);
    }
    
    if (IsNotNilAndEmpty(self.routerScheme) && [url hasPrefix:self.routerScheme]) { // 特殊处理
        return [self openRouterUrl:url];
    }
    
    if (![url hasPrefix:@"http://"] && ![url hasPrefix:@"https://"]) { // url为pagecode，直接跳转
        return [self openViewController:url params:extraParams removeViewControllerNum:0 removeViewControllers:nil];
    }
    
    if (IsNotNilAndEmpty(self.nativeHost) && [url containsString:self.nativeHost]) {
        return [self parseUrl:url extraParams:extraParams];
    }
    
    if (!IsNotNilAndEmpty(self.webName)) {
        return NO;
    }
    
    if (!self.routerWebParamsAssemblyHandler) {
        return NO;
    }
    
    NSDictionary *params = self.routerWebParamsAssemblyHandler(url, extraParams);
    return [self openViewController:self.webName params:params removeViewControllerNum:0 removeViewControllers:nil];
}


- (BOOL)pushPage:(NSString *)pageCode extraParams:(NSDictionary *)extraParams removeViewControllerNum:(NSInteger)number
{
    return [self pushPage:pageCode extraParams:extraParams removeViewControllerNum:number removeViewControllers:nil];
}


- (BOOL)pushPage:(NSString *)pageCode extraParams:(NSDictionary *)extraParams removeViewControllerNum:(NSInteger)number removeViewControllers:(NSArray *)vcArray {
    if (!IsNotNilAndEmpty(pageCode)) {
        NSLog(@"跳转pageCode为空");
        return NO;
    }
    
    return [self openViewController:pageCode params:extraParams removeViewControllerNum:number removeViewControllers:vcArray];
}

- (void)popToViewModelAnimated:(BOOL)animated
{
    UINavigationController *navigationViewController = [UIViewController topViewController].navigationController;
    if (navigationViewController) {
        [navigationViewController popViewControllerAnimated:animated];
    } else {
        NSLog(@"popToViewModelAnimated: navigationViewController为空");
    }
}

- (void)popToRootViewModelAnimated:(BOOL)animated
{
    UINavigationController *navigationViewController = [UIViewController topViewController].navigationController;
    if (navigationViewController) {
        [navigationViewController popToRootViewControllerAnimated:animated];
    } else {
        NSLog(@"popToRootViewModelAnimated: navigationViewController为空");
    }
}


- (void)popNumberOfStack:(NSInteger)number animated:(BOOL)animated
{
    UINavigationController *navigationViewController = [UIViewController topViewController].navigationController;
    if (number < 0) {
        [navigationViewController popViewControllerAnimated:animated];
        return;
    }
    if (navigationViewController.viewControllers.count <= number) {
        [navigationViewController popToRootViewControllerAnimated:animated];
        return;
    }
    [navigationViewController popToViewController:navigationViewController.viewControllers[navigationViewController.viewControllers.count - number - 1] animated:animated];
}

- (void)popViewControllers:(NSArray *)vcArray animated:(BOOL)animated
{
    UINavigationController *navigationViewController = [UIViewController topViewController].navigationController;
    if (vcArray.count == 0) {
        [navigationViewController popViewControllerAnimated:animated];
        return;
    }
    NSMutableArray <UIViewController *> *viewControllers = [[NSMutableArray alloc] init];
    for (UIViewController *vc in navigationViewController.viewControllers) {
        NSString *vcString = NSStringFromClass(vc.class);
        if ([vcArray containsObject:vcString]) {
            continue;
        }
        
        [viewControllers addObject:vc];
    }
    if (viewControllers.count == 0) {
        [navigationViewController popToRootViewControllerAnimated:animated];
        return;
    }
    [navigationViewController setViewControllers:viewControllers animated:YES];
}



#pragma mark - present模式
- (BOOL)presentPage:(NSString *)pageCode extraParams:(NSDictionary *)extraParams completion:(void (^__nullable)(void))completion
{
    KJVC *viewController = [self createViewController:pageCode params:extraParams];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:viewController];
    //用于转场动画，因为无法显式获得viewController的navigationController,因此子类如果需要转场效果，则自行实现transitioningDelegate中协议即可
    navController.transitioningDelegate = viewController.childViewControllers.lastObject;
    navController.modalPresentationStyle = UIModalPresentationFullScreen;
    
    UINavigationController *navigationViewController = [UIViewController topViewController].navigationController;
    [navigationViewController presentViewController:navController animated:YES completion:completion];
    return YES;
}

- (BOOL)dismissPageWithCompletion:(void (^__nullable)(void))completion
{
    UIViewController *topViewController = [UIViewController topViewController];
    UINavigationController *navigationViewController = topViewController.navigationController;
    if (navigationViewController.presentingViewController) {
        [navigationViewController.presentingViewController dismissViewControllerAnimated:YES completion:completion];
        return YES;
    } else {
        [topViewController.presentingViewController dismissViewControllerAnimated:YES completion:completion];
    }
    return NO;
}

- (BOOL)dismissPageWithCompletion:(void (^)(void))completion animate:(BOOL)animate
{
    UIViewController *topViewController = [UIViewController topViewController];
    UINavigationController *navigationViewController = topViewController.navigationController;
    if (navigationViewController.presentingViewController) {
        [navigationViewController.presentingViewController dismissViewControllerAnimated:animate completion:completion];
        return YES;
    } else {
        [topViewController.presentingViewController dismissViewControllerAnimated:animate completion:completion];
    }
    return NO;
}

- (void)presentViewController:(UIViewController *)viewController completion:(void (^)(void))completion
{
    if (!viewController) {
        return;
    }
    UINavigationController *navigationViewController = [UIViewController topViewController].navigationController;
    [navigationViewController presentViewController:viewController animated:YES completion:completion];
}

- (void)presentViewController:(UIViewController *)viewController animate:(BOOL)animate completion:(void (^)(void))completion
{
    if (!viewController) {
        return;
    }
    UINavigationController *navigationViewController = [UIViewController topViewController].navigationController;
    [navigationViewController presentViewController:viewController animated:animate completion:completion];
}

#pragma mark - 半屏弹窗
- (void)presentHalfScreen:(NSString *)pageCode extraParams:(NSDictionary *)extraParams inSize:(CGSize)size direction:(PVCDirection)direction completion:(void (^)(void))completion
{
    if (!IsNotNilAndEmpty(pageCode)) {
        NSLog(@"跳转pageCode为空");
        return;
    }
    KJVC *vc = [self createViewController:pageCode params:extraParams];
    if (!vc) {
        return;
    }
    UINavigationController *navigationViewController = [UIViewController topViewController].navigationController;
    [navigationViewController presentViewController:vc inSize:size direction:direction completion:completion];
}

- (void)presentNavigationHalfScreen:(NSString *)pageCode extraParams:(NSDictionary *)extraParams inSize:(CGSize)size direction:(PVCDirection)direction completion:(void (^)(void))completion
{
    if (!IsNotNilAndEmpty(pageCode)) {
        NSLog(@"跳转pageCode为空");
        return;
    }
    KJVC *vc = [self createViewController:pageCode params:extraParams];
    if (!vc) {
        return;
    }
    UINavigationController *presentNav = [[UINavigationController alloc] initWithRootViewController:vc];
    vc.fd_prefersNavigationBarHidden = YES;
    
    UINavigationController *navigationViewController = [UIViewController topViewController].navigationController;
    [navigationViewController presentViewController:presentNav inSize:size direction:direction completion:completion];
}

#pragma mark - 打开页面

/// 解析url
- (BOOL)parseUrl:(NSString *)url extraParams:(NSDictionary *)extraParams
{
    /**
     *  远程url格式 http://native.4g.ppmoney.com/%7B%27kind%27%3A%271%27%2C%27prjType%27%3A%27104025%27%2C%27prjModelType%27%3A%27%27%2C%27productId%27%3A%27%27%2C%27requestId%27%3A%27%27%2C%27jumpType%27%3A%273%27%7D?experienceDetail
     **/
    //去掉问号
    NSArray *urlParamsArray = [url componentsSeparatedByString:@"?"];
    NSString *lastParams = urlParamsArray.lastObject;
    NSArray *viewModelArray = [lastParams componentsSeparatedByString:@"/"];
    NSString *pageCode = viewModelArray.lastObject;
    
    if (IsNotNilAndEmpty(pageCode)) {
        NSMutableDictionary *paramsDic = nil;
        if (urlParamsArray.count == 2) {
            NSArray *paramsArray = [urlParamsArray.firstObject componentsSeparatedByString:@"/"];
            NSString *paramsString = paramsArray.lastObject;
            paramsString = [paramsString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            if ([paramsString hasPrefix:@"{"] && [paramsString hasSuffix:@"}"]) {
                paramsDic = [NSMutableDictionary dictionaryWithCapacity:0];
                paramsString = [paramsString stringByReplacingOccurrencesOfString:@"\'" withString:@"\""];
                NSError *error;
                NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:[paramsString dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:&error];
                if (jsonDic) {
                    [paramsDic addEntriesFromDictionary:jsonDic];
                }
                [paramsDic setObject:paramsString forKey:@"paramsString"];
            }
        }
        
        NSMutableDictionary *allParams = [[NSMutableDictionary alloc] initWithDictionary:extraParams];
        if (paramsDic && paramsDic.count) {
            [allParams addEntriesFromDictionary:paramsDic];
        }
        
        return [self openViewController:pageCode params:allParams removeViewControllerNum:0 removeViewControllers:nil];
    }
    NSLog(@"规则解析失败");
    return NO;
}


/// 打开链接
- (BOOL)openViewController:(NSString *)pageCode params:(NSDictionary *)params removeViewControllerNum:(NSInteger)number removeViewControllers:(NSArray *)vcArray
{
    KJVC *vc = [self createViewController:pageCode params:params];
    if (!vc) {
        return NO;
    }
    
    UINavigationController *navigationViewController = [UIViewController topViewController].navigationController;
    if (navigationViewController) {
        if (number > 0 && number < navigationViewController.viewControllers.count) {
            NSMutableArray *viewControllerArray = [NSMutableArray arrayWithArray:navigationViewController.viewControllers];
            [viewControllerArray removeObjectsInRange:NSMakeRange(navigationViewController.viewControllers.count - number, number)];
            [viewControllerArray addObject:vc];
            [navigationViewController setViewControllers:viewControllerArray animated:YES];
        } else if (vcArray.count) {
            NSMutableArray <UIViewController *> *viewControllers = [[NSMutableArray alloc] init];
            for (UIViewController *vc in navigationViewController.viewControllers) {
                NSString *vcString = NSStringFromClass(vc.class);
                if ([vcArray containsObject:vcString]) {
                    continue;
                }
                
                [viewControllers addObject:vc];
            }
            if (viewControllers.count == 0) {
                [viewControllers addObject:navigationViewController.viewControllers.firstObject];
            }
            [viewControllers addObject:vc];
            [navigationViewController setViewControllers:viewControllers animated:YES];
        } else {
            [navigationViewController pushViewController:vc animated:YES];
        }
        return YES;
    } else {
        NSLog(@"openViewController:params: navigationViewController为空");
    }
    
    return NO;
}

/// 生成视图控制器
- (KJVC *)createViewController:(NSString *)pageCode params:(NSDictionary *)params
{
    if (!IsNotNilAndEmpty(pageCode)) {
        return nil;
    }
    // 需要映射处理
    if (self.routerMap && IsNotNilAndEmpty([self.routerMap objectForKey:pageCode])) {
        pageCode = [self.routerMap objectForKey:pageCode];
    }
    
    // 外部判断特殊情况不能跳转
    if (self.routerSpecialHandler) {
        BOOL canOpen = self.routerSpecialHandler(pageCode, params);
        if (!canOpen) {
            return nil;
        }
    }
    
    
    Class cls = NSClassFromString(pageCode);
    if (!cls) {
        return nil;
    }
    
    NSParameterAssert([cls isSubclassOfClass:[KJVC class]]);
    NSParameterAssert([cls instancesRespondToSelector:@selector(initWithParams:)]);
    KJVC *vc = [[cls alloc] initWithParams:params];
    vc.hidesBottomBarWhenPushed = YES;
    return vc;
}

#pragma mark - 特殊跳转，打开App Store等
- (BOOL)openRouterUrl:(NSString *)url
{
    //@"router://openApp?app=PPmoneyHJF&inAppstore=905910288&safari=http://www.ppmoney.com/loan/index?utm_source=lcgw&source=loan";
    NSString *jsonString = [[url componentsSeparatedByString:@"openApp?"] lastObject];
    NSArray *keysArray = [jsonString componentsSeparatedByString:@"&"];
    NSDictionary *keyDictionary = [NSMutableDictionary dictionaryWithCapacity:0];
    for (NSString *keyString in keysArray) {
        NSString *key = [[keyString componentsSeparatedByString:@"="] firstObject];
        NSString *value = [[keyString componentsSeparatedByString:@"="] lastObject];
        [keyDictionary setValue:value forKey:key];
    }
    
    return [self openRouterUrlWithObject:keyDictionary];
}

- (BOOL)openRouterUrlWithObject:(NSDictionary *)keyDictionary
{
    if ([[keyDictionary objectForKey:@"app"] length] && [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:[keyDictionary objectForKey:@"app"]]]) {
        //如果用户手机装了目标app，直接从本app唤醒目标app
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[keyDictionary objectForKey:@"app"]]];
        return YES;
    } else if ([[keyDictionary objectForKey:@"inAppstore"] length]) {
        //应用内打开appstore
        SKStoreProductViewController *storeProductVC = [[SKStoreProductViewController alloc] init];
        storeProductVC.delegate = self;
        NSDictionary *dict = @{ SKStoreProductParameterITunesItemIdentifier : [keyDictionary objectForKey:@"inAppstore"] };
        [storeProductVC loadProductWithParameters:dict completionBlock:^(BOOL result, NSError *error) {
            if (result) {
                //跳转至详情页面
                [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:storeProductVC animated:YES completion:nil];
            }
        }];
        return YES;
    } else if ([[keyDictionary objectForKey:@"outAppstore"] length]) {
        //应用外打开appstore
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"itms-apps://itunes.apple.com/cn/app/id%@", [keyDictionary objectForKey:@"outAppstore"]]];
        if ([[UIApplication sharedApplication] canOpenURL:url]) {
            [[UIApplication sharedApplication] openURL:url];
            return YES;
        }
    } else {
        //其他非HTTP/HTTPS连接，以openURL方式打开
        for (id value in keyDictionary.allValues) {
            if ([value isKindOfClass:[NSString class]] && [value length]) {
                NSString *decodeUrl = [self URLDecodedString:value];
                if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", decodeUrl]]]) {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", decodeUrl]]];
                    return YES;
                }
            }
        }
    }
    return NO;
}

- (NSString *)URLDecodedString:(NSString *)str

{
    NSString *decodedString = (__bridge_transfer NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL, (__bridge CFStringRef)str, CFSTR(""), CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
    
    return decodedString;
}

#pragma mark SKStoreProductViewControllerDelegate
- (void)productViewControllerDidFinish:(SKStoreProductViewController *)viewController
{
    [viewController dismissViewControllerAnimated:YES completion:^{
       
    }];
}

@end

