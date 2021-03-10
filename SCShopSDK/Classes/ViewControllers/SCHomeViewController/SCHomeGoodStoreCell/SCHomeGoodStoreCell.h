//
//  SCHomeGoodStoreCell.h
//  shopping
//
//  Created by gejunyu on 2021/3/2.
//  Copyright © 2021 jsmcc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCHomeStoreModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SCHomeGoodStoreCell : UITableViewCell

@property (nonatomic, strong) NSArray <SCHomeStoreModel *> *goodStoreList;

//查看更多
@property (nonatomic, copy) void (^moreBlock)(void);
@property (nonatomic, copy) void (^enterShopBlock)(NSInteger row, SCHShopInfoModel *shopModel);
@property (nonatomic, copy) void (^imgBlock)(NSInteger row, NSInteger index, SCHActImageModel *imgModel);

+ (CGFloat)getRowHeight:(NSInteger)rowNum;

@end

NS_ASSUME_NONNULL_END
