//
//  SCCartStoreCell.h
//  shopping
//
//  Created by gejunyu on 2020/7/9.
//  Copyright © 2020 jsmcc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCStoreItemCell.h"
#import "SCCartModel.h"

NS_ASSUME_NONNULL_BEGIN

#define kCartStoreTopH         SCREEN_FIX(34)
#define kCartStoreBottomH      SCREEN_FIX(43)

@interface SCCartStoreCell : UICollectionViewCell

@property (nonatomic, strong) SCCartModel *model;

@property (nonatomic, copy) void (^deleteBlock)(SCCartItemModel *item);
@property (nonatomic, copy) void (^commitBlock)(void);
@property (nonatomic, copy) void (^rowClickBlock)(NSString *url);

@end

NS_ASSUME_NONNULL_END
