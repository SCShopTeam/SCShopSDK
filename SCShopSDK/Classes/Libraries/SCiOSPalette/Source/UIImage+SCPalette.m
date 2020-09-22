//
//  UIImage+SCPalette.m
//  Atom
//
//  Created by dylan.tang on 17/4/20.
//  Copyright © 2017年 dylan.tang All rights reserved.
//

#import "UIImage+SCPalette.h"

@implementation UIImage (SCPalette)

- (void)getPaletteImageColor:(GetColorBlock)block{
    [self getPaletteImageColorWithMode:DEFAULT_NON_MODE_PALETTE withCallBack:block];
    
}

- (void)getPaletteImageColorWithMode:(PaletteTargetMode)mode withCallBack:(GetColorBlock)block{
    SCPalette *palette = [[SCPalette alloc]initWithImage:self];
    [palette startToAnalyzeForTargetMode:mode withCallBack:block];
}

@end
