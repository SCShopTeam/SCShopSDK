//
//  SCHomeRecommendStoreCell.h
//  shopping
//
//  Created by gejunyu on 2021/3/2.
//  Copyright © 2021 jsmcc. All rights reserved.
//

#import <UIKit/UIKit.h>



NS_ASSUME_NONNULL_BEGIN

@interface SCHomeRecommendStoreCell : UITableViewCell

@property (nonatomic, copy) void (^enterStoreBlock)();
@property (nonatomic, copy) void (^telBlock)();
@property (nonatomic, copy) void (^serviceBlock)();

+ (CGFloat)getRowHeight;

- (void)setData; //假数据

@end

NS_ASSUME_NONNULL_END
