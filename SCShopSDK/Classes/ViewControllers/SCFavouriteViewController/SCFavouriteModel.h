//
//  SCFavouriteModel.h
//  shopping
//
//  Created by gejunyu on 2020/8/4.
//  Copyright © 2020 jsmcc. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SCFavouriteModel : NSObject

@property (nonatomic, copy) NSString *favNum;       //收藏记录编码
@property (nonatomic, copy) NSString *busiType;     //商户性质
@property (nonatomic, copy) NSString *busiNum;      //商户编码
@property (nonatomic, copy) NSString *itemNum;      //商品编码
@property (nonatomic, assign) CGFloat itemPrice;    //商品价格
@property (nonatomic, copy) NSString *itemTitle;    //商品标题
@property (nonatomic, copy) NSString *itemThumb;    //商品缩略图
@property (nonatomic, copy) NSString *discount;     //商品优惠信息    Json文本（暂不使用）：
@property (nonatomic, assign) BOOL itemValid;       //商品是否有效    1为有效,0为失效
@property (nonatomic, copy) NSString *categoryUrl;

@end

NS_ASSUME_NONNULL_END
