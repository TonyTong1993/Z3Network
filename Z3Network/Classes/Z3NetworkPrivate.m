//
//  Z3NetworkPrivate.m
//  Z3Newwork_Example
//
//  Created by 童万华 on 2019/6/4.
//  Copyright © 2019 Tony Tony. All rights reserved.
//

#import "Z3NetworkPrivate.h"
#import "Z3NetworkConfig.h"
void Z3Log(NSString *format, ...) {
#ifdef DEBUG
    if (![Z3NetworkConfig shareConfig].debugLogEnabled) {
        return;
    }
    va_list argptr;
    va_start(argptr, format);
    NSLogv(format, argptr);
    va_end(argptr);
#endif
}
@implementation Z3NetworkPrivate

@end

