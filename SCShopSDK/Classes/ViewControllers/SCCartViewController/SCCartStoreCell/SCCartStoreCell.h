//
//  SCCartStoreCell.h
//  shopping
//
//  Created by gejunyu on 2020/7/9.
//  Copyright © 2020 jsmcc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCCartModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SCCartStoreCell : UICollectionViewCell

@property (nonatomic, strong) SCCartModel *model;

@property (nonatomic, copy) void (^deleteBlock)(SCCartItemModel *item, BOOL needConfirm);
@property (nonatomic, copy) void (^commitBlock)(void);
@property (nonatomic, copy) void (^rowClickBlock)(NSString *url);

+ (CGFloat)calculateRowHeight:(SCCartModel *)model;

@end

NS_ASSUME_NONNULL_END
