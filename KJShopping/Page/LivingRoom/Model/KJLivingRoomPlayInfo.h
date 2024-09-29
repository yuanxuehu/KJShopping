//
//  KJLivingRoomPlayInfo.h
//  KJShopping
//
//  Created by TigerHu on 2024/9/18.
//

#import <Foundation/Foundation.h>

@class KJLivingRoomPushInfo;

@interface KJLivingRoomPlayInfo : NSObject

//拉流地址
@property (nonatomic, copy) NSString *playUrl;
//直播间Id
@property (nonatomic, copy) NSString *roomId;
//主播id
@property (nonatomic, copy) NSString *anchorId;
//主播名称
@property (nonatomic, copy) NSString *anchorName;
//主播头像
@property (nonatomic, copy) NSString *anchorImg;
//是否关注当前主播
@property (nonatomic, assign) BOOL isFollow;
//预告id
@property (nonatomic, copy) NSString *noticeId;
//直播标题
@property (nonatomic, copy) NSString *noticeTitle;
//直播类型 1:竖屏 0:横屏
@property (nonatomic, assign) NSInteger playType;
//直播地点
@property (nonatomic, copy) NSString *address;
//会员IM账号
@property (nonatomic, copy) NSString *imAccount;
//会员IM登陆签名
@property (nonatomic, copy) NSString *imUserSig;
//直播间音频聊天室Id
@property (nonatomic, copy) NSString *imGroupId;
//店铺Id
@property (nonatomic, copy) NSString *storeId;
//店铺名称
@property (nonatomic, copy) NSString *storeName;
//店铺头像
@property (nonatomic, copy) NSString *storeImg;
//在线人数
@property (nonatomic, assign) NSInteger onlineUserCount;
//点赞人数
@property (nonatomic, assign) NSInteger thumbsUpCount;
//预告开播时间
@property (nonatomic, copy) NSString *livingTime;
//上次直播的直播时长
@property (nonatomic, copy) NSString *livingDuration;
//直播状态
//1:直播中
//2:预告开播
//说明:未开播&存在最新直播预告
//界面显示预告开播时间livingTime
//3:直播已经结束
//说明:未开播&不存在最新直播预告&存在开播记录
//界面显示上次直播的直播时长livingDuration
//4: 等待开播
//说明:未开播&不存在最新
@property (nonatomic, assign) NSInteger livingStatus;
//预告图片
@property (nonatomic, copy) NSString *pictureUrl1;
//预告图片
@property (nonatomic, copy) NSString *pictureUrl2;
//预告视频
@property (nonatomic, copy) NSString *videoUrl;
/** 是否获取下一个数据集*/
@property (nonatomic, assign) NSInteger isGet;

//@property (nonatomic, strong) NSArray <KJGoodsInfo *> *goodsList;

@property (nonatomic, assign) NSInteger goodsCount;

@end

