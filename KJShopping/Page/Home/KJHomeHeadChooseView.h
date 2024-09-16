//
//  KJHomeHeadChooseView.h
//  KJShopping
//
//  Created by TigerHu on 2024/4/20.
//

#import <UIKit/UIKit.h>

@protocol KJHomeHeadChooseViewDelegate <NSObject>

- (void)homeHeadChooseViewButtonClick:(NSInteger)index;

@end

@interface KJHomeHeadChooseView : UIView

@property (nonatomic, strong) UIView *mainView;

/** 直播*/
@property (nonatomic, strong) UIImageView *liveImageView;
@property (nonatomic, strong) UIButton *liveButton;
/** 关注*/
@property (nonatomic, strong) UILabel *focusLabel;
@property (nonatomic, strong) UIButton *focusButton;
/** 看看*/
@property (nonatomic, strong) UILabel *videoLabel;
@property (nonatomic, strong) UIButton *videoButton;
/** 商品*/
@property (nonatomic, strong) UILabel *goodsLabel;
@property (nonatomic, strong) UIButton *goodsButton;
/** 滑块*/
@property (nonatomic, strong) UILabel *slider;
/** 搜索*/
@property (nonatomic, strong) UIImageView *searchImageView;
@property (nonatomic, strong) UIButton *searchButton;
/** 我的*/
@property (nonatomic, strong) UIImageView *myImageView;
@property (nonatomic, strong) UIButton *myButton;

@property (nonatomic, strong) UIView *alertBgView;

@property (nonatomic, weak) id <KJHomeHeadChooseViewDelegate> delegate;

@property (nonatomic, copy) void (^chooseBlock)(NSInteger index);

@property (nonatomic, assign) NSInteger currentIndex;

@property (nonatomic, assign) BOOL isNeedWhite;

- (void)setPage:(NSInteger)index;

@end
