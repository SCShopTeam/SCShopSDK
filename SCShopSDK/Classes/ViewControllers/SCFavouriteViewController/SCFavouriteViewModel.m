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
        
        if (!self.favouriteList) {
            self.favouriteList = [NSMutableArray arrayWithCapacity:items.count];
            
        }else {
            [self.favouriteList removeAllObjects];
        }
        
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
    [SCRequest requestRecommend:^(NSArray<SCCommodityModel *> * _Nonnull commodityList, NSArray * _Nonnull originDatas) {
        self.recommendList = commodityList;
        if (completion) {
            completion(nil);
        }
    } failure:^(NSString * _Nullable errorMsg) {
        if (completion) {
            completion(errorMsg);
        }
    }];

}


@end
