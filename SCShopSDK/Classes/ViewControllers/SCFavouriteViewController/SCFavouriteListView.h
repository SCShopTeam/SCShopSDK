//
//  SCFavouriteListView.h
//  shopping
//
//  Created by gejunyu on 2020/8/13.
//  Copyright © 2020 jsmcc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCFavouriteModel.h"

#define kFavouriteRowH  SCREEN_FIX(148)

NS_ASSUME_NONNULL_BEGIN

@interface SCFavouriteListView : UICollectionReusableView
@property (nonatomic, strong) NSMutableArray <SCFavouriteModel *> *favouriteList;

@property (nonatomic, copy) void (^selectBlock)(NSInteger row);
@property (nonatomic, copy) void (^deleteBlock)(NSInteger row);

@end

NS_ASSUME_NONNULL_END
