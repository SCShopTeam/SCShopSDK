//
//  SCFavouriteViewModel.h
//  shopping
//
//  Created by gejunyu on 2020/8/4.
//  Copyright © 2020 jsmcc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SCFavouriteModel.h"
#import "SCCommodityModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SCFavouriteViewModel : NSObject
@property (nonatomic, strong, readonly) NSMutableArray <SCFavouriteModel *> *favouriteList;
@property (nonatomic, strong, readonly) NSArray <SCCommodityModel *> *recommendList;

- (void)requestFavoriteList:(SCHttpRequestCompletion)completion;

- (void)requestRecommend:(SCHttpRequestCompletion)completion;

@end

NS_ASSUME_NONNULL_END
