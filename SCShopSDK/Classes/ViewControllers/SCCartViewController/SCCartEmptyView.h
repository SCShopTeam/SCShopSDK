//
//  SCCartEmptyView.h
//  shopping
//
//  Created by gejunyu on 2020/9/4.
//  Copyright © 2020 jsmcc. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SCCartEmptyView : UICollectionReusableView

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) void (^pushBlock)(void);

@end

NS_ASSUME_NONNULL_END
