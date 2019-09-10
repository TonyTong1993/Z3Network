    //
    //  Z3BaseRequest.h
    //  Z3Newwork_Example
    //
    //  Created by 童万华 on 2019/5/11.
    //  Copyright © 2019 Tony Tony. All rights reserved.
    //
/*
 *description:Z3BaseRequest 请求基础类
 *设置请求
 *设置响应
 */
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSUInteger,RequestMethod) {
    GET,
    POST,
};


@class Z3BaseRequest,AFHTTPRequestSerializer,AFHTTPResponseSerializer,Z3BaseResponse;
@protocol AFMultipartFormData;
typedef void(^Z3RequestCompletionBlock)(__kindof Z3BaseResponse *response);
typedef void(^FormDataBuilder)(id<AFMultipartFormData> formData);
typedef void(^ProgressCallback)(NSProgress *progress);;
@interface Z3BaseRequest : NSObject

/**
 如果baseURL已经设置了，只需要设置relativeToURL
 */
@property (nonatomic,copy,readonly) NSString *urlStr;

/**
 如果设置了absoluteURL,此时baseURL将失效
 */
@property (nonatomic,copy,readonly) NSString *absoluteURL;
@property (nonatomic,copy,readonly) NSDictionary *parameters;
@property (nonatomic,assign,readonly) RequestMethod method;
@property (nonatomic,assign) NSTimeInterval *timeout;
@property (nonatomic,assign) short *retryCount;

#pragma mark - Request and Response Information
@property (nonatomic,strong) AFHTTPRequestSerializer *requestSerializer;

@property (nonatomic,strong) AFHTTPResponseSerializer *responseSerializer;

@property (nonatomic,strong,readwrite) NSURLSessionTask *requestTask;

@property (nonatomic,strong,readonly) Class responseClasz;

    ///  Return cancelled state of request task.
@property (nonatomic, readonly, getter=isCancelled) BOOL cancelled;

    ///  Executing state of request task.
@property (nonatomic, readonly, getter=isExecuting) BOOL executing;

@property (nonatomic,copy) FormDataBuilder formDataBuilder;

@property (nonatomic,copy) ProgressCallback progressCallback;

#pragma mark - Request Configuration

@property (nonatomic, strong, nullable) NSDictionary *userInfo;

@property (nonatomic, copy, nullable) Z3RequestCompletionBlock successCompletionBlock;

@property (nonatomic, copy, nullable) Z3RequestCompletionBlock failureCompletionBlock;

- (instancetype)initWithRelativeToURL:(NSString * _Nonnull)relativeToURL
                               method:(RequestMethod)method
                            parameter:(NSDictionary *)parameters
                              success:(Z3RequestCompletionBlock)successBlock
                              failure:(Z3RequestCompletionBlock)failureBlock;

- (instancetype)initWithAbsoluteURL:(NSString * _Nonnull)absoluteURL
                             method:(RequestMethod)method
                          parameter:(NSDictionary *)parameters
                            success:(Z3RequestCompletionBlock)successBlock
                            failure:(Z3RequestCompletionBlock)failureBlock;
    //开始请求
- (void)start;
    //取消请求
- (void)stop;

- (void)registerRequestProgressCallback:(ProgressCallback)callback;

@end

NS_ASSUME_NONNULL_END
