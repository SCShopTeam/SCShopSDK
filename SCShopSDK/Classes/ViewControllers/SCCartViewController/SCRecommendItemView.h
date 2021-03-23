//
//  SCRecommendItemView.h
//  shopping
//
//  Created by gejunyu on 2021/3/18.
//  Copyright © 2021 jsmcc. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SCCommodityModel;

NS_ASSUME_NONNULL_BEGIN

@interface SCRecommendItemView : UIView

@property (nonatomic, strong) NSArray <SCCommodityModel *> *list;

@property (nonatomic, copy) void (^selectBlock)(SCCommodityModel *model);

@end

NS_ASSUME_NONNULL_END
