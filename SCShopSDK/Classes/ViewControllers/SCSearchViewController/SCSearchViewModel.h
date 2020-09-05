//
//  SCSearchViewModel.h
//  shopping
//
//  Created by gejunyu on 2020/8/12.
//  Copyright © 2020 jsmcc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SCSearchItemModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SCSearchViewModel : NSObject

@property (nonatomic, strong, readonly) NSArray <SCSearchItemModel *> *itemList;

@property (nonatomic, assign, readonly) BOOL hasMoreData;

- (void)requestSearch:(NSString *)keyWord success:(SCHttpRequestSuccess)success failure:(SCHttpRequestFailed)failure;


@end

NS_ASSUME_NONNULL_END
