//
//  KJAudienceRoomCoverView.h
//  KJShopping
//
//  Created by TigerHu on 2024/9/28.
//

#import <UIKit/UIKit.h>

@class KJChatModel;

@protocol KJAudienceRoomCoverViewDelegate <NSObject>

- (void)closeRoom;
- (void)sendChatMsg:(NSString *)text;

- (void)jumpToStoreGoodsVC;
- (void)jumpToGoodsDetailVCWithRoomID:(NSString *)roomID withSpuId:(NSString *)spuId;
- (void)updateBackGroundImage:(NSString *)imagePath;

- (void)slideFromLeftToRight;
- (void)slideFromRightToLeft;
- (void)resignFirstResponderForTextField;

@end

@interface KJAudienceRoomCoverView : UIView

@property (nonatomic, weak) id <KJAudienceRoomCoverViewDelegate> delegate;

//@property (nonatomic, strong) TMCommentVC *commentVC;

@property (nonatomic, copy) NSString *hostName;
@property (nonatomic, copy) NSString *livePicture;

@property (nonatomic, copy) NSString *hostId;
@property (nonatomic, copy) NSString *roomId;

// 更新直播间状态
- (void)updateCoverViewBg;

// 自己发送消息成功，添加消息到列表
- (void)addNewChatMsgWithText:(NSString *)text;

// 添加接收到的消息到列表
- (void)addRecvChatMsg:(KJChatModel *)model;

/// 更新当前直播商品显示
/// @param infoDic 商品信息
//- (void)updateLiveGoodsViewWithDic:(NSDictionary *)infoDic withIsOnSale:(BOOL)isOnSale withIsShowButton:(BOOL)IsShowButton;
//- (void)updateLiveGoodsView:(PPGoodsInfo *)infoDic;

- (void)getLiveGoods;
- (void)hideGoodsButtonAndView;
- (void)hideGoodsView;
- (void)showGoodsButton;

/// 显示优惠券标记
/// @param dic 数据
- (void)showCouponTagWith:(NSDictionary *)dic isShowDetail:(BOOL)isShowDetail;

//注销第一响应者
- (void)resignFirstResponderForTextField;
// 清屏
- (void)clearAllData;


//开启获取直播间点赞数 定时器
- (void)startGetLikeCountTimer:(NSInteger)second;
//关闭定时器
- (void)stopGetLikeCountTimer;
- (void)stopSendLikeCountTimer;


// 抬起键盘 布局
- (void)showCustomTextFieldWithKeyboardHeight:(CGFloat)keyboardHeight;

@end
