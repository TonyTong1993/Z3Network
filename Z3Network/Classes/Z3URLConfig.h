//
//  Z3URLConfig.h
//  Z3Newwork_Example
//
//  Created by 童万华 on 2019/5/10.
//  Copyright © 2019年 Tony Tony. All rights reserved.
//

/*
 *目标:
 *用于修改或读取IP/端口/虚拟路径
 */
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Z3URLConfig : NSObject
    
/**
 获取主机IP地址
 */
@property (nonatomic,readonly) NSString *host;
    
/**
 获取端口号
 */
@property (nonatomic,readonly) NSString *port;
    
/**
 获取虚拟路径
 */
@property (nonatomic,readonly) NSString *virtualPath;
   
    
/**
 获取基础网址
 */
@property (nonatomic,readonly) NSURL *baseURL;

@property (nonatomic,readonly) NSString *baseURLString;

/**
 获取基础网址
 */
@property (nonatomic,copy,readonly) NSString *rootURLPath;

@property (nonatomic,copy,readonly) NSString *webURL;


+ (instancetype)configration;
    
/**
 保存IP地址

 @param host IP
 */
- (void)setHost:(NSString * _Nonnull)host;
    
/**
 设置端口号

 @param port 端口号
 */
- (void)setPort:(NSString * _Nonnull)port;
    
/**
 设置虚拟路径

 @param virtualPath 虚拟路径
 */
- (void)setVirtualPath:(NSString * _Nonnull)virtualPath;


/**
 设置网页的根URL

 @param webURL 根URL
 */
- (void)setWebURL:(NSString * _Nonnull)webURL;


@end
NS_ASSUME_NONNULL_END
