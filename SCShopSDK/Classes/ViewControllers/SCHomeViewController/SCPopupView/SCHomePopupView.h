//
//  SCHomePopupView.h
//  shopping
//
//  Created by gejunyu on 2020/10/23.
//  Copyright © 2020 jsmcc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCHomeTouchModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SCHomePopupView : UIView

@property (nonatomic, strong) SCHomeTouchModel *model;

@property (nonatomic, copy) void (^linkBlock)(SCHomeTouchModel *model);

@property (nonatomic, assign) BOOL moveAfterClicked; //点击跳转后是否清除 default YES

//子类自定义部分
@property (nonatomic, assign) CGRect imageFrame;
@property (nonatomic, assign) CGRect closeFrame;

@end

NS_ASSUME_NONNULL_END
