//
//  SCHomeAdCell.h
//  shopping
//
//  Created by gejunyu on 2021/3/2.
//  Copyright © 2021 jsmcc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCHomeTouchModel.h"

#define kHomeAdRowH SCREEN_FIX(110)

NS_ASSUME_NONNULL_BEGIN

@interface SCHomeAdCell : UITableViewCell

@property (nonatomic, copy) void (^touchShowBlock)(SCHomeTouchModel *model); //触点曝光

@property (nonatomic, copy) void (^selectBlock)(NSInteger index, SCHomeTouchModel *touchModel);

@property (nonatomic, strong) NSArray <SCHomeTouchModel *> *adList;

@end

NS_ASSUME_NONNULL_END
