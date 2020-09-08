//
//  SCLifeViewModel.h
//  shopping
//
//  Created by gejunyu on 2020/8/7.
//  Copyright © 2020 jsmcc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SCCommodityModel.h"
#import "SCCategoryModel.h"
@class SCLifeSubViewController;

NS_ASSUME_NONNULL_BEGIN

@interface SCLifeViewModel : NSObject
@property (nonatomic, assign, readonly) BOOL hasMoreData;
@property (nonatomic, strong, readonly) NSArray <SCCategoryModel *> *categoryList;
@property (nonatomic, strong, readonly) NSArray <SCLifeSubViewController *> *subVcList;
@property (nonatomic, strong, readonly) NSMutableArray <SCCommodityModel *> *commodityList;
@property (nonatomic, assign, readonly) NSInteger selectedIndex;

- (void)requestCategoryList:(NSDictionary *)paramDic success:(SCHttpRequestSuccess)success failure:(SCHttpRequestFailed)failure;

- (void)requestCommodityList:(NSString *)typeNum page:(NSInteger)page completion:(SCHttpRequestCompletion)completion;


@end

NS_ASSUME_NONNULL_END
