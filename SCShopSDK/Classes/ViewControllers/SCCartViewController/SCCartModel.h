//
//  SCCartModel.h
//  shopping
//
//  Created by gejunyu on 2020/7/9.
//  Copyright © 2020 jsmcc. All rights reserved.
//

#import <Foundation/Foundation.h>
@class SCCartItemModel;

NS_ASSUME_NONNULL_BEGIN

@interface SCCartModel : NSObject
@property (nonatomic, copy) NSString *busiNum;                            //商户编码
@property (nonatomic, copy) NSString *busiName;                           //商户名称
@property (nonatomic, copy) NSString *busiType;                           //商户性质
@property (nonatomic, strong) NSArray <SCCartItemModel *> *cartItems;     //商户下商品列表

//自定义
@property (nonatomic, assign) BOOL selectedAll;      //是否全选
@property (nonatomic, assign) CGFloat sumPrice;      //合计
@property (nonatomic, assign) NSInteger balanceNum;  //结算数量

//是否是阿波罗商户
@property (nonatomic, assign) BOOL isApollo;

@property (nonatomic, copy) void (^updateSelectBlock)(SCCartModel *model);

- (void)updateData;

@end


@interface SCCartItemModel : NSObject

@property (nonatomic, copy) NSString *cartItemNum;        //购物车记录编码
@property (nonatomic, copy) NSString *itemNum;            //商品编码
@property (nonatomic, assign) CGFloat itemPrice;          //商品价格
@property (nonatomic, copy) NSString *itemTitle;          //商品标题
@property (nonatomic, copy) NSString *skuNum;             //商品SKU编码
@property (nonatomic, copy) NSString *skuName;            //商品SKU名称
@property (nonatomic, copy) NSString *itemThumb;          //商品缩略图
@property (nonatomic, assign) NSInteger itemQuantity;     //商品数量
@property (nonatomic, assign) BOOL itemValid;             //商品是否有效
@property (nonatomic, copy) NSString *categoryUrl;        //sku地址

//自定义
@property (nonatomic, assign) BOOL selected;   //是否被选中

@end

NS_ASSUME_NONNULL_END
