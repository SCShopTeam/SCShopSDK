//
//  UIColor+SCHex.h
//  MessageCenterDemo
//
//  Created by gejunyu on 2020/6/12.
//  Copyright © 2020 jsbc. All rights reserved.
//

#import <UIKit/UIKit.h>

#undef    RGB
#define RGB(R,G,B)       [UIColor colorWithRed:R/255.0f green:G/255.0f blue:B/255.0f alpha:1.0f]

#undef    RGBA
#define RGBA(R,G,B,A)    [UIColor colorWithRed:R/255.0f green:G/255.0f blue:B/255.0f alpha:A]

#undef    HEX_RGB
#define HEX_RGB(V)       [UIColor colorWithHex:V]

#undef    HEX_RGBA
#define HEX_RGBA(V, A)   [UIColor colorWithHex:V alpha:A]

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (SCHex)

+ (UIColor *)colorWithHex:(NSString *)color alpha:(CGFloat)alpha;

+ (UIColor *)colorWithHex:(NSString *)color;

@end

NS_ASSUME_NONNULL_END
