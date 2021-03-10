//
//  SCAddressViewModel.m
//  shopping
//
//  Created by gejunyu on 2020/8/4.
//  Copyright © 2020 jsmcc. All rights reserved.
//

#import "SCAddressViewModel.h"

@interface SCAddressViewModel ()
@property (nonatomic, strong) NSMutableArray <SCAdminListModel *> *adminList;

@end

@implementation SCAddressViewModel
DEF_SINGLETON(SCAddressViewModel)

- (void)requestAdminList:(SCAdminType)adminType provinceNum:(NSString *)provinceNum cityNum:(NSString *)cityNum success:(SCHttpRequestSuccess)success failure:(SCHttpRequestFailed)failure
{
    //先判断本地是否已经有数据
    if ([self checkLocalAdminList:adminType provinceNum:provinceNum cityNum:cityNum]) {
        if (success) {
            success(nil);
        }
        return;
    }
    
    //没有数据则开始请求
    NSString *adminNum = @"";
    if (adminType == SCAdminTypeProvince) {
        
    }else if (adminType == SCAdminTypeCity) {
        adminNum = provinceNum;
        
    }else {
        adminNum = cityNum;
    }
    
    NSDictionary *params = @{@"level":@(adminType),
                             @"adminNum":adminNum};
    
    [SCRequestParams shareInstance].requestNum = @"address.adminlist";
    
    [SCNetworkManager POST:SC_ADMIN_LIST parameters:params success:^(id  _Nonnull responseObject) {
        NSString *key = @"admins";
        if (![SCNetworkTool checkResult:responseObject key:key forClass:NSArray.class failure:failure]) {
            return;
        }
        
        NSArray *admins = responseObject[B_RESULT][key];
        
        NSMutableArray *mulArr = [NSMutableArray array];
        for (NSDictionary *dict in admins) {
            if (!VALID_DICTIONARY(dict)) {
                continue;
            }
            SCAdminListModel *model = [SCAdminListModel yy_modelWithDictionary:dict];
            [mulArr addObject:model];
        }
        
        if (adminType == SCAdminTypeProvince) {
            self.adminList = mulArr;
            
        }else if (adminType == SCAdminTypeCity) {
            for (SCAdminListModel *province in self.adminList) {
                if ([province.adminNum isEqualToString:provinceNum]) {
                    province.children = mulArr;
                }
            }
            
        }else {
            for (SCAdminListModel *province in self.adminList) {
                if ([province.adminNum isEqualToString:provinceNum]) {
                    for (SCAdminListModel *city in province.children) {
                        if ([city.adminNum isEqualToString:cityNum]) {
                            city.children = mulArr;
                        }
                    }
                }
            }

        }
        
        if (success) {
            success(nil);
        }
        
    } failure:failure];
}

- (BOOL)checkLocalAdminList:(SCAdminType)adminType provinceNum:(NSString *)provinceNum cityNum:(NSString *)cityNum
{
    BOOL hasProvince = VALID_ARRAY(self.adminList);
    if (adminType == SCAdminTypeProvince) { //省
        return hasProvince;
        
    }else if (adminType == SCAdminTypeCity) { //市
        if (hasProvince) {
            for (SCAdminListModel *province in self.adminList) {
                if ([province.adminNum isEqualToString:provinceNum]) {
                    return VALID_ARRAY(province.children);
                }
            }
        }
        
        return NO;
        
    }else {  //区
        if (hasProvince) {
            for (SCAdminListModel *province in self.adminList) {
                if ([province.adminNum isEqualToString:provinceNum]) {
                    for (SCAdminListModel *city in province.children) {
                        if ([city.adminNum isEqualToString:cityNum]) {
                            return VALID_ARRAY(city.children);
                        }
                    }
                }
            }
        }
        return NO;
        
    }
        
    
    return NO;
}

- (NSMutableArray<SCAdminListModel *> *)adminList
{
    if (!_adminList) {
        _adminList = [NSMutableArray array];
    }
    return _adminList;
}

@end
