//
//  Z3BaseResponse.m
//  Z3Newwork_Example
//
//  Created by 童万华 on 2019/6/4.
//  Copyright © 2019 Tony Tony. All rights reserved.
//

#import "Z3BaseResponse.h"
#import "Z3NetworkPrivate.h"
NSErrorDomain const Z3ServerErrorDomain = @"zzht.network.server.error";
NSInteger const Z3ServerErrorCode = 10000;
@implementation Z3BaseResponse
- (void)toModel {
    
}

@end
@implementation Z3BaseResponse(Private)

- (void)setResponse:(NSHTTPURLResponse *)response {
    _response = response;
}

- (void)setResponseStatusCode:(NSInteger *)responseStatusCode {
    _responseStatusCode = responseStatusCode;
}
- (void)setResponseHeaders:(NSDictionary *)responseHeaders {
    _responseHeaders = responseHeaders;
}
- (void)setResponseData:(NSData *)responseData {
    _responseData = responseData;
}
- (void)setResponseString:(NSString *)responseString {
    _responseString = responseString;
}
- (void)setResponseJSONObject:(id)responseJSONObject {
    _responseJSONObject = responseJSONObject;
}
-(void)setError:(NSError *)error {
    _error = error;
}
@end
