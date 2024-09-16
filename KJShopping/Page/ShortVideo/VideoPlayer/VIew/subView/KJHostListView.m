//
//  KJHostListView.m
//  KJShopping
//
//  Created by TigerHu on 2024/9/16.
//

#import "KJHostListView.h"
#import "KJHomeHostModelView.h"
#import "KJHomeHostInfo.h"

@interface KJHostListView () <KJHomeHostModelViewDelegate>

@end

@implementation KJHostListView

- (instancetype)init {
    self = [super init];
    if (self) {
        
        [self setLayout];
    }
    return self;
}

- (void)setLayout
{
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(NavBarHeight);
        make.left.right.bottom.offset(0);
    }];
    
    self.backgroundColor = MainBlackColor;
}

- (void)setStartAnimation:(BOOL)startAnimation
{
    _startAnimation = startAnimation;
    
    if (self.dataArray.count > 0) {
        for (KJHomeHostModelView *modelView in self.scrollView.subviews) {
            [modelView startAnimationForLive:startAnimation];
        }
    }
}

- (void)setDataArray:(NSArray *)dataArray
{
    _dataArray = dataArray;
    
    [self.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    self.scrollView.contentSize = CGSizeMake(SCRXFromX(75) *dataArray.count, 0);
    
    if (dataArray.count > 0) {
        for (int i = 0; i < dataArray.count; i ++) {
            KJHomeHostModelView *modelView = [[KJHomeHostModelView alloc] init];
            modelView.info = dataArray[i];
            modelView.delegate = self;
            modelView.tag = i;
            [self.scrollView addSubview:modelView];
            
            if (i == 0) {
                [modelView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.offset(SCRXFromX(15));
                    make.width.offset(SCRXFromX(60));
                    make.height.offset(SCRXFromX(100));
                    make.centerY.equalTo(self.scrollView);
                }];
            } else {
                KJHomeHostModelView *lastView = self.scrollView.subviews[i - 1];
                [modelView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(lastView.mas_right).offset(SCRXFromX(15));
                    make.width.offset(SCRXFromX(60));
                    make.height.offset(SCRXFromX(100));
                    make.centerY.equalTo(self.scrollView);
                }];
            }
        }
    }
}

#pragma mark - KJHomeHostModelViewDelegate
- (void)homeHostModelViewButtonClick:(NSInteger)index
{
    KJHomeHostInfo *info = self.dataArray[index];
    [KJRouterInstance pushURL:@"KJAudienceRoomVC" extraParams:@{@"roomId":info.roomId}];
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.backgroundColor = [UIColor clearColor];
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.contentSize = CGSizeMake(0, 0);
        _scrollView.bounces = YES;
        [self addSubview:_scrollView];
    }
    return _scrollView;
}

@end
