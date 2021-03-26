//
//  SCCartViewController.m
//  shopping
//
//  Created by gejunyu on 2020/7/3.
//  Copyright © 2020 jsmcc. All rights reserved.
//

#import "SCCartViewController.h"
#import "SCShopCollectionCell.h"
#import "SCCartStoreCell.h"
#import "SCCartViewModel.h"
#import "SCCartEmptyView.h"
#import "SCLifeViewController.h"
#import "SCRecommendItemView.h"

#define kStoreSectionMargin SCREEN_FIX(11.5)

@interface SCCartViewController () <UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) SCCollectionView *collectionView;
@property (nonatomic, strong) SCRecommendItemView *recommendView;

@property (nonatomic, strong) SCCartViewModel *viewModel;

@end

@implementation SCCartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"购物车";
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self requestData];
    
}

- (void)requestData
{
    [self.viewModel requestCartList:^(NSString * _Nullable errorMsg) {
        [self stopLoading];
        [self.collectionView reloadData];
    }];
    
    if (!self.viewModel.recommendList) {
        [self.viewModel requestRecommend:^(NSString * _Nullable errorMsg) {
            self.recommendView.list = self.viewModel.recommendList;
            [self.collectionView reloadData];
        }];
    }
    
    
}

#pragma mark -UICollectionViewDelegate, UICollectionViewDataSource
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{   
    CGFloat height = VALID_ARRAY(self.viewModel.cartList) ? 0 : SCREEN_FIX(200); //空数据提示

    return CGSizeMake(collectionView.width, height);
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    return CGSizeMake(collectionView.width, self.recommendView.height);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) { //header 空数据提示
        SCCartEmptyView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:UICollectionElementKindSectionHeader forIndexPath:indexPath];
        @weakify(self)
        header.pushBlock = ^{
            @strongify(self)

            [self.navigationController pushViewController:[SCLifeViewController new] animated:YES];
        };
        
        return header;
        
    }else { //footer 推荐商品
        UICollectionReusableView *footer = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:UICollectionElementKindSectionFooter forIndexPath:indexPath];
        
        SCRecommendItemView *recommendView = [footer viewWithTag:100];
        
        if (!recommendView) {
            self.recommendView.tag = 100;
            
            @weakify(self)
            self.recommendView.selectBlock = ^(SCCommodityModel * _Nonnull model) {
                @strongify(self)
                [SCURLSerialization gotoWebcustom:model.detailUrl title:@"" navigation:self.navigationController];
            };
            [footer addSubview:self.recommendView];
            
        }

        return footer;
    }
    
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.viewModel.cartList.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SCCartModel *model = self.viewModel.cartList[indexPath.row];
    
    return CGSizeMake(collectionView.width - kStoreSectionMargin*2, model.rowHeight);
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
        SCCartStoreCell *cell = (SCCartStoreCell *)[collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(SCCartStoreCell.class) forIndexPath:indexPath];
        SCCartModel *model = self.viewModel.cartList[indexPath.row];
        cell.model = model;
        
        @weakify(self)
        cell.deleteBlock = ^(SCCartItemModel * _Nonnull item, BOOL needConfirm) {
            @strongify(self)
            [self deleteCartItem:item needConfirm:needConfirm];
        };
        
        cell.commitBlock = ^{
            @strongify(self)
            NSString *url = [self.viewModel getOrderUrl:model];
            [SCURLSerialization gotoWebcustom:url title:@"" navigation:self.navigationController];
        };
        
        cell.rowClickBlock = ^(NSString *url) {
            @strongify(self)
            [SCURLSerialization gotoWebcustom:url title:@"" navigation:self.navigationController];
        };
        
        return cell;

}

- (void)deleteCartItem:(SCCartItemModel *)item needConfirm:(BOOL)needConfirm
{
    if (!needConfirm) { //不需要确认
        [self requestDelete:item];
        return;
    }
    
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"确定要删除该商品吗" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [ac addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [self requestDelete:item];
        
    }]];
    [ac addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:ac animated:YES completion:nil];
}

- (void)requestDelete:(SCCartItemModel *)item
{
    [self showLoading];
    [self.viewModel requestCartDelete:item success:^(id  _Nullable responseObject) {
        [self requestData];
        
    } failure:^(NSString * _Nullable errorMsg) {
        [self stopLoading];
        [self showWithStatus:errorMsg];
        
    }];
}


#pragma mark -ui
- (SCCollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.sectionInset = UIEdgeInsetsMake(SCREEN_FIX(13), kStoreSectionMargin, 0, kStoreSectionMargin);
        layout.minimumLineSpacing = SCREEN_FIX(12);
        layout.minimumInteritemSpacing = 0;
        
        CGFloat h = SCREEN_HEIGHT - NAV_BAR_HEIGHT - (self.isMainTabVC ? TAB_BAR_HEIGHT: 0);
        
        _collectionView = [[SCCollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, h) collectionViewLayout:layout];
        _collectionView.backgroundColor = HEX_RGB(@"#F5F6F7");
        _collectionView.delegate        = self;
        _collectionView.dataSource      = self;
        [self.view addSubview:_collectionView];
        
        [_collectionView registerClass:SCCartStoreCell.class forCellWithReuseIdentifier:NSStringFromClass(SCCartStoreCell.class)];
        [_collectionView registerClass:SCCartEmptyView.class forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:UICollectionElementKindSectionHeader];
        [_collectionView registerClass:UICollectionReusableView.class forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:UICollectionElementKindSectionFooter];
        
        //
        [_collectionView showsRefreshHeader];
        @weakify(self)
        _collectionView.refreshingBlock = ^(NSInteger page) {
            @strongify(self)
            [self requestData];
        };
    }
    return _collectionView;
}

- (SCRecommendItemView *)recommendView
{
    if (!_recommendView) {
        _recommendView = [[SCRecommendItemView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 0)];
    }
    return _recommendView;
}

- (SCCartViewModel *)viewModel
{
    if (!_viewModel) {
        _viewModel = [SCCartViewModel new];
    }
    return _viewModel;
}

@end
