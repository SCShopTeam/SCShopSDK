//
//  SCApolloOrderModel.m
//  shopping
//
//  Created by zhangtao on 2020/8/13.
//  Copyright © 2020 jsmcc. All rights reserved.
//

#import "SCApolloOrderModel.h"

@implementation SCApolloOrderModel
+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass
{
    return @{@"ordOrderItemsAppVOList": ordOrderItemModel.class};
}
@end


@implementation ordOrderItemModel



@end
