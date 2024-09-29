//
//  KJAudienceRoomCoverView.m
//  KJShopping
//
//  Created by TigerHu on 2024/9/28.
//

#import "KJAudienceRoomCoverView.h"
#import "KJCommentVC.h"

#import "KJChatModel.h"
#import "KJRoom.h"
#import "KJLivingRoomPlayInfo.h"

@interface KJAudienceRoomCoverView () <UITextFieldDelegate, KJCommentVCDelegate>

@property (nonatomic, strong) KJCommentVC *commentVC;

// 自定义输入框
@property (nonatomic, strong) UIView *customInputView;
//@property (nonatomic, strong) TMTextField *txtfInput;
@property (nonatomic, strong) UILabel *blackVerticalLine;
@property (nonatomic, strong) UIButton *sendTextButton;


@property (nonatomic, strong) UIButton *btnAttention;
@property (nonatomic, strong) UILabel *lbLikeNum;       // 点赞数

//@property (nonatomic, strong) LiveGoodsView *goodsView;
@property (nonatomic, strong) UIButton *btnCoupon;
@property (nonatomic, strong) UIButton *btnLike;
@property (nonatomic, strong) UIButton *quitButton;
@property (nonatomic, strong) UIButton *btnShare;
@property (nonatomic, strong) UIButton *btnGift;// 礼物按钮
@property (nonatomic, strong) UIButton *btnGoods;
@property (nonatomic, strong) UIButton *bottomTextField;
@property (nonatomic, strong) UIView *blackLine;


@property (nonatomic, strong) NSDate *likeDate;

//@property (nonatomic, strong) TMLiveAnchorInfo *liveAnchorInfo;

//主播下播UI
@property (nonatomic, strong) UILabel *outOfLiveLabel;
@property (nonatomic, strong) UILabel *liveDurationLabel;
@property (nonatomic, strong) UILabel *viewingNumberLabel;
@property (nonatomic, strong) UILabel *viewingLabel;
@property (nonatomic, strong) UILabel *commentNumberLabel;
@property (nonatomic, strong) UILabel *commentLabel;
@property (nonatomic, strong) UILabel *likeNumberLabel;
@property (nonatomic, strong) UILabel *likeLabel;
//@property (nonatomic, strong) LiveGoodsListView *liveGoodsTableView;

//点赞数 逻辑更新
@property (nonatomic, assign) NSInteger clickLikeCount;
@property (nonatomic, assign) NSInteger getAllLikeCountFromServer;
@property (nonatomic, strong) dispatch_source_t getLikeCountTimer;
@property (nonatomic, strong) dispatch_source_t sendLikeCountTimer;

//在线观看人数
@property (nonatomic, assign) NSInteger getAllOnlineCountFromServer;


// 单击屏幕
@property (nonatomic, assign) CGFloat startX;
@property (nonatomic, assign) CGFloat startY;

@end

@implementation KJAudienceRoomCoverView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        // 头部
        [self createHeaderBar];
        // 底部
        [self createBottomBar];
        // 聊天
        [self createChatPart];
        // 添加双击手势
        [self addDoubleTapGesture];

    }
    
    return self;
}

// 头部控件
- (void)createHeaderBar
{
    CGFloat topEdge = isIPhoneX ? 50 : 35;
    UIView *headerBgView = [[UIView alloc] init];
    headerBgView.backgroundColor = [UIColor colorWithHexString:@"000000" alpha:0.3];
    headerBgView.layer.masksToBounds = YES;
    headerBgView.layer.cornerRadius = 15;
    [self addSubview:headerBgView];
    [headerBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(topEdge);
        make.left.equalTo(self).offset(10);
        make.width.offset(144);
        make.height.offset(30);
    }];
    
    // 主播头像
    UIImageView *headerImageView = [[UIImageView alloc] init];
    headerImageView.contentMode = UIViewContentModeScaleAspectFill;
    headerImageView.layer.masksToBounds = YES;
    headerImageView.layer.cornerRadius = 14;
//    headerImageView.image = [UIImage imageNamed:@"defaultHead"];
    [headerBgView addSubview:headerImageView];
    
    @weakify(headerImageView)
    [[RACObserve([KJRoom sharedInstance], roomPlayInfo.anchorImg) ignore:nil] subscribeNext:^(NSString *headerString) {
        @strongify(headerImageView)
        
//        [headerImageView sd_setImageWithURL:[NSURL URLWithString:headerString] placeholderImage:[UIImage imageNamed:@"defaultHead"]];
        headerImageView.image = [UIImage imageNamed:headerString];
    }];
     
    [headerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headerBgView).offset(2.5);
        make.centerY.equalTo(headerBgView);
        make.height.width.offset(28);
    }];

    UIButton *enterStoreButton = [[UIButton alloc] init];
    [enterStoreButton addTarget:self action:@selector(enterStoreVC) forControlEvents:UIControlEventTouchUpInside];
    [headerBgView addSubview:enterStoreButton];
    [enterStoreButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.top.offset(0);
    }];

    // 主播名称
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.font = [UIFont systemFontOfSize:12];
    nameLabel.textColor = [UIColor whiteColor];
    nameLabel.text = @"--";
    [headerBgView addSubview:nameLabel];
    
    RAC(nameLabel, text) = [RACObserve([KJRoom sharedInstance], roomPlayInfo.anchorName) ignore:nil];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headerImageView.mas_right).offset(5);
        make.top.offset(3);
        make.width.offset(56);
        make.height.offset(12);
    }];
     
    // 观看人数
    UILabel *onlineLabel = [[UILabel alloc] init];
    onlineLabel.font = [UIFont systemFontOfSize:9];
    onlineLabel.textColor = [UIColor whiteColor];
    onlineLabel.text = @"观众:0";
    [headerBgView addSubview:onlineLabel];
    [onlineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headerImageView.mas_right).offset(5);
        make.bottom.offset(-1);
        make.width.offset(56);
        make.height.offset(9);
    }];

    @weakify(onlineLabel)
    [[RACObserve([KJRoom sharedInstance], roomPlayInfo.onlineUserCount) ignore:nil] subscribeNext:^(NSNumber *users) {
          @strongify(onlineLabel)

            if ([users integerValue] > 10000) {
                onlineLabel.text = [KJCommonlyMethods removeSuffix:[NSString stringWithFormat:@"观众:%.1f万", [users integerValue]/10000.0]];
            } else {
                onlineLabel.text = [NSString stringWithFormat:@"观众:%@", users];
            }
    }];

    // 关注按钮
    self.btnAttention = [UIButton buttonWithType:UIButtonTypeCustom];
//    _btnAttention.backgroundColor = HexColor(TMCommonRedColor);
    [_btnAttention setTitle:@"关注" forState:UIControlStateNormal];
    [_btnAttention setTitle:@"已关注" forState:UIControlStateSelected];
    [_btnAttention addTarget:self action:@selector(attentionAction:) forControlEvents:UIControlEventTouchUpInside];
    [_btnAttention setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _btnAttention.titleLabel.font = [UIFont systemFontOfSize:12];
    _btnAttention.layer.cornerRadius = 12.5;
    _btnAttention.titleLabel.font = kTextFont12;
    [headerBgView addSubview:_btnAttention];
    [_btnAttention mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-5);
        make.centerY.equalTo(headerBgView.mas_centerY);
        make.width.offset(40);
        make.height.offset(25);
    }];
   
    @weakify(self)
    [[RACObserve([KJRoom sharedInstance], roomPlayInfo.isFollow) ignore:nil] subscribeNext:^(id value) {
        @strongify(self)
        self.btnAttention.selected = [value boolValue];

    }];
}

// 底部元素
- (void)createBottomBar {
    CGFloat bottomEdge = isIPhoneX ? -39 : -5;
    CGFloat shareButtonBottomP = bottomEdge - 5;
    
    // 退出直播间按钮
    UIButton *quitButton = [[UIButton alloc] init];
    self.quitButton = quitButton;
    [quitButton setImage:[UIImage imageNamed:@"icon_living_quit"] forState:UIControlStateNormal];
    [quitButton addTarget:self action:@selector(closeAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:quitButton];
    [quitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-15);
        make.bottom.offset(shareButtonBottomP);
        make.width.height.offset(30);
    }];
    
    // 分享按钮
     UIButton *btnShare = [self createButton:@"icon_living_share" withTag:2];
     self.btnShare = btnShare;
     [self addSubview:btnShare];
     [btnShare mas_makeConstraints:^(MASConstraintMaker *make) {
         make.right.equalTo(quitButton.mas_left).offset(-10);
         make.bottom.offset(shareButtonBottomP);
         make.width.height.offset(30);
     }];
    
    // 礼物按钮
    UIButton *btnGift = [self createButton:@"icon_living_gift" withTag:1];
    self.btnGift = btnGift;
    [self addSubview:btnGift];
    [btnGift mas_makeConstraints:^(MASConstraintMaker *make) {

        make.right.equalTo(btnShare.mas_left).offset(-10);
        make.bottom.offset(shareButtonBottomP);
        make.width.height.offset(30);
    }];
    
    // 商品按钮
    self.btnGoods = [self createButton:@"icon_living_goods" withTag:0];
    self.btnGoods.hidden = YES;
    [self addSubview:_btnGoods];
    [_btnGoods mas_makeConstraints:^(MASConstraintMaker *make) {
       make.right.equalTo(btnGift.mas_left).offset(-10);
       make.bottom.offset(shareButtonBottomP);
       make.width.height.offset(30);
    }];
    
    // 输入框按钮
    self.bottomTextField = [UIButton new];
    self.bottomTextField.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    //距左的边距为10
    self.bottomTextField.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    [self.bottomTextField setTitle:@"跟主播聊些什么？" forState:UIControlStateNormal];
    [self.bottomTextField.titleLabel setFont:[UIFont systemFontOfSize:14]];
    self.bottomTextField.layer.cornerRadius = 6;
    self.bottomTextField.layer.masksToBounds = YES;
    [self.bottomTextField setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.bottomTextField setBackgroundColor:[UIColor colorWithHexString:@"000000" alpha:0.3]];
    [self.bottomTextField addTarget:self action:@selector(clickBottomTextFieldAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.bottomTextField];
    [self.bottomTextField mas_makeConstraints:^(MASConstraintMaker *make) {
           make.left.equalTo(self).offset(10);
           make.right.equalTo(self.btnGift.mas_left).offset(-15);
           make.centerY.equalTo(btnShare);
           make.height.offset(30);
    }];
    
    //黑横线
    UIView *blackLine = [UIView new];
    self.blackLine = blackLine;
    blackLine.backgroundColor = [UIColor clearColor];//[UIColor colorWithHexString:@"000000" alpha:0.3];
    [self addSubview:blackLine];
    [blackLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.bottom.equalTo(btnShare.mas_top).offset(-6);
        make.height.offset(1.0);
    }];
    
//    // 直播商品
//    self.goodsView = [[LiveGoodsView alloc] init];
//    _goodsView.hidden = YES;
//    [self addSubview:_goodsView];
//    [_goodsView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.width.offset(101);
//        make.height.offset(118);
//        make.right.offset(-11);
//        make.bottom.equalTo(self.blackLine.mas_top).offset(-10);
//    }];
//    @weakify(self);
//    _goodsView.detailBlock = ^(NSDictionary * _Nonnull dic) {
//        @strongify(self);
//
//        NSString *roomId = [TMRoom sharedInstance].roomPlayInfo.roomId;
//        NSString *spuId = [dic safeStringForKey:@"spuId"];
//
//        if (self.delegate && [self.delegate respondsToSelector:@selector(jumpToGoodsDetailVCWithRoomID:withSpuId:)]) {
//            [self.delegate jumpToGoodsDetailVCWithRoomID:roomId withSpuId:spuId];
//        }
//    };
//
//    _goodsView.clickDetailBlock = ^(PPGoodsInfo * _Nonnull model) {
//
//        @strongify(self);
//
//        NSString *roomId = [TMRoom sharedInstance].roomPlayInfo.roomId;
//        NSString *spuId = model.spuId;
//
//        if (self.delegate && [self.delegate respondsToSelector:@selector(jumpToGoodsDetailVCWithRoomID:withSpuId:)]) {
//           [self.delegate jumpToGoodsDetailVCWithRoomID:roomId withSpuId:spuId];
//        }
//    };
    
    self.lbLikeNum = [KJUtils createLabel:@"368" textColor:[UIColor whiteColor] Font:[UIFont systemFontOfSize:10]];
//    self.lbLikeNum.hidden = YES;
    _lbLikeNum.textAlignment = NSTextAlignmentCenter;
    _lbLikeNum.backgroundColor = HexColor(@"ffb534");
    _lbLikeNum.layer.cornerRadius = 6;
    _lbLikeNum.clipsToBounds = YES;
    [self addSubview:_lbLikeNum];
    [_lbLikeNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(blackLine.mas_top).offset(-10);
        make.right.equalTo(self).offset(-18);
        make.width.offset(40);
        make.height.offset(13);
    }];
    
//    RAC(self.lbLikeNum, text) = [[RACObserve([TMRoom sharedInstance], roomPlayInfo.thumbsUpCount) ignore:nil] map:^id(id value) {
//
//        if ([value integerValue] >= 10000) {
//            return [NSString stringWithFormat:@"%.1f万", [value integerValue]/10000.0];
//        }
//        return [NSString stringWithFormat:@"%@", value];
//    }];
    self.lbLikeNum.text = @"22222";
    
    
      // 点赞按钮
      UIButton *btnLike = [self createButton:@"icon_live_like" withTag:3];
//      btnLike.hidden = YES;
      self.btnLike = btnLike;
      [self addSubview:btnLike];
      [btnLike mas_makeConstraints:^(MASConstraintMaker *make) {
          make.centerX.equalTo(self.lbLikeNum);
          make.bottom.equalTo(self.lbLikeNum.mas_top).offset(-2);
          make.width.height.offset(25);
      }];
    
}

- (void)createChatPart {
    //聊天信息
    self.commentVC = [[KJCommentVC alloc] init];
    self.commentVC.view.frame = CGRectMake(0, 500, SCREEN_WIDTH * 0.73, 200);
    [self addSubview:self.commentVC.view];
    self.commentVC.tableViewDelegate = self;
    
    [self.commentVC tableViewFrame];
    
    //test
    KJChatModel *chatModel = [[KJChatModel alloc] init];
    [self addRecvChatMsg:chatModel];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //test
        KJChatModel *chatModel = [[KJChatModel alloc] init];
        [self addRecvChatMsg:chatModel];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            //test
            KJChatModel *chatModel = [[KJChatModel alloc] init];
            [self addRecvChatMsg:chatModel];
           
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                //test
                KJChatModel *chatModel = [[KJChatModel alloc] init];
                [self addRecvChatMsg:chatModel];
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    //test
                    KJChatModel *chatModel = [[KJChatModel alloc] init];
                    [self addRecvChatMsg:chatModel];
                    
                    
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        //test
                        KJChatModel *chatModel = [[KJChatModel alloc] init];
                        [self addRecvChatMsg:chatModel];
                        
                        
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            //test
                            KJChatModel *chatModel = [[KJChatModel alloc] init];
                            [self addRecvChatMsg:chatModel];
                            
                        });
                    });
                });
                
            });
        });
    });
    
}

- (void)addDoubleTapGesture {
    //双击手势
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapAction:)];
    [doubleTap setNumberOfTapsRequired:2];
    [self addGestureRecognizer:doubleTap];
}

// 添加接收到的消息到列表
- (void)addRecvChatMsg:(KJChatModel *)model {
    [self.commentVC addChatModel:model];
}

#pragma mark - KJCommentVCDelegate

- (void)slideFromLeftToRight
{
    if (self.delegate) {
        [self.delegate slideFromLeftToRight];
    }
}

- (void)slideFromRightToLeft
{
    if (self.delegate) {
        [self.delegate slideFromRightToLeft];
    }
}

#pragma mark - 点击事件处理

- (void)attentionAction:(UIButton *)button
{
    
}

- (void)closeAction
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(closeRoom)]) {
        [self.delegate closeRoom];
    }
}



- (void)enterStoreVC {
    if (self.delegate && [self.delegate respondsToSelector:@selector(jumpToStoreGoodsVC)]) {
        [self.delegate jumpToStoreGoodsVC];
    }
}

- (void)bottomBarAction:(UIButton *)button {
    
}

- (void)clickBottomTextFieldAction
{
    
}

#pragma mark - 双击屏幕触发点赞动画
- (void)doubleTapAction:(UITapGestureRecognizer *)sender
{
    // 点赞
    [self showLikeAnimation];
}

- (void)showLikeAnimation {
    [self praiseAnimationWithImageName:@"icon_like_animation_21"];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self praiseAnimationWithImageName:@"icon_like_animation_22"];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self praiseAnimationWithImageName:@"icon_like_animation_23"];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self praiseAnimationWithImageName:@"icon_like_animation_24"];
            
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                   [self praiseAnimationWithImageName:@"icon_like_animation_25"];
            
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                          [self praiseAnimationWithImageName:@"icon_like_animation_26"];
                   });
                });
            });
        });
    });
}


- (void)praiseAnimationWithImageName:(NSString *)imageNameString
{
    UIImageView *imageView = [[UIImageView alloc] init];
    
    CGFloat startX = self.startX;
    CGFloat startY = self.startY;
    
    //  初始frame，即设置了动画的起点
    imageView.frame = CGRectMake(startX, startY, 30, 30);
    [self addSubview:imageView];
    
   //  随机产生一个动画结束点的X值
   CGFloat finishX = random() % 20;
   //  动画结束点的Y值
   CGFloat finishY = 0;
   //  imageView在运动过程中的缩放比例
   CGFloat scale = round(random() % 2) + 0.7;
   // 生成一个作为速度参数的随机数
   CGFloat speed = 1 / round(random() % 900) + 0.6;
   //  动画执行时间
   NSTimeInterval duration = 4 * speed;
   //  如果得到的时间是无穷大，就重新附一个值（这里要特别注意，请看下面的特别提醒）
   if (duration == INFINITY) duration = 2.412346;
    
    //  开始动画
    [UIView beginAnimations:nil context:(__bridge void *_Nullable)(imageView)];
    //  设置动画时间
    [UIView setAnimationDuration:duration];
    
    //  拼接图片名字
    imageView.image = [UIImage imageNamed:imageNameString];
    
    //  设置imageView的结束frame
    imageView.frame = CGRectMake( finishX, finishY, 30 * scale, 30 * scale);
    
    //  设置渐渐消失的效果，这里的时间最好和动画时间一致
    [UIView animateWithDuration:duration animations:^{
        imageView.alpha = 0;
    }];
    
    // 结束动画，调用onAnimationComplete:finished:context:函数
    [UIView setAnimationDidStopSelector:@selector(onAnimationComplete:finished:context:)];
    // 设置动画代理
    [UIView setAnimationDelegate:self];
    [UIView commitAnimations];
}

// 动画完后销毁iamgeView
- (void)onAnimationComplete:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context{
    UIImageView *imageView = (__bridge UIImageView *)(context);
    [imageView removeFromSuperview];
    imageView = nil;
}

#pragma mark - 界面触摸监听
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    
     // 1.获取手指
     UITouch *touch = [touches anyObject];
     // 2.获取触摸的上一个位置
     CGPoint lastPoint;
     CGPoint currentPoint;

     lastPoint = [touch previousLocationInView:self];
     currentPoint = [touch locationInView:self];

    self.startX = lastPoint.x;
    self.startY = lastPoint.y;

    [self resignFirstResponderForTextField];
}

// 收起键盘
- (void)resignFirstResponderForTextField
{
    
}

- (UIButton *)createButton:(NSString *)imgStr withTag:(NSInteger)index
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setBackgroundImage:[UIImage imageNamed:imgStr] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(bottomBarAction:) forControlEvents:UIControlEventTouchUpInside];
    btn.tag = index;
    
    return btn;
}

@end
