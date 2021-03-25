//
//  SCHomeStoreActivityCell.h
//  shopping
//
//  Created by gejunyu on 2021/3/4.
//  Copyright © 2021 jsmcc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCHomeStoreProtocol.h"
@class SCHomeActivityModel;

NS_ASSUME_NONNULL_BEGIN

@interface SCHomeStoreActivityCell : UICollectionViewCell

@property (nonatomic, weak) id <SCHomeStoreProtocol> delegate;

@property (nonatomic, strong) NSArray <SCHomeActivityModel *>*models;

@end

NS_ASSUME_NONNULL_END
