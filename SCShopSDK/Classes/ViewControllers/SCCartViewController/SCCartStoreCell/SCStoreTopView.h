//
//  SCStoreTopView.h
//  shopping
//
//  Created by gejunyu on 2020/7/9.
//  Copyright © 2020 jsmcc. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SCCartModel;

NS_ASSUME_NONNULL_BEGIN

@interface SCStoreTopView : UIView

@property (nonatomic, copy) void (^selectActionBlock)(void);
@property (nonatomic, assign) BOOL selected;
@property (nonatomic, assign) NSString *title;

@end

NS_ASSUME_NONNULL_END
