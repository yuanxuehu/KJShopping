//
//  KJLiveNumView.h
//  KJShopping
//
//  Created by TigerHu on 2024/9/16.
//

#import <UIKit/UIKit.h>

@interface KJLiveNumView : UIView

@property (nonatomic, strong) UIView *numView;
@property (nonatomic, strong) UILabel *numLabel;
@property (nonatomic, strong) UIImageView *numImageView;
@property (nonatomic, strong) UIButton *numButton;

@property (nonatomic, copy) void (^openHostListBlock)(void);

@property (nonatomic, assign) NSInteger num;

@end
