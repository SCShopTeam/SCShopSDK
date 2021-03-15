//
//  SCHomeGoodStoreCell.h
//  shopping
//
//  Created by gejunyu on 2021/3/2.
//  Copyright © 2021 jsmcc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCGoodStoreModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SCHomeGoodStoreCell : UITableViewCell

@property (nonatomic, strong) NSArray <SCGoodStoreModel *> *goodStoreList;

//查看更多
@property (nonatomic, copy) void (^moreBlock)(void);
@property (nonatomic, copy) void (^enterShopBlock)(NSInteger row, SCGShopInfoModel *shopModel);
@property (nonatomic, copy) void (^imgBlock)(NSInteger row, NSInteger index, SCGActImageModel *imgModel);

+ (CGFloat)getRowHeight:(NSInteger)rowNum;

@end

NS_ASSUME_NONNULL_END
