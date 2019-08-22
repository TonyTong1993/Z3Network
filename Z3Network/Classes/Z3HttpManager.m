//
//  Z3NetworkManager.m
//  Z3Newwork_Example
//
//  Created by 童万华 on 2019/5/10.
//  Copyright © 2019 Tony Tony. All rights reserved.
//

#import "Z3HttpManager.h"
#import "Z3NetworkConfig.h"
#import "Z3URLConfig.h"
#import "Z3BaseRequest.h"
#import "Z3BaseResponse.h"
#import "Z3NetworkPrivate.h"
#import "AFNetworking.h"
#import <pthread/pthread.h>
#define Lock() pthread_mutex_lock(&_lock)
#define Unlock() pthread_mutex_unlock(&_lock)
@interface Z3HttpManager(){
    AFHTTPSessionManager *_manager;
    NSMutableDictionary<NSNumber *, Z3BaseRequest *> *_requestsRecord;
    pthread_mutex_t _lock;
    dispatch_queue_t _completionQueue;
}

@end
@implementation Z3HttpManager
+ (instancetype)manager {
    static Z3HttpManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _manager = [AFHTTPSessionManager manager];
        _requestsRecord = [NSMutableDictionary dictionary];
        pthread_mutex_init(&_lock, NULL);
        //设置af完成请求的队列
        _completionQueue = dispatch_queue_create("com.zzht.network.manager.processing", DISPATCH_QUEUE_CONCURRENT);
        _manager.completionQueue = _completionQueue;
        
    }
    return self;
    
}

- (void)addRequestToRecords:(Z3BaseRequest *)request {
    Lock();
    _requestsRecord[@(request.requestTask.taskIdentifier)] = request;
    Unlock();
}

- (void)removeRequestFromRecords:(Z3BaseRequest *)request {
    Lock();
    [_requestsRecord removeObjectForKey:@(request.requestTask.taskIdentifier)];
    Unlock();
}
    
- (void)sendHttpRequest:(Z3BaseRequest *)request{
    NSParameterAssert(request != nil);
    NSURLSessionTask *task = nil;
    if (request.requestSerializer) {
        [_manager setRequestSerializer:request.requestSerializer];
    }else {
        [_manager setRequestSerializer:[AFHTTPRequestSerializer serializer]];
    }
    if (request.responseSerializer) {
        [_manager setResponseSerializer:request.responseSerializer];
    }else {
        AFHTTPResponseSerializer *responseSerializer = [[AFJSONResponseSerializer alloc] init];
        responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain", nil];
         [_manager setResponseSerializer:responseSerializer];
    }
    
    switch (request.method) {
        case GET:
        task = [self sendGETHttpRequest:request];
        break;
        case POST:
        task = [self sendPOSTHttpRequest:request];
        break;
        default:
        break;
    }
    request.requestTask = task;
    //将请求添加到records中
    [self addRequestToRecords:request];
}

- (NSURLSessionTask *)sendGETHttpRequest:(Z3BaseRequest *)request {
    NSString *url = [self buildRequestUrl:request];
    NSDictionary *params = [self buildRequestParameters:request];
    NSURLSessionTask *task = [_manager GET:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self handleRequestResult:task responseObject:responseObject error:nil];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self handleRequestResult:task responseObject:nil error:error];
    }];
    return task;
}
    
- (NSURLSessionTask *)sendPOSTHttpRequest:(Z3BaseRequest *)request  {
    NSString *url = [self buildRequestUrl:request];
    NSDictionary *params = [self buildRequestParameters:request];
    //判断请求是否需要上传formData
    NSURLSessionTask *task = nil;
    if (request.formDataBuilder) {
        task = [_manager POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            request.formDataBuilder(formData);
        } progress:^(NSProgress * _Nonnull uploadProgress) {
            if (request.progressCallback) {
                request.progressCallback(uploadProgress);
            }
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              [self handleRequestResult:task responseObject:responseObject error:nil];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              [self handleRequestResult:task responseObject:nil error:error];
        }];
    }else {
       task = [_manager POST:url parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
           if (request.progressCallback) {
               request.progressCallback(uploadProgress);
           }
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             [self handleRequestResult:task responseObject:responseObject error:nil];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             [self handleRequestResult:task responseObject:nil error:error];
        }];

    }
    return task;
}

- (void)cancelHttpRequest:(Z3BaseRequest *)request {
     NSParameterAssert(request != nil);
    [request.requestTask cancel];
    [self removeRequestFromRecords:request];
}

- (void)handleRequestResult:(NSURLSessionTask *)task responseObject:(id)responseObject error:(NSError *)error  {
    Lock();
    Z3BaseRequest *request = _requestsRecord[@(task.taskIdentifier)];
    Unlock();
    id response = nil;
    if (request.responseClasz) {
        response = [[request.responseClasz alloc] init];
        NSAssert([response isKindOfClass:[Z3BaseResponse class]], @"responseClasz must be kind of Z3BaseResponse class");
    }else {
        response = [[Z3BaseResponse alloc] init];
    }
    if (error) {
        [(Z3BaseResponse*)response setError:error];
        dispatch_async(dispatch_get_main_queue(), ^{
            request.failureCompletionBlock(response);
        });
        
    }else {
        [(Z3BaseResponse*)response setResponseJSONObject:responseObject];
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            if ([[responseObject allKeys] containsObject:@"isSuccess"]) {
                if (![responseObject[@"isSuccess"] boolValue]) {
                    NSString *message = responseObject[@"msg"];
                    if (message) {
                        NSError *error = [NSError errorWithDomain:Z3ServerErrorDomain code:Z3ServerErrorCode userInfo:@{@"msg":message}];
                        [(Z3BaseResponse*)response setError:error];
                    }
                    dispatch_async(dispatch_get_main_queue(), ^{
                        request.failureCompletionBlock(response);
                    });
                    return;
                }
            }
        }
        if ([(Z3BaseResponse*)response respondsToSelector:@selector(toModel)]) {
            [(Z3BaseResponse*)response toModel];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            request.successCompletionBlock(response);
        });
            //TODO:根据cache status 判断是否需要缓存数据
    }
    [self removeRequestFromRecords:request];
}

- (NSString *)buildRequestUrl:(Z3BaseRequest *)request {
    NSParameterAssert(request != nil);
    NSString *absoluteURL = request.absoluteURL;
    if (absoluteURL) {
        return absoluteURL;
    }else {
        NSURL *baseURL = [[Z3NetworkConfig shareConfig] baseURL];
        if ([[baseURL path] length] > 0 && ![[baseURL absoluteString] hasSuffix:@"/"]) {
            baseURL = [baseURL URLByAppendingPathComponent:@""];
        }
        NSString *urlStr = request.urlStr;
        NSURL *url = [NSURL URLWithString:urlStr relativeToURL:baseURL];
        return [url absoluteString];
    }
}

- (NSDictionary *)buildRequestParameters:(Z3BaseRequest *)request {
     NSParameterAssert(request != nil);
    NSDictionary *params = request.parameters;
    if (params == nil) {
        params = @{};
    }
    if (request.userInfo) {
        NSMutableDictionary *mparams = [NSMutableDictionary dictionary];
        [mparams addEntriesFromDictionary:request.userInfo];
        [mparams addEntriesFromDictionary:params];
        return [mparams copy];
    }else {
        return params;
    }
}
@end
