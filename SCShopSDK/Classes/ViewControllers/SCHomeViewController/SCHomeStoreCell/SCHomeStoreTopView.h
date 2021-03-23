//
//  SCHomeStoreTopView.h
//  shopping
//
//  Created by gejunyu on 2021/3/4.
//  Copyright © 2021 jsmcc. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SCHomeStoreModel;

NS_ASSUME_NONNULL_BEGIN

@interface SCHomeStoreTopView : UIView

@property (nonatomic, strong) SCHomeStoreModel *model;

@property (nonatomic, copy) void (^enterStoreBlock)(void);
@property (nonatomic, copy) void (^phoneBlock)(void);
@property (nonatomic, copy) void (^serviceBlock)(void);

@end

NS_ASSUME_NONNULL_END
