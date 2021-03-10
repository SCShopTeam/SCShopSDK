//
//  SCTableView.h
//  shopping
//
//  Created by gejunyu on 2020/7/7.
//  Copyright © 2020 jsmcc. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
*  带有分页刷新的TableView
*/

@interface SCTableView : UITableView

@property (nonatomic, assign) NSInteger page;
@property (nonatomic, copy) void (^refreshingBlock)(NSInteger page);

/**
 *和scrollView嵌套联动用的属性，默认NO
 */
@property (nonatomic, assign) BOOL shouldRecognizeSimultaneouslyWithOtherGestureRecognizer;

/**
 *  显示下拉刷新控件
 */
- (void)showsRefreshHeader;

/**
 *  隐藏下拉刷新控件
 */
- (void)hidesRefreshHeader;

/**
 *  显示上拉刷新控件
 *  autoRefresh  表示是否自动加载更多数据    默认为YES
 */
- (void)showsRefreshFooterWithAuto:(BOOL)autoRefresh;
- (void)showsRefreshFooter;

/**
 *  隐藏上拉刷新控件
 */
- (void)hidesRefreshFooter;

/**
 *  刷新数据
 *  hasNoData  表示是否有更多数据  默认为NO
 */
//hasNoData:YES 显示“无更多数据提示”
- (void)reloadDataWithNoMoreData:(BOOL)hasNoData;
- (void)reloadData;
//hasMoreData:NO 直接隐藏上拉加载
- (void)reloadDataShowFooter:(BOOL)hasMoreData;

/**
 *  消除没有更多数据的状态
 */
- (void)cleanNoMoreDataState;

/**
 *  自动下拉刷新
 */
- (void)autoRefreshing;



@end

NS_ASSUME_NONNULL_END
