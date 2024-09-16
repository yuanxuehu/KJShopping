//
//  KJVC.h
//  KJShopping
//
//  Created by TigerHu on 2024/4/20.
//

#import <UIKit/UIKit.h>

@interface KJVC : UIViewController

// 初始化方法
- (instancetype)initWithParams:(NSDictionary *)params;
// 数据处理方法，在viewdidload前执行
- (void)initialize __attribute__((objc_requires_super));
@end
