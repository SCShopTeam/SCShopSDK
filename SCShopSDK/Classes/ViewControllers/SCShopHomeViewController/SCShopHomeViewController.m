//
//  SCShopHomeViewController.m
//  shopping
//
//  Created by gejunyu on 2020/7/23.
//  Copyright © 2020 jsmcc. All rights reserved.
//

#import "SCShopHomeViewController.h"
#import "SCCollectionView.h"
#import "SCSiftView.h"
#import "SCShopCollectionCell.h"
#import "SCShopHomeHeaderView.h"
#import "SCShopViewModel.h"
#import "SCCategoryViewModel.h"

#define kTopH SCREEN_FIX(185)

@interface SCShopHomeViewController () <UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) SCCollectionView *collectionView;
@property (nonatomic, strong) SCSiftView *siftView;
@property (nonatomic, strong) SCShopViewModel *viewModel;
@property (nonatomic, strong) UILabel *emptyTipLabel;
@end

@implementation SCShopHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"移动好货";
    
    [SCUtilities scXWMobStatMgrStr:@"IOS_T_NZDSCSDDP_A01" url:@"" inPage:NSStringFromClass(self.class)];
    
    [self requestData:1];
}

- (void)requestData:(NSInteger)pageNum
{   
    if (!VALID_STRING(self.tenantNum)) {
        return;
    }
    
    dispatch_group_t group = dispatch_group_create();
    
    if (pageNum == 1 && !self.viewModel.tenantInfo) {
        [self showLoading];
        // 请求商铺信息
        dispatch_group_enter(group);
        [self.viewModel requestTenantInfo:_tenantNum completion:^(NSString * _Nullable errorMsg) {
            dispatch_group_leave(group);
        }];
    }

    //请求商品列表
    dispatch_group_enter(group);
    SCCategorySortKey sort      = self.siftView.currentSortKey;
    SCCategorySortType sortType = self.siftView.currentSortType;
    [self.viewModel requestCommodityList:_tenantNum sort:sort sortType:sortType pageNum:pageNum completion:^(NSString * _Nullable errorMsg) {
        dispatch_group_leave(group);
    }];


    // 当上述两个请求结束后，收到通知，在此做后续工作
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        [self stopLoading];
        [self.collectionView reloadDataShowFooter:self.viewModel.hasMoreData];
        self.emptyTipLabel.hidden = self.viewModel.commodityList.count > 0;
    });
}


#pragma mark -UICollectionViewDelegate, UICollectionViewDataSource
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(collectionView.width, kTopH);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    SCShopHomeHeaderView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass(SCShopHomeHeaderView.class) forIndexPath:indexPath];
    
    header.tenantInfo = self.viewModel.tenantInfo;
    
    return header;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.viewModel.commodityList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SCShopCollectionCell *cell = (SCShopCollectionCell *)[collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(SCShopCollectionCell.class) forIndexPath:indexPath];
    
    SCCommodityModel *model = self.viewModel.commodityList[indexPath.row];
    
    cell.model = model;
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    SCCommodityModel *model = self.viewModel.commodityList[indexPath.row];
    
    [[SCURLSerialization shareSerialization] gotoWebcustom:model.detailUrl title:@"商品详情" navigation:self.navigationController];
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
        [_collectionView registerClass:SCShopHomeHeaderView.class forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass(SCShopHomeHeaderView.class)];
        
        [_collectionView showsRefreshHeader];
//        [_collectionView showsRefreshFooter];
        
        @weakify(self)
        _collectionView.refreshingBlock = ^(NSInteger page) {
            @strongify(self)
            [self requestData:page];
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
            [self requestData:1];
        };
        
    }
    return _siftView;
}

- (SCShopViewModel *)viewModel
{
    if (!_viewModel) {
        _viewModel = [SCShopViewModel new];
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
