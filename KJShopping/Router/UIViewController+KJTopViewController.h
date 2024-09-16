//
//  UIViewController+KJTopViewController.h
//  KJShopping
//
//  Created by TigerHu on 2024/4/22.
//

#import <UIKit/UIKit.h>

@interface UIViewController (KJTopViewController)

/**
 获取当前程序的最顶层ViewController
 
 @return ViewController
 */
+ (UIViewController *)topViewController;

@end
