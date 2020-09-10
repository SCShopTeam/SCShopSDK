//
//  SCApolloOrderModel.h
//  shopping
//
//  Created by zhangtao on 2020/8/13.
//  Copyright © 2020 jsmcc. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ordOrderItemModel;

@interface SCApolloOrderModel : NSObject

@property(nonatomic,strong)NSString *orderId;
@property(nonatomic,strong)NSString *storeName;
@property(nonatomic,strong)NSString *orderDetailUrl;
@property(nonatomic,strong)NSMutableArray<ordOrderItemModel *> *ordOrderItemsAppVOList;

//-(instancetype)

-(instancetype)initWithDic:(NSDictionary *)dic;

@end

@interface ordOrderItemModel : NSObject
@property(nonatomic,assign)NSInteger quantity;// = 1,  //数量
@property(nonatomic,strong)NSString *purchasePriceDesc;// = "0.01",
@property(nonatomic,strong)NSString *skuName;// = "测试审批",
@property(nonatomic,strong)NSString *memberPriceDesc;// = "",
@property(nonatomic,strong)NSString *retailPriceYuan;// = <null>,
@property(nonatomic,assign)CGFloat preferentialAmount;// = 0,
@property(nonatomic,assign)CGFloat memberPrice;// = <null>,
@property(nonatomic,strong)NSString *preferentialAmountDesc;// = "0.00",
@property(nonatomic,strong)NSString *comGoodsPicturesUrl;
@property(nonatomic,assign)CGFloat retailPrice ;//= 10,
@property(nonatomic,strong)NSString *skuId;// = "3000205001",
@property(nonatomic,assign)CGFloat purchasePrice;// = <null>,

@property(nonatomic,strong)NSString *Attribution;  //从数组goodsAttribution中遍历得到的字符串拼接

-(instancetype)initWithDic:(NSDictionary *)dic;

@end
