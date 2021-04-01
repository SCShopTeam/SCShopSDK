//
//  SCAddressSelectView.h
//  shopping
//
//  Created by gejunyu on 2020/7/31.
//  Copyright © 2020 jsmcc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCAddressModel.h"
#import "SCAdminListModel.h"

typedef void(^SCAddressBlock)(SCAddressModel * _Nonnull addressModel);

NS_ASSUME_NONNULL_BEGIN

@interface SCAddressSelectView : UIView

//新增或修改地址
+ (void)showIn:(UIViewController *)vc addressModel:(nullable SCAddressModel *)addressModel addressBlock:(SCAddressBlock)addressBlock;

//新增
+ (void)showIn:(UIViewController *)vc addressBlock:(SCAddressBlock)addressBlock;



@end

NS_ASSUME_NONNULL_END
