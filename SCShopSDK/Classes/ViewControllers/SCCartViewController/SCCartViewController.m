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

#define kStoreSectionMargin SCREEN_FIX(11.5)

@interface SCCartViewController () <UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) SCCollectionView *collectionView;

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
    
    if (!_collectionView) {
        [self showLoading];
    }
    
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
            [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:1]];
        }];
    }
    
    
}

#pragma mark -UICollectionViewDelegate, UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 2;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize size = CGSizeZero;
    
    if (indexPath.section == 0) { //商品
        SCCartModel *model = self.viewModel.cartList[indexPath.row];
        size = CGSizeMake(collectionView.width - kStoreSectionMargin*2, kCartStoreTopH + kCartStoreBottomH + kCartStoreRowH*model.cartItems.count);
        
        
    }else { //为你推荐
        CGFloat itemW = kCommodityItemW;
        CGFloat itemH = kCommodityItemH;
        size = CGSizeMake(itemW, itemH);
    }
    return size;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    if (section == 0) { //商品
        return UIEdgeInsetsMake(SCREEN_FIX(13), kStoreSectionMargin, SCREEN_FIX(10), kStoreSectionMargin);
        
    }else { //为你推荐
        CGFloat margin = SCREEN_FIX(17);
        return UIEdgeInsetsMake(SCREEN_FIX(5.5), margin, SCREEN_FIX(10), margin);
    }
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    if (section == 0) { //商品
        return SCREEN_FIX(12);
        
    }else {
        return SCREEN_FIX(19);
    }
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    if (section == 0) { //商品
        return 0;
        
    }else {
        return SCREEN_FIX(13.5);
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    
    CGFloat width = collectionView.width;
    CGFloat height;
    
    if (section == 0) {
        height = VALID_ARRAY(self.viewModel.cartList) ? 0 : SCREEN_FIX(200);
        
    }else {
        height = VALID_ARRAY(self.viewModel.recommendList) ? SCREEN_FIX(29.5) : 0;
    }
    return CGSizeMake(width, height);
    
}



- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        SCCartEmptyView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass(SCCartEmptyView.class) forIndexPath:indexPath];
        @weakify(self)
        header.pushBlock = ^{
            @strongify(self)
            [self.navigationController pushViewController:[SCLifeViewController new] animated:YES];
        };
        
        return header;
        
    }else {
        UICollectionReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass(UICollectionReusableView.class) forIndexPath:indexPath];
        UIImageView *imgView = [header viewWithTag:100];
        if (!imgView) {
            UIImageView *imageView = [[UIImageView alloc] initWithImage:SCIMAGE(@"Cart_Recommend")];
            imageView.center = CGPointMake(header.width/2, header.height/2);
            imageView.tag = 100;
            [header addSubview:imageView];
        }
        
        
        return header;
    }
    
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section == 0) { //商品
        return self.viewModel.cartList.count;
        
    }else { //为你推荐
        return self.viewModel.recommendList.count;
    }
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {  //商品
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
        
    }else {  //为你推荐
        SCShopCollectionCell *cell = (SCShopCollectionCell *)[collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(SCShopCollectionCell.class) forIndexPath:indexPath];
        SCCommodityModel *model = self.viewModel.recommendList[indexPath.row];
        cell.model = model;
        
        return cell;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section != 0) { //为你推荐
        SCCommodityModel *model = self.viewModel.recommendList[indexPath.row];
        [SCURLSerialization gotoWebcustom:model.detailUrl title:@"" navigation:self.navigationController];
        
    }
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
    [SCRequest requestCartDelete:item.cartItemNum itemNum:item.itemNum success:^(id  _Nullable responseObject) {
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
        
        CGFloat h = SCREEN_HEIGHT - NAV_BAR_HEIGHT - (self.isMainTabVC ? TAB_BAR_HEIGHT: 0);
        
        _collectionView = [[SCCollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, h) collectionViewLayout:layout];
        _collectionView.backgroundColor = HEX_RGB(@"#F5F6F7");
        _collectionView.delegate        = self;
        _collectionView.dataSource      = self;
        [self.view addSubview:_collectionView];
        
        [_collectionView registerClass:SCShopCollectionCell.class forCellWithReuseIdentifier:NSStringFromClass(SCShopCollectionCell.class)];
        [_collectionView registerClass:SCCartStoreCell.class forCellWithReuseIdentifier:NSStringFromClass(SCCartStoreCell.class)];
        [_collectionView registerClass:SCCartEmptyView.class forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass(SCCartEmptyView.class)];
        [_collectionView registerClass:UICollectionReusableView.class forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass(UICollectionReusableView.class)];
        
        //
        [_collectionView showsRefreshHeader];
        //        [_collectionView showsRefreshFooter];
        @weakify(self)
        _collectionView.refreshingBlock = ^(NSInteger page) {
            @strongify(self)
            [self requestData];
        };
    }
    return _collectionView;
}

- (SCCartViewModel *)viewModel
{
    if (!_viewModel) {
        _viewModel = [SCCartViewModel new];
    }
    return _viewModel;
}

@end
