//
//  SCMainCategoryController.h
//  shopping
//
//  Created by zhangtao on 2020/7/8.
//  Copyright © 2020 jsmcc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCCategoryModel.h"
NS_ASSUME_NONNULL_BEGIN

@protocol MainCategoryDelegate <NSObject>

-(void)mainCategorySelect:(SCCategoryModel *)categoryModel;

@end

@interface SCMainCategoryController : UITableViewController

@property(nonatomic,strong)NSMutableArray<SCCategoryModel *> *sourceArrs;

@property(nonatomic,weak)id<MainCategoryDelegate>delegate;

-(void)reloadData;

@end


@interface mainCategoryCell : UITableViewCell
//@property(nonatomic,strong)NSDictionary *dataDic;
@end

NS_ASSUME_NONNULL_END
