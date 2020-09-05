//
//  SCTagShopViewModel.h
//  shopping
//
//  Created by gejunyu on 2020/8/7.
//  Copyright © 2020 jsmcc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SCCommodityModel.h"
#import "SCCategoryModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SCTagShopViewModel : NSObject
@property (nonatomic, assign, readonly) BOOL hasMoreData;
@property (nonatomic, strong, readonly) NSArray <SCCategoryModel *> *categoryList;
@property (nonatomic, strong, readonly) NSMutableArray <SCCommodityModel *> *commodityList;
@property (nonatomic, assign, readonly) NSInteger selectedIndex;

- (void)requestCategoryList:(SCHttpRequestSuccess)success failure:(SCHttpRequestFailed)failure;

- (void)requestCommodityList:(NSInteger)page completion:(SCHttpRequestCompletion)completion;


- (void)setModelSelected:(NSDictionary *)paramDic;

@end

NS_ASSUME_NONNULL_END
