//
//  SCHomeStoreCell.h
//  shopping
//
//  Created by gejunyu on 2021/3/2.
//  Copyright © 2021 jsmcc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCHomeStoreModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SCHomeStoreCell : UITableViewCell

@property (nonatomic, strong) SCHomeStoreModel *model;

@property (nonatomic, copy) void (^pushBlock)(NSString *url);
@property (nonatomic, copy) void (^callBlock)(NSString *url);

+ (CGFloat)getRowHeight:(SCHomeStoreModel *)model;

@end

NS_ASSUME_NONNULL_END
