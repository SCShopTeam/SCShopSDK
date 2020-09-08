//
//  SCFavouriteViewController.m
//  shopping
//
//  Created by gejunyu on 2020/7/14.
//  Copyright © 2020 jsmcc. All rights reserved.
//

#import "SCFavouriteViewController.h"
#import "SCShopCollectionCell.h"
#import "SCFavouriteViewModel.h"
#import "SCFavouriteListView.h"
#import "SCCartEmptyView.h"
#import "SCLifeViewController.h"

@interface SCFavouriteViewController () <UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) SCCollectionView *collectionView;
@property (nonatomic, strong) SCFavouriteViewModel *viewModel;

@end

@implementation SCFavouriteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"商品收藏";
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self requestData];
}

- (void)requestData
{
    dispatch_group_t group = dispatch_group_create();
    // 请求收藏
    dispatch_group_enter(group);
    [self.viewModel requestFavoriteList:^(NSString * _Nullable errorMsg) {
        dispatch_group_leave(group);
    }];
    
    // 请求为你推荐
    if (!self.viewModel.recommendList) {
        dispatch_group_enter(group);
        [self.viewModel requestRecommend:^(NSString * _Nullable errorMsg) {
            dispatch_group_leave(group);
        }];
    }

    // 当上述两个请求结束后，收到通知，在此做后续工作
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        [self stopLoading];
        [self.collectionView reloadData];
    });
    
    

}

#pragma mark -UICollectionViewDelegate, UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 2;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize size = CGSizeZero;
    
    if (indexPath.section == 0) { //收藏
//        if (VALID_ARRAY(self.viewModel.favouriteList)) {
//            size = CGSizeMake(SCREEN_WIDTH, SCREEN_FIX(148));
//        }
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
        return UIEdgeInsetsMake(0, 0, SCREEN_FIX(10), 0);
    }else { //为你推荐
        CGFloat margin = SCREEN_FIX(17);
        return UIEdgeInsetsMake(SCREEN_FIX(5.5), margin, SCREEN_FIX(10), margin);
    }
}

    
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    if (section == 0) { //商品
        return 0;
        
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
        if (VALID_ARRAY(self.viewModel.favouriteList)) {
            height = kFavouriteRowH * self.viewModel.favouriteList.count;
        }else {
            height = SCREEN_FIX(200);
        }
        
    }else {
        height = SCREEN_FIX(29.5);
    }
    return CGSizeMake(width, height);
    
}



- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (VALID_ARRAY(self.viewModel.favouriteList)) {
            SCFavouriteListView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass(SCFavouriteListView.class) forIndexPath:indexPath];
            header.favouriteList = self.viewModel.favouriteList;
            
            @weakify(self)
            header.selectBlock = ^(NSInteger row) {
                @strongify(self)
                [self favouriteSelect:row];
            };
            header.deleteBlock = ^(NSInteger row) {
                @strongify(self)
                [self favouriteDelete:row];
            };
            
            
            return header;
            
        }else {
            SCCartEmptyView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass(SCCartEmptyView.class) forIndexPath:indexPath];
            header.title = @"收藏竟然是空的";
            @weakify(self)
            header.pushBlock = ^{
                @strongify(self)
                [self.navigationController pushViewController:[SCLifeViewController new] animated:YES];
            };
            
            return header;
            
            return header;
            
        }

        
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
        return 0;
        
    }else { //为你推荐
        return self.viewModel.recommendList.count;
    }
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {  //商品
        return [UICollectionViewCell new];

        
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
        [[SCURLSerialization shareSerialization] gotoWebcustom:model.detailUrl title:@"商品详情" navigation:self.navigationController];
        
    }
}

#pragma mark -action
- (void)favouriteSelect:(NSInteger)row
{
    if (row < 0 || row >= self.viewModel.favouriteList.count) {
        return;
    }
    
    SCFavouriteModel *model = self.viewModel.favouriteList[row];
    NSString *url = model.categoryUrl;
    if ([SCUtilities isValidString:url]) {
        [[SCURLSerialization shareSerialization] gotoWebcustom:url title:@"商品详情" navigation:self.navigationController];
    }
}

- (void)favouriteDelete:(NSInteger)row
{
    if (row < 0 || row >= self.viewModel.favouriteList.count) {
        return;
    }
    
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"确定要删除该商品吗" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [ac addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self showLoading];
        SCFavouriteModel *model = self.viewModel.favouriteList[row];
        [SCRequest requestFavoriteDelete:model.favNum itemNum:model.itemNum success:^(id  _Nullable responseObject) {
            [self stopLoading];
            [self.viewModel.favouriteList removeObjectAtIndex:row];
            [self.collectionView reloadData];
            
        } failure:^(NSString * _Nullable errorMsg) {
            [self stopLoading];
            [self showWithStatus:errorMsg];
        }];
    }]];
    [ac addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:ac animated:YES completion:nil];
}


#pragma mark -ui
- (SCCollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        layout.scrollDirection         = UICollectionViewScrollDirectionVertical;
        
        CGFloat h = SCREEN_HEIGHT - NAV_BAR_HEIGHT - (self.isMainTabVC ? TAB_BAR_HEIGHT: 0);
        
        _collectionView = [[SCCollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, h) collectionViewLayout:layout];
        _collectionView.backgroundColor = HEX_RGB(@"#F5F6F7");
        _collectionView.delegate        = self;
        _collectionView.dataSource      = self;
        [self.view addSubview:_collectionView];
        
        [_collectionView registerClass:SCShopCollectionCell.class forCellWithReuseIdentifier:NSStringFromClass(SCShopCollectionCell.class)];
        [_collectionView registerClass:SCFavouriteListView.class forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass(SCFavouriteListView.class)];
        [_collectionView registerClass:SCCartEmptyView.class forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass(SCCartEmptyView.class)];
        [_collectionView registerClass:UICollectionReusableView.class forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass(UICollectionReusableView.class)];

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

- (SCFavouriteViewModel *)viewModel
{
    if (!_viewModel) {
        _viewModel = [SCFavouriteViewModel new];
    }
    return _viewModel;
}

@end
