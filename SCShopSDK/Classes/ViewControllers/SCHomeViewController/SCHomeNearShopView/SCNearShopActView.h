//
//  SCNearShopActView.h
//  shopping
//
//  Created by gejunyu on 2020/8/20.
//  Copyright © 2020 jsmcc. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SCHActModel;
@class SCHActImageModel;

NS_ASSUME_NONNULL_BEGIN

@interface SCNearShopActView : UIView
@property (nonatomic, strong) SCHActModel *actModel;

@property (nonatomic, strong) NSArray <SCHActModel *> *actList;

@property (nonatomic, copy) void (^actBlock)(NSInteger index, SCHActImageModel *imgModel);

@end

NS_ASSUME_NONNULL_END
