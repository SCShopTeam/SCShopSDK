//
//  SCHomeMoreView.h
//  shopping
//
//  Created by gejunyu on 2021/3/3.
//  Copyright © 2021 jsmcc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCShoppingManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface SCHomeMoreView : UIImageView

@property (nonatomic, copy) void (^selectBlock)(SCShopMoreType type);

@end

NS_ASSUME_NONNULL_END
