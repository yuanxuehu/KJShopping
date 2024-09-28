//
//  KJLivingRoomPushInfo.h
//  KJShopping
//
//  Created by TigerHu on 2024/9/18.
//

#import <Foundation/Foundation.h>

@interface KJGoodsInfo : NSObject
@property (nonatomic, strong) NSString *goodsId;
@property (nonatomic, strong) NSString *spuId;
@property (nonatomic, strong) NSString *skuId;
@property (nonatomic, strong) NSString *goodTitle;
@property (nonatomic, assign) NSInteger price;//显示价格
@property (nonatomic, strong) NSString *goodsImage;
@property (nonatomic, assign) NSInteger quantity;

// 是否显示
@property (nonatomic, assign) NSInteger currentSale;// 1 显示
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *thumbUrl;

@property (nonatomic, strong) NSString *shareBonus;
@property (nonatomic, strong) NSString *afterCouponPrice;

@end

@interface KJLivingRoomPushInfo : NSObject
//推流地址
@property (nonatomic, strong) NSString *pushUrl;
//直播间Id
@property (nonatomic, strong) NSString *roomId;
//主播id
@property (nonatomic, strong) NSString *anchorId;
//主播名称
@property (nonatomic, strong) NSString *anchorName;
//主播头像
@property (nonatomic, strong) NSString *anchorImg;
//预告id
@property (nonatomic, strong) NSString *noticeId;
//预告图片1
@property (nonatomic, strong) NSString *pictureUrl1;
//预告图片2
@property (nonatomic, strong) NSString *pictureUrl2;

//直播标题
@property (nonatomic, strong) NSString *noticeTitle;
//直播类型 1:竖屏 0:横屏
@property (nonatomic, assign) NSInteger playType;
//直播地点
@property (nonatomic, strong) NSString *address;
//主播IM账号
@property (nonatomic, strong) NSString *imAccount;
//IM登陆签名
@property (nonatomic, strong) NSString *imUserSig;
//直播间音频聊天室Id
@property (nonatomic, strong) NSString *imGroupId;
//店铺Id
@property (nonatomic, strong) NSString *storeId;
//店铺名称
@property (nonatomic, strong) NSString *storeName;
//店铺头像
@property (nonatomic, strong) NSString *storeImg;
//在线人数
@property (nonatomic, assign) NSInteger onlineUserCount;
//点赞数
@property (nonatomic, assign) NSInteger thumbsUpCount;
//评论数（自己统计）
@property (nonatomic, assign) NSInteger commentCount;

@property (nonatomic, strong) NSArray <KJGoodsInfo *> *goodsList;

@end
