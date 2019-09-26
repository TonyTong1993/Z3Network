//
//  Z3URLConfig.m
//  Z3Newwork_Example
//
//  Created by ZZHT on 2019/5/10.
//  Copyright © 2019年 Tony Tony. All rights reserved.
//

#import "Z3URLConfig.h"

@implementation Z3URLConfig
static NSString * Z3URLConfigHostKey = @"com.zzht.url.config.host";
static NSString * Z3URLConfigPortKey = @"com.zzht.url.config.port";
static NSString * Z3URLConfigVirtualPathKey = @"com.zzht.url.config.virtual.path";
+ (instancetype)configration {
    return [[Z3URLConfig alloc] init];
}

- (void)setHost:(NSString *)host {
    [[NSUserDefaults standardUserDefaults] setObject:host forKey:Z3URLConfigHostKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setPort:(NSString *)port {
    [[NSUserDefaults standardUserDefaults] setObject:port forKey:Z3URLConfigPortKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setVirtualPath:(NSString *)virtualPath {
    [[NSUserDefaults standardUserDefaults] setObject:virtualPath forKey:Z3URLConfigVirtualPathKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)scheme {
    return @"http";
}

- (NSString *)host {
    NSString *host = [[NSUserDefaults standardUserDefaults] objectForKey:Z3URLConfigHostKey];
    if (host == nil) {
//        host = @"https://test_gismobile.macaowatercloud.com";
//        host = @"http://2140u809i6.imwork.net";
        host = @"192.168.8.147";
    }
    
    return host;
}

- (NSString *)port {
    NSString *port = [[NSUserDefaults standardUserDefaults] objectForKey:Z3URLConfigPortKey];
    if (port == nil) {
         port = @"7778";
//        port = @"10938";
//        port = @"8085";
    }
    return port;
}

- (NSString *)virtualPath {
    NSString *virtualPath = [[NSUserDefaults standardUserDefaults] objectForKey:Z3URLConfigVirtualPathKey];
    if (virtualPath == nil) {
        virtualPath = @"ServiceEngine";
    }
    
    return virtualPath;
}

- (NSURL *)baseURL {
    NSMutableString *mBaseURL = [[NSMutableString alloc] initWithString:[self rootURLPath]];
    NSString *virtualPath = [self virtualPath];
    if (virtualPath == nil || virtualPath.length <= 0) {
        [mBaseURL appendString:@"/"];
    }else {
        if ([virtualPath hasPrefix:@"/"]) {
             [mBaseURL appendString:virtualPath];
        }else {
             [mBaseURL appendString:@"/"];
             [mBaseURL appendString:virtualPath];
        }
    }
   return [NSURL URLWithString:[mBaseURL copy]];
}

- (NSString *)rootURLPath {
    NSString *host = [self host];
    NSMutableString *mBaseURL = nil;
    if ([host hasPrefix:@"http"]) {
        mBaseURL = [[NSMutableString alloc] initWithString:host];
    }else {
        mBaseURL = [[NSMutableString alloc] initWithString:[self scheme]];
        [mBaseURL appendString:@"://"];
        [mBaseURL appendString:[self host]];
    }
    
    [mBaseURL appendString:@":"];
    [mBaseURL appendString:[self port]];
    return [mBaseURL copy];
}
@end


