//
//  UIImage+SCPalette.h
//  Atom
//
//  Created by dylan.tang on 17/4/20.
//  Copyright © 2017年 dylan.tang All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCPalette.h"

@interface UIImage (SCPalette)

//To avoid some weird problems,so I add the "SCPalette" prefix to the API declaration

- (void)getPaletteImageColor:(GetColorBlock)block;

//you can use '|' to separate every target mode ,eg :"DARK_VIBRANT_PALETTE | VIBRANT_PALETTE"

- (void)getPaletteImageColorWithMode:(PaletteTargetMode)mode withCallBack:(GetColorBlock)block;

@end
