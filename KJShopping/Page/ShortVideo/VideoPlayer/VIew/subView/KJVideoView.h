//
//  KJVideoView.h
//  KJShopping
//
//  Created by TigerHu on 2024/9/16.
//

#import <UIKit/UIKit.h>

@class KJShortVideoPlayerCoverVC;
@class KJPlayerVC;

@interface KJVideoView : UIView

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) KJShortVideoPlayerCoverVC *coverVC;
@property (nonatomic, strong) KJPlayerVC *playerVC;

@end
