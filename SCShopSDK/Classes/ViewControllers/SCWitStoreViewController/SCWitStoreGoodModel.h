//
//  SCWitStoreGoodModel.h
//  shopping
//
//  Created by gejunyu on 2020/8/30.
//  Copyright © 2020 jsmcc. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SCWitStoreGoodModel : NSObject
@property (nonatomic, copy) NSString *goodsId;           // "100460"商品id
@property (nonatomic, copy) NSString *goodsCode;         // "1587946" 商品编码
@property (nonatomic, copy) NSString *storeId;
@property (nonatomic, copy) NSString *storeCode;
@property (nonatomic, copy) NSString *goodsName;         //"绿联 安卓数据线...."
@property (nonatomic, assign) NSInteger wholesalePrice;  //零售价 65000
@property (nonatomic, copy) NSString *goodsPicture;      //商品图片
@property (nonatomic, copy) NSString *sufflx;            //后缀名   "jpg"
@property (nonatomic, copy) NSString *supplierName;      //供货商名称 "京东直供"
@property (nonatomic, copy) NSString *supplierCode;      //供货商编码 "JD"
@property (nonatomic, assign) NSInteger displayQuantity; //销量
@property (nonatomic, assign) NSInteger amount;          //库存数量
@property (nonatomic, copy) NSString *goodsPictureUrl;   //商品图片url
@property (nonatomic, copy) NSString *goodsH5Link;       //商品详情url
 
@end

NS_ASSUME_NONNULL_END
