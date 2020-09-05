//
//  SCHomeGridView.h
//  shopping
//
//  Created by gejunyu on 2020/7/8.
//  Copyright © 2020 jsmcc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCHomeTouchModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SCHomeGridView : UICollectionReusableView

@property (nonatomic, copy) void (^selectBlock)(NSInteger index);

@property (nonatomic, strong) NSArray <SCHomeTouchModel *> *touchList;

@end

NS_ASSUME_NONNULL_END
