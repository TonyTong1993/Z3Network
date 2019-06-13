//
//  Z3NetworkConfig.h
//  Z3Newwork_Example
//
//  Created by 童万华 on 2019/6/2.
//  Copyright © 2019 Tony Tony. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class Z3URLConfig;
@interface Z3NetworkConfig : NSObject
@property (nonatomic,strong,readonly) Z3URLConfig *urlConfig;
@property (nonatomic,strong,readonly) NSURL *baseURL;

+ (instancetype)shareConfig;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;

- (void)setUrlConfig:(Z3URLConfig * _Nonnull)urlConfig;
- (BOOL)debugLogEnabled;
@end

NS_ASSUME_NONNULL_END
