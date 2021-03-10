//
//  SCHomeBannerCell.h
//  shopping
//
//  Created by gejunyu on 2021/3/2.
//  Copyright © 2021 jsmcc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCHomeTouchModel.h"

#define kHomeBannerRowH SCREEN_FIX(140)

NS_ASSUME_NONNULL_BEGIN

@interface SCHomeBannerCell : UITableViewCell

/** 网络图片 url string 数组 */
@property (nonatomic, strong) NSArray <SCHomeTouchModel *> *bannerList;

//点击事件
@property (nonatomic, copy) void (^selectBlock)(NSInteger index, SCHomeTouchModel *model);

//展示
@property (nonatomic, copy) void (^showblock)(NSInteger index, SCHomeTouchModel *model);

@end

NS_ASSUME_NONNULL_END
