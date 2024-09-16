//
//  KJVC.m
//  KJShopping
//
//  Created by TigerHu on 2024/4/20.
//

#import "KJVC.h"
//#import "NSObject+RACDescription.h"

@interface KJVC ()
/// 跳转传递参数
@property (nonatomic, strong) NSMutableDictionary *params;
@end

@implementation KJVC

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    KJVC *vc = [super allocWithZone:zone];
    
    @weakify(vc);
    RACSignal *initServicesSignal = [vc rac_signalForSelector:@selector(viewDidLoad)];
    [initServicesSignal subscribeNext:^(id x) {
        @strongify(vc);
        [vc setPageTitleFromParams];
    }];
    
    return vc;
}

- (void)setPageTitleFromParams
{
    if (IsNotNilAndEmpty(self.params[@"pageTitle"])) {
        self.title = self.params[@"pageTitle"];
    }
}

- (instancetype)initWithParams:(NSDictionary *)params
{
    if (self = [super init]) {
        self.params = [[NSMutableDictionary alloc] initWithDictionary:params];
        [self initializeProperty];
        [self initialize];
    }
    return self;
}

- (void)initializeProperty
{
    for (NSString *key in self.params) {
        if ([self respondsToSelector:sel_registerName([key UTF8String])]) {
            [self setValue:self.params[key] forKey:key];
        }
    }
}

- (void)initialize {
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

@end
