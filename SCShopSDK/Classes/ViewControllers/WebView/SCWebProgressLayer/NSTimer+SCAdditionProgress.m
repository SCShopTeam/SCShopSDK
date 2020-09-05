//
//  NSTimer+AdditionProgress.m
//  ecmc
//
//  Created by gaoleyu on 16-10-26..
//  Copyright (c) 2013年 cp9. All rights reserved.
//

#import "NSTimer+SCAdditionProgress.h"
@implementation NSTimer (SCAdditionProgress)

- (void)pause {
    if (!self.isValid) return;
    [self setFireDate:[NSDate distantFuture]];
}

- (void)resume {
    if (!self.isValid) return;
    [self setFireDate:[NSDate date]];
}

- (void)resumeWithTimeInterval:(NSTimeInterval)time {
    if (!self.isValid) return;
    [self setFireDate:[NSDate dateWithTimeIntervalSinceNow:time]];
}

@end
