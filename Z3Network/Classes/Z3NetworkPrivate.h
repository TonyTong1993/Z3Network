//
//  Z3NetworkPrivate.h
//  Z3Newwork_Example
//
//  Created by 童万华 on 2019/6/4.
//  Copyright © 2019 Tony Tony. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Z3BaseResponse.h"
NS_ASSUME_NONNULL_BEGIN
FOUNDATION_EXPORT void Z3Log(NSString *format, ...) NS_FORMAT_FUNCTION(1,2);
@interface Z3NetworkPrivate : NSObject

@end

@interface Z3BaseResponse(Private)
- (void)setResponse:(NSHTTPURLResponse * _Nonnull)response;
- (void)setResponseStatusCode:(NSInteger * _Nonnull)responseStatusCode;
- (void)setResponseHeaders:(NSDictionary * _Nullable)responseHeaders;
- (void)setResponseData:(NSData * _Nullable)responseData;
- (void)setResponseString:(NSString * _Nullable)responseString;
-(void)setResponseJSONObject:(id _Nullable)responseJSONObject;
- (void)setError:(NSError * _Nullable)error;
@end



NS_ASSUME_NONNULL_END
