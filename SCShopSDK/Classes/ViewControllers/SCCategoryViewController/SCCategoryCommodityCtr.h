//
//  SCCategoryCommodityCtr.h
//  shopping
//
//  Created by zhangtao on 2020/7/14.
//  Copyright © 2020 jsmcc. All rights reserved.
//

//#import "SCBaseViewController.h"
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol CagegoryCommodityDelegte <NSObject>

-(void)cagegoryCommodityClick:(NSIndexPath *)indexPath;

@end


@interface SCCategoryCommodityCtr : UICollectionViewController
//@property(nonatomic,strong) UICollectionView *collectionView;

@property(nonatomic,strong)NSArray *sourceArrs;

@property(nonatomic,weak)id<CagegoryCommodityDelegte>delegate;

-(void)reloadData;

@end

NS_ASSUME_NONNULL_END
