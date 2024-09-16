//
//  KJVideoInfo.h
//  KJShopping
//
//  Created by TigerHu on 2024/9/16.
//

#import <Foundation/Foundation.h>

@interface KJVideoInfo : NSObject

//短视频id
@property (nonatomic, copy) NSString *shortVideoId;
//短视频下标识(用于上滑下滑切换视频)
@property (nonatomic, assign) NSInteger shortVideoIndex;
//短视频地址
@property (nonatomic, copy) NSString *shortVideoUrl;
//短视频封面
@property (nonatomic, copy) NSString *shortPicUrl;
//短视频内容简介
@property (nonatomic, copy) NSString *shortVidelDetail;
//短视频播放次数
@property (nonatomic, assign) NSInteger shortVideoPlayCount;
//短视频点赞次数
@property (nonatomic, assign) NSInteger shortVideoThumbsUpCount;
//分享数
@property (nonatomic, assign) NSInteger shortVideoShareCount;
//评论数
@property (nonatomic, assign) NSInteger shortVideoCommentCount;
//短视频发布人id
@property (nonatomic, copy) NSString *anchorId;

//是否获取新数据(调用短视频上滑下滑切换视频接口)
@property (nonatomic, assign) BOOL isGet;
//是否最后一条数据
@property (nonatomic, assign) BOOL isLast;
/** 是否是我的视频*/
@property (nonatomic, assign) BOOL isOwn;
//短视频智能标签
@property (nonatomic, copy) NSString *tag;
//短视频智能分类
@property (nonatomic, copy) NSString *classification;
//主播名
@property (nonatomic, copy) NSString *anchor;
//短视频评论数-当数值超过10000会返回 以万为单位
@property (nonatomic, copy) NSString *shortVideoCommentCountStr;
//短视频点赞次数-当数值超过10000会返回 以万为单位,
@property (nonatomic, copy) NSString *shortVodThumbsUpCountStr;
//短视频分享次数-当数值超过10000会返回 以万为单位
@property (nonatomic, copy) NSString *shortVideoShareCountStr;
//短视频地址
@property (nonatomic, copy) NSString *address;
//短视频经度
@property (nonatomic, copy) NSString *longitude;
//短视频纬度
@property (nonatomic, copy) NSString *latitude;
//是否为当前点击进入详情页面的视频 0:否 1:是
@property (nonatomic, assign) NSInteger isCurrentVod;

- (instancetype)initWithDict:(NSDictionary *)dict;

@end
