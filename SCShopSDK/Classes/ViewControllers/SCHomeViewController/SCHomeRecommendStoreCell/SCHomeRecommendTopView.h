//
//  SCHomeRecommendTopView.h
//  shopping
//
//  Created by gejunyu on 2021/3/4.
//  Copyright © 2021 jsmcc. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SCHomeRecommendTopView : UIView

@property (nonatomic, copy) void (^enterStoreBlock)();
@property (nonatomic, copy) void (^telBlock)();
@property (nonatomic, copy) void (^serviceBlock)();


//假数据
- (void)getData;

@end

NS_ASSUME_NONNULL_END
