//
//  SCSCOrderModel.m
//  shopping
//
//  Created by zhangtao on 2020/8/12.
//  Copyright © 2020 jsmcc. All rights reserved.
//

#import "SCSCOrderModel.h"

@implementation SCSCOrderModel
+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass
{
    return @{@"goodsList": SCOrderGoodsModel.class};
}
@end


@implementation SCOrderGoodsModel



@end
