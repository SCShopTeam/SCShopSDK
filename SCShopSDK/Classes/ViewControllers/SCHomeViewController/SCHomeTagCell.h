//
//  SCHomeTagCell.h
//  shopping
//
//  Created by gejunyu on 2021/3/2.
//  Copyright © 2021 jsmcc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCCategoryModel.h"
#import "SCTagView.h"

NS_ASSUME_NONNULL_BEGIN

#define kHomeTagRowH SCREEN_FIX(51)

@interface SCHomeTagCell : UITableViewCell

- (void)setCategoryList:(NSArray <SCCategoryModel *> *)categoryList;

@property (nonatomic, copy) void (^selectBlock)(NSInteger index);

@property (nonatomic, strong, readonly) SCTagView *tagView;

@end

NS_ASSUME_NONNULL_END
