//
//  SCWitStoreSortView.h
//  shopping
//
//  Created by gejunyu on 2020/9/3.
//  Copyright © 2020 jsmcc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCWitStoreHeader.h"


NS_ASSUME_NONNULL_BEGIN

@interface SCWitStoreSortView : UITableViewHeaderFooterView

@property (nonatomic, copy) void (^sortBlock)(SCWitSortType sortType);

- (void)show:(SCWitSortType)sortType;

@end

NS_ASSUME_NONNULL_END
