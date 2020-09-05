//
//  SCTagView.h
//  shopping
//
//  Created by gejunyu on 2020/7/7.
//  Copyright © 2020 jsmcc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCCategoryModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SCTagView : UICollectionReusableView

@property (nonatomic, strong) NSArray <SCCategoryModel *> *categoryList;

//- (void)pushToIndex:(NSInteger)index;

@property (nonatomic, copy) void (^selectBlock)(NSInteger index);

@property (nonatomic, assign) UIEdgeInsets contentEdgeInsets; //default Zero

@end

NS_ASSUME_NONNULL_END
