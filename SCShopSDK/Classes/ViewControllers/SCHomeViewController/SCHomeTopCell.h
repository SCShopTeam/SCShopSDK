//
//  SCHomeTopCell.h
//  shopping
//
//  Created by gejunyu on 2021/3/2.
//  Copyright © 2021 jsmcc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCHomeTouchModel.h"

#define kHomeTopRowH SCREEN_FIX(66.5)

typedef NS_ENUM(NSInteger, SCHomeTopType) {
    SCHomeTopTypeFirst,     //触点 点位一
    SCHomeTopTypeSecond,    //触点 点位二
    SCHomeTopTypeCart,      //固定 购物车
    SCHomeTopTypeOrder      //固定 我的订单
};

NS_ASSUME_NONNULL_BEGIN

@interface SCHomeTopCell : UITableViewCell

@property (nonatomic, strong) NSArray <SCHomeTouchModel *> *topList;

@property (nonatomic, copy) void (^selectBlock)(SCHomeTopType type, SCHomeTouchModel *model);

@end

NS_ASSUME_NONNULL_END
