//
//  UIViewController+KJTopViewController.m
//  KJShopping
//
//  Created by TigerHu on 2024/4/22.
//

#import "UIViewController+KJTopViewController.h"

@implementation UIViewController (KJTopViewController)

+ (UIViewController *)topViewController
{
    UIViewController *rootViewController = [UIApplication sharedApplication].windows.firstObject.rootViewController;
    return [[UIViewController class] topViewControllerOfViewController:rootViewController];
}

+ (UIViewController *)topViewControllerOfViewController:(nullable UIViewController *)viewController
{
    if ([viewController isKindOfClass:[UITabBarController class]]) {
        UIViewController *selectedViewController = ((UITabBarController *)viewController).selectedViewController;
        return [UIViewController topViewControllerOfViewController:selectedViewController];
    }
    
    if ([viewController isKindOfClass:[UINavigationController class]]) {
        UIViewController *visibleViewController = ((UINavigationController *)viewController).visibleViewController;
        return [UIViewController topViewControllerOfViewController:visibleViewController];
    }
    
    if (viewController.presentedViewController) {
        return [UIViewController topViewControllerOfViewController:viewController.presentedViewController];
    }
    
    for (UIView *subView in viewController.view.subviews) {
        id childViewController = subView.nextResponder;
        if ([childViewController isKindOfClass:[UIViewController class]]) {
            return [UIViewController topViewControllerOfViewController:childViewController];
        }
    }
    
    return viewController;
}

@end
