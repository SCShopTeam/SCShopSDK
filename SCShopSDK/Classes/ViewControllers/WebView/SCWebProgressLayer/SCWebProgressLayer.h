//
//  WebProgressLayer.h
//  ecmc
//
//  Created by gaoleyu on 16-10-26..
//  Copyright (c) 2013年 cp9. All rights reserved.
//  精度条

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>



@interface SCWebProgressLayer : CAShapeLayer

- (void)finishedLoad;
- (void)startLoad;

- (void)closeTimer;

@end
