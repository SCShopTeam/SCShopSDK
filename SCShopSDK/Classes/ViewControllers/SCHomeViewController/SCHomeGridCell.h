//
//  SCHomeGridCell.h
//  shopping
//
//  Created by gejunyu on 2021/3/2.
//  Copyright © 2021 jsmcc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCHomeTouchModel.h"

#define kHomeGridRowH SCREEN_FIX(152)

NS_ASSUME_NONNULL_BEGIN

@interface SCHomeGridCell : UITableViewCell

@property (nonatomic, copy) void (^touchShowBlock)(SCHomeTouchModel *model); //触点曝光

@property (nonatomic, copy) void (^selectBlock)(NSInteger index);

@property (nonatomic, strong) NSArray <SCHomeTouchModel *> *gridList;

@end

NS_ASSUME_NONNULL_END
