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
#define SCIMAGE(P)       [UIImage bundleImageNamed:P]


@interface UIImage (SCExtension)

+ (nullable UIImage *)bundleImageNamed:(NSString *)name;

+ (nullable UIImage *)bundleImageNamed:(NSString *)name scale:(NSInteger)scale;

+ (nullable UIImage *)bundleImageNamed:(NSString *)name type:(NSString *)type;

+ (nullable UIImage *)bundleImageNamed:(NSString *)name scale:(NSInteger)scale type:(NSString *)type;

- (UIImage *)thumbWithSize:(CGSize)size;

@end

NS_ASSUME_NONNULL_END
