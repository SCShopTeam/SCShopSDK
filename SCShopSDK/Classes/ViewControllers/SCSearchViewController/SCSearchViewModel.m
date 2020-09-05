//
//  SCSearchViewModel.m
//  shopping
//
//  Created by gejunyu on 2020/8/12.
//  Copyright © 2020 jsmcc. All rights reserved.
//

#import "SCSearchViewModel.h"
#import "SCShoppingManager.h"

@interface SCSearchViewModel ()
@property (nonatomic, strong) NSArray <SCSearchItemModel *> *itemList;
@property (nonatomic, assign) BOOL hasMoreData;
@end

@implementation SCSearchViewModel

- (void)requestSearch:(NSString *)keyWord success:(SCHttpRequestSuccess)success failure:(SCHttpRequestFailed)failure
{
    SCShoppingManager *manager = [SCShoppingManager sharedInstance];
    
    if (![manager.delegate respondsToSelector:@selector(scSearch:backData:)]) {
        [self failueBack:@"请求失败" failure:failure];
        return;
    }
    
    [manager.delegate scSearch:keyWord backData:^(NSDictionary * _Nullable result, NSString * _Nullable errorMsg) {
        NSArray *rows = [self verifySearchData:result errorMsg:errorMsg failure:failure];
        if (!rows) {
            return;
        }
        
        NSMutableArray *mulArr = [NSMutableArray arrayWithCapacity:rows.count];
        for (NSDictionary *dict in rows) {
            if (!VALID_DICTIONARY(dict)) {
                continue;
            }
            
            SCSearchItemModel *model = [SCSearchItemModel yy_modelWithDictionary:dict];
            if ([model.tsectionNum isEqualToString:@"ios_new_goods_section"] || [model.tsectionNum isEqualToString:@"ios_ablmd_goods_section"]) {
                [mulArr addObject:model];
            }
        }
        self.itemList = mulArr.copy;
        
        
        if (success) {
            success(nil);
        }
        
    }];

}

//测试数据处理
- (nullable NSArray *)verifySearchData:(NSDictionary *)result errorMsg:(NSString *)errorMsg failure:(SCHttpRequestFailed)failure
{
    
    if (VALID_STRING(errorMsg)) {
        [self failueBack:errorMsg failure:failure];
        return nil;
    }
    
    
    if (!VALID_DICTIONARY(result)) {
        [self failueBack:@"解析错误" failure:failure];
        return nil;
    }
    
    
    
    if (!VALID_STRING(result[@"success"]) || ![result[@"success"] isEqualToString:@"0"]) {
        NSString *msg = VALID_STRING(result[@"message"]) ? result[@"message"] : @"response failure";
        [self failueBack:msg failure:failure];
        return nil;
    }
    
    
    if (!VALID_DICTIONARY(result[@"result"])) {
        [self failueBack:@"解析错误" failure:failure];
        return nil;
    }
    
    NSDictionary *resultDict = result[@"result"];
    
    
    if (!VALID_ARRAY(resultDict[@"rows"])) {
        [self failueBack:@"解析错误" failure:failure];
        return nil;
    }
    
    NSArray *rows = resultDict[@"rows"];
    
    return rows;
}

- (void)failueBack:(NSString *)msg failure:(SCHttpRequestFailed)failure
{
    if (failure) {
        failure(msg);
    }
}

@end
