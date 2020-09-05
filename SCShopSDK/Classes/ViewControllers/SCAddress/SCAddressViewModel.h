//
//  SCAddressViewModel.h
//  shopping
//
//  Created by gejunyu on 2020/8/4.
//  Copyright © 2020 jsmcc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SCAdminListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SCAddressViewModel : NSObject

//地址单例保存
AS_SINGLETON(SCAddressViewModel)

@property (nonatomic, strong, readonly) NSMutableArray <SCAdminListModel *> *adminList;

- (void)requestAdminList:(SCAdminType)adminType provinceNum:(nullable NSString *)provinceNum cityNum:(nullable NSString *)cityNum success:(SCHttpRequestSuccess)success failure:(SCHttpRequestFailed)failure;

@end

NS_ASSUME_NONNULL_END
