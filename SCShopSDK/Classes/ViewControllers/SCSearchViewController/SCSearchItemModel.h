//
//  SCSearchItemModel.h
//  shopping
//
//  Created by gejunyu on 2020/8/18.
//  Copyright © 2020 jsmcc. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SCSearchItemModel : NSObject

@property (nonatomic, copy) NSString *title;// 行标题
@property (nonatomic, copy) NSString *text;// 行内容
@property (nonatomic, copy) NSString *url;// 行相关的URL


//colunm
@property (nonatomic, copy) NSString *goodsSource;      //商店来源 [门店/自营]
@property (nonatomic, copy) NSString *shopAddr;         //门店地址
@property (nonatomic, copy) NSString *rate;             //价格
@property (nonatomic, copy) NSString *linePrice;        //划线价
@property (nonatomic, copy) NSString *shopName;         //店铺名称
@property (nonatomic, copy) NSString *shopLng;          //门店经度
@property (nonatomic, copy) NSString *shopLat;          //门店纬度
@property (nonatomic, copy) NSString *distanceNum;      //公里
@property (nonatomic, copy) NSString *busiNum;
@property (nonatomic, copy) NSString *targetId;
@property (nonatomic, copy) NSString *busiImage;
@property (nonatomic, copy) NSString *sourceId;
@property (nonatomic, copy) NSString *tsectionId;
@property (nonatomic, copy) NSString *introduce;
@property (nonatomic, copy) NSString *tsectionName;
@property (nonatomic, copy) NSString *tsectionNum;
@property (nonatomic, copy) NSString *labels;

//自定义
- (nullable NSAttributedString *)addressAttributedText;


@end


NS_ASSUME_NONNULL_END
