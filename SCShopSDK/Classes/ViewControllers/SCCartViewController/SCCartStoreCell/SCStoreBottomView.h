//
//  SCStoreBottomView.h
//  shopping
//
//  Created by gejunyu on 2020/7/9.
//  Copyright © 2020 jsmcc. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SCStoreBottomView : UIView
@property (nonatomic, assign) CGFloat price;
@property (nonatomic, assign) NSInteger balanceNum;

@property (nonatomic, copy) void (^balanceBlock)(void);

@end

NS_ASSUME_NONNULL_END
