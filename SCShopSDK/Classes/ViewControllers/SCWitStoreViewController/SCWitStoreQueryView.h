//
//  SCWitStoreQueryView.h
//  shopping
//
//  Created by gejunyu on 2020/8/29.
//  Copyright © 2020 jsmcc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCWitStoreHeader.h"

NS_ASSUME_NONNULL_BEGIN


@interface SCWitStoreQueryView : UIView

@property (nonatomic, copy) void (^queryBlock)(SCWitQueryType queryType);
@property (nonatomic, copy) void (^showSortBlock)(void);

- (void)showBgColor:(BOOL)show;

- (void)clear;

@end

NS_ASSUME_NONNULL_END
