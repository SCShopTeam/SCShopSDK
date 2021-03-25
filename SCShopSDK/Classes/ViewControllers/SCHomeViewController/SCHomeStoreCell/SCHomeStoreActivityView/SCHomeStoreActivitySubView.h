//
//  SCHomeStoreActivitySubView.h
//  shopping
//
//  Created by gejunyu on 2021/3/4.
//  Copyright © 2021 jsmcc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCHomeStoreProtocol.h"
@class SCHomeActivityModel;

NS_ASSUME_NONNULL_BEGIN

@interface SCHomeStoreActivitySubView : UIView

@property (nonatomic, weak) id <SCHomeStoreProtocol> delegate;

@property (nonatomic, strong) SCHomeActivityModel *model;


@end

NS_ASSUME_NONNULL_END
