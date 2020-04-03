//
//  Z3BaseRequest.m
//  Z3Newwork_Example
//
//  Created by 童万华 on 2019/5/11.
//  Copyright © 2019 Tony Tony. All rights reserved.
//

#import "Z3BaseRequest.h"
#import "Z3HttpManager.h"
@interface Z3BaseRequest()

@end
@implementation Z3BaseRequest

- (instancetype)initWithRelativeToURL:(NSString *)relativeToURL
                               method:(RequestMethod)method
                            parameter:(NSDictionary *)parameters
                              success:(Z3RequestCompletionBlock)successBlock
                              failure:(Z3RequestCompletionBlock)failureBlock {
    self = [super init];
    if (self) {
        _urlStr = relativeToURL;
        [self conveniceInitWithMethod:method parameter:parameters success:successBlock failure:failureBlock];
    }
    return self;
}

- (instancetype)initWithAbsoluteURL:(NSString *)absoluteURL
                             method:(RequestMethod)method
                          parameter:(NSDictionary *)parameters
                            success:(Z3RequestCompletionBlock)successBlock
                            failure:(Z3RequestCompletionBlock)failureBlock {
    self = [super init];
    if (self) {
        _absoluteURL = absoluteURL;
        [self conveniceInitWithMethod:method parameter:parameters success:successBlock failure:failureBlock];
    }
    return self;
}

- (void)conveniceInitWithMethod:(RequestMethod)method
                      parameter:(NSDictionary *)parameters
                        success:(Z3RequestCompletionBlock)successBlock
                        failure:(Z3RequestCompletionBlock)failureBlock {
    _method = method;
    _parameters = parameters;
    _successCompletionBlock = successBlock;
    _failureCompletionBlock = failureBlock;
}

- (void)start {
    [[Z3HttpManager manager] sendHttpRequest:self];
}

- (void)stop {
    [[Z3HttpManager manager] cancelHttpRequest:self];
}

- (void)clearCompletionBlock {
    _successCompletionBlock = nil;
    _failureCompletionBlock = nil;
}

- (void)registerRequestProgressCallback:(ProgressCallback)callback {
    _progressCallback = callback;
}

- (NSDictionary *)userInfo {
    if (!_userInfo) {
        //        _userInfo = @{@"sys":@"mobile",
        //                      @"f":@"json",
        //                      @"_type":@"json",
        //                      };
        
        _userInfo = @{@"sys":@"mpat",
                      @"f":@"json",
                      @"_type":@"json",
                      @"client":@"app",
        };
    }
    return _userInfo;
}

- (BOOL)isExecuting {
    return self.requestTask.state == NSURLSessionTaskStateRunning;
}

@end
