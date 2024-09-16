//
//  KJHomeHeadChooseView.m
//  KJShopping
//
//  Created by TigerHu on 2024/4/20.
//

#import "KJHomeHeadChooseView.h"
//#import <SDWebImage/UIImage+GIF.h>

@implementation KJHomeHeadChooseView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setLayout];
    }
    return self;
}

#pragma mark - Layout
- (void)setLayout
{
    self.backgroundColor = [UIColor clearColor];

    CGFloat distanceX = SCRXFromX(15);
    [self.mainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.offset(0);
        make.height.offset(SYSTEM_NAV_BAR_HEIGHT);
    }];
    
    [self.videoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.height.offset(SCRXFromX(15));
        make.bottom.offset(-(SCRXFromX(5) +10));
    }];

    [self.videoButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.videoLabel.mas_top).offset(-SCRXFromX(5));
        make.left.equalTo(self.videoLabel.mas_left).offset(-SCRXFromX(5));
        make.right.equalTo(self.videoLabel.mas_right).offset(SCRXFromX(5));
        make.bottom.equalTo(self.videoLabel.mas_bottom).offset(SCRXFromX(5));
    }];

    [self.focusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.videoLabel.mas_bottom).offset(0);
        make.right.equalTo(self.videoLabel.mas_left).offset(-distanceX);
        make.height.offset(SCRXFromX(15));
    }];

    [self.focusButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.focusLabel.mas_top).offset(-SCRXFromX(5));
        make.left.equalTo(self.focusLabel.mas_left).offset(-SCRXFromX(5));
        make.right.equalTo(self.focusLabel.mas_right).offset(SCRXFromX(5));
        make.bottom.equalTo(self.focusLabel.mas_bottom).offset(SCRXFromX(5));
    }];

    [self.goodsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.videoLabel.mas_bottom).offset(0);
        make.left.equalTo(self.videoLabel.mas_right).offset(distanceX);
        make.height.offset(SCRXFromX(15));
    }];

    [self.goodsButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.goodsLabel.mas_top).offset(-SCRXFromX(5));
        make.left.equalTo(self.goodsLabel.mas_left).offset(-SCRXFromX(5));
        make.right.equalTo(self.goodsLabel.mas_right).offset(SCRXFromX(5));
        make.bottom.equalTo(self.goodsLabel.mas_bottom).offset(SCRXFromX(5));
    }];
    
    [self.liveImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(SCRXFromX(15));
        make.width.height.offset(SCRXFromX(40));
        make.bottom.offset(-5);
    }];

    [self.liveButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.offset(SCRXFromX(30));
        make.centerY.equalTo(self.liveImageView);
        make.centerX.equalTo(self.liveImageView);
    }];
    
    [self.myImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-SCRXFromX(15));
        make.width.height.offset(SCRXFromX(20));
        make.centerY.equalTo(self.videoLabel);
    }];

    [self.myButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.myImageView.mas_top).offset(-SCRXFromX(5));
        make.left.equalTo(self.myImageView.mas_left).offset(-SCRXFromX(5));
        make.right.equalTo(self.myImageView.mas_right).offset(SCRXFromX(5));
        make.bottom.equalTo(self.myImageView.mas_bottom).offset(SCRXFromX(5));
    }];
    
    [self.searchImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.myImageView.mas_left).offset(-SCRXFromX(15));
        make.width.height.offset(SCRXFromX(20));
        make.centerY.equalTo(self.videoLabel);
    }];
    
    [self.searchButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.searchImageView.mas_top).offset(-SCRXFromX(5));
        make.left.equalTo(self.searchImageView.mas_left).offset(-SCRXFromX(5));
        make.right.equalTo(self.searchImageView.mas_right).offset(SCRXFromX(5));
        make.bottom.equalTo(self.searchImageView.mas_bottom).offset(SCRXFromX(5));
    }];


    [self.slider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.offset(-7);
        make.width.offset(SCRXFromX(20));
        make.height.offset(SCRXFromX(2));
        make.centerX.equalTo(self.videoLabel);
    }];
    
    
    [self.alertBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.left.right.bottom.offset(0);
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideAlertBgView) name:@"隐藏遮罩" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showAlertBgView) name:@"显示遮罩" object:nil];
        
    self.isNeedWhite = YES;
}

- (void)setIsNeedWhite:(BOOL)isNeedWhite
{
    _isNeedWhite = isNeedWhite;
    
    if (isNeedWhite) {
    
//        NSData *gif = [NSData dataWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"liveLogo_white" ofType:@"gif"]];
//        self.liveImageView.image = [UIImage sd_imageWithGIFData:gif];
        self.searchImageView.image = UIImageName(@"navSearch_white");
        self.myImageView.image = UIImageName(@"navMine_white");
        self.focusLabel.textColor = [UIColor whiteColor];
        self.videoLabel.textColor = [UIColor whiteColor];
        self.goodsLabel.textColor = [UIColor whiteColor];
        self.slider.backgroundColor = [UIColor whiteColor];
        
    } else {
        
//        NSData *gif = [NSData dataWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"liveLogo_black" ofType:@"gif"]];
//        self.liveImageView.image = [UIImage sd_imageWithGIFData:gif];
        self.searchImageView.image = UIImageName(@"navSearch_black");
        self.myImageView.image = UIImageName(@"navMine_black");
        self.focusLabel.textColor = [UIColor blackColor];
        self.videoLabel.textColor = [UIColor blackColor];
        self.goodsLabel.textColor = [UIColor blackColor];
        self.slider.backgroundColor = [UIColor blackColor];
       
    }
}

- (void)setPage:(NSInteger)index
{
    self.currentIndex = index;
    
}

- (void)headChoose:(UIButton *)button
{
    if (button.tag < 3) {
        
        if (self.currentIndex != button.tag) {
            
            self.currentIndex = button.tag;
            
//            [[NSNotificationCenter defaultCenter] postNotificationName:kHomePlayForIndex object:[NSNumber numberWithInteger:button.tag]];
        }
    } else {
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(homeHeadChooseViewButtonClick:)]) {
            
            [self.delegate homeHeadChooseViewButtonClick:button.tag];
        }
    }
}

- (void)setCurrentIndex:(NSInteger)currentIndex
{
    _currentIndex = currentIndex;
    
    [self switchForSlider:currentIndex];
    
    if (self.chooseBlock) {
        self.chooseBlock(currentIndex);
    }
}

- (void)switchForSlider:(NSInteger)index
{
    CGFloat width = [KJCommonlyMethods calculateLengthOfText:@"推荐" font:SCRXFromX(18)].width;
    if (index == 0) {//关注
        
        [UIView animateWithDuration:0.2 animations:^{
            
            [self.slider mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.bottom.offset(-7);
                make.width.offset(width - SCRXFromX(20));
                make.height.offset(SCRXFromX(2));
                make.centerX.equalTo(self.focusLabel);
            }];
            
            self.focusLabel.alpha = 1;
            self.videoLabel.alpha = 0.6;
            self.goodsLabel.alpha = 0.6;
            [self layoutIfNeeded];
        }];
    } else if (index == 1) {//看看
        
        [UIView animateWithDuration:0.2 animations:^{
            
            [self.slider mas_remakeConstraints:^(MASConstraintMaker *make) {
                
                make.bottom.offset(-7);
                make.width.offset(width - SCRXFromX(20));
                make.height.offset(SCRXFromX(2));
                make.centerX.equalTo(self.videoLabel);
            }];

            self.focusLabel.alpha = 0.6;
            self.videoLabel.alpha = 1;
            self.goodsLabel.alpha = 0.6;
            [self layoutIfNeeded];
        }];
    } else {//商品
        
        [UIView animateWithDuration:0.2 animations:^{
            
            [self.slider mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.bottom.offset(-7);
                make.width.offset(width - SCRXFromX(20));
                make.height.offset(SCRXFromX(2));
                make.centerX.equalTo(self.goodsLabel);
            }];
            
            self.focusLabel.alpha = 0.6;
            self.videoLabel.alpha = 0.6;
            self.goodsLabel.alpha = 1;
            [self layoutIfNeeded];
        }];
    }
}

- (void)alertBgButtonClick:(UIButton *)button
{
    self.alertBgView.hidden = YES;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"首页导航遮罩隐藏" object:nil];
}

- (void)hideAlertBgView
{
    self.alertBgView.hidden = YES;
}

- (void)showAlertBgView
{
    self.alertBgView.hidden = NO;
}

- (UIView *)mainView
{
    if (!_mainView) {
        _mainView = [[UIView alloc] init];
        _mainView.backgroundColor = [UIColor clearColor];
        [self addSubview:_mainView];
    }
    return _mainView;
}

- (UIImageView *)liveImageView
{
    if (!_liveImageView) {
        _liveImageView = [[UIImageView alloc] init];
//        NSString *path = [[NSBundle mainBundle] pathForResource:@"liveLogo_white" ofType:@"gif"];
//        _liveImageView.image = [UIImage sd_imageWithGIFData:[NSData dataWithContentsOfFile:path]];
        _liveImageView.alpha = 0.7;
        [self addSubview:_liveImageView];
    }
    return _liveImageView;
}

- (UIButton *)liveButton
{
    if (!_liveButton) {
        _liveButton = [[UIButton alloc] init];
        _liveButton.tag = 3;
//        _liveButton.clickArea = @"2.0";
        [_liveButton addTarget:self action:@selector(headChoose:) forControlEvents:UIControlEventTouchUpInside];
        [self.mainView addSubview:_liveButton];
    }
    return _liveButton;
}

- (UILabel *)focusLabel
{
    if (!_focusLabel) {
        _focusLabel = [[UILabel alloc] init];
        _focusLabel.font = [UIFont fontWithName:BoldFont size:SCRXFromX(16)];
        _focusLabel.textColor = [UIColor whiteColor];
        _focusLabel.textAlignment = NSTextAlignmentCenter;
        _focusLabel.text = @"关注";
        [self.mainView addSubview:_focusLabel];
    }
    return _focusLabel;
}

- (UIButton *)focusButton
{
    if (!_focusButton) {
        _focusButton = [[UIButton alloc] init];
        _focusButton.tag = 0;
        [_focusButton addTarget:self action:@selector(headChoose:) forControlEvents:UIControlEventTouchUpInside];
        [self.mainView addSubview:_focusButton];
    }
    return _focusButton;
}

- (UILabel *)videoLabel
{
    if (!_videoLabel) {
        _videoLabel = [[UILabel alloc] init];
        _videoLabel.font = [UIFont fontWithName:BoldFont size:SCRXFromX(16)];
        _videoLabel.textColor = [UIColor whiteColor];
        _videoLabel.textAlignment = NSTextAlignmentCenter;
        _videoLabel.text = @"看看";
        [self.mainView addSubview:_videoLabel];
    }
    return _videoLabel;
}

- (UIButton *)videoButton
{
    if (!_videoButton) {
        _videoButton = [[UIButton alloc] init];
        _videoButton.tag = 1;
        [_videoButton addTarget:self action:@selector(headChoose:) forControlEvents:UIControlEventTouchUpInside];
        [self.mainView addSubview:_videoButton];
    }
    return _videoButton;
}

- (UILabel *)goodsLabel
{
    if (!_goodsLabel) {
        _goodsLabel = [[UILabel alloc] init];
        _goodsLabel.font = [UIFont fontWithName:BoldFont size:SCRXFromX(16)];
        _goodsLabel.textColor = [UIColor whiteColor];
        _goodsLabel.textAlignment = NSTextAlignmentCenter;
        _goodsLabel.text = @"商品";
        [self.mainView addSubview:_goodsLabel];
    }
    return _goodsLabel;
}

- (UIButton *)goodsButton
{
    if (!_goodsButton) {
        _goodsButton = [[UIButton alloc] init];
        _goodsButton.tag = 2;
        [_goodsButton addTarget:self action:@selector(headChoose:) forControlEvents:UIControlEventTouchUpInside];
        [self.mainView addSubview:_goodsButton];
    }
    return _goodsButton;
}

- (UILabel *)slider
{
    if (!_slider) {
        _slider = [[UILabel alloc] init];
        _slider.backgroundColor = [UIColor whiteColor];
        _slider.layer.masksToBounds = YES;
        _slider.layer.cornerRadius = SCRXFromX(1);
        [self.mainView addSubview:_slider];
    }
    return _slider;
}

- (UIImageView *)searchImageView
{
    if (!_searchImageView) {
        _searchImageView = [[UIImageView alloc] init];
        _searchImageView.image = UIImageName(@"navSearch_white");
        _searchImageView.alpha = 0.7;
        [self.mainView addSubview:_searchImageView];
    }
    return _searchImageView;
}

- (UIButton *)searchButton
{
    if (!_searchButton) {
        _searchButton = [[UIButton alloc] init];
        _searchButton.tag = 4;
        [_searchButton addTarget:self action:@selector(headChoose:) forControlEvents:UIControlEventTouchUpInside];
        [self.mainView addSubview:_searchButton];
    }
    return _searchButton;
}

- (UIImageView *)myImageView
{
    if (!_myImageView) {
        _myImageView = [[UIImageView alloc] init];
        _myImageView.image = UIImageName(@"navMine_white");
        _myImageView.alpha = 0.7;
        [self.mainView addSubview:_myImageView];
    }
    return _myImageView;
}

- (UIButton *)myButton
{
    if (!_myButton) {
        _myButton = [[UIButton alloc] init];
        _myButton.tag = 5;
        [_myButton addTarget:self action:@selector(headChoose:) forControlEvents:UIControlEventTouchUpInside];
        [self.mainView addSubview:_myButton];
    }
    return _myButton;
}

- (UIView *)alertBgView
{
    if (!_alertBgView) {
        _alertBgView = [[UIView alloc] init];
        _alertBgView.backgroundColor = MainBlackColor;
        _alertBgView.alpha = 0.3;
        _alertBgView.hidden = YES;
        UIButton *button = [[UIButton alloc] init];
        [button addTarget:self action:@selector(alertBgButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_alertBgView addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.bottom.offset(0);
        }];
        [self addSubview:_alertBgView];
    }
    return _alertBgView;
}

@end
