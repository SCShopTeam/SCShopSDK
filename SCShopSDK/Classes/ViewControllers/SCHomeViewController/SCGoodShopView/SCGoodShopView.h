//
//  SCGoodShopView.h
//  shopping
//
//  Created by gejunyu on 2020/8/17.
//  Copyright © 2020 jsmcc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCHomeShopModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface SCGoodShopView : UICollectionReusableView

@property (nonatomic, strong) NSArray <SCHomeShopModel *> *goodShopList;

//查看更多
@property (nonatomic, copy) void (^moreBlock)(void);
@property (nonatomic, copy) void (^enterShopBlock)(NSInteger row, SCHShopInfoModel *shopModel);
@property (nonatomic, copy) void (^imgBlock)(NSInteger row, NSInteger index, SCHActImageModel *imgModel);


+ (CGFloat)sectionHeight:(NSInteger)rowNumber;


@end

NS_ASSUME_NONNULL_END
