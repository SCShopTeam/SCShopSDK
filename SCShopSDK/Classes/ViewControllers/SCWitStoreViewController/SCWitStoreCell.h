//
//  SCWitStoreCell.h
//  shopping
//
//  Created by gejunyu on 2020/8/29.
//  Copyright © 2020 jsmcc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCWitStoreModel.h"

typedef NS_ENUM(NSInteger, SCWitCornerStyle) {
    SCWitCornerStyleNone,
    SCWitCornerStyleTop = 1<<1,
    SCWitCornerStyleBottom = 1<<2
};

NS_ASSUME_NONNULL_BEGIN

@interface SCWitStoreCell : UITableViewCell

+ (void)calculateRowHeight:(SCWitStoreModel *)model;

@property (nonatomic, copy) void (^enterBlock)(SCWitStoreModel *storeModel); //进店逛逛
@property (nonatomic, copy) void (^phoneBlock)(NSString *phone);             //电话
@property (nonatomic, copy) void (^orderBlock)(SCWitStoreModel *model);      //取号

@property (nonatomic, assign) SCWitCornerStyle style;
@property (nonatomic, strong) SCWitStoreModel *model;

@end

NS_ASSUME_NONNULL_END
