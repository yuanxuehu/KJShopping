//
//  UIViewController+PVCMotal.m
//  KJShopping
//
//  Created by TigerHu on 2024/4/22.
//

#import "UIViewController+PVCMotal.h"
#import <objc/message.h>

@interface PVCPresentAnimation : NSObject<UIViewControllerAnimatedTransitioning>

@property (nonatomic, assign, getter=isPresentation) BOOL presentation;
@property (nonatomic, assign)PVCDirection direction;

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext;

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext;

@end

@implementation PVCPresentAnimation

+ (instancetype)presentAnimationWithDirection:(PVCDirection)direction isPresentation:(BOOL)isPresentation
{
    PVCPresentAnimation * presentAnimation = [[PVCPresentAnimation alloc] init];
    presentAnimation.direction = direction;
    presentAnimation.presentation = isPresentation;
    return presentAnimation;
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext;
{
    return 0.3;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    //1
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];

    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    //2
    CGRect backRect = transitionContext.containerView.bounds;
    if (self.presentation && toVC.view) {
        UIView * backView = [[UIView alloc] initWithFrame:backRect];
        backView.backgroundColor = [UIColor blackColor];
        backView.alpha = 0.5;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:fromVC action:@selector(dismissViewController)];
        [backView addGestureRecognizer:tap];
        [[transitionContext containerView] addSubview:backView];
        [[transitionContext containerView] addSubview:toVC.view];
    }
   
    CGSize finalSize = self.presentation? toVC.preferredContentSize:fromVC.preferredContentSize;
    
    CGFloat final_X=0,final_Y=0;
    switch (self.direction) {
        case PVCDirectionCenter:
        {
            final_X = (CGRectGetWidth(backRect)-finalSize.width)/2.0;
            final_Y = (CGRectGetHeight(backRect)-finalSize.height)/2.0;
        }
            break;
        case PVCDirectionTop:
        {
            final_X = (CGRectGetWidth(backRect)-finalSize.width)/2.0;
            final_Y = 0;
        }
            break;
        case PVCDirectionLeft:
        {
            final_X = 0;
            final_Y = (CGRectGetHeight(backRect)-finalSize.height)/2.0;
        }
            break;
        case PVCDirectionRight:
        {
            final_X = (CGRectGetWidth(backRect)-finalSize.width);
            final_Y = (CGRectGetHeight(backRect)-finalSize.height)/2.0;
        }
            break;
        case PVCDirectionBottom:
        {
            final_X = (CGRectGetWidth(backRect)-finalSize.width)/2.0;
            final_Y = (CGRectGetHeight(backRect)-finalSize.height);
        }
            break;
            
        default:
            break;
    }
    CGRect finalRect = CGRectMake(final_X, final_Y, finalSize.width, finalSize.height);

    
    UIView * animationView = self.presentation?toVC.view:fromVC.view;
    NSInteger count = transitionContext.containerView.subviews.count;
    UIView *alphaView = transitionContext.containerView.subviews[count-2];
    alphaView.alpha = self.presentation?0:0.2;
    //3
    switch (self.direction) {
        case PVCDirectionCenter:
        {
            animationView.frame = self.presentation?CGRectOffset(finalRect, 0,[UIScreen mainScreen].bounds.size.height-final_Y):finalRect;
        }
            break;
        case PVCDirectionTop:
        {
            animationView.frame = self.presentation?CGRectOffset(finalRect, 0,finalSize.height*(-1)):finalRect;
        }
            break;
        case PVCDirectionLeft:
        {
            animationView.frame = self.presentation?CGRectOffset(finalRect, finalSize.width*(-1),0):finalRect;
        }
            break;
        case PVCDirectionRight:
        {
            animationView.frame = self.presentation?CGRectOffset(finalRect, finalSize.width,0):finalRect;
        }
            break;
        case PVCDirectionBottom:
        {
            animationView.frame = self.presentation?CGRectOffset(finalRect, 0, finalSize.height):finalRect;
        }
            break;
            
        default:
            break;
    }

    [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        switch (self.direction) {
            case PVCDirectionCenter:
            {
                animationView.frame = self.presentation?finalRect:CGRectOffset(finalRect, 0,[UIScreen mainScreen].bounds.size.height-final_Y);
            }
                break;
            case PVCDirectionTop:
            {
                animationView.frame = self.presentation?finalRect:CGRectOffset(finalRect, 0,finalSize.height*(-1));
            }
                break;
            case PVCDirectionLeft:
            {
                animationView.frame = self.presentation?finalRect:CGRectOffset(finalRect, finalSize.width*(-1),0);
            }
                break;
            case PVCDirectionRight:
            {
                animationView.frame = self.presentation?finalRect:CGRectOffset(finalRect, finalSize.width,0);
            }
                break;
            case PVCDirectionBottom:
            {
                animationView.frame = self.presentation?finalRect:CGRectOffset(finalRect, 0, finalSize.height);
            }
                break;
                
            default:
                break;
        }
        alphaView.alpha = self.presentation?0.2:0;
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:YES];

    }];
}

@end



@interface PVCTransitionDelegate : NSObject<UIViewControllerTransitioningDelegate>

@property (nonatomic, assign) PVCDirection direction;

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source;

@end

@implementation PVCTransitionDelegate

+ (instancetype)transtionDelegateWithDirection:(PVCDirection)direction
{
    PVCTransitionDelegate * delegate = [[PVCTransitionDelegate alloc] init];
    delegate.direction = direction;
    return delegate;
}

- (nullable id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source;
{
    return [PVCPresentAnimation presentAnimationWithDirection:self.direction isPresentation:YES];
}

- (nullable id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    return [PVCPresentAnimation presentAnimationWithDirection:self.direction isPresentation:NO];
}
@end

@implementation UIViewController (PMotal)

- (void)presentViewController:(UIViewController *)viewController inSize:(CGSize)size direction:(PVCDirection)direction completion:(PresentCompletion)completion;
{
    if (!viewController) {
        return;
    }
    
    viewController.modalPresentationStyle = UIModalPresentationCustom;
    viewController.preferredContentSize = size;
    PVCTransitionDelegate * transitionDelegate = [PVCTransitionDelegate transtionDelegateWithDirection:direction];
    viewController.transitioningDelegate = transitionDelegate;
    objc_setAssociatedObject(viewController, _cmd, transitionDelegate, OBJC_ASSOCIATION_RETAIN_NONATOMIC);

    [self presentViewController:viewController animated:YES completion:completion];
    
}

- (void)dismissViewController
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
