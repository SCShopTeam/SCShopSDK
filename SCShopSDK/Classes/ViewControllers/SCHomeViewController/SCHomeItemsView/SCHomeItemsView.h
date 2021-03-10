//
//  SCHomeItemsView.h
//  shopping
//
//  Created by gejunyu on 2021/3/3.
//  Copyright © 2021 jsmcc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCCategoryModel.h"
#import "SCCommodityModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SCHomeItemsView : UIView

@property (nonatomic, strong) NSArray <SCCategoryModel *> *categoryList;

@property (nonatomic, assign) NSInteger currentIndex;

@property (nonatomic, copy) void (^scrollBlock)(NSInteger index);

@property (nonatomic, copy) void (^selectBlock)(SCCommodityModel *model);

- (void)refresh;


@end

NS_ASSUME_NONNULL_END
