//
//  KJAudienceRoomCoverView.m
//  KJShopping
//
//  Created by TigerHu on 2024/9/28.
//

#import "KJAudienceRoomCoverView.h"

@interface KJAudienceRoomCoverView ()

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

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
//        self.clickLikeCount = 0;
//        self.getAllLikeCountFromServer = 0;
        
        // 头部
        [self createHeaderBar];

        // 底部
//        [self createBottomBar];

        // 聊天
//        [self createChatPart];

        // 添加双击手势
//        [self addDoubleTapGesture];

    }
    
    return self;
}

// 头部元素
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
    headerImageView.image = [UIImage imageNamed:@"defaultHead"];
    [headerBgView addSubview:headerImageView];
    /*
    @weakify(headerImageView);
    [[RACObserve([TMRoom sharedInstance], roomPlayInfo.anchorImg) ignore:nil] subscribeNext:^(NSString *headerString) {
        @strongify(headerImageView);
        [headerImageView sd_setImageWithURL:[NSURL URLWithString:headerString] placeholderImage:[UIImage imageNamed:@"defaultHead"]];
    }];
     */
    headerImageView.image = [UIImage imageNamed:@"defaultHead"];
    
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
    /*
    RAC(nameLabel, text) = [RACObserve([TMRoom sharedInstance], roomPlayInfo.anchorName) ignore:nil];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headerImageView.mas_right).offset(5);
        make.top.offset(3);
        make.width.offset(56);
        make.height.offset(12);
    }];
     */
    nameLabel.text = @"111";
    
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
    @weakify(onlineLabel);

    //修复观看人数不更新bug
//    [[RACObserve([TMRoom sharedInstance], roomPlayInfo.onlineUserCount) ignore:nil] subscribeNext:^(NSNumber *users) {
//          @strongify(onlineLabel);
//
//            if ([users integerValue] > 10000) {
//                onlineLabel.text = [TMCommonlyMethods removeSuffix:[NSString stringWithFormat:@"观众:%.1f万", [users integerValue]/10000.0]];
//            } else {
//                onlineLabel.text = [NSString stringWithFormat:@"观众:%@", users];
//            }
//      }];

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
    @weakify(self);
//    [[RACObserve([TMRoom sharedInstance], roomPlayInfo.isFollow) ignore:nil] subscribeNext:^(id value) {
//
//        @strongify(self);
//        self.btnAttention.selected = [value boolValue];
//
//    }];
}





@end
