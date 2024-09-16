//
//  KJCommonlyMethods.m
//  KJShopping
//
//  Created by TigerHu on 2024/4/20.
//

#import "KJCommonlyMethods.h"
#import <AVFoundation/AVFoundation.h>
#import <AdSupport/AdSupport.h>
//#import "OpenUDID.h"

static CGRect oldframe;
@implementation KJCommonlyMethods

/** 计算Label文字长度*/
+ (CGSize)calculateLengthOfText:(NSString *)text font:(NSInteger)font
{
    NSDictionary *attrs = @{NSFontAttributeName : [UIFont boldSystemFontOfSize:font]};
    CGSize size = [text sizeWithAttributes:attrs];
    
    return size;
}

/** 获取当前时间*/
+ (NSString *)getCurrentTime
{
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateStr = [formatter stringFromDate:date];
    
    return dateStr;
}

/** 获取当前年月日*/
+ (NSString *)getCurrentDay
{
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateStr = [formatter stringFromDate:date];
    
    return dateStr;
}

/** 获取当前控制器*/
+ (UIViewController *)currentViewController
{
    UIViewController *vc = [UIApplication sharedApplication].keyWindow.rootViewController;
    while (1) {
        
        if ([vc isKindOfClass:[UITabBarController class]]) {
            vc = ((UITabBarController*)vc).selectedViewController;
        }
        if ([vc isKindOfClass:[UINavigationController class]]) {
            vc = ((UINavigationController*)vc).visibleViewController;
        }
        if (vc.presentedViewController) {
            vc = vc.presentedViewController;
        }else{
            break;
        }
    }
    return vc;
}

//类型识别:将所有的NSNull类型转化成@""
+ (id)changeType:(id)myObj {
    if ([myObj isKindOfClass:[NSDictionary class]]) {
        return [self nullDic:myObj];
    }
    else if ([myObj isKindOfClass:[NSArray class]]) {
        return [self nullArr:myObj];
    }
    else if ([myObj isKindOfClass:[NSString class]]) {
        return [self stringToString:myObj];
    }
    else if ([myObj isKindOfClass:[NSNull class]]) {
        return [self nullToString];
    }
    return myObj;
}

//将NSDictionary中的Null类型的项目转化成@""
+ (NSDictionary *)nullDic:(NSDictionary *)myDic {
    NSArray * keyArr = [myDic allKeys];
    NSMutableDictionary * resDic = [[NSMutableDictionary alloc] init];
    for (int i = 0; i < keyArr.count; i ++) {
        id obj = [myDic objectForKey:keyArr[i]];
        obj = [self changeType:obj];
        [resDic setObject:obj forKey:keyArr[i]];
    }
    return resDic;
}
 
//将NSDictionary中的Null类型的项目转化成@""
+ (NSArray *)nullArr:(NSArray *)myArr {
    NSMutableArray * resArr = [[NSMutableArray alloc] init];
    for (int i = 0; i < myArr.count; i ++) {
        id obj = myArr[i];
        obj = [self changeType:obj];
        [resArr addObject:obj];
    }
    return resArr;
}

//将NSString类型的原路返回
+ (NSString *)stringToString:(NSString *)string {
    return string;
}
 
//将Null类型的项目转化成@""
+ (NSString *)nullToString {
    return @"";
}

/** 判断字符串是否为空*/
+ (BOOL)isEmPty:(NSString *)string
{
    if ([string isEqualToString:@""] || string == nil || string.length == 0 || [string isKindOfClass:[NSNull class]]) {
        
        return YES;
    }else {
        
        return NO;
    }
}

/** 获取视频第一帧*/
+ (UIImage *)firstFrameWithVideoURL:(NSURL *)url size:(CGSize)size
{
    // 获取视频第一帧
    NSDictionary *opts = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO] forKey:AVURLAssetPreferPreciseDurationAndTimingKey];
    AVURLAsset *urlAsset = [AVURLAsset URLAssetWithURL:url options:opts];
    AVAssetImageGenerator *generator = [AVAssetImageGenerator assetImageGeneratorWithAsset:urlAsset];
    generator.appliesPreferredTrackTransform = YES;
    generator.maximumSize = CGSizeMake(size.width, size.height);
    NSError *error = nil;
    CGImageRef img = [generator copyCGImageAtTime:CMTimeMake(0, 10) actualTime:NULL error:&error];
    {
        return [UIImage imageWithCGImage:img];
    }
    return nil;
}

//根据正则，过滤特殊字符
+ (NSString *)filterCharactor:(NSString *)string withRegex:(NSString *)regexStr
{
    NSString *searchText = string;
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regexStr options:NSRegularExpressionCaseInsensitive error:&error];
    NSString *result = [regex stringByReplacingMatchesInString:searchText options:NSMatchingReportCompletion range:NSMakeRange(0, searchText.length) withTemplate:@""];
    return result;
}

//图片放大查看
+ (void)showImage:(UIImageView *)avatarImageView
{
    UIImage *image = avatarImageView.image;
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    UIView *backgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    oldframe = [avatarImageView convertRect:avatarImageView.bounds toView:window];
    backgroundView.backgroundColor = [UIColor blackColor];
    backgroundView.alpha = 0;
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:oldframe];
    imageView.image = image;
    imageView.tag = 1;
    [backgroundView addSubview:imageView];
    [window addSubview:backgroundView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideImage:)];
    [backgroundView addGestureRecognizer: tap];
    
    [UIView animateWithDuration:0.2 animations:^{
        imageView.frame = CGRectMake(0,([UIScreen mainScreen].bounds.size.height - image.size.height * [UIScreen mainScreen].bounds.size.width / image.size.width) / 2, [UIScreen mainScreen].bounds.size.width, image.size.height * [UIScreen mainScreen].bounds.size.width / image.size.width);
        backgroundView.alpha = 1;
    } completion:^(BOOL finished) {
        
    }];
}
 
+ (void)hideImage:(UITapGestureRecognizer *)tap
{
    UIView *backgroundView = tap.view;
    UIImageView *imageView=(UIImageView *)[tap.view viewWithTag:1];
    [UIView animateWithDuration:0.2 animations:^{
        imageView.frame = oldframe;
        backgroundView.alpha = 0;
    } completion:^(BOOL finished) {
        [backgroundView removeFromSuperview];
    }];
}

//获取label每行的文字
+ (NSArray *)getLinesArrayOfStringInLabel:(UILabel *)label width:(CGFloat)width
{
    NSString *text = [label text];
    if ([self isEmPty:text]) {
        
        return @[@""];
    }
    UIFont *font = [label font];
    CGRect rect = CGRectMake(label.frame.origin.x, label.frame.origin.y, width, label.frame.size.height);// [label frame];
    
    CTFontRef myFont = CTFontCreateWithName(( CFStringRef)([font fontName]), [font pointSize], NULL);
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:text];
    [attStr addAttribute:(NSString *)kCTFontAttributeName value:(__bridge  id)myFont range:NSMakeRange(0, attStr.length)];
    CFRelease(myFont);
    CTFramesetterRef frameSetter = CTFramesetterCreateWithAttributedString(( CFAttributedStringRef)attStr);
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, CGRectMake(0,0,rect.size.width,100000));
    CTFrameRef frame = CTFramesetterCreateFrame(frameSetter, CFRangeMake(0, 0), path, NULL);
    NSArray *lines = ( NSArray *)CTFrameGetLines(frame);
    NSMutableArray *linesArray = [[NSMutableArray alloc]init];
    for (id line in lines) {
        CTLineRef lineRef = (__bridge  CTLineRef )line;
        CFRange lineRange = CTLineGetStringRange(lineRef);
        NSRange range = NSMakeRange(lineRange.location, lineRange.length);
        NSString *lineString = [text substringWithRange:range];
        CFAttributedStringSetAttribute((CFMutableAttributedStringRef)attStr, lineRange, kCTKernAttributeName, (CFTypeRef)([NSNumber numberWithFloat:0.0]));
        CFAttributedStringSetAttribute((CFMutableAttributedStringRef)attStr, lineRange, kCTKernAttributeName, (CFTypeRef)([NSNumber numberWithInt:0.0]));
        [linesArray addObject:lineString];
    }
    
    CGPathRelease(path);
    CFRelease( frame );
    CFRelease(frameSetter);
    return (NSArray *)linesArray;
}

//设置不同颜色的文本
+ (NSAttributedString *)SetRichText:(NSString *)string theRange:(NSUInteger)theRange changeRange:(NSInteger)changeRange color:(UIColor *)color
{
    NSMutableAttributedString *noteStr = [[NSMutableAttributedString alloc] initWithString:string];
    NSRange redRange = NSMakeRange(theRange,changeRange);
    [noteStr addAttribute:NSForegroundColorAttributeName value:color range:redRange];
    return noteStr;
}

//将网络图片转换成image
+ (UIImage *)getImageFromURL:(NSString *)fileURL
{
    NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:fileURL]];

    return [UIImage imageWithData:data];
}

//裁剪5:4图片
+ (UIImage *)cutCenterSquareImage:(UIImage *)image
{
    CGSize imageSize = image.size;

    CGFloat centerW;
    CGFloat centerH;

    //根据图片的大小计算出图片中间矩形区域的位置与大小
     if (imageSize.width >= (imageSize.height *5)/4) {
         if (imageSize.height >=200) {
             centerH = 200;
         }else {
             centerH = imageSize.height;
         }
         centerW = (centerH *5)/4;
     }else{
         if (imageSize.width >=250) {
             centerW = 250;
         }else {
             centerW = imageSize.width;
         }
         centerH = (centerW*4)/5;
     }
    
    UIGraphicsBeginImageContext(CGSizeMake(centerW, centerH));
    [image drawInRect:CGRectMake((imageSize.width -centerW)/2, (imageSize.height -centerH)/2, centerW, centerH)];//把image画到上下文中
    UIImage *resultImg = UIGraphicsGetImageFromCurrentImageContext();//从当前上下文中获得最终图片
    UIGraphicsEndImageContext();//关闭上下文

    return resultImg;
}

//两张图片合成一张图片
+ (UIImage *)composeImg:(UIImage *)image1 topImage:(UIImage *)image2
{
    //将底部的一张的大小作为所截取的合成图的尺寸
    UIGraphicsBeginImageContext(image1.size);
    
    // Draw image2，底下的
    [image1 drawInRect:CGRectMake(0, 0, image1.size.width, image1.size.height)];
    
    [image2 drawInRect:CGRectMake((image1.size.width -40)/2,(image1.size.height - 20)/2, 40, 40)];
    
    UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return resultingImage;
}

//按宽度缩放
+ (UIImage *)imageCompressForWidth:(UIImage *)sourceImage targetWidth:(CGFloat)defineWidth
{
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    if (width <defineWidth) {
        return sourceImage;
    }
    
    CGFloat targetWidth = defineWidth;
    CGFloat targetHeight = height * (targetWidth / width);
    CGSize size = CGSizeMake(targetWidth, targetHeight);
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0, 0.0);
    
    if(CGSizeEqualToSize(imageSize, size) ==NO){
       CGFloat widthFactor = targetWidth / width;
       CGFloat heightFactor = targetHeight / height;

       if(widthFactor > heightFactor){
            scaleFactor = widthFactor;
        }else{
            scaleFactor = heightFactor;
        }
        scaledWidth = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
       if(widthFactor > heightFactor){
            thumbnailPoint.y = (targetHeight - scaledHeight) *0.5;
        }else if(widthFactor < heightFactor){
            thumbnailPoint.x = (targetWidth - scaledWidth) *0.5;
        }
    }
    UIGraphicsBeginImageContext(size);
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    [sourceImage drawInRect:thumbnailRect];
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    
   if(newImage == nil){
        NSLog(@"scale image fail");
    }
    UIGraphicsEndImageContext();
   return newImage;
}

//设置渐变色
+ (void)addTransitionColor:(UIColor *)startColor
                  endColor:(UIColor *)endColor
                      view:(UIView *)view{
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.colors = @[(__bridge id)startColor.CGColor, (__bridge id)endColor.CGColor];
    gradientLayer.locations = @[@0, @1];
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(0, 1);
    gradientLayer.frame = view.bounds;
    [view.layer insertSublayer:gradientLayer atIndex:0];
}

// UIView圆角 上下左右
+ (UIView *)roundCornersOnView:(UIView *)view onTopLeft:(BOOL)tl topRight:(BOOL)tr bottomLeft:(BOOL)bl bottomRight:(BOOL)br radius:(float)radius {
    if (tl || tr || bl || br) {
        UIRectCorner corner = 0;//holds the corner
        //Determine which corner(s) should be changed
        if (tl) {
            corner = corner | UIRectCornerTopLeft;
        }
        if (tr) {
            corner = corner | UIRectCornerTopRight;
        }
        if (bl) {
            corner = corner | UIRectCornerBottomLeft;
        }
        if (br) {
            corner = corner | UIRectCornerBottomRight;
        }
        UIView *roundedView = view;
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:roundedView.bounds byRoundingCorners:corner cornerRadii:CGSizeMake(radius, radius)];
        CAShapeLayer *maskLayer = [CAShapeLayer layer];
        maskLayer.frame = roundedView.bounds;
        maskLayer.path = maskPath.CGPath;
        roundedView.layer.mask = maskLayer;
        return roundedView;
    } else {
        return view;
    }
}

/** 计算文字高度*/
+ (CGFloat)calculateRowHeight:(NSString *)string fontSize:(NSInteger)fontSize width:(CGFloat)width
{

    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]};

    CGRect rect = [string boundingRectWithSize:CGSizeMake(width, 0)/*计算高度要先指定宽度*/ options:NSStringDrawingUsesLineFragmentOrigin |  NSStringDrawingUsesFontLeading attributes:dic context:nil];
    
    
    return ceilf(rect.size.height);
    
}

/** view转成image*/
+ (UIImage *)convertViewToImage:(UIView *)view
{
    UIImage *imageRet = [[UIImage alloc]init];
    //UIGraphicsBeginImageContextWithOptions(区域大小, 是否是非透明的, 屏幕密度);
    UIGraphicsBeginImageContextWithOptions(view.frame.size, YES, [UIScreen mainScreen].scale);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    imageRet = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return imageRet;
    
}

/** 与当前时间差*/
+ (NSString *)pleaseInsertStarTimeo:(NSString *)time
{
    // 1.将时间转换为date
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate *date1 = [formatter dateFromString:time];
    NSDate *date2 = [formatter dateFromString:[KJCommonlyMethods getCurrentTime]];
    // 2.创建日历
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSCalendarUnit type = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    // 3.利用日历对象比较两个时间的差值
    NSDateComponents *cmps = [calendar components:type fromDate:date1 toDate:date2 options:0];
    // 4.输出结果
    NSLog(@"---------%ld",(long)cmps.year);
    if (cmps.year >0) {
        
        return [NSString stringWithFormat:@"%ld年前",(long)cmps.year];
    }
    
    if (cmps.month >0) {
        
        return [NSString stringWithFormat:@"%ld月前",(long)cmps.month];
    }
    
    if (cmps.day >0) {
        
        return [NSString stringWithFormat:@"%ld天前",(long)cmps.day];
    }
    
    if (cmps.hour >0) {
        
        return [NSString stringWithFormat:@"%ld小时前",(long)cmps.hour];
    }
    
    if (cmps.minute >0) {
        
        return [NSString stringWithFormat:@"%ld分钟前",(long)cmps.minute];
    }
    
    return @"刚刚";
}

+ (CGFloat)heightFromString:(NSString*)text withFont:(UIFont*)font constraintToWidth:(CGFloat)width
{
    if (text && font) {
        CGRect rect  = [text boundingRectWithSize:CGSizeMake(width, 1000) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:font} context:nil];
        
        return rect.size.height;
    }
    
    return 0;
}

+ (void)animationAlert:(UIView *)view
{
    CAKeyframeAnimation *popAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    popAnimation.duration = 0.4;
    popAnimation.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.01f, 0.01f, 1.0f)],
                            [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1f, 1.1f, 1.0f)],
                            [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0f, 1.0f, 1.0f)]
                            ];
    popAnimation.keyTimes = @[@0.0f, @0.5f, @1.0f];
    popAnimation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                     [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                     [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [view.layer addAnimation:popAnimation forKey:nil];
}

+ (NSData *)zipNSDataWithImage:(UIImage *)sourceImage
{
    //进行图像尺寸的压缩
    CGSize imageSize = sourceImage.size;//取出要压缩的image尺寸
    CGFloat width = imageSize.width;    //图片宽度
    CGFloat height = imageSize.height;  //图片高度
    
    if (width >1280 && height >1280) {//1.宽高大于1280(宽高比不按照2来算，按照1来算)
        
        if (width>height) {
            CGFloat scale = height/width;
            width = 1280;
            height = width*scale;
        }else{
            CGFloat scale = width/height;
            height = 1280;
            width = height*scale;
        }
    }else if(width >1280 && height <1280) {//2.宽大于1280高小于1280
        
        CGFloat scale = height/width;
        width = 1280;
        height = width*scale;

    }else if(width <1280 && height >1280){//3.宽小于1280高大于1280
        CGFloat scale = width/height;
        width = height*scale;
        
    }else{//4.宽高都小于1280
        
    }

    UIGraphicsBeginImageContext(CGSizeMake(width, height));
    [sourceImage drawInRect:CGRectMake(0,0,width,height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    //进行图像的画面质量压缩
    NSData *data = UIImageJPEGRepresentation(newImage, 1.0);
    if (data.length > 200 *1024) {
        
        CGFloat zoomNum = data.length/(180*1024);
        
        data = UIImageJPEGRepresentation(newImage, 1/zoomNum);
    }
    return data;
}

//金额、最多保留两位小数
+ (NSString *)removeSuffix:(NSString *)numberStr
{
    if (numberStr.length > 1) {
        
        if ([numberStr componentsSeparatedByString:@"."].count == 2) {
            NSString *last = [numberStr componentsSeparatedByString:@"."].lastObject;
            if ([last isEqualToString:@"00"]) {
                numberStr = [numberStr substringToIndex:numberStr.length - (last.length + 1)];
                return numberStr;
            }else{
                if ([[last substringFromIndex:last.length -1] isEqualToString:@"0"]) {
                    numberStr = [numberStr substringToIndex:numberStr.length - 1];
                    return numberStr;
                }
            }
        }
        return numberStr;
    }else{
        return nil;
    }
}

/** 计算时间差：分钟*/
+ (NSString *)intervalFromLastDate:(NSString *)time2 with:(NSString *)nowTime
{
    NSDateFormatter *date = [[NSDateFormatter alloc] init];
    [date setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *d1 = [date dateFromString:time2];
    NSTimeInterval late1 = [d1 timeIntervalSince1970]*1;
    NSDate *d2 = [date dateFromString:nowTime];
    NSTimeInterval late2 = [d2 timeIntervalSince1970]*1;
    NSTimeInterval cha = late2 - late1;

    NSString *min = @"";
    min = [NSString stringWithFormat:@"%d", (int)cha/60];

    return min;

}

/** 计算时间差：秒*/
+ (NSString *)intervalFromsecond:(NSString *)time2 with:(NSString *)nowTime {
    
    NSDateFormatter *date = [[NSDateFormatter alloc] init];
    [date setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *d1 = [date dateFromString:time2];
    NSTimeInterval late1 = [d1 timeIntervalSince1970]*1;
    NSDate *d2 = [date dateFromString:nowTime];
    NSTimeInterval late2 = [d2 timeIntervalSince1970]*1;
    NSTimeInterval cha = late2 - late1;

    NSString *second = @"";
    second = [NSString stringWithFormat:@"%d", (int)cha];


    return second;

}


/** 判断当前时间是否在某个时间段内*/
+ (BOOL)isBetweenFromHour:(NSInteger)fromHour toHour:(NSInteger)toHour
{
    NSDate *dateFrom = [KJCommonlyMethods getCustomDateWithHour:fromHour];
    NSDate *dateTo = [KJCommonlyMethods getCustomDateWithHour:toHour];
      
    NSDate *currentDate = [NSDate date];
    if ([currentDate compare:dateFrom]==NSOrderedDescending && [currentDate compare:dateTo]==NSOrderedAscending) {
        // 当前时间在9点和10点之间
        return YES;
    }
    return NO;
}

+ (NSDate *)getCustomDateWithHour:(NSInteger)hour {
    //获取当前时间
    NSDate *currentDate = [NSDate date];
    NSCalendar *currentCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *currentComps = [[NSDateComponents alloc] init];
      
    NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
      
    currentComps = [currentCalendar components:unitFlags fromDate:currentDate];
      
    //设置当天的某个点
    NSDateComponents *resultComps = [[NSDateComponents alloc] init];
    [resultComps setYear:[currentComps year]];
    [resultComps setMonth:[currentComps month]];
    [resultComps setDay:[currentComps day]];
    [resultComps setHour:hour];
      
    NSCalendar *resultCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    return [resultCalendar dateFromComponents:resultComps];
}


+ (NSString *)stringFromDate:(NSDate *)UTCDate
{
    NSDateFormatter *dataFormatter = [[NSDateFormatter alloc]init];
    [dataFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *UTCString = [dataFormatter stringFromDate:UTCDate];
    return UTCString;
}


+ (NSInteger)intervalSinceNow:(NSString *)theDate
{
    NSArray *timeArray = [theDate componentsSeparatedByString:@"."];
    theDate = [timeArray objectAtIndex:0];
    NSDateFormatter *date = [[NSDateFormatter alloc] init];
    [date setDateFormat:@"yyyy-MM-dd"];
    NSDate *d = [date dateFromString:theDate];
    NSTimeInterval late = [d timeIntervalSince1970]*1;
    NSDate* dat = [NSDate date];
    NSTimeInterval now = [dat timeIntervalSince1970]*1;
    NSString *timeString = @"";
    NSTimeInterval cha = now - late;
    
    timeString = [NSString stringWithFormat:@"%f", cha/86400];
    timeString = [timeString substringToIndex:timeString.length-7];
    
    return [timeString integerValue];
}

/** 返回该年月包含的天数*/
+ (NSMutableArray *)getDayForYear:(NSInteger)year Month:(NSInteger)month
{
    
    NSMutableArray *array = [NSMutableArray array];
    int dayNum = 0;
    if (month == 1 || month == 3 || month == 5 || month == 7 || month == 8 || month == 10 || month == 12) {
        
        dayNum = 31;
    }else if (month == 2) {
        
        NSInteger index = fmod(year, 4);
        if (index == 0) {
            
            dayNum = 29;
        }else {
            
            dayNum = 28;
        }
    }else {
        
        dayNum = 30;
    }
    
    for (int i = 1; i < dayNum +1; i ++) {
        
        [array addObject:@(i)];
    }
    
    return array;
}

+ (NSInteger)getMonth
{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate* dt = [NSDate date];
    // 定义一个时间字段的旗标，指定将会获取指定年、月、日、时、分、秒的信息
    unsigned unitFlags = NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond|NSCalendarUnitWeekday;
    // 获取不同时间字段的信息
    NSDateComponents* comp = [gregorian components:unitFlags fromDate:dt];
    
    return comp.month;
}

+ (NSInteger)getDay
{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate* dt = [NSDate date];
    // 定义一个时间字段的旗标，指定将会获取指定年、月、日、时、分、秒的信息
    unsigned unitFlags = NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond|NSCalendarUnitWeekday;
    // 获取不同时间字段的信息
    NSDateComponents* comp = [gregorian components:unitFlags fromDate:dt];
    
    return comp.day;
}

+ (NSInteger)getHour
{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate* dt = [NSDate date];
    // 定义一个时间字段的旗标，指定将会获取指定年、月、日、时、分、秒的信息
    unsigned unitFlags = NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond|NSCalendarUnitWeekday;
    // 获取不同时间字段的信息
    NSDateComponents* comp = [gregorian components:unitFlags fromDate:dt];
    
    return comp.hour;
}

+ (NSInteger)getMinues
{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate* dt = [NSDate date];
    // 定义一个时间字段的旗标，指定将会获取指定年、月、日、时、分、秒的信息
    unsigned unitFlags = NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond|NSCalendarUnitWeekday;
    // 获取不同时间字段的信息
    NSDateComponents* comp = [gregorian components:unitFlags fromDate:dt];
    
    return comp.minute;
}

+ (NSInteger)getYear
{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate* dt = [NSDate date];
    // 定义一个时间字段的旗标，指定将会获取指定年、月、日、时、分、秒的信息
    unsigned unitFlags = NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond|NSCalendarUnitWeekday;
    // 获取不同时间字段的信息
    NSDateComponents* comp = [gregorian components:unitFlags fromDate:dt];
    
    return comp.year;
}

/**
 校验身份证号码是否正确 返回BOOL值

 @param idCardString 身份证号码
 @return 返回BOOL值 YES or NO
 */
+ (BOOL)cly_verifyIDCardString:(NSString *)idCardString
{
    NSString *regex = @"^[1-9]\\d{5}(18|19|([23]\\d))\\d{2}((0[1-9])|(10|11|12))(([0-2][1-9])|10|20|30|31)\\d{3}[0-9Xx]$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    BOOL isRe = [predicate evaluateWithObject:idCardString];
    if (!isRe) {
         //身份证号码格式不对
        return NO;
    }
    //加权因子 7, 9, 10, 5, 8, 4, 2, 1, 6, 3, 7, 9, 10, 5, 8, 4, 2
    NSArray *weightingArray = @[@"7", @"9", @"10", @"5", @"8", @"4", @"2", @"1", @"6", @"3", @"7", @"9", @"10", @"5", @"8", @"4", @"2"];
    //校验码 1, 0, 10, 9, 8, 7, 6, 5, 4, 3, 2
    NSArray *verificationArray = @[@"1", @"0", @"10", @"9", @"8", @"7", @"6", @"5", @"4", @"3", @"2"];
    
    NSInteger sum = 0;//保存前17位各自乖以加权因子后的总和
    for (int i = 0; i < weightingArray.count; i++) {//将前17位数字和加权因子相乘的结果相加
        NSString *subStr = [idCardString substringWithRange:NSMakeRange(i, 1)];
        sum += [subStr integerValue] * [weightingArray[i] integerValue];
    }
    
    NSInteger modNum = sum % 11;//总和除以11取余
    NSString *idCardMod = verificationArray[modNum]; //根据余数取出校验码
    NSString *idCardLast = [idCardString.uppercaseString substringFromIndex:17]; //获取身份证最后一位
    
    if (modNum == 2) {//等于2时 idCardMod为10  身份证最后一位用X表示10
        idCardMod = @"X";
    }
    if ([idCardLast isEqualToString:idCardMod]) { //身份证号码验证成功
        return YES;
    } else { //身份证号码验证失败
        return NO;
    }
}

+(void)userDefaultsKey:(NSString *)key Obj:(id)obj {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:obj forKey:key];
}

+(id)loadUserDefaultsObjKey:(NSString *)key {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:key];
}


#pragma mark - IDFA

//+ (NSString *)getIDFA
//{
//
//    BOOL isCan = [[ASIdentifierManager sharedManager] isAdvertisingTrackingEnabled];
//    if (isCan) {
//
//        NSString *idfa = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
//        return idfa;
//    } else {
//        return [OpenUDID value];
//    }
//}
//
//#pragma mark - openUDID
//
//+ (NSString *)getOpenUDID
//{
//    return [OpenUDID value];
//}

@end


