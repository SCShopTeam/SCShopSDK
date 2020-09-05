//
//  SCCollectionView.m
//  shopping
//
//  Created by gejunyu on 2020/7/7.
//  Copyright © 2020 jsmcc. All rights reserved.
//

#import "SCCollectionView.h"
#import <MJRefresh/MJRefresh.h>

@implementation SCCollectionView

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout
{
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        self.page = 1;
    }
    return self;
}


- (void)showsRefreshHeader {
    
//    @weakify(self)
//    // 下拉刷新
//    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
//        @strongify(self)
//        self.pageIndex = 1;
//        if (self.refreshingBlock ) {
//            self.refreshingBlock(self.pageIndex);
//        }
//    }];
//
////    NSMutableArray *imgs = [SCLoadingUtil sharedInstance].loadingImgs;
////
////    [header setImages:imgs duration:2 forState:MJRefreshStateIdle];
////    [header setImages:imgs duration:2 forState:MJRefreshStateRefreshing];
//    header.lastUpdatedTimeLabel.hidden = YES;
//    header.stateLabel.hidden = YES;
//    // 设置自动切换透明度(在导航栏下面自动隐藏)
//    header.automaticallyChangeAlpha = YES;
//
//    self.mj_header = header;
    
    @weakify(self)
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        @strongify(self)
        self.page = 1;
        if (self.refreshingBlock) {
            self.refreshingBlock(self.page);
        }
    }];
    header.automaticallyChangeAlpha = YES;
    self.mj_header = header;
    
}

- (void)hidesRefreshHeader {
    self.mj_header = nil;
}

- (void)showsRefreshFooterWithAuto:(BOOL)autoRefresh {
    
//    self.mj_footer.automaticallyHidden = YES;


    @weakify(self)
    // 上拉刷新
    if (autoRefresh) {
        self.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            @strongify(self)
            self.page ++;
            if (self.refreshingBlock) {
                self.refreshingBlock(self.page);
            }
        }];
    }
    else {
        self.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            @strongify(self)
            self.page ++;
            if (self.refreshingBlock) {
                self.refreshingBlock(self.page);
            }
        }];
    }
}

- (void)showsRefreshFooter {
    [self showsRefreshFooterWithAuto:YES];
}

- (void)hidesRefreshFooter {
    self.mj_footer = nil;
}

- (void)reloadDataWithNoMoreData:(BOOL)hasNoData {
    
    [super reloadData];
    [self.mj_header endRefreshing];
    [self.mj_footer endRefreshing];
    
    if ( hasNoData ) {
        [self.mj_footer endRefreshingWithNoMoreData];
    }
}

- (void)reloadData {
    [self reloadDataWithNoMoreData:NO];
}

//hasNoData:YES 直接隐藏上拉加载
- (void)reloadDataShowFooter:(BOOL)hasMoreData
{
    [super reloadData];
    [self.mj_header endRefreshing];
    [self.mj_footer endRefreshing];
    
    hasMoreData ? [self showsRefreshFooter] : [self hidesRefreshFooter];

}

- (void)cleanNoMoreDataState {
    [self.mj_footer resetNoMoreData];
}

- (void)autoRefreshing {
    if ( self.mj_header ) {
        [self.mj_header beginRefreshing];
    }
}


@end
