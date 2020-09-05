//
//  SCGoodShopCell.h
//  shopping
//
//  Created by gejunyu on 2020/8/17.
//  Copyright © 2020 jsmcc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCHomeShopModel.h"

#define kGoodShopRowH SCREEN_FIX(170)

NS_ASSUME_NONNULL_BEGIN

@interface SCGoodShopCell : UITableViewCell
@property (nonatomic, strong) SCHomeShopModel *model;

@property (nonatomic, copy) void (^enterShopBlock)(SCHShopInfoModel *shopModel);
@property (nonatomic, copy) void (^imgBlock)(NSInteger index, SCHActImageModel *imgModel);

@end

NS_ASSUME_NONNULL_END
