//
//  KJCommonlyMethods.h
//  KJShopping
//
//  Created by TigerHu on 2024/4/20.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>

/*
 订单渠道来源
 Normal:正常渠道下单
 Live:直播间商品下单O
 Vod:短视频商品下单
 */
typedef NS_ENUM(NSInteger, TMOrderChannelType) {
    TMOrderChannelTypeNormal = 0,
    TMOrderChannelTypeLive = 1,
    TMOrderChannelTypeShortVideo = 2
    
};

@interface KJCommonlyMethods : NSObject

/** 计算字体长度*/
+ (CGSize)calculateLengthOfText:(NSString *)text font:(NSInteger)font;

/** 获取当前时间*/
+ (NSString *)getCurrentTime;

/** 获取当前年月日*/
+ (NSString *)getCurrentDay;

/** 获取当前控制器*/
+ (UIViewController *)currentViewController;

//类型识别:将所有的NSNull类型转化成@""
+ (id)changeType:(id)myObj;

/** 判断字符串是否为空*/
+ (BOOL)isEmPty:(NSString *)string;

/** 获取视频第一帧*/
+ (UIImage *)firstFrameWithVideoURL:(NSURL *)url size:(CGSize)size;

//根据正则，过滤特殊字符
+ (NSString *)filterCharactor:(NSString *)string withRegex:(NSString *)regexStr;

//图片放大查看
+ (void)showImage:(UIImageView *)avatarImageView;

//获取label每行的文字
+ (NSArray *)getLinesArrayOfStringInLabel:(UILabel *)label width:(CGFloat)width;

//设置不同颜色的文本
+ (NSAttributedString *)SetRichText:(NSString *)string theRange:(NSUInteger)theRange changeRange:(NSInteger)changeRange color:(UIColor *)color;

//将网络图片转换成image
+ (UIImage *)getImageFromURL:(NSString *)fileURL;

//裁剪5:4图片
+ (UIImage *)cutCenterSquareImage:(UIImage *)image;

//两张图片合成一张图片
+ (UIImage *)composeImg:(UIImage *)image1 topImage:(UIImage *)image2;

//按宽度缩放
+ (UIImage *)imageCompressForWidth:(UIImage *)sourceImage targetWidth:(CGFloat)defineWidth;

//设置渐变色
+ (void)addTransitionColor:(UIColor *)startColor endColor:(UIColor *)endColor view:(UIView *)view;

// UIView圆角 上下左右
+ (UIView *)roundCornersOnView:(UIView *)view onTopLeft:(BOOL)tl topRight:(BOOL)tr bottomLeft:(BOOL)bl bottomRight:(BOOL)br radius:(float)radius;

//计算文字高度
+ (CGFloat)calculateRowHeight:(NSString *)string fontSize:(NSInteger)fontSize width:(CGFloat)width;

/** view转成image*/
+ (UIImage *)convertViewToImage:(UIView *)view;

/** 与当前时间差*/
+ (NSString *)pleaseInsertStarTimeo:(NSString *)time;

+ (CGFloat)heightFromString:(NSString*)text withFont:(UIFont*)font constraintToWidth:(CGFloat)width;

//添加动画
+ (void)animationAlert:(UIView *)view;

//压缩图片
+ (NSData *)zipNSDataWithImage:(UIImage *)sourceImage;

//金额、最多保留两位小数
+ (NSString *)removeSuffix:(NSString *)numberStr;

/** 计算时间差：分钟*/
+ (NSString *)intervalFromLastDate:(NSString *)time2 with:(NSString *)nowTime;

/** 计算时间差：秒*/
+ (NSString *)intervalFromsecond:(NSString *)time2 with:(NSString *)nowTime;


/** 判断当前时间是否在某个时间段内*/
+ (BOOL)isBetweenFromHour:(NSInteger)fromHour toHour:(NSInteger)toHour;
/** 获取某个时间点*/
+ (NSDate *)getCustomDateWithHour:(NSInteger)hour;

/** date转字符串*/
+ (NSString *)stringFromDate:(NSDate *)UTCDate;

/** 与今天的日期差*/
+ (NSInteger)intervalSinceNow:(NSString *)theDate;

/** 返回该年月包含的天数*/
+ (NSMutableArray *)getDayForYear:(NSInteger)year Month:(NSInteger)month;

/** 获取当前年份*/
+ (NSInteger)getYear;
/** 获取当前月份*/
+ (NSInteger)getMonth;
/** 获取当前天*/
+ (NSInteger)getDay;
/** 获取当前小时*/
+ (NSInteger)getHour;
/** 获取当前分钟*/
+ (NSInteger)getMinues;

/**使用 UserDefaults 存储*/
+(void)userDefaultsKey:(NSString *)key Obj:(id)obj;
/**读取 UserDefaults 值*/
+(id)loadUserDefaultsObjKey:(NSString *)key;

/**
 校验身份证号码是否正确 返回BOOL值

 @param idCardString 身份证号码
 @return 返回BOOL值 YES or NO
 */
+ (BOOL)cly_verifyIDCardString:(NSString *)idCardString;


//+ (NSString *)getIDFA;
//// 获取openUDID
//+ (NSString *)getOpenUDID;

@end
