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
static NSString * Z3URLConfigWebURLKey = @"com.zzht.url.web.url";
static NSString * Z3URLConfigProtocolKey = @"com.zzht.url.config.protocol";
static NSString * Z3URLConfigTraceReportURLKey = @"com.zzht.url.trace.report.url";
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

- (void)setWebURL:(NSString *)webURL {
    [[NSUserDefaults standardUserDefaults] setObject:webURL forKey:Z3URLConfigWebURLKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setProtocol:(NSString * _Nonnull)protocol{
    [[NSUserDefaults standardUserDefaults] setObject:protocol forKey:Z3URLConfigProtocolKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setTraceReportURL:(NSString * _Nonnull)traceReportURL{
    [[NSUserDefaults standardUserDefaults] setObject:traceReportURL forKey:Z3URLConfigTraceReportURLKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)scheme {
    return @"http";
}

- (NSString *)host {
    NSString *host = [[NSUserDefaults standardUserDefaults] objectForKey:Z3URLConfigHostKey];
    if (host == nil) {
        //host = @"https://test_gismobile.macaowatercloud.com";
        host = @"https://gismobile.macaowatercloud.com";
//        host = @"http://2140u809i6.imwork.net";
//        host = @"192.168.8.147";
#ifdef SUQIAN
         host = @"192.168.8.101";
#endif
    }
    
    return host;
}

- (NSString *)port {
    NSString *port = [[NSUserDefaults standardUserDefaults] objectForKey:Z3URLConfigPortKey];
    if (port == nil) {
        port = @"443";
//        port = @"10938";
//        port = @"8085";
#ifdef SUQIAN
        port = @"7777";
#endif
    }
    return port;
}

- (NSString *)virtualPath {
    NSString *virtualPath = [[NSUserDefaults standardUserDefaults] objectForKey:Z3URLConfigVirtualPathKey];
    if (virtualPath == nil) {
        virtualPath = @"mobileSvr";
    }
    
    return virtualPath;
}

- (NSString *)protocol {
    NSString *protocol = [[NSUserDefaults standardUserDefaults] objectForKey:Z3URLConfigProtocolKey];
    if (protocol == nil) {
        protocol = @"http";
    }
    
    return protocol;
}

- (NSString *)webURL {
    NSString *webURL = [[NSUserDefaults standardUserDefaults] objectForKey:Z3URLConfigWebURLKey];
    if (webURL == nil) {
        webURL = @"";
    }
    return webURL;
}

- (NSString *)traceReportURL {
    NSString *traceReportURL = [[NSUserDefaults standardUserDefaults] objectForKey:Z3URLConfigTraceReportURLKey];
    if (traceReportURL == nil) {
        traceReportURL = @"";
    }
    return traceReportURL;
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

- (NSString *)baseURLString {
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
    
    return [mBaseURL copy];
}

- (NSString *)baseURLStringWithOutVirtualPath{
    NSMutableString *mBaseURL = [[NSMutableString alloc] initWithString:[self rootURLPath]];
    [mBaseURL appendString:@"/"];
    
    return [mBaseURL copy];
}

- (NSString *)rootURLPath {
    NSString *host = [self host];
    NSMutableString *mBaseURL = nil;
    if ([host hasPrefix:@"http"]) {
        mBaseURL = [[NSMutableString alloc] initWithString:host];
    }else {
        mBaseURL = [[NSMutableString alloc] initWithString:[self protocol]];
        [mBaseURL appendString:@"://"];
        [mBaseURL appendString:[self host]];
    }
    
    [mBaseURL appendString:@":"];
    [mBaseURL appendString:[self port]];
    return [mBaseURL copy];
}
@end


