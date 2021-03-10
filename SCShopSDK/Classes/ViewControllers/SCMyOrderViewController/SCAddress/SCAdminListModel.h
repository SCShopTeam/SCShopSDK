//
//  SCAdminListModel.h
//  shopping
//
//  Created by gejunyu on 2020/8/3.
//  Copyright © 2020 jsmcc. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, SCAdminType) {
    SCAdminTypeProvince = 1,   //省
    SCAdminTypeCity = 2,       //市
    SCAdminTypeRegion = 3      //区县
};

NS_ASSUME_NONNULL_BEGIN

//省市县地址列表

@interface SCAdminListModel : NSObject

@property (nonatomic, copy) NSString *adminNum;                        //行政单位编码
@property (nonatomic, copy) NSString *adminName;                       //行政单位名称
@property (nonatomic, assign) BOOL isDefault;                          //是否选中
@property (nonatomic, strong) NSArray <SCAdminListModel *> *children;  //子行政列表


@end

NS_ASSUME_NONNULL_END
