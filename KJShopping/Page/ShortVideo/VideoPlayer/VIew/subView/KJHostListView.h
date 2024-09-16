//
//  KJHostListView.h
//  KJShopping
//
//  Created by TigerHu on 2024/9/16.
//

#import <UIKit/UIKit.h>

@interface KJHostListView : UIView

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, copy) NSArray *dataArray;
@property (nonatomic, assign) BOOL startAnimation;

@end
