//
//  SCHomeStoreCell.h
//  shopping
//
//  Created by gejunyu on 2021/3/2.
//  Copyright © 2021 jsmcc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCHomeStoreModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SCHomeStoreCell : UITableViewCell

@property (nonatomic, strong) SCHomeStoreModel *model;

@property (nonatomic, copy) void (^callBlock)(NSString *contactPhone);
@property (nonatomic, copy) void (^serviceBlock)(NSString *serviceUrl);
@property (nonatomic, copy) void (^storePageBlock)(NSString *storeLink);
@property (nonatomic, copy) void (^storeGoodsBlock)(NSString *goodsDetailUrl, NSInteger index);
@property (nonatomic, copy) void (^activityGoodsBlock)(NSString *link, NSInteger index);
@property (nonatomic, copy) void (^activityLinkBlock)(NSString *link);

+ (CGFloat)getRowHeight:(SCHomeStoreModel *)model;

@end

NS_ASSUME_NONNULL_END
