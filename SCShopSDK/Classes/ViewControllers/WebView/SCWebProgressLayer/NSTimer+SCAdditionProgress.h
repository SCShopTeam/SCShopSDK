//
//  NSTimer+AdditionProgress.h
//  ecmc
//
//  Created by gaoleyu on 16-10-26..
//  Copyright (c) 2013年 cp9. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSTimer (SCAdditionProgress)

- (void)pause;
- (void)resume;
- (void)resumeWithTimeInterval:(NSTimeInterval)time;

@end
