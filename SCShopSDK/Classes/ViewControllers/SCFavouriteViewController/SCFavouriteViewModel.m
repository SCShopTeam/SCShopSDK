//
//  SCFavouriteViewModel.m
//  shopping
//
//  Created by gejunyu on 2020/8/4.
//  Copyright © 2020 jsmcc. All rights reserved.
//

#import "SCFavouriteViewModel.h"

@interface SCFavouriteViewModel ()
@property (nonatomic, strong) NSMutableArray <SCFavouriteModel *> *favouriteList;
@property (nonatomic, strong) NSArray <SCCommodityModel *> *recommendList;
@end

@implementation SCFavouriteViewModel

- (void)requestFavoriteList:(SCHttpRequestCompletion)completion
{
    NSDictionary *param = @{kCurPageKey:@1,
                            kCountCurPageKey: @30};
    [SCRequestParams shareInstance].requestNum = @"favorite.list";
    
    [SCNetworkManager POST:SC_FAVORITE_LIST parameters:param success:^(id  _Nullable responseObject) {
        NSString *key = @"items";
        if (![SCNetworkTool checkResult:responseObject key:key forClass:NSArray.class completion:completion]) {
            return;
        }
        

        NSArray *items = responseObject[B_RESULT][key];

        [self.favouriteList removeAllObjects];
        for (NSDictionary *dict in items) {
            if (!VALID_DICTIONARY(dict)) {
                continue;
            }
            SCFavouriteModel *model = [SCFavouriteModel yy_modelWithDictionary:dict];
            [self.favouriteList addObject:model];
        }

        
        if (completion) {
            completion(nil);
        }
        
        
    } failure:^(NSString * _Nullable errorMsg) {
        if (completion) {
            completion(errorMsg);
        }
    }];
}

- (void)requestRecommend:(SCHttpRequestCompletion)completion
{
    [SCRequest requestRecommend:^(NSArray<SCCommodityModel *> * _Nonnull commodityList, BOOL hasNoData) {
        self.recommendList = commodityList;
        if (completion) {
            completion(nil);
        }
    } failure:^(NSString * _Nullable errorMsg) {
        if (completion) {
            completion(errorMsg);
        }
    } useCache:YES];

}


//删除商品
- (void)requestFavoriteDelete:(SCFavouriteModel *)model success:(SCHttpRequestSuccess)success failure:(SCHttpRequestFailed)failure
{
    if (!model || !VALID_STRING(model.favNum) || !VALID_STRING(model.itemNum)) {
        if (failure) {
            failure(@"param error");
        }
        return;
    }
    
    NSDictionary *param = @{@"favNum": model.favNum,
                            @"itemNum": model.itemNum};
    
    [SCRequestParams shareInstance].requestNum = @"favorite.delete";
    [SCNetworkManager POST:SC_FAVORITE_DELETE parameters:param success:^(id  _Nullable responseObject) {
        if (![SCNetworkTool checkCode:responseObject failure:failure]) {
            return;
        }
        
        if (success) {
            success(nil);
        }
        
    } failure:failure];
}



//新增商品 （不用）
+ (void)requestFavoriteAdd:(SCFavouriteModel *)model success:(SCHttpRequestSuccess)success failure:(SCHttpRequestFailed)failure
{
    if (!model || !VALID_STRING(model.itemNum)) {
        if (failure) {
            failure(@"itemNum null");
        }
        return;
    }
    
    NSDictionary *param = @{@"itemNum": model.itemNum};
    
    [SCRequestParams shareInstance].requestNum = @"favorite.add";
    [SCNetworkManager POST:SC_FAVORITE_ADD parameters:param success:^(id  _Nullable responseObject) {
        if (![SCNetworkTool checkCode:responseObject failure:failure]) {
            return;
        }
        
        if (success) {
            success(nil);
        }
        
    } failure:failure];
}

- (NSMutableArray<SCFavouriteModel *> *)favouriteList
{
    if (!_favouriteList) {
        _favouriteList = [NSMutableArray array];
    }
    return _favouriteList;
}


@end
