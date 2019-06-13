//
//  Z3NetworkManager.h
//  Z3Newwork_Example
//
//  Created by 童万华 on 2019/5/10.
//  Copyright © 2019 Tony Tony. All rights reserved.
//
/*
 *description:Z3HttpManager
 *职责：
 *发送网络GET\POST请求,文件下载、断点续传
 *处理响应数据
 *回调用户期望的数据
 *缓存控制
 *重试控制
 */
#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN
@class Z3BaseRequest;
@interface Z3HttpManager : NSObject

+ (instancetype)manager;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;


- (void)sendHttpRequest:(Z3BaseRequest *)request;

- (void)cancelHttpRequest:(Z3BaseRequest *)request;
@end

NS_ASSUME_NONNULL_END
