//
//  SCShopDelegateUtil.h
//  shopping
//
//  Created by gejunyu on 2021/3/1.
//  Copyright © 2021 jsmcc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SCShoppingManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface SCShopDelegateUtil : NSObject <SCShoppingDelegate>

+ (instancetype)sharedInstance;

@end

NS_ASSUME_NONNULL_END
