//
//  SCSiftView.h
//  shopping
//
//  Created by gejunyu on 2020/7/23.
//  Copyright © 2020 jsmcc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SCSiftItem;

NS_ASSUME_NONNULL_BEGIN


@interface SCSiftView : UIView

@property (nonatomic, strong, readonly) NSArray <SCSiftItem *>*itemList;

@property (nonatomic, copy) void (^selectBlock)(NSInteger index);

- (void)setCurrentIndex:(NSInteger)currentIndex;

@end

@interface SCSiftItem : NSObject
@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) BOOL sort;      //是否有排序
@property (nonatomic, assign) BOOL selected;  //是否被选中
@property (nonatomic, assign) BOOL isAscend;  //是否是升序
@property (nonatomic, assign) SCCategorySortKey sortKey;

@property (nonatomic, copy) void (^updateTypeBlock)(void);

@end

NS_ASSUME_NONNULL_END
