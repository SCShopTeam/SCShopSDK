//
//  SCWitStoreHeader.h
//  shopping
//
//  Created by gejunyu on 2020/9/3.
//  Copyright © 2020 jsmcc. All rights reserved.
//

#ifndef SCWitStoreHeader_h
#define SCWitStoreHeader_h

//控件左右边距
#define kWitStoreHorMargin SCREEN_FIX(12.5)
//圆角
#define kWitStoreCorner    SCREEN_FIX(10)

typedef NS_ENUM(NSInteger, SCWitQueryType) {
    SCWitQueryTypeSearch,  //搜索框
    SCWitQueryTypeNear,    //附近门店
    SCWitQueryTypeVIP,     //会员门店
    SCWitQueryTypeCommon   //常用门店
};

typedef NS_ENUM(NSInteger, SCWitSortType) {
    SCWitSortTypeNone,   //不排序
    SCWitSortTypeNear,   //附近
    SCWitSortTypeVIP,    //旗舰店
    SCWitSortTypeCoupon, //有券
    SCWitSortTypePeople  //人少
};

#endif /* SCWitStoreHeader_h */
