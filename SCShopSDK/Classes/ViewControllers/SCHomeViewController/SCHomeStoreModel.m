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

- (void)parsingActivityModelsFromData:(NSDictionary *)data
{
    //本店优惠商品
    self.topGoodsList = [self getGoodsModelFromList:data[@"topGoodsList"]];
    
    
    //活动顺序   1直播、2秒杀、3预售、4拼团、5抽奖、6优惠券  两两一组
    
    NSMutableArray *temp = [NSMutableArray arrayWithCapacity:7];
    
    //直播
    NSDictionary *livePlayerInfo = data[@"livePlayerInfo"];
    if (VALID_DICTIONARY(livePlayerInfo)) {
        SCHomeLiveModel *model = [SCHomeLiveModel yy_modelWithDictionary:livePlayerInfo];
        [temp addObject:model];
        [temp addObject:model]; //直播占两个位置
    }
    
    //秒杀
    NSDictionary *limitedInfo = data[@"limitedInfo"];
    if (VALID_DICTIONARY(limitedInfo)) {
        SCHomeLimitedModel *model = [SCHomeLimitedModel yy_modelWithDictionary:limitedInfo];
        [temp addObject:model];
    }
    
    //预售
    NSDictionary *presaleInfo = data[@"presaleInfo"];
    if (VALID_DICTIONARY(presaleInfo)) {
        SCHomePresaleModel *model = [SCHomePresaleModel yy_modelWithDictionary:presaleInfo];
        [temp addObject:model];
    }
    
    //拼团
    NSDictionary *groupInfo = data[@"groupInfo"];
    if (VALID_DICTIONARY(groupInfo)) {
        SCHomeGroupModel *model = [SCHomeGroupModel yy_modelWithDictionary:groupInfo];
        [temp addObject:model];
    }
    
    //活动
    NSArray *activityInfoList = data[@"activityInfoList"];
    if (VALID_ARRAY(activityInfoList)) {
        for (NSDictionary *dict in activityInfoList) {
            if (VALID_DICTIONARY(dict)) {
                SCHomeActivityModel *model = [SCHomeActivityModel yy_modelWithDictionary:dict];
                [temp addObject:model];
                
            }
        }
    }
    
//    if (temp.count%2 > 0) { //只取偶数位 多余的去掉
//        [temp removeLastObject];
//    }
    NSMutableArray *models = [NSMutableArray arrayWithCapacity:temp.count/2];
    NSInteger index = 1;
    while (index < temp.count) {   //model两两组成一个数组，作为一个元素。 如果一共是数量是奇数，多余的一个model去除
        id model1 = temp[index-1];
        id model2 = temp[index];
        [models addObject:@[model1,model2]];
        index+=2;
    }
    
    self.activityList = models.copy;
    
    /*
     {
         success = 1,
         resultCode = "000000",
         info = "",
         result =     {
             presaleInfo = <null>,
             activityInfoList =     (
             ),
             limitedInfo =     {
                 limitedTopic = "111",
                 limitedGoodsList =     (
                         {
                         supplierCode = "JD",
                         storeId = "10952599",
                         activityPrice = 80000000,
                         displayQuantity = 0,
                         amount = <null>,
                         supplierName = "京东",
                         guidePrice = <null>,
                         goodsLabel = <null>,
                         goodsCode = "3284255",
                         goodsName = "迪士尼Disney 清新系列毛绒玩具 生日礼物公仔抱枕 玩偶布娃娃靠垫 9” 黛丝 DSN(T)1171 22厘米",
                         offerType = <null>,
                         storeCode = <null>,
                         groupPersonCount = <null>,
                         wholesalePrice = 20,
                         goodsId = "102710",
                         preferentialFee = <null>,
                         goodsPictureUrl = "https://cnr.asiainfo.com/apollosrv/api/common/v1.0/getImage/5ca37c665b4fa5770eede32e/jpg/260x260",
                     },
                 ),
                 endTime = <null>,
                 limitedUrl = "https://wx.apollojs.cn/limited-web/limitedDiscount?storeId=10952599&storeCode=14999860",
                 startTime = <null>,
                 limitedName = "新品秒杀",
                 limitedSellPoint = "1111",
             },
             groupInfo =     {
                 groupUrl = "https://cnr.asiainfo.com/cnr-web/pinTuanList?storeId=10952599&storeCode=14999860",
                 groupName = "新品拼团",
                 groupGoodsList =     (
                         {
                         supplierCode = "APOLLO",
                         storeId = "10952599",
                         activityPrice = <null>,
                         displayQuantity = 0,
                         amount = <null>,
                         supplierName = "门店自营",
                         guidePrice = 0,
                         goodsLabel = <null>,
                         goodsCode = "ZC3000287001",
                         goodsName = "测试商品0001",
                         offerType = <null>,
                         storeCode = <null>,
                         groupPersonCount = 2,
                         wholesalePrice = 199000,
                         goodsId = "3000287001",
                         preferentialFee = <null>,
                         goodsPictureUrl = "https://cnr.asiainfo.com/apollosrv/api/common/v1.0/getImage/e7eb1dfc14e54e5d9a4049f0f795e1ed/jpg/350x350",
                     },
                 ),
                 groupSellPoint = "1",
                 groupPersonCount = <null>,
                 groupTopic = "1",
             },
             topGoodsList = <null>,
             livePlayerInfo = <null>,
         },
         resultMessage = "操作成功",
     }

*/
}

- (NSArray <SCHomeGoodsModel *> *)getGoodsModelFromList:(NSArray *)list
{
    if (!VALID_ARRAY(list)) {
        return nil;
    }
    
    NSMutableArray *temp = [NSMutableArray arrayWithCapacity:list.count];
    
    for (NSDictionary *dict in list) {
        if (VALID_DICTIONARY(dict)) {
            SCHomeGoodsModel *model = [SCHomeGoodsModel yy_modelWithDictionary:dict];
            [temp addObject:model];
        }
    }
    
    return temp.copy;
    
}

@end


@implementation SCHomeLightSpotModel


@end



@implementation SCHomeCouponModel



@end

@implementation SCHomeGoodsModel


@end

@implementation SCHomeLiveModel
+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass
{
    return @{@"liveGoodsList": SCHomeGoodsModel.class};
}

@end

@implementation SCHomeLimitedModel
+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass
{
    return @{@"limitedGoodsList": SCHomeGoodsModel.class};
}


@end

@implementation SCHomePresaleModel
+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass
{
    return @{@"presaleGoodsList": SCHomeGoodsModel.class};
}


@end

@implementation SCHomeGroupModel
+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass
{
    return @{@"groupGoodsList": SCHomeGoodsModel.class};
}


@end

@implementation SCHomeActivityModel


@end

