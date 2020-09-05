//
//  SCSiftView.h
//  shopping
//
//  Created by gejunyu on 2020/7/23.
//  Copyright © 2020 jsmcc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCCategoryViewModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface SCSiftView : UIView

@property (nonatomic, assign, readonly) SCCategorySortKey currentSortKey;
@property (nonatomic, assign, readonly) SCCategorySortType currentSortType;

@property (nonatomic, copy) void (^selectBlock)(void);

@end

NS_ASSUME_NONNULL_END
