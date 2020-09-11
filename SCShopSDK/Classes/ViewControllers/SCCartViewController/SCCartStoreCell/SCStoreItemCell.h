//
//  SCStoreItemCell.h
//  shopping
//
//  Created by gejunyu on 2020/7/9.
//  Copyright © 2020 jsmcc. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SCCartItemModel;

#define kCartStoreRowH         SCREEN_FIX(103.5)

NS_ASSUME_NONNULL_BEGIN

@interface SCStoreItemCell : UITableViewCell
@property (nonatomic, strong) SCCartItemModel *item;

@property (nonatomic, assign) BOOL userSelected;

@property (nonatomic, copy) void (^numBlock)(void);
@property (nonatomic, copy) void (^selectBlock)(void);

@property (nonatomic, copy) void (^deleteBlock)(SCCartItemModel *item);

@end

NS_ASSUME_NONNULL_END
