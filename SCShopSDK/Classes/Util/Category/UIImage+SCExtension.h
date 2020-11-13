//
//  UIImage+SCExtension.h
//  shopping
//
//  Created by gejunyu on 2020/7/3.
//  Copyright © 2020 jsmcc. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#undef  SCIMAGE
#define SCIMAGE(P)       [UIImage sc_imageNamed:P]


@interface UIImage (SCExtension)

+ (nullable UIImage *)sc_imageNamed:(NSString *)name;

+ (nullable UIImage *)sc_imageNamed:(NSString *)name scale:(NSInteger)scale;

+ (nullable UIImage *)sc_imageNamed:(NSString *)name type:(NSString *)type;

+ (nullable UIImage *)sc_imageNamed:(NSString *)name scale:(NSInteger)scale type:(NSString *)type;

- (UIImage *)sc_thumbWithSize:(CGSize)size;

- (UIColor *)sc_getPixelColorAtPoint:(CGPoint)point;

@end

NS_ASSUME_NONNULL_END
