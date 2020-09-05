//
//  SCHomeAdView.h
//  shopping
//
//  Created by gejunyu on 2020/7/8.
//  Copyright © 2020 jsmcc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCHomeTouchModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SCHomeAdView : UICollectionReusableView
@property (nonatomic, copy) void (^selectBlock)(NSInteger index, SCHomeTouchModel *touchModel);

@property (nonatomic, strong) NSArray <SCHomeTouchModel *> *adList;

@end

NS_ASSUME_NONNULL_END
