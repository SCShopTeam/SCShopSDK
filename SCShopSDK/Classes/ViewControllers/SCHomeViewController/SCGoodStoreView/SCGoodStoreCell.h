//
//  SCGoodStoreCell.h
//  shopping
//
//  Created by gejunyu on 2020/8/17.
//  Copyright © 2020 jsmcc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCHomeStoreModel.h"

#define kGoodStoreRowH SCREEN_FIX(158)

NS_ASSUME_NONNULL_BEGIN

@interface SCGoodStoreCell : UITableViewCell
@property (nonatomic, strong) SCHomeStoreModel *model;

@property (nonatomic, copy) void (^enterShopBlock)(SCHShopInfoModel *shopModel);
@property (nonatomic, copy) void (^imgBlock)(NSInteger index, SCHActImageModel *imgModel);

@end

NS_ASSUME_NONNULL_END
