//
//  SCCategoryModel.m
//  shopping
//
//  Created by zhangtao on 2020/8/6.
//  Copyright © 2020 jsmcc. All rights reserved.
//

#import "SCCategoryModel.h"
@implementation SCCategoryModel
+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass
{
    return @{@"secondList": SecondCategoryModel.class};
}

@end


@implementation SecondCategoryModel



@end
