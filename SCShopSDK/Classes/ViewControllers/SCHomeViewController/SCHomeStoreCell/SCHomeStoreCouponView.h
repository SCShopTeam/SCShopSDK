//
//  SCHomeStoreCouponView.h
//  shopping
//
//  Created by gejunyu on 2021/3/8.
//  Copyright © 2021 jsmcc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCHomeStoreProtocol.h"
@class SCHomeStoreModel;

NS_ASSUME_NONNULL_BEGIN

@interface SCHomeStoreCouponView : UIView

@property (nonatomic, weak) id <SCHomeStoreProtocol> delegate;

@property (nonatomic, strong) SCHomeStoreModel *model;


@end

NS_ASSUME_NONNULL_END
