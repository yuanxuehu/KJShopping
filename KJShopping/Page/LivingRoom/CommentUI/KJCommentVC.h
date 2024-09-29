//
//  KJCommentVC.h
//  KJShopping
//
//  Created by TigerHu on 2024/9/29.
//

#import "KJVC.h"

@class KJChatModel;

@protocol KJCommentVCDelegate <NSObject>

- (void)slideFromLeftToRight;
- (void)slideFromRightToLeft;

@end

@interface KJCommentVC : KJVC

@property (nonatomic, weak) id <KJCommentVCDelegate> tableViewDelegate;

- (void)tableViewFrame;
- (void)addChatModel:(KJChatModel *)chatModel;


@end
