//
//  SCStoreHomeViewController.m
//  shopping
//
//  Created by gejunyu on 2020/7/23.
//  Copyright © 2020 jsmcc. All rights reserved.
//

#import "SCStoreHomeViewController.h"
#import "SCCollectionView.h"
#import "SCSiftView.h"
#import "SCShopCollectionCell.h"
#import "SCStoreHomeHeaderView.h"
#import "SCStoreHomeViewModel.h"
#import "SCCategoryViewModel.h"

#define kTopH SCREEN_FIX(185)

@interface SCStoreHomeViewController () <UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) SCCollectionView *collectionView;
@property (nonatomic, strong) SCSiftView *siftView;
@property (nonatomic, strong) SCStoreHomeViewModel *viewModel;
@property (nonatomic, strong) UILabel *emptyTipLabel;
@end

@implementation SCStoreHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"移动好货";
    
    [self requestData];
    
}

- (void)requestData
{
    if (!VALID_STRING(self.tenantNum)) {
        return;
    }
    
    [self requestTenantInfo];
    [self requestCommodityList:1 showCache:YES];
}

- (void)requestTenantInfo
{
    [self.viewModel requestTenantInfo:_tenantNum completion:^(NSString * _Nullable errorMsg) {
        [self.collectionView reloadData];
    }];
}

- (void)requestCommodityList:(NSInteger)page showCache:(BOOL)showCache
{
    SCCategorySortKey sort      = self.siftView.currentSortKey;
    SCCategorySortType sortType = self.siftView.currentSortType;
    
    [self.viewModel getCommodityList:_tenantNum sort:sort sortType:sortType pageNum:page showCache:showCache completion:^(NSString * _Nullable errorMsg) {
        SCStoreHomeCacheModel *cacheModel = self.viewModel.currentCacheModel;
        
        self.collectionView.page = cacheModel.page;
        [self.collectionView reloadDataShowFooter:cacheModel.hasMoreData];
        self.emptyTipLabel.hidden = cacheModel.commodityList.count > 0;
    }];

}


#pragma mark -UICollectionViewDelegate, UICollectionViewDataSource
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(collectionView.width, kTopH);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    SCStoreHomeHeaderView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass(SCStoreHomeHeaderView.class) forIndexPath:indexPath];
    header.tenantInfo = self.viewModel.tenantInfo;
    
    header.bannerBlock = ^(SCTenantInfoModel * _Nonnull tenantInfo) {
        [SCUtilities scXWMobStatMgrStr:@"IOS_T_NZDSCSDDP_A01" url:@"" inPage:NSStringFromClass(self.class)];
    };
    
    
    
    
    return header;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    SCStoreHomeCacheModel *cacheModel = self.viewModel.currentCacheModel;
    return cacheModel.commodityList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SCShopCollectionCell *cell = (SCShopCollectionCell *)[collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(SCShopCollectionCell.class) forIndexPath:indexPath];
    
    SCStoreHomeCacheModel *cacheModel = self.viewModel.currentCacheModel;
    
    if (indexPath.row < cacheModel.commodityList.count) {
        SCCommodityModel *model = cacheModel.commodityList[indexPath.row];
        cell.model = model;
    }

    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    SCStoreHomeCacheModel *cacheModel = self.viewModel.currentCacheModel;
    SCCommodityModel *model = cacheModel.commodityList[indexPath.row];
    
    [[SCURLSerialization shareSerialization] gotoWebcustom:model.detailUrl title:@"" navigation:self.navigationController];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offsetY = scrollView.contentOffset.y;
    
    //坐标
    CGFloat y = kTopH - offsetY;
    self.siftView.top = MAX(0, y);
    
}

#pragma mark -ui
- (SCCollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        layout.minimumLineSpacing      = SCREEN_FIX(18);
        layout.minimumInteritemSpacing = SCREEN_FIX(13.5);
        layout.itemSize                = CGSizeMake(kCommodityItemW, kCommodityItemH);
        layout.scrollDirection         = UICollectionViewScrollDirectionVertical;
        layout.sectionInset = UIEdgeInsetsMake(self.siftView.height, SCREEN_FIX(18), SCREEN_FIX(10), SCREEN_FIX(18));
        
        _collectionView = [[SCCollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-NAV_BAR_HEIGHT) collectionViewLayout:layout];
        _collectionView.backgroundColor = HEX_RGB(@"#F6F6F6");
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        [self.view addSubview:_collectionView];
        [self.view sendSubviewToBack:_collectionView];
        
        [_collectionView registerClass:SCShopCollectionCell.class forCellWithReuseIdentifier:NSStringFromClass(SCShopCollectionCell.class)];
        [_collectionView registerClass:SCStoreHomeHeaderView.class forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass(SCStoreHomeHeaderView.class)];
        
        [_collectionView showsRefreshHeader];
//        [_collectionView showsRefreshFooter];
        
        @weakify(self)
        _collectionView.refreshingBlock = ^(NSInteger page) {
            @strongify(self)
            [self requestCommodityList:page showCache:NO];
        };
    }
    return _collectionView;
}

- (SCSiftView *)siftView
{
    if (!_siftView) {
        _siftView = [[SCSiftView alloc] initWithFrame:CGRectMake(0, kTopH, SCREEN_WIDTH, SCREEN_FIX(51.5))];
        [self.view addSubview:_siftView];
        
        @weakify(self)
        _siftView.selectBlock = ^{
          @strongify(self)
            self.collectionView.page = 1;
            [self requestCommodityList:1 showCache:YES];
            
            //悬停高度
            if (self.collectionView.contentOffset.y > kTopH) {
                [self.collectionView setContentOffset:CGPointMake(0, kTopH) animated:NO];
            }
        };
        
    }
    return _siftView;
}

- (SCStoreHomeViewModel *)viewModel
{
    if (!_viewModel) {
        _viewModel = [SCStoreHomeViewModel new];
    }
    return _viewModel;
}

- (UILabel *)emptyTipLabel
{
    if (!_emptyTipLabel) {
        _emptyTipLabel = [UILabel new];
        _emptyTipLabel.textAlignment = NSTextAlignmentCenter;
        _emptyTipLabel.font = SCFONT_SIZED(15);
        _emptyTipLabel.textColor = HEX_RGB(@"#999999");
        _emptyTipLabel.text = @"抱歉，商品不存在，看看其他商品吧~";
        [_emptyTipLabel sizeToFit];
        _emptyTipLabel.center = self.collectionView.center;
        [self.view addSubview:_emptyTipLabel];
    }
    return _emptyTipLabel;
}

@end
