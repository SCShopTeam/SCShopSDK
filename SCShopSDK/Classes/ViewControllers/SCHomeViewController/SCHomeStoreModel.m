//
//  SCHomeStoreModel.m
//  shopping
//
//  Created by gejunyu on 2021/3/16.
//  Copyright © 2021 jsmcc. All rights reserved.
//

#import "SCHomeStoreModel.h"

@implementation SCHomeStoreModel

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass
{
    return @{@"lightspotList": SCHomeLightSpotModel.class,
             @"couponList": SCHomeCouponModel.class};
}

- (void)parsingTopGoodsModelsFromData:(NSDictionary *)data
{
    NSArray *list = data[@"topGoodsList"];

    //本店优惠商品
    self.topGoodsList = [SCHomeGoodsModel parsingModelsFromData:list parentType:0];
}

- (void)parsingActivityModelsFromData:(NSDictionary *)data
{
    //活动顺序   1直播、2秒杀、3预售、4拼团、5抽奖、6优惠券  两两一组
    
    NSMutableArray *temp = [NSMutableArray arrayWithCapacity:7];
    
    //直播
    NSDictionary *livePlayerInfo = data[@"livePlayerInfo"];
    if (VALID_DICTIONARY(livePlayerInfo)) {
        SCHomeActivityModel *liveModel = [SCHomeActivityModel parsingModelFromData:livePlayerInfo type:SCHomeActivityTypeLive];
        [temp addObject:liveModel];
        [temp addObject:liveModel];  //直播占两个位置
    }
    
    //秒杀
    NSDictionary *limitedInfo = data[@"limitedInfo"];
    if (VALID_DICTIONARY(limitedInfo)) {
        SCHomeActivityModel *limitedModel = [SCHomeActivityModel parsingModelFromData:limitedInfo type:SCHomeActivityTypeLimited];
        [temp addObject:limitedModel];
    }
    
    //预售
    NSDictionary *presaleInfo = data[@"presaleInfo"];
    if (VALID_DICTIONARY(presaleInfo)) {
        SCHomeActivityModel *presaleModel = [SCHomeActivityModel parsingModelFromData:presaleInfo type:SCHomeActivityTypePresale];
        [temp addObject:presaleModel];
    }
    
    //拼团
    NSDictionary *groupInfo = data[@"groupInfo"];
    if (VALID_DICTIONARY(groupInfo)) {
        SCHomeActivityModel *groupModel = [SCHomeActivityModel parsingModelFromData:groupInfo type:SCHomeActivityTypeGroup];
        [temp addObject:groupModel];
    }
    
    //活动
    NSArray *activityInfoList = data[@"activityInfoList"];
    if (VALID_ARRAY(activityInfoList)) {
        for (NSDictionary *dict in activityInfoList) {
            if (VALID_DICTIONARY(dict)) {
                SCHomeActivityModel *model = [SCHomeActivityModel parsingModelFromData:dict type:SCHomeActivityTypeActivity];
                [temp addObject:model];
                
            }
        }
    }
    

    NSMutableArray *models = [NSMutableArray arrayWithCapacity:temp.count/2];
    NSInteger index = 1;
    while (index < temp.count) {   //model两两组成一个数组，作为一个元素。 如果总数量是奇数，多余的一个model去除
        id model1 = temp[index-1];
        id model2 = temp[index];
        [models addObject:@[model1,model2]];
        index+=2;
    }
    
    self.activityList = models.copy;
    
}

@end


@implementation SCHomeLightSpotModel


@end



@implementation SCHomeCouponModel



@end

@implementation SCHomeActivityModel
+ (instancetype)parsingModelFromData:(NSDictionary *)data type:(SCHomeActivityType)type
{
    if (!VALID_DICTIONARY(data) || type > SCHomeActivityTypeActivity) {
        return nil;
    }
    
    SCHomeActivityModel *model = [SCHomeActivityModel new];
    model.type = type;
    
    switch (type) {
        case SCHomeActivityTypeLive:
        {
            model.name         = [data sc_safeStringValueForKey:@"livePlayerName"];
            model.topic        = [data sc_safeStringValueForKey:@"livePlayerTopic"];
            model.sellPoint    = [data sc_safeStringValueForKey:@"livePlayerSellPoint"];
            model.liveAudience = [data sc_safeIntegerValueForKey:@"liveAudience"];
            model.link         = [data sc_safeStringValueForKey:@"livePlayerUrl"];
            model.startTime    = [data sc_safeStringValueForKey:@"startTime"];
            model.endTime      = [data sc_safeStringValueForKey:@"endTime"];
            model.imageUrl     = [data sc_safeStringValueForKey:@"liveImageUrl"];
            model.goodsList    = [SCHomeGoodsModel parsingModelsFromData:data[@"liveGoodsList"] parentType:type];
        }
            break;
        case SCHomeActivityTypeLimited:
        {
            model.name      = [data sc_safeStringValueForKey:@"limitedName"];
            model.topic     = [data sc_safeStringValueForKey:@"limitedTopic"];
            model.sellPoint = [data sc_safeStringValueForKey:@"limitedSellPoint"];
            model.link      = [data sc_safeStringValueForKey:@"limitedUrl"];
            model.startTime = [data sc_safeStringValueForKey:@"startTime"];
            model.endTime   = [data sc_safeStringValueForKey:@"endTime"];
            model.goodsList = [SCHomeGoodsModel parsingModelsFromData:data[@"limitedGoodsList"] parentType:type];
        }
            break;
        case SCHomeActivityTypePresale:
        {
            model.name            = [data sc_safeStringValueForKey:@"presaleName"];
            model.topic           = [data sc_safeStringValueForKey:@"presaleTopic"];
            model.sellPoint       = [data sc_safeStringValueForKey:@"presalePoint"];
            model.link            = [data sc_safeStringValueForKey:@"presaleUrl"];
            model.offerType       = [data sc_safeStringValueForKey:@"offerType"];
            model.preferentialFee = [data sc_safeIntegerValueForKey:@"preferentialFee"];
            model.goodsList       = [SCHomeGoodsModel parsingModelsFromData:data[@"presaleGoodsList"] parentType:type];
        }
            break;
        case SCHomeActivityTypeGroup:
        {
            model.name             = [data sc_safeStringValueForKey:@"groupName"];
            model.topic            = [data sc_safeStringValueForKey:@"groupTopic"];
            model.sellPoint        = [data sc_safeStringValueForKey:@"groupSellPoint"];
            model.link             = [data sc_safeStringValueForKey:@"groupUrl"];
            model.groupPersonCount = [data sc_safeIntegerValueForKey:@"groupPersonCount"];
            model.goodsList        = [SCHomeGoodsModel parsingModelsFromData:data[@"groupGoodsList"] parentType:type];
        }
            break;
        case SCHomeActivityTypeActivity:
        {
            model.name       = [data sc_safeStringValueForKey:@"activityName"];
            model.topic      = [data sc_safeStringValueForKey:@"topic"];
            model.sellPoint  = [data sc_safeStringValueForKey:@"activityPoints"];
            model.link       = [data sc_safeStringValueForKey:@"activityLink"];
            model.imageUrl   = [data sc_safeStringValueForKey:@"imageUrl"];
            model.activityId = [data sc_safeStringValueForKey:@"activityId"];
        }
            break;
            
        default:
            break;
    }
    
    return model;
    
}


@end

@implementation SCHomeGoodsModel
+ (NSArray <SCHomeGoodsModel *> *)parsingModelsFromData:(NSArray *)data parentType:(SCHomeActivityType)parentType
{
    if (!VALID_ARRAY(data)) {
        return nil;
    }
    
    NSMutableArray *temp = [NSMutableArray arrayWithCapacity:data.count];
    
    for (NSDictionary *dict in data) {
        if (VALID_DICTIONARY(dict)) {
            SCHomeGoodsModel *model = [SCHomeGoodsModel yy_modelWithDictionary:dict];
            model.parentType = parentType;
            [temp addObject:model];
        }
    }
    
    return temp.copy;
}


@end

//@implementation SCHomeLiveModel
//+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass
//{
//    return @{@"liveGoodsList": SCHomeGoodsModel.class};
//}
//
//@end
//
//@implementation SCHomeLimitedModel
//+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass
//{
//    return @{@"limitedGoodsList": SCHomeGoodsModel.class};
//}
//
//
//@end
//
//@implementation SCHomePresaleModel
//+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass
//{
//    return @{@"presaleGoodsList": SCHomeGoodsModel.class};
//}
//
//
//@end
//
//@implementation SCHomeGroupModel
//+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass
//{
//    return @{@"groupGoodsList": SCHomeGoodsModel.class};
//}
//
//
//@end
//
//@implementation SCHomeActivityModel
//
//
//@end

