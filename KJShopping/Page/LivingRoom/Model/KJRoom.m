//
//  KJRoom.m
//  KJShopping
//
//  Created by TigerHu on 2024/9/29.
//

#import "KJRoom.h"
#import <pthread.h>
#import "KJLivingRoomPlayInfo.h"

#pragma mark - 工具类
@interface KJProxy : NSProxy {
    KJRoom *_object;
}
- (instancetype)initWithInstance:(KJRoom *)cloud;
- (void)destroy;
@end

@implementation KJProxy
+ (Class)class {
    return [KJRoom class];
}

- (instancetype)initWithInstance:(KJRoom *)object
{
    _object = object;
    return self;
}
- (void)destroy {
    _object = nil;
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)sel {
    return [KJRoom instanceMethodSignatureForSelector:sel];
}

- (void)forwardInvocation:(NSInvocation *)invocation {
    if (_object) {
        [invocation invokeWithTarget:_object];
    } else {
        NSLog(@"Calling method on destroyed MLVBLiveRoom: %p, %s", self, [NSStringFromSelector(invocation.selector) UTF8String]);
    }
}

@end



@interface KJRoom ()
{
    BOOL inBackground;         //是否进入后台模式
    NSInteger videoQuality;    // 保存当前推流的视频质量
    KJRoomRole roomRole;       // 房间角色，创建者:0 普通观众:1
}



@end

static KJProxy *sharedInstance = nil;
static pthread_mutex_t sharedInstanceLock;

@implementation KJRoom

+ (void)load {
    pthread_mutex_init(&sharedInstanceLock, NULL);
}

+ (instancetype)sharedInstance {
    if (sharedInstance == nil) {
        pthread_mutex_lock(&sharedInstanceLock);
        if (sharedInstance == nil) {
            KJRoom *room = [[KJRoom alloc] initInternal];
            sharedInstance = [[KJProxy alloc] initWithInstance:room];
            NSLog(@"sharedInstance<%p> is created", sharedInstance);
        }
        pthread_mutex_unlock(&sharedInstanceLock);
    }
    return (KJRoom *)sharedInstance;
}

- (void)dealloc
{
//    [self.imManager prepareToDealloc];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (instancetype)initInternal {
    if (self = [super init]) {
        inBackground = NO;
        
        NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
        [center addObserver:self selector:@selector(willResignActive:) name:UIApplicationWillResignActiveNotification object:nil];
        [center addObserver:self selector:@selector(didBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
    }
    return self;
}

/**
 观众
 播放房间的混流播放地址
 */
- (void)enterRoomWithView:(NSString *)roomId
                   inView:(UIView *)view
               completion:(void(^)(NSInteger errCode, NSString *errMsg))completion {
    roomRole = KJRoomRoleMember;  // 房间角色为普通观众
    
    
}



- (void)setRoomPlayInfo:(KJLivingRoomPlayInfo *)roomPlayInfo
{
    _roomPlayInfo = roomPlayInfo;
    
    
    
}


@end
