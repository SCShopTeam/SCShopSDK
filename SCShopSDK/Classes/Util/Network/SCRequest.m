//
//  SCRequest.m
//  shopping
//
//  Created by zhangtao on 2020/7/29.
//  Copyright © 2020 jsmcc. All rights reserved.
//

#import "SCRequest.h"
#import "SCRequestParams.h"
#import "SCNetworkManager.h"
#import "SCNetworkDefine.h"
#import "SCLocationService.h"
#import "SCShoppingManager.h"
@implementation SCRequest

+(void)scLoginResultBlock:(void (^)(BOOL, NSDictionary *, NSString *))callBack{
    SCRequestParams *model = [SCRequestParams shareInstance];
    model.requestNum = @"user.login";
    NSDictionary *params = @{@"userOs":model.userOs,@"userNetwork":model.userNetwork,@"userAppVer":model.userAppVer};
    
    [SCNetworkManager POST:SC_LOGIN parameters:params success:^(id  _Nonnull responseObject) {
        callBack(YES,responseObject,@"");
        
        if ([SCUtilities isValidDictionary:responseObject]) {
            NSString*resCode = responseObject[@"resCode"];
            if ([SCUtilities isValidString:resCode] && [resCode isEqualToString:@"0"]) {
                NSDictionary *result = responseObject[@"result"];
                if ([SCUtilities isValidDictionary:result]) {
                    NSLog(@"--sc-- shopping登陆成功");
                    callBack(YES,result,nil);
                }else{
                     NSLog(@"--sc-- shopping登陆失败");
                    callBack(NO,nil,nil);
                }
            }else{
                 NSLog(@"--sc-- shopping登陆失败");
                callBack(NO,nil,nil);
            }
        }else{
             NSLog(@"--sc-- shopping登陆失败");
            callBack(NO,nil,nil);
        }
        
    } failure:^(NSString * _Nullable errorMsg) {
        NSLog(@"--sc-- shopping登陆失败");
        callBack(NO,@{},@"error msg");
    }];

}


+(void)scAreaListWithLevel:(NSString *)level adminNum:(NSString*)adminNum block:(void (^)(BOOL, NSDictionary *, NSString *))callBack{
    NSMutableDictionary *param = [[SCRequestParams shareInstance]getParams];
    if ([SCUtilities isValidString:level]) {
        param[@"level"] = level;
    }
    if ([SCUtilities isValidString:adminNum]) {
        param[@"adminNum"] = adminNum;
    }
    param[@"level"] = @"1";
    [SCNetworkManager POST:SC_ADMIN_LIST parameters:param success:^(id  _Nonnull responseObject) {
        if ([SCUtilities isValidDictionary:responseObject]) {
            NSString*resCode = responseObject[@"resCode"];
            if ([SCUtilities isValidString:resCode] && [resCode isEqualToString:@"0"]) {
                NSDictionary *result = responseObject[@"result"];
                if ([SCUtilities isValidDictionary:result]) {
                    callBack(YES,result,nil);
                }else{
                    callBack(NO,nil,nil);
                }
            }else{
                callBack(NO,nil,nil);
            }
        }else{
            callBack(NO,nil,nil);
        }
        
    } failure:^(NSString * _Nullable errorMsg) {
        callBack(NO,nil,@"error");
    }];
}

//购物车新增/修改
+ (void)requestCartMerge:(NSString *)cartItemNum itemNum:(NSString *)itemNum itemQuantity:(NSInteger)itemQuantity success:(SCHttpRequestSuccess)success failure:(SCHttpRequestFailed)failure
{
    if (!VALID_STRING(itemNum) || itemQuantity <= 0) {
        return;
    }
    NSMutableDictionary *param = @{@"itemNum":itemNum, @"itemQuantity":@(itemQuantity)}.mutableCopy;
    if (VALID_STRING(cartItemNum)) {
        param[@"cartItemNum"] = cartItemNum;
    }
    [SCRequestParams shareInstance].requestNum = @"cart.merge";
    [SCNetworkManager POST:SC_CART_MERGE parameters:param success:^(id  _Nullable responseObject) {
        if (![SCNetworkTool checkCode:responseObject failure:failure]) {
            return;
        }
        
        if (success) {
            success(nil);
        }
        
    } failure:failure];
}

//购物车 商品删除
+ (void)requestCartDelete:(NSString *)cartItemNum itemNum:(NSString *)itemNum success:(SCHttpRequestSuccess)success failure:(SCHttpRequestFailed)failure
{
    if (!VALID_STRING(cartItemNum)) {
        return;
    }

    NSDictionary *param = @{@"cartItemNum": cartItemNum, @"itemNum": itemNum};
    
    [SCRequestParams shareInstance].requestNum = @"cart.delete";
    [SCNetworkManager POST:SC_CART_DELETE parameters:param success:^(id  _Nullable responseObject) {
        if (![SCNetworkTool checkCode:responseObject failure:failure]) {
            return;
        }
        
        if (success) {
            success(nil);
        }
        
    } failure:failure];
}

//用户 收藏商品 新增
+ (void)requestFavoriteAdd:(nonnull NSString *)itemNum success:(nullable SCHttpRequestSuccess)success failure:(nullable SCHttpRequestFailed)failure
{
    if (!VALID_STRING(itemNum)) {
        return;
    }
    
    NSDictionary *param = @{@"itemNum": itemNum};
    
    [SCRequestParams shareInstance].requestNum = @"favorite.add";
    [SCNetworkManager POST:SC_FAVORITE_ADD parameters:param success:^(id  _Nullable responseObject) {
        if (![SCNetworkTool checkCode:responseObject failure:failure]) {
            return;
        }
        
        if (success) {
            success(nil);
        }
        
    } failure:failure];
}

//用户 收藏商品 删除
+ (void)requestFavoriteDelete:(nonnull NSString *)favNum itemNum:(nonnull NSString *)itemNum success:(nullable SCHttpRequestSuccess)success failure:(nullable SCHttpRequestFailed)failure
{
    if (!VALID_STRING(favNum)) {
        return;
    }
    
    
    NSDictionary *param = @{@"favNum": favNum,
                            @"itemNum": itemNum};
    
    [SCRequestParams shareInstance].requestNum = @"favorite.delete";
    [SCNetworkManager POST:SC_FAVORITE_DELETE parameters:param success:^(id  _Nullable responseObject) {
        if (![SCNetworkTool checkCode:responseObject failure:failure]) {
            return;
        }
        
        if (success) {
            success(nil);
        }
        
    } failure:failure];
}

+(void)scAddressList:(void (^)(BOOL, NSArray * _Nullable, NSString * _Nullable))callBack{
    [SCRequestParams shareInstance].requestNum = @"address.list";
    [SCNetworkManager POST:SC_ADDRESS_LIST parameters:@{} success:^(id  _Nullable responseObject) {
        if ([SCUtilities isValidDictionary:responseObject]) {
            NSString*resCode = responseObject[@"resCode"];
            if ([SCUtilities isValidString:resCode] && [resCode isEqualToString:@"0"]) {
                NSArray *result = responseObject[@"result"];
                if ([SCUtilities isValidArray:result]) {
                    callBack(YES,result,nil);
                }else{
                    callBack(YES,nil,nil);
                }
            }else{
                callBack(NO,nil,nil);
            }
        }else{
            callBack(NO,nil,nil);
        }
    } failure:^(NSString * _Nullable errorMsg) {
        callBack(NO,nil,nil);
    }];
}


+(void)scAddressDetail:(NSString *)addressNum block:(void (^)(BOOL, NSDictionary * _Nullable, NSString * _Nullable))callBack{
    [SCRequestParams shareInstance].requestNum = @"address.detail";
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    if (addressNum) {
        dic[@"addressNum"] = addressNum;
    }
    [SCNetworkManager POST:SC_ADDRESS_DETAIL parameters:dic success:^(id  _Nullable responseObject) {
        if ([SCUtilities isValidDictionary:responseObject]) {
            NSString*resCode = responseObject[@"resCode"];
            if ([SCUtilities isValidString:resCode] && [resCode isEqualToString:@"0"]) {
                NSDictionary *result = responseObject[@"result"];
                if ([SCUtilities isValidDictionary:result]) {
                    callBack(YES,result,nil);
                }else{
                    callBack(NO,nil,nil);
                }
            }else{
                callBack(NO,nil,nil);
            }
        }else{
            callBack(NO,nil,nil);
        }
    } failure:^(NSString * _Nullable errorMsg) {
        callBack(NO,nil,nil);
    }];
}

+(void)scAddressEdit:(NSDictionary *)addressDic block:(void (^)(BOOL, NSDictionary * _Nullable, NSString * _Nullable))callBack{
    [SCRequestParams shareInstance].requestNum = @"address.merge";
    [SCNetworkManager POST:SC_ADDRESS_EDIT parameters:addressDic success:^(id  _Nullable responseObject) {
        if ([SCUtilities isValidDictionary:responseObject]) {
            NSString*resCode = responseObject[@"resCode"];
            if ([SCUtilities isValidString:resCode] && [resCode isEqualToString:@"0"]) {
//                NSDictionary *result = responseObject[@"result"];
//                if ([SCUtilities isValidDictionary:result]) {
                    callBack(YES,nil,nil);
//                }else{
//                    callBack(NO,nil,nil);
//                }
            }else{
                callBack(NO,nil,nil);
            }
        }else{
            callBack(NO,nil,nil);
        }
    } failure:^(NSString * _Nullable errorMsg) {
        callBack(NO,nil,nil);
    }];
}



+(void)scAddressDelete:(NSString *)addressNum block:(void (^)(BOOL, NSDictionary * _Nullable, NSString * _Nullable))callBack{
    [SCRequestParams shareInstance].requestNum = @"address.delete";
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    if (addressNum) {
        dic[@"addressNum"] = addressNum;
    }
    [SCNetworkManager POST:SC_ADDRESS_DELETE parameters:dic success:^(id  _Nullable responseObject) {
        if ([SCUtilities isValidDictionary:responseObject]) {
            NSString*resCode = responseObject[@"resCode"];
            if ([SCUtilities isValidString:resCode] && [resCode isEqualToString:@"0"]) {
//                NSDictionary *result = responseObject[@"result"];
//                if ([SCUtilities isValidDictionary:result]) {
                    callBack(YES,nil,nil);
//                }else{
//                    callBack(NO,nil,nil);
//                }
            }else{
                callBack(NO,nil,nil);
            }
        }else{
            callBack(NO,nil,nil);
        }
    } failure:^(NSString * _Nullable errorMsg) {
        callBack(NO,nil,nil);
    }];
}


+(void)scCategoryListBlock:(void (^)(BOOL, NSArray * _Nullable, NSString * _Nullable))callBack{
  
    [SCRequestParams shareInstance].requestNum = @"goodsType.queryGoodsTypeList";
    
    [SCNetworkManager GET:SC_GOODTYPE_LIST parameters:@{} success:^(id  _Nullable responseObject) {
         if ([SCUtilities isValidDictionary:responseObject]) {
            NSString*resCode = responseObject[@"resCode"];
            if ([SCUtilities isValidString:resCode] && [resCode isEqualToString:@"0"]) {
                NSArray *result = responseObject[@"result"];
                if ([SCUtilities isValidArray:result]) {
                    callBack(YES,result,nil);
                }else{
                    callBack(NO,nil,nil);
                }
            }else{
                
                callBack(NO,nil,nil);
            }
        }else{
            callBack(NO,nil,nil);
        }
        
    } failure:^(NSString * _Nullable errorMsg) {
        callBack(NO,nil,nil);
    }];
}


+(void)scCategoryCommoditiesList:(NSDictionary *)param block:(void (^)(BOOL, NSDictionary * _Nullable, NSString * _Nullable))callBack{
    [SCRequestParams shareInstance].requestNum = @"goods.queryCategoryList";
    NSMutableDictionary *dic = [[SCRequestParams shareInstance] getParams];
    if ([SCUtilities isValidDictionary:param]) {
        [dic addEntriesFromDictionary:param];
    }
    NSString *userCityNum = [SCUtilities isValidString:[SCUserInfo currentUser].uan]?[SCUserInfo currentUser].uan:@"";
    if (!VALID_STRING(dic[@"tenantNum"])) {
        dic[@"tenantType"] = @"collect";
    }

    dic[@"userCityNum"] = userCityNum;
    dic[@"longitude"] = [SCLocationService sharedInstance].longitude ?: @"";
    dic[@"latitude"]  = [SCLocationService sharedInstance].latitude ?: @"";
    
    
    [SCNetworkManager POST:SC_COMMODITY_LIST parameters:dic success:^(id  _Nullable responseObject) {
        
        if ([SCUtilities isValidDictionary:responseObject]) {
                  NSString*resCode = responseObject[@"resCode"];
                  if ([SCUtilities isValidString:resCode] && [resCode isEqualToString:@"0"]) {
                      NSDictionary *result = responseObject[@"result"];
                      if ([SCUtilities isValidDictionary:result]) {
                          callBack(YES,result,nil);
                      }else{
                          callBack(NO,nil,nil);
                      }
                  }else{
                      callBack(NO,nil,nil);
                  }
              }else{
                  callBack(NO,nil,nil);
              }
        
    } failure:^(NSString * _Nullable errorMsg) {
        callBack(NO,nil,nil);
    }];
}


+(void)scMyOrderList_scParam:(NSDictionary *)param block:(void (^)(BOOL, NSDictionary * _Nullable, NSString * _Nullable))callBack{
    [SCRequestParams shareInstance].requestNum = @"order.queryMyOrders";
    
    [SCNetworkManager POST:SC_MYORDER_LIST_SC parameters:param success:^(id  _Nullable responseObject) {
        if ([SCUtilities isValidDictionary:responseObject]) {
            NSString*resCode = responseObject[@"resCode"];
            if ([SCUtilities isValidString:resCode] && [resCode isEqualToString:@"0"]) {
                NSDictionary *result = responseObject[@"result"];
                if ([SCUtilities isValidDictionary:result]) {
                    callBack(YES,result,nil);
                }else{
                    callBack(NO,nil,nil);
                }
            }else{
                callBack(NO,nil,nil);
            }
        }else{
            callBack(NO,nil,nil);
        }
    } failure:^(NSString * _Nullable errorMsg) {
        callBack(NO,nil,nil);
    }];
}


+(void)mdMyOrderList_mdParam:(NSDictionary *)param block:(void (^)(BOOL, NSDictionary * _Nullable, NSString * _Nullable))callBack{
    
    [SCNetworkManager POST:SC_MYORDER_LIST_MD parameters:param success:^(id  _Nullable responseObject) {
           if ([SCUtilities isValidDictionary:responseObject]) {
               NSString*resCode = responseObject[@"resultCode"];
               if ([SCUtilities isValidString:resCode] && [resCode isEqualToString:@"000000"]) {
                   NSDictionary *result = responseObject[@"result"];
                   if ([SCUtilities isValidDictionary:result]) {
                       callBack(YES,result,nil);
                   }else{
                       callBack(NO,nil,nil);
                   }
               }else{
                   callBack(NO,nil,nil);
               }
           }else{
               callBack(NO,nil,nil);
           }
    } failure:^(NSString * _Nullable errorMsg) {
        callBack(NO,nil,nil);
    }];
}


+(void)requestWithErrorLoginCode:(NSString *)code{
    
    if ([SCUtilities isValidString:code] && [code isEqualToString:@"403"]) {
        UINavigationController *nav = [SCUtilities currentNavigationController];
         SCShoppingManager *manager = [SCShoppingManager sharedInstance];
         if (manager.delegate && [manager.delegate respondsToSelector:@selector(scLoginResultBlock:)]) {
             [manager.delegate scLoginWithNav:nav back:^(UIViewController * _Nonnull controller) {
                 
             }];
         }
    }
}

@end
