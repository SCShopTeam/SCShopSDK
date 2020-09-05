//
//  SCCartViewModel.h
//  shopping
//
//  Created by gejunyu on 2020/8/4.
//  Copyright © 2020 jsmcc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SCCartModel.h"
#import "SCCommodityModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SCCartViewModel : NSObject

@property (nonatomic, strong, readonly) NSMutableArray <SCCartModel *> *cartList;
@property (nonatomic, strong, readonly) NSArray <SCCommodityModel *> *recommendList;

//购物车列表
- (void)requestCartList:(SCHttpRequestCompletion)completion;

//为你推荐
- (void)requestRecommend:(SCHttpRequestCompletion)completion;

//结算
- (NSString *)getOrderUrl:(SCCartModel *)cart;


@end

NS_ASSUME_NONNULL_END
