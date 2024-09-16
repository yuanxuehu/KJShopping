//
//  KJShowMessage.m
//  KJShopping
//
//  Created by TigerHu on 2024/4/22.
//

#import "KJShowMessage.h"
#import "UIView+Toast.h"
#import <HexColors/HexColors.h>

@interface KJShowMessage ()
@property (strong, nonatomic) UIWindow *topNavView;
@property (strong, nonatomic) NSString *showMessage;
@property (nonatomic, assign) NSTimeInterval showedErrorTime;
@end

@implementation KJShowMessage

+ (instancetype)sharedInstance
{
    static KJShowMessage *message;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        message = [[self alloc] init];
    });
    return message;
}

+ (BOOL)showMessage:(NSString *)message
{
    if (IsNotNilAndEmpty(message)) {
        if ([message isEqualToString:[KJShowMessage sharedInstance].showMessage]) {
            return NO;
        }

        NSTimeInterval curTime = [[NSDate date] timeIntervalSince1970];
        if (![KJShowMessage sharedInstance].showedErrorTime) {
            [KJShowMessage sharedInstance].showedErrorTime = curTime;
        }

        if (curTime - [KJShowMessage sharedInstance].showedErrorTime >= 3 || curTime == [KJShowMessage sharedInstance].showedErrorTime) { // 3秒内 不重复弹网络错误提示
            [KJShowMessage sharedInstance].showedErrorTime = curTime;

            [KJShowMessage sharedInstance].showMessage = message;
            CSToastStyle *style = [CSToastManager sharedStyle];
            style.backgroundColor = [UIColor colorWithHexString:@"000000" alpha:0.6];
            if ([[[UIApplication sharedApplication] delegate] window] == nil) { //防止为view为nil不能展示信息时，之后show相同错误无法展示
                [KJShowMessage sharedInstance].showMessage = nil;
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[[[UIApplication sharedApplication] delegate] window] makeToast:message duration:2.f position:CSToastPositionCenter title:nil image:nil style:style completion:^(BOOL didTap) {
                        [KJShowMessage sharedInstance].showMessage = nil;
                    }];
                });
                return YES;
            }
        }
    }
    return NO;
}


+ (BOOL)showAnimationMessage:(NSString *)message parentView:(UIView *)parentView
{
    if (IsNotNilAndEmpty(message)) {
        if ([message isEqualToString:[KJShowMessage sharedInstance].showMessage]) {
            return NO;
        }

        NSTimeInterval curTime = [[NSDate date] timeIntervalSince1970];
        if (![KJShowMessage sharedInstance].showedErrorTime) {
            [KJShowMessage sharedInstance].showedErrorTime = curTime;
        }

        if (curTime - [KJShowMessage sharedInstance].showedErrorTime >= 2.8 || curTime == [KJShowMessage sharedInstance].showedErrorTime) {
            [KJShowMessage sharedInstance].showedErrorTime = curTime;

            [KJShowMessage sharedInstance].showMessage = message;

            if (parentView == nil || [UIViewController topViewController].view == nil) { //防止为view为nil不能展示信息时，之后show相同错误无法展示
                [KJShowMessage sharedInstance].showMessage = nil;
            } else {
                [self animationMessage:message parentView:parentView];
                return YES;
            }
        }
    }
    return NO;
}

+ (void)animationMessage:(NSString *)message parentView:(UIView *)parentView
{
    UIView *borderView = [[UIView alloc] init];
    borderView.backgroundColor = HexColor(@"2A84F8");
    borderView.layer.cornerRadius = 16.0f;
    borderView.layer.masksToBounds = YES;

    UILabel *messageLabel = [[UILabel alloc] init];
    messageLabel.font = [UIFont systemFontOfSize:12.0f];
    messageLabel.textAlignment = NSTextAlignmentCenter;
    messageLabel.textColor = [UIColor whiteColor];
    messageLabel.text = message;
    [borderView addSubview:messageLabel];
    [messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(borderView).offset(9);
        make.bottom.equalTo(borderView).offset(-9);
        make.left.equalTo(borderView).offset(18);
        make.right.equalTo(borderView).offset(-18);
    }];

    if (parentView) {
        [parentView addSubview:borderView];
    } else {
        if ([UIViewController topViewController].view) {
            [[UIViewController topViewController].view addSubview:borderView];
        } else {
            return;
        }
    }

    [borderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(borderView.superview).offset(-90);
        make.centerX.equalTo(borderView.superview);
    }];

    borderView.alpha = 0.0;

    [borderView.superview layoutIfNeeded];

    [UIView animateWithDuration:0.3 animations:^{
        [borderView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(borderView.superview).offset(-45);
            make.centerX.equalTo(borderView.superview);
        }];
        borderView.alpha = 1.0;
        [borderView.superview layoutIfNeeded];

    } completion:^(BOOL finished) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:1.0 animations:^{

                [borderView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.centerY.equalTo(borderView.superview).offset(-90);
                    make.centerX.equalTo(borderView.superview);
                }];
                borderView.alpha = 0.0;
                [borderView.superview layoutIfNeeded];

            } completion:^(BOOL finished) {
                [KJShowMessage sharedInstance].showMessage = nil;
            }];

        });
    }];
}
+ (void)showMessage:(NSString *)message completion:(void (^)(BOOL didTap))completion
{
    [[UIViewController topViewController].view makeToast:message duration:1.5f position:CSToastPositionCenter title:nil image:nil style:nil completion:completion];
}

+ (void)showAlertMessage:(NSString *)message title:(NSString *)title cancelButtonTitle:(NSString *)cancelButtonTitle
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:cancelButtonTitle otherButtonTitles:nil];

    [alertView show];
}


- (void)showBlackMessage:(id)message title:(NSString *)title
{
    [self showBlackMessage:message title:title completion:NULL];
}

- (void)showBlackMessage:(id)message title:(NSString *)title completion:(void (^)(void))completion
{
    [[UIViewController topViewController].view endEditing:YES];

    if (!IsNotNilAndEmpty(message) || !IsNotNilAndEmpty(title)) {
        return;
    }

    self.topNavView = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.topNavView.windowLevel = UIWindowLevelAlert - 1;
    self.topNavView.rootViewController = [UIViewController topViewController].navigationController;
    [self.topNavView makeKeyAndVisible];
    NSAssert(self.topNavView != nil, @"");

    __block UIView *blackView = [[UIView alloc] init];
    [self.topNavView addSubview:blackView];
    blackView.backgroundColor = [UIColor colorWithHexString:@"000000" alpha:0.83];
    [blackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(blackView.superview);
    }];

    blackView.alpha = 0;
    [UIView animateWithDuration:0.4 animations:^{
        blackView.alpha = 1;
    }];

    UITapGestureRecognizer *tapGz = [[UITapGestureRecognizer alloc] init];
    [blackView addGestureRecognizer:tapGz];
    [tapGz.rac_gestureSignal subscribeNext:^(id x){
        //屏蔽后面的操作
    }];


    UILabel *titleLabel = [[UILabel alloc] init];
    [blackView addSubview:titleLabel];
    titleLabel.textColor = HexColor(@"ffffff");
    titleLabel.font = [UIFont systemFontOfSize:18];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(blackView.superview);
        make.top.equalTo(blackView.superview).offset(107);
        make.height.offset(30);
    }];
    titleLabel.text = title;

    UIView *separator = [[UIView alloc] init];
    [blackView addSubview:separator];
    separator.backgroundColor = HexColor(@"ffffff");
    [separator mas_makeConstraints:^(MASConstraintMaker *make) {
//        if ([TMSDiOSVersion deviceSize] == Screen4inch || [TMSDiOSVersion deviceSize] == Screen3Dot5inch) {
//            make.left.equalTo(separator.superview).offset(20);
//            make.right.equalTo(separator.superview).offset(-20);
//        } else {
            make.left.equalTo(separator.superview).offset(39);
            make.right.equalTo(separator.superview).offset(-39);
//        }
        make.height.offset(0.5);
        make.top.equalTo(titleLabel.mas_bottom).offset(17);
    }];

    UIButton *closeBtn = [[UIButton alloc] init];
    [blackView addSubview:closeBtn];
    [closeBtn setImage:[UIImage imageNamed:@"lost_off"] forState:UIControlStateNormal];
    [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(closeBtn.superview);
        make.bottom.equalTo(closeBtn.superview).offset(-69);
    }];

    @weakify(self);
    [[closeBtn rac_signalForControlEvents:UIControlEventTouchUpInside]
        subscribeNext:^(id x) {
            @strongify(self);
            [UIView animateWithDuration:0.4 animations:^{
                blackView.alpha = 0;
            } completion:^(BOOL finished) {
                //                [blackView removeFromSuperview];
                //                blackView = nil;
                self.topNavView.hidden = YES;
                [self.topNavView resignKeyWindow];
                self.topNavView = nil;
                if (completion) {
                    completion();
                }
            }];
        }];


    UITextView *messageLebal = [[UITextView alloc] init];
    [blackView addSubview:messageLebal];
    messageLebal.textColor = HexColor(@"ffffff");
    messageLebal.font = [UIFont systemFontOfSize:14];
    if ([message isKindOfClass:[NSAttributedString class]]) {
        messageLebal.attributedText = message;
    } else {
        messageLebal.text = message;

        // 调整行间距
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:message];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];

        paragraphStyle.lineHeightMultiple = 1.5; //行间距是多少倍

        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [message length])];
        [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, [message length])];
        [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, [message length])];
        messageLebal.attributedText = attributedString;
    }

    messageLebal.backgroundColor = [UIColor clearColor];

    //iphoneX上messageLabel 下面设置与布局有异常冲突
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        messageLebal.editable = NO;
        for (UIGestureRecognizer *recognizer in messageLebal.gestureRecognizers) {
            if ([recognizer isKindOfClass:[UITapGestureRecognizer class]] || [recognizer isKindOfClass:[UILongPressGestureRecognizer class]] || [recognizer isKindOfClass:NSClassFromString(@"UITextTapRecognizer")] || [recognizer isKindOfClass:NSClassFromString(@"UITapAndAHalfRecognizer")]) {
                recognizer.enabled = NO;
            }
        }
    });

    [messageLebal mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(separator.mas_bottom).offset(21);
        make.bottom.equalTo(closeBtn.mas_top).offset(-10);

//        if ([TMSDiOSVersion deviceSize] == Screen4inch || [TMSDiOSVersion deviceSize] == Screen3Dot5inch) {
//            make.left.equalTo(blackView.superview).offset(30);
//            make.right.equalTo(blackView.superview).offset(-30);
//        } else {
            make.left.equalTo(blackView.superview).offset(60);
            make.right.equalTo(blackView.superview).offset(-60);
//        }
    }];
}

@end
