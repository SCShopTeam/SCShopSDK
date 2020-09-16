//
//  SCCartViewModel.m
//  shopping
//
//  Created by gejunyu on 2020/8/4.
//  Copyright © 2020 jsmcc. All rights reserved.
//

#import "SCCartViewModel.h"
#import "SCCategoryViewModel.h"

NSString *const SC_CART_DELETE_NOTIFICATION = @"SC_CART_DELETE_NOTIFICATION";

@interface SCCartViewModel ()
@property (nonatomic, strong) NSMutableArray <SCCartModel *> *cartList;
@property (nonatomic, strong) NSArray <SCCommodityModel *> *recommendList;
@end

@implementation SCCartViewModel

- (void)requestCartList:(SCHttpRequestCompletion)completion
{
    [SCRequestParams shareInstance].requestNum = @"cart.list";
    [SCNetworkManager POST:SC_CART_LIST parameters:nil success:^(id  _Nullable responseObject) {
        NSString *key = @"businesses";
        if (![SCNetworkTool checkResult:responseObject key:key forClass:NSArray.class completion:completion]) {
            return;
        }
        NSArray *businesses = responseObject[B_RESULT][key];
        
        [self.cartList removeAllObjects];
        for (NSDictionary *dict in businesses) {
            if (!VALID_DICTIONARY(dict)) {
                continue;
            }
            SCCartModel *model = [SCCartModel yy_modelWithDictionary:dict];
            [self.cartList addObject:model];
        }
        if (completion) {
            completion(nil);
        }
        
    } failure:^(NSString * _Nullable errorMsg) {
        completion(errorMsg);
    }];
}

- (void)requestRecommend:(SCHttpRequestCompletion)completion
{
    [SCCategoryViewModel requestRecommend:^(NSMutableArray<SCCommodityModel *> * _Nonnull commodityList) {
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

//结算
- (NSString *)getOrderUrl:(SCCartModel *)cart
{
    if (cart.isApollo) {
        NSString *sotreId = cart.busiNum;
        
        
        NSMutableArray *paramGoodsList = [NSMutableArray arrayWithCapacity:cart.cartItems.count];
        
        for (SCCartItemModel *item in cart.cartItems) {
            if (!item.selected) {
                continue;
            }
            
            NSDictionary *dict = @{@"amount": @(item.itemQuantity),
                                   @"skuId": item.itemNum,
                                   @"wholesalePrice": [NSString stringWithFormat:@"%02f",item.itemPrice]};
            [paramGoodsList addObject:dict];
            
        }
        NSError *error = nil;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:paramGoodsList options:NSJSONWritingPrettyPrinted error:&error];
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        NSString *jsonTemp = [jsonString stringByReplacingOccurrencesOfString:@"\n" withString:@""];

        NSString *url = [NSString stringWithFormat:@"%@/cnr-web/toFillOrder?storeId=%@&showSendWay=2&paramGoodsList=%@",IS_RELEASE_ENVIRONMENT ? @"https://wx.apollojs.cn" : @"https://cnr.asiainfo.com",sotreId, jsonTemp];
        
        
        return url;
    }else {
        NSMutableString *goodsNum = [NSMutableString string];
        NSMutableString *num      = [NSMutableString string];
        NSMutableString *objPrice = [NSMutableString string];
        
        for (SCCartItemModel *item in cart.cartItems) {
            if (!item.selected) {
                continue;
            }
            NSString *addGood = goodsNum.length == 0 ? item.itemNum : [NSString stringWithFormat:@"|%@",item.itemNum];
            [goodsNum appendString:addGood];
            
            NSString *addNum = num.length == 0 ? [NSString stringWithFormat:@"%li",item.itemQuantity] : [NSString stringWithFormat:@"|%li",item.itemQuantity];
            [num appendString:addNum];
            
            NSString *addPrice = objPrice.length == 0 ? [NSString stringWithFormat:@"%f",item.itemPrice] : [NSString stringWithFormat:@"|%f",item.itemPrice];
            [objPrice appendString:addPrice];
            
        }
        
        NSString *url = NSStringFormat(@"http://wap.js.10086.cn/ex/%@mall/pages/order.html?goodsNum=%@&num=%@&objPrice=%@",(IS_RELEASE_ENVIRONMENT ? @"" : @"test/"),goodsNum,num,objPrice);
        return url;
    }
}

- (NSMutableArray<SCCartModel *> *)cartList
{
    if (!_cartList) {
        _cartList = [NSMutableArray array];
    }
    return _cartList;
}

@end
