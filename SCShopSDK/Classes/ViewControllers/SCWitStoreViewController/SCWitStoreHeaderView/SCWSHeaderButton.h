//
//  SCWSHeaderButton.h
//  shopping
//
//  Created by gejunyu on 2020/8/28.
//  Copyright © 2020 jsmcc. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SCWitStoreGoodModel;
@class SCHomeGoodsModel;

NS_ASSUME_NONNULL_BEGIN

@interface SCWSHeaderButton : UIControl

@property (nonatomic, strong) SCWitStoreGoodModel *witGoodModel;

@property (nonatomic, strong) SCHomeGoodsModel *homeGoodsModel;

@end

NS_ASSUME_NONNULL_END
