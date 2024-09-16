//
//  KJVideoView.m
//  KJShopping
//
//  Created by TigerHu on 2024/9/16.
//

#import "KJVideoView.h"

@implementation KJVideoView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor blackColor];
        [self addBgImageView];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        
        self.backgroundColor = [UIColor blackColor];
        [self addBgImageView];
    }
    return self;
}

- (void)addBgImageView {
    self.imageView = [[UIImageView alloc] init];
    self.imageView.hidden = YES;
    [self addSubview:self.imageView];

    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.offset(0);
    }];
}

@end
