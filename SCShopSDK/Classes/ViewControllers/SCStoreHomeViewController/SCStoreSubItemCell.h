//
//  SCStoreSubItemCell.h
//  shopping
//
//  Created by gejunyu on 2021/3/8.
//  Copyright © 2021 jsmcc. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SCSiftItem;

NS_ASSUME_NONNULL_BEGIN

@interface SCStoreSubItemCell : UICollectionViewCell

@property (nonatomic, copy) NSString *tenantNum;

@property (nonatomic, strong) SCSiftItem *item;

@end

NS_ASSUME_NONNULL_END
