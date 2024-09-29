//
//  KJChatModel.m
//  KJShopping
//
//  Created by TigerHu on 2024/9/29.
//

#import "KJChatModel.h"

@interface KJChatModel ()

@property (nonatomic, strong) NSArray *nameColorArray;

@end

@implementation KJChatModel

- (NSString *)nameColor {
    NSUInteger random = arc4random_uniform(400);
    return self.nameColorArray[random % 4];
}

- (NSArray *)nameColorArray {
    if (!_nameColorArray) {
        _nameColorArray = @[ @"ffc67d",
                             @"7dff99",
                             @"807dff",
                             @"ff7db4"
        ];
    }
    return _nameColorArray;
}

@end
