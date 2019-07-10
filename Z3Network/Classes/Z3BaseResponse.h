//
//  Z3BaseResponse.h
//  Z3Newwork_Example
//
//  Created by 童万华 on 2019/6/4.
//  Copyright © 2019 Tony Tony. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
extern NSErrorDomain const Z3ServerErrorDomain;
extern NSInteger const Z3ServerErrorCode;
@interface Z3BaseResponse : NSObject
@property (nonatomic,strong,readonly) NSHTTPURLResponse        *response;

@property (nonatomic,assign,readonly) NSInteger                *responseStatusCode;

@property (nonatomic, strong, readonly, nullable) NSDictionary *responseHeaders;

@property (nonatomic, strong, readonly, nullable) NSData       *responseData;

@property (nonatomic, strong, readonly, nullable) NSString     *responseString;

@property (nonatomic, strong, readonly, nullable) id           responseJSONObject;

@property (nonatomic, strong, readonly, nullable) id           data;

@property (nonatomic, strong, readonly, nullable) NSError      *error;

@property (nonatomic, copy, readonly, nullable) NSString      *errorMsg;

- (void)toModel;
@end

NS_ASSUME_NONNULL_END
