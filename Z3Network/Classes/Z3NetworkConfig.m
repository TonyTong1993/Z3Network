//
//  Z3NetworkConfig.m
//  Z3Newwork_Example
//
//  Created by 童万华 on 2019/6/2.
//  Copyright © 2019 Tony Tony. All rights reserved.
//

#import "Z3NetworkConfig.h"
#include "Z3URLConfig.h"
@implementation Z3NetworkConfig
+ (instancetype)shareConfig {
    static dispatch_once_t onceToken;
    static Z3NetworkConfig *_instance;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _urlConfig = [Z3URLConfig configration];
       _baseURL = [_urlConfig baseURL];
       _baseURLString = [_urlConfig baseURLString];
    }
    return self;
}

- (void)setUrlConfig:(Z3URLConfig *)urlConfig {
    _urlConfig = urlConfig;
    _baseURL = [urlConfig baseURL];
    _baseURLString = [_urlConfig baseURLString];
}

- (BOOL)debugLogEnabled {
    return YES;
}

- (NSString *)ipAndPort {
    return [NSString stringWithFormat:@"http://%@:%@",_urlConfig.host,_urlConfig.port];
}

@end
