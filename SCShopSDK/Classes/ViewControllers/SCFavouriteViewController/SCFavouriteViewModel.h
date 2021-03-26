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

//收藏列表
- (void)requestFavoriteList:(SCHttpRequestCompletion)completion;

//推荐列表
- (void)requestRecommend:(SCHttpRequestCompletion)completion;

//删除商品
- (void)requestFavoriteDelete:(SCFavouriteModel *)model success:(SCHttpRequestSuccess)success failure:(SCHttpRequestFailed)failure;

//新增商品 （不用）
+ (void)requestFavoriteAdd:(SCFavouriteModel *)model success:(SCHttpRequestSuccess)success failure:(SCHttpRequestFailed)failure;



@end

NS_ASSUME_NONNULL_END
