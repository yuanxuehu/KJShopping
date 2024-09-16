//
//  UIViewController+PVCMotal.h
//  KJShopping
//
//  Created by TigerHu on 2024/4/22.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,PVCDirection)
{
    PVCDirectionCenter = 0,
    PVCDirectionTop,
    PVCDirectionLeft,
    PVCDirectionRight,
    PVCDirectionBottom
};

typedef void(^PresentCompletion)(void);

@interface UIViewController (PVCDirection)

- (void)presentViewController:(UIViewController *)viewController inSize:(CGSize)size direction:(PVCDirection)direction completion:(PresentCompletion)completion;

@end
