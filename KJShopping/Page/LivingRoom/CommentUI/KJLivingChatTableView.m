//
//  KJLivingChatTableView.m
//  KJShopping
//
//  Created by TigerHu on 2024/9/29.
//

#import "KJLivingChatTableView.h"

@implementation KJLivingChatTableView

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    return [super hitTest:point withEvent:event];
}

#pragma mark - 界面触摸监听
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];

}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {

    // 1.获取手指
    UITouch *touch = [touches anyObject];
    // 2.获取触摸的上一个位置
    CGPoint lastPoint;
    CGPoint currentPoint;

    lastPoint = [touch previousLocationInView:self];
    currentPoint = [touch locationInView:self];
    
    NSLog(@"lastPoint = %@, currentPoint = %@", (NSStringFromCGPoint(lastPoint)), (NSStringFromCGPoint(currentPoint)));
    
    //判断是左右滑动
    if (ABS(currentPoint.x - lastPoint.x) > ABS(currentPoint.y - lastPoint.y)) {

           if (currentPoint.x - lastPoint.x > 5) {
               //右滑清屏
               if (self.slideDelegate) {
                   [self.slideDelegate slideFromLeftToRight];
               }
           } else if (lastPoint.x - currentPoint.x > 5) {//左滑还原
               if (self.slideDelegate) {
                   [self.slideDelegate slideFromRightToLeft];
               }
           }
    }
}

@end
