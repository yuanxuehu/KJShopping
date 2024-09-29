//
//  KJLivingChatTableView.h
//  KJShopping
//
//  Created by TigerHu on 2024/9/29.
//

#import <UIKit/UIKit.h>

@protocol KJLivingChatTableViewDelegate <NSObject>

- (void)slideFromLeftToRight;
- (void)slideFromRightToLeft;

@end

@interface KJLivingChatTableView : UITableView

@property (nonatomic, weak) id <KJLivingChatTableViewDelegate> slideDelegate;

@end
