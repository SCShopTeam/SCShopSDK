//
//  SCHomeStoreActivityView.h
//  shopping
//
//  Created by gejunyu on 2021/3/4.
//  Copyright © 2021 jsmcc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCHomeStoreProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface SCHomeStoreActivityView : UIView;

@property (nonatomic, weak) id <SCHomeStoreProtocol> delegate;

@property (nonatomic, copy) NSArray *activityList;


@end

NS_ASSUME_NONNULL_END
