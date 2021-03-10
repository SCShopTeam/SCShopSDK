//
//  SCHomeNavBar.h
//  shopping
//
//  Created by gejunyu on 2021/3/1.
//  Copyright © 2021 jsmcc. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SCHomeNavBar : UIView

@property (nonatomic, copy) void (^searchBlock)(void);

@property (nonatomic, copy) void (^serviceBlock)(void);

@property (nonatomic, copy) void (^moreBlock)(void);

@end

NS_ASSUME_NONNULL_END
