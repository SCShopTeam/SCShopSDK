//
//  SCCategoryCommodityController.h
//  shopping
//
//  Created by zhangtao on 2020/7/8.
//  Copyright © 2020 jsmcc. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol CagegoryCommodityDelegte <NSObject>

-(void)cagegoryCommodityClick:(NSIndexPath *)indexPath;

@end

@interface SCCategoryCommodityController : UITableViewController

@property(nonatomic,copy)NSArray *sourceArrs;

@property(nonatomic,weak) id <CagegoryCommodityDelegte>delegate;

-(void)reloadData;

@end

NS_ASSUME_NONNULL_END
