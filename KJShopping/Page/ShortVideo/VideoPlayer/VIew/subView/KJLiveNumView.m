//
//  KJLiveNumView.m
//  KJShopping
//
//  Created by TigerHu on 2024/9/16.
//

#import "KJLiveNumView.h"

@implementation KJLiveNumView

- (instancetype)init {
    self = [super init];
    if (self) {
        
        [self setLayout];
    }
    return self;
}

#pragma mark - Layout
- (void)setLayout
{
    self.backgroundColor = [UIColor clearColor];
    
    [self.numView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.offset(0);
    }];
    
    [self.numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(SCRXFromX(10));
        make.centerY.equalTo(self);
    }];
    
    [self.numImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.numLabel.mas_right).offset(SCRXFromX(4));
        make.width.offset(SCRXFromX(11));
        make.height.offset(SCRXFromX(6));
        make.centerY.equalTo(self);
    }];
    
    [self.numButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.offset(0);
    }];
}

- (void)buttonClick
{
    if (self.openHostListBlock) {
        self.openHostListBlock();
    }
}

- (void)setNum:(NSInteger)num {
    _num = num;
    
    self.numLabel.text = [NSString stringWithFormat:@"%ld个直播",(long)num];
}

- (UIView *)numView
{
    if (!_numView) {
        _numView = [[UIView alloc] init];
        _numView.backgroundColor = NavBlackColor;
        _numView.alpha = 0.3;
        _numView.layer.masksToBounds = YES;
        _numView.layer.cornerRadius = SCRXFromX(12.5);
        [self addSubview:_numView];
    }
    return _numView;
}

- (UILabel *)numLabel
{
    if (!_numLabel) {
        _numLabel = [[UILabel alloc] init];
        _numLabel.font = [UIFont systemFontOfSize:SCRXFromX(14)];
        _numLabel.textColor = [UIColor whiteColor];
        _numLabel.textAlignment = NSTextAlignmentLeft;
        _numLabel.text = @"4个直播";
        [self addSubview:_numLabel];
    }
    return _numLabel;
}

- (UIImageView *)numImageView
{
    if (!_numImageView) {
        _numImageView = [[UIImageView alloc] init];
        _numImageView.image = UIImageName(@"liveOpen");
        [self addSubview:_numImageView];
    }
    return _numImageView;
}

- (UIButton *)numButton
{
    if (!_numButton) {
        _numButton = [[UIButton alloc] init];
        [_numButton addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_numButton];
    }
    return _numButton;
}

@end
