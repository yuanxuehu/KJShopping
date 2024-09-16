//
//  KJAPIManager.m
//  KJShopping
//
//  Created by TigerHu on 2024/4/22.
//

#import "KJAPIManager.h"
//#import "KJShowMessage.h"
#import <AFNetworking/AFHTTPSessionManager.h>

#define kRequestTimeoutErrorToast @"网络超时，稍后再试试"
#define kRequestDefaultErrorToast @"网络繁忙，稍后再试试"

#define  KTimeOut       30 //超时时间

typedef enum : NSUInteger {
    JsonType,
    Unnormal,
    FormBody,
} ContentType;

@interface KJAPIManager ()
/**
 域名
 */
@property (nonatomic, strong) NSString *hostAddress;
/**
  新域名
 */
@property (nonatomic, strong) NSString *otherHostAddress;

@end

@implementation KJAPIManager

+ (instancetype)shardManager
{
    static KJAPIManager *shardManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shardManager = [[KJAPIManager alloc] init];
    });
    
    return shardManager;
}

#pragma mark-- http请求
- (RACSignal *)requestTenApiAuthDataWithUrl:(NSString *)urlString requestData:(NSDictionary *)requestData headerData:(NSDictionary *)headerData {
    @weakify(self);
    NSLog(@"urlString ==== %@", urlString);
    NSLog(@"requestData == %@", requestData);
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);
        AFHTTPSessionManager *manager = [self sessionManager:Unnormal];
        for (NSString *key in headerData.allKeys) {
            [manager.requestSerializer setValue:[headerData objectForKey:key] ?: @"" forHTTPHeaderField:key];
        }
        NSURLSessionDataTask *sessionTask = [manager POST:urlString parameters:requestData progress:nil success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {
            NSLog(@"responseObject == %@", responseObject);
            NSMutableDictionary *response = [[NSMutableDictionary alloc] init];
            if ([responseObject objectForKey:@"Msg"]) {
                [response setObject:[responseObject objectForKey:@"Msg"] forKey:@"message"];
            }
            if ([responseObject objectForKey:@"Status"]) {
                if ([[responseObject objectForKey:@"Status"] integerValue] == 1) {
                    [response setObject:@(200) forKey:@"code"];
                } else {
                    [response setObject:[responseObject objectForKey:@"Status"] forKey:@"code"];
                }
            }
            if ([responseObject objectForKey:@"Result"]) {
                [response setObject:[responseObject objectForKey:@"Result"] forKey:@"data"];
            }
            [self requestSuccessWithResponse:response businessProcessError:NO subscriber:subscriber];
        } failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
            NSString *message = kRequestDefaultErrorToast;
            if (error.code == NSURLErrorTimedOut /*-1001*/) {
                message = kRequestTimeoutErrorToast;
            }
            [self requestErrorWithCode:error.code message:message businessProcessError:NO subscriber:subscriber];
        }];
        
        return [RACDisposable disposableWithBlock:^{
            [sessionTask cancel];
        }];
    }];
}


- (RACSignal *)postDataWithMethod:(NSString *)method requestData:(NSDictionary *)requestData{
    return [self postDataWithMethod:method requestData:requestData businessProcessError:NO];
}

- (RACSignal *)postDataWithMethod:(NSString *)method requestData:(NSDictionary *)requestData businessProcessError:(BOOL)businessProcessError {
    return [self postDataWithMethod:method requestData:requestData businessProcessError:businessProcessError normalContentType:YES];
}

- (RACSignal *)postDataWithMethod:(NSString *)method requestData:(NSDictionary *)requestData businessProcessError:(BOOL)businessProcessError normalContentType:(BOOL)normalContentType {
    return [self postDataWithMethod:method requestData:requestData businessProcessError:businessProcessError normalContentType:normalContentType type:0];
}

- (RACSignal *)postDataWithOtherHostMethod:(NSString *)method requestData:(NSDictionary *)requestData {
    return [self postDataWithMethod:method requestData:requestData businessProcessError:NO normalContentType:YES type:1];
}

- (RACSignal *)postDataWithMethod:(NSString *)method requestData:(NSDictionary *)requestData businessProcessError:(BOOL)businessProcessError normalContentType:(BOOL)normalContentType type:(NSInteger)type{
    @weakify(self);
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);
        NSString *host;
        if (type) {
            host = self.otherHostAddress;
        }else {
            host = self.hostAddress;
        }
        NSString *urlString = [NSString stringWithFormat:@"%@/%@", host, [method hasPrefix:@"/"] ? [method substringFromIndex:1] : method];
        NSURLSessionDataTask *sessionTask = [[self sessionManager:normalContentType ? JsonType:Unnormal] POST:urlString parameters:requestData progress:nil success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {
            NSLog(@"urlString == %@", urlString);
            NSLog(@"requestData == %@", requestData);
            NSLog(@"responseObject == %@", responseObject);
            [self requestSuccessWithResponse:responseObject businessProcessError:businessProcessError subscriber:subscriber];
        } failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
            NSString *message = kRequestDefaultErrorToast;
            if (error.code == NSURLErrorTimedOut /*-1001*/) {
                message = kRequestTimeoutErrorToast;
            }
            [self requestErrorWithCode:error.code message:message businessProcessError:businessProcessError subscriber:subscriber];
        }];
        
        return [RACDisposable disposableWithBlock:^{
            [sessionTask cancel];
        }];
    }];
}


- (RACSignal *)getDataWithMethod:(NSString *)method requestData:(NSDictionary *)requestData {
    return [self getDataWithMethod:method requestData:requestData businessProcessError:NO];
}

- (RACSignal *)getDataWithMethod:(NSString *)method requestData:(NSDictionary *)requestData businessProcessError:(BOOL)businessProcessError {
    return [self getDataWithMethod:method requestData:requestData businessProcessError:businessProcessError type:0];
}

- (RACSignal *)getDataWithOtherHostMethod:(NSString *)method requestData:(NSDictionary *)requestData {
    return [self getDataWithMethod:method requestData:requestData businessProcessError:NO type:1];
}

- (RACSignal *)getDataWithMethod:(NSString *)method requestData:(NSDictionary *)requestData businessProcessError:(BOOL)businessProcessError type:(NSInteger)type {
    
    @weakify(self);
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);
        NSString *host;
        if (type) {
            host = self.otherHostAddress;
        }else {
            host = self.hostAddress;
        }
        NSString *urlString = [NSString stringWithFormat:@"%@/%@", host, [method hasPrefix:@"/"] ? [method substringFromIndex:1] : method];
        NSURLSessionDataTask *sessionTask = [[self sessionManager:JsonType] GET:urlString parameters:requestData progress:nil success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {
            
            NSLog(@"get--responseObject:%@", responseObject);
            [self requestSuccessWithResponse:responseObject businessProcessError:businessProcessError subscriber:subscriber];
        } failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
            
            NSString *message = kRequestDefaultErrorToast;
            if (error.code == NSURLErrorTimedOut /*-1001*/) {
                message = kRequestTimeoutErrorToast;
            }
            [self requestErrorWithCode:error.code message:message businessProcessError:businessProcessError subscriber:subscriber];
        }];
        
        return [RACDisposable disposableWithBlock:^{
            [sessionTask cancel];
        }];
    }];
}

- (RACSignal *)uploadImgVideoWidthProgressMethod:(NSString *)method requestData:(NSData *)requestData parameters:(NSDictionary *)parameters dataType:(NSInteger)dataType progress:(progressBlock)uploadProgress businessProcessError:(BOOL)businessProcessError
{
    {
        @weakify(self);
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            @strongify(self);
            NSString *urlString = [NSString stringWithFormat:@"%@/%@", self.hostAddress, [method hasPrefix:@"/"] ? [method substringFromIndex:1] : method];
            NSURLSessionTask *sessionTask = [[self sessionManager:FormBody] POST:urlString parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> _Nonnull formData){
                
                if (dataType == 0) {
                    
                    // 图片
                    [formData appendPartWithFileData:requestData name:@"file" fileName:@"imageFileName.jpg" mimeType:@"image/jpeg"];
                } else {
                 
                    // 视频
                    [formData appendPartWithFileData:requestData name:@"file" fileName:@"video"  mimeType:@"application/octet-stream"];
                }
            } progress:uploadProgress success:^(NSURLSessionDataTask * _Nonnull task, id _Nonnull responseObject){
                NSLog(@"urlString == %@", urlString);
                NSLog(@"responseObject == %@", responseObject);
                [self requestSuccessWithResponse:responseObject businessProcessError:businessProcessError subscriber:subscriber];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error){
                NSString *message = kRequestDefaultErrorToast;
                if (error.code == NSURLErrorTimedOut /*-1001*/) {
                    message = kRequestTimeoutErrorToast;
                }
                [self requestErrorWithCode:error.code message:message businessProcessError:businessProcessError subscriber:subscriber];
            }];
            return [RACDisposable disposableWithBlock:^{
                [sessionTask cancel];
            }];
        }];
    }
}

- (RACSignal *)uploadImageWidthArrayMethod:(NSString *)method requestData:(NSArray <NSData *>*)dataArray parameters:(NSDictionary *)parameters businessProcessError:(BOOL)businessProcessError
{
    @weakify(self);
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);
        NSString *urlString = [NSString stringWithFormat:@"%@/%@", self.hostAddress, [method hasPrefix:@"/"] ? [method substringFromIndex:1] : method];
        NSURLSessionTask *sessionTask = [[self sessionManager:FormBody] POST:urlString parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> _Nonnull formData){
            
            for (int i = 0; i <dataArray.count; i ++) {
                
                [formData appendPartWithFileData:dataArray[i] name:[NSString stringWithFormat:@"file%ld",(long)i +1] fileName:@"imageFileName.jpg" mimeType:@"image/jpeg"];
            }
        } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id _Nonnull responseObject){
            NSLog(@"urlString == %@", urlString);
            NSLog(@"responseObject == %@", responseObject);
            [self requestSuccessWithResponse:responseObject businessProcessError:businessProcessError subscriber:subscriber];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error){
            NSString *message = kRequestDefaultErrorToast;
            if (error.code == NSURLErrorTimedOut /*-1001*/) {
                message = kRequestTimeoutErrorToast;
            }
            [self requestErrorWithCode:error.code message:message businessProcessError:businessProcessError subscriber:subscriber];
        }];
        return [RACDisposable disposableWithBlock:^{
            [sessionTask cancel];
        }];
    }];
}


- (RACSignal *)uploadImgVideoWidthBodyMethod:(NSString *)method requestData:(NSData *)requestData parameters:(NSDictionary *)parameters dataType:(NSInteger)dataType businessProcessError:(BOOL)businessProcessError
{
    @weakify(self);
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);
        NSString *urlString = [NSString stringWithFormat:@"%@/%@", self.hostAddress, [method hasPrefix:@"/"] ? [method substringFromIndex:1] : method];
        NSURLSessionTask *sessionTask = [[self sessionManager:FormBody] POST:urlString parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> _Nonnull formData){
            
            if (dataType == 0) {
                
                // 图片
                [formData appendPartWithFileData:requestData name:@"file" fileName:@"imageFileName.jpg" mimeType:@"image/jpeg"];
            } else {
             
                // 视频
                [formData appendPartWithFileData:requestData name:@"file" fileName:@"video"  mimeType:@"application/octet-stream"];
            }
        } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id _Nonnull responseObject){
            NSLog(@"urlString == %@", urlString);
            NSLog(@"responseObject == %@", responseObject);
            [self requestSuccessWithResponse:responseObject businessProcessError:businessProcessError subscriber:subscriber];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error){
            NSString *message = kRequestDefaultErrorToast;
            if (error.code == NSURLErrorTimedOut /*-1001*/) {
                message = kRequestTimeoutErrorToast;
            }
            [self requestErrorWithCode:error.code message:message businessProcessError:businessProcessError subscriber:subscriber];
        }];
        return [RACDisposable disposableWithBlock:^{
            [sessionTask cancel];
        }];
    }];
    
}

- (RACSignal *)uploadImgVideoMethod:(NSString *)method requestData:(NSData *)requestData dataType:(NSInteger)dataType  businessProcessError:(BOOL)businessProcessError
{
    return [self uploadImgVideoWidthBodyMethod:method requestData:requestData parameters:nil dataType:dataType businessProcessError:businessProcessError];
}

#pragma mark - 请求结果处理
- (void)requestSuccessWithResponse:(NSDictionary *)response businessProcessError:(BOOL)businessProcessError subscriber:(id<RACSubscriber>)subscriber {
    NSInteger code = [[response objectForKey:@"code"] integerValue];
    if (code == 200) { // 请求成功
        id data = [response objectForKey:@"data"];
        id ext = [response objectForKey:@"ext"];
        if ([data isEqual:[NSNull null]]) {
            data = nil;
        }
        if ([ext isEqual:[NSNull null]]) {
            ext = nil;
        }
        if (ext) {
            [subscriber sendNext:RACTuplePack(data, ext)];
        } else {
            [subscriber sendNext:data];
        }
        [subscriber sendCompleted];
        return;
    }
    NSString *message = [response safeStringForKey:@"message"];
    if ((code == 402 || code == 401) && [KJSharedUserInfo sharedInstance].isLogined) { // 需要刷新token
        [[KJSharedUserInfo sharedInstance].refreshTokenCommand execute:nil];
    }
    [self requestErrorWithCode:code message:message businessProcessError:businessProcessError subscriber:subscriber];
}

- (void)requestErrorWithCode:(NSInteger)code message:(NSString *)message businessProcessError:(BOOL)businessProcessError subscriber:(id<RACSubscriber>)subscriber {
    NSDictionary *userInfo = @{ @"code":@(code), @"message": message ?: @"" };
    [subscriber sendError:[NSError errorWithDomain:@"" code:code userInfo:userInfo]];
    if (!businessProcessError) {
        
        [KJShowMessage showMessage:message];
    }
}



#pragma mark -- getter
- (AFHTTPSessionManager *)sessionManager:(ContentType)type {
    AFHTTPSessionManager *sessionMgr = [AFHTTPSessionManager manager];
    if (type == JsonType) {
        sessionMgr.requestSerializer = [AFJSONRequestSerializer serializer];
    }else if (type == Unnormal){
        [sessionMgr.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    }
    sessionMgr.responseSerializer = [AFJSONResponseSerializer serializer];
//    sessionMgr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/plain", nil];
    sessionMgr.operationQueue.maxConcurrentOperationCount = 5;
    // 超时时间
    sessionMgr.requestSerializer.timeoutInterval = KTimeOut;
    // 请求头
    NSString *token = [KJSharedUserInfo sharedInstance].accessToken;
    if (IsNotNilAndEmpty(token)) {
        [sessionMgr.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@", token] forHTTPHeaderField:@"Authorization"];
    }
    return sessionMgr;
}

- (NSString *)hostAddress {
    if (!_hostAddress) {
        _hostAddress = [[KJNetConfig sharedInstance] envValueWithKey:kNetEnv_Http];
        if ([_hostAddress hasSuffix:@"/"]) {
            _hostAddress = [_hostAddress substringToIndex:_hostAddress.length - 1];
        }
    }
    return _hostAddress;
}

- (NSString *)otherHostAddress
{
    if (!_otherHostAddress) {
        _otherHostAddress = [[KJNetConfig sharedInstance] envValueWithKey:kNetEnv_newHttp];
        if ([_otherHostAddress hasSuffix:@"/"]) {
            _otherHostAddress = [_otherHostAddress substringToIndex:_otherHostAddress.length -1];
        }
    }
    return _otherHostAddress;
}

@end
