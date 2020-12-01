//
//  SCApolloOrderModel.m
//  shopping
//
//  Created by zhangtao on 2020/8/13.
//  Copyright © 2020 jsmcc. All rights reserved.
//

#import "SCApolloOrderModel.h"

@implementation SCApolloOrderModel
//+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass
//{
//    return @{@"ordOrderItemsAppVOList": ordOrderItemModel.class};
//}

-(instancetype)initWithDic:(NSDictionary *)dic{
    
    if (self = [super init]) {
        
        if ([SCUtilities isValidDictionary:dic]) {
            
            NSDictionary *ordOrderInfoVO = dic[@"ordOrderInfoVO"];
            if ([SCUtilities isValidDictionary:ordOrderInfoVO]) {
                NSString *orderId = [NSString stringWithFormat:@"%@",ordOrderInfoVO[@"orderId"]];
                NSString *storeName = ordOrderInfoVO[@"storeName"];
                NSString *orderDetailUrl = ordOrderInfoVO[@"orderDetailUrl"];
                if ([SCUtilities isValidString:orderId]) {
                    self.orderId = orderId;
                }
                if ([SCUtilities isValidString:storeName]) {
                    self.storeName = storeName;
                }
                if ([SCUtilities isValidString:orderDetailUrl]) {
                    self.orderDetailUrl = orderDetailUrl;
                }
            }
            self.ordOrderItemsAppVOList = [NSMutableArray arrayWithCapacity:0];
            NSArray *ordOrderItemsAppVOList = dic[@"ordOrderItemsAppVOList"];
            if ([SCUtilities isValidArray:ordOrderItemsAppVOList]) {
                for (NSDictionary *dic in ordOrderItemsAppVOList) {
                    ordOrderItemModel *model = [[ordOrderItemModel alloc]initWithDic:dic];
                    [self.ordOrderItemsAppVOList addObject:model];
                }
            }
        }
        
    }
    
    return self;
    
}

@end


@implementation ordOrderItemModel

-(instancetype)initWithDic:(NSDictionary *)dic{
    if (self = [super init]) {
        
        NSInteger quantity = [dic[@"quantity"] integerValue];
        NSString *purchasePriceDesc = dic[@"purchasePriceDesc"];
        NSString *skuName = dic[@"skuName"];
        NSString *comGoodsPicturesUrl = dic[@"comGoodsPicturesUrl"];
            self.quantity = quantity;
        self.retailPrice = [dic[@"retailPrice"] floatValue];
        
        if ([SCUtilities isValidString:purchasePriceDesc]) {
            self.purchasePriceDesc = purchasePriceDesc;
        }
        if ([SCUtilities isValidString:skuName]) {
            self.skuName = skuName;
        }
        if ([SCUtilities isValidString:comGoodsPicturesUrl]) {
            self.comGoodsPicturesUrl = comGoodsPicturesUrl;
        }
        
        NSArray *goodsAttribution = dic[@"goodsAttribution"];
        
        if ([SCUtilities isValidArray:goodsAttribution]) {
            NSString *allAttribute = @"";
            for (NSDictionary *dic in goodsAttribution) {
                NSString *attributeValueName = dic[@"attributeValueName"];
                if ([SCUtilities isValidString:attributeValueName]) {
                    allAttribute = [NSString stringWithFormat:@"%@ %@",allAttribute,attributeValueName];
                }
            }
            self.Attribution = allAttribute;
        }
        
//        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}

@end
