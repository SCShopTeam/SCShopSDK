//
//  SCWitStoreHeaderView.h
//  shopping
//
//  Created by gejunyu on 2020/8/28.
//  Copyright © 2020 jsmcc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCWitStoreModel.h"
@class SCWitStoreGoodModel;

NS_ASSUME_NONNULL_BEGIN

@interface SCWitStoreHeaderView : UIView
@property (nonatomic, strong) SCWitStoreModel *model;

@property (nonatomic, copy) void (^phoneBlock)(NSString *phone);                       //电话
@property (nonatomic, copy) void (^goodSelectBlock)(SCWitStoreGoodModel *goodModel);   //商品
@property (nonatomic, copy) void (^orderBlock)(SCWitStoreModel *model);                //立即取号
@property (nonatomic, copy) void (^enterBlock)(SCWitStoreModel *model);                //进店逛逛
@property (nonatomic, copy) void (^orderHistoryBlock)(void);                           //排队记录


- (void)setGoodsList:(nullable NSArray <SCWitStoreGoodModel *> *)goodsList;  //推荐商品

@end

NS_ASSUME_NONNULL_END
