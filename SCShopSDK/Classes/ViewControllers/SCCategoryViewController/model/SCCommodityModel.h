//
//  SCCommodityModel.h
//  shopping
//
//  Created by zhangtao on 2020/8/6.
//  Copyright © 2020 jsmcc. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SCCommodityModel : NSObject

@property(nonatomic,strong)NSString *categoryName;
@property(nonatomic,strong)NSString *tenantType;  //1:自营  2旗舰  3：
@property(nonatomic,strong)NSString *categoryTitle;
@property(nonatomic,strong)NSString *tenantNum;
@property(nonatomic,strong)NSString *picUrl;
@property(nonatomic,assign)CGFloat maxSalePrice;
@property(nonatomic,strong)NSString *tenantName;
@property(nonatomic,strong)NSString *installment;
@property(nonatomic,assign)CGFloat minSuggPrice;
@property(nonatomic,assign)CGFloat saleAmount;
@property(nonatomic,strong)NSString *categorySell;
@property(nonatomic,strong)NSString *categoryNum;
@property(nonatomic,strong)NSString *expressType;
@property(nonatomic,assign)CGFloat minSalePrice;  //显示价格
@property(nonatomic,assign)CGFloat maxSuggPrice;  //划线价格

@property(nonatomic,strong)NSString *detailUrl;

@end

NS_ASSUME_NONNULL_END
