//
//  KJHomeHostModelView.h
//  KJShopping
//
//  Created by TigerHu on 2024/9/16.
//

#import <UIKit/UIKit.h>

@class KJHomeHostInfo;

@protocol KJHomeHostModelViewDelegate <NSObject>

- (void)homeHostModelViewButtonClick:(NSInteger)index;

@end

@interface KJHomeHostModelView : UIView

@property (nonatomic, strong) UIView *imageBgView;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *statusLabel;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIButton *hostButton;

@property (nonatomic, weak) id <KJHomeHostModelViewDelegate> delegate;

@property (nonatomic, strong) KJHomeHostInfo *info;

@property (nonatomic, assign) BOOL isStartAnimation;

- (void)startAnimationForLive:(BOOL)isStart;

@end
