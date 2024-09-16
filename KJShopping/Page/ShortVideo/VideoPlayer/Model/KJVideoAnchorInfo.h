//
//  KJVideoAnchorInfo.h
//  KJShopping
//
//  Created by TigerHu on 2024/9/16.
//

#import <Foundation/Foundation.h>

@interface KJVideoAnchorInfo : NSObject

//短视频发布人id
@property (nonatomic, copy) NSString *anchorId;
//短视频发布人名称
@property (nonatomic, copy) NSString *anchorName;
//发布人头像
@property (nonatomic, copy) NSString *anchorImg;
//是否关注
@property (nonatomic, assign) BOOL isFollow;
//小店id
@property (nonatomic, copy) NSString *storeId;
//小店名称
@property (nonatomic, copy) NSString *storeName;
//小店logo
@property (nonatomic, copy) NSString *storeImg;
//当前短视频作者 直播状态 0:未开播 1:直播中
@property (nonatomic, assign) NSInteger liveStatus;
//直播房间号
@property (nonatomic, copy) NSString *roomId;
//短视频是否已经点赞
@property (nonatomic, assign) BOOL isThumbsUp;
//是否是我的视频
@property (nonatomic, assign) NSInteger isOwn;


@end
