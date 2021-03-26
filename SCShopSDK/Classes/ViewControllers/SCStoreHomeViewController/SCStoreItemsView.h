//
//  SCStoreItemsView.h
//  shopping
//
//  Created by gejunyu on 2021/3/8.
//  Copyright © 2021 jsmcc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SCSiftItem;

NS_ASSUME_NONNULL_BEGIN

@interface SCStoreItemsView : UIView

@property (nonatomic, copy) NSString *tenantNum;

@property (nonatomic, strong) NSArray <SCSiftItem *>*itemList;

@property (nonatomic, copy) void (^scrollBlock)(NSInteger index);

@property (nonatomic, copy) void (^selectBlock)(SCCommodityModel *model);

- (void)setCurrentIndex:(NSInteger)currentIndex;


@end

NS_ASSUME_NONNULL_END
