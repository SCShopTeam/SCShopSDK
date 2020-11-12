//
//  SCHomeBannerView.h
//  shopping
//
//  Created by gejunyu on 2020/7/7.
//  Copyright © 2020 jsmcc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCHomeTouchModel.h"

NS_ASSUME_NONNULL_BEGIN

#define kHomeBannerH SCREEN_FIX(240)

@interface SCHomeBannerView : UICollectionReusableView


/** 网络图片 url string 数组 */
@property (nonatomic, strong) NSArray <SCHomeTouchModel *> *bannerList;

//点击事件
@property (nonatomic, copy) void (^selectBlock)(NSInteger index, SCHomeTouchModel *model);

//展示
@property (nonatomic, copy) void (^showblock)(NSInteger index, SCHomeTouchModel *model);


@end

NS_ASSUME_NONNULL_END
