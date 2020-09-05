//
//  SCSearchHistoryView.h
//  shopping
//
//  Created by gejunyu on 2020/7/10.
//  Copyright © 2020 jsmcc. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SCSearchHistoryView : UIView

@property (nonatomic, copy) void (^selectBlock)(NSString *record);

- (void)addSearchRecord:(NSString *)record;

@end

NS_ASSUME_NONNULL_END
