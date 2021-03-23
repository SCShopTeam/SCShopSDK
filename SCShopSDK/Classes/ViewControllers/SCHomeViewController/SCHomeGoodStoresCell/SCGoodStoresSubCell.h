//
//  SCGoodStoresSubCell.h
//  shopping
//
//  Created by gejunyu on 2021/3/2.
//  Copyright © 2021 jsmcc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCGoodStoresModel.h"

#define kGoodStoreRowH SCREEN_FIX(129)

NS_ASSUME_NONNULL_BEGIN

@interface SCGoodStoresSubCell : UITableViewCell
@property (nonatomic, strong) SCGoodStoresModel *model;

//@property (nonatomic, copy) void (^enterShopBlock)(SCGShopInfoModel *shopModel);
@property (nonatomic, copy) void (^imgBlock)(NSInteger index, SCGActImageModel *imgModel);

@end

NS_ASSUME_NONNULL_END
