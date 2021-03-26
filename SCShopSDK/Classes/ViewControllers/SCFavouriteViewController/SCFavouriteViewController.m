//
//  SCFavouriteViewController.m
//  shopping
//
//  Created by gejunyu on 2020/7/14.
//  Copyright © 2020 jsmcc. All rights reserved.
//

#import "SCFavouriteViewController.h"
#import "SCFavouriteViewModel.h"
#import "SCFavouriteCell.h"
#import "SCCartEmptyView.h"
#import "SCLifeViewController.h"
#import "SCRecommendItemView.h"

@interface SCFavouriteViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) SCTableView *tableView;
@property (nonatomic, strong) SCRecommendItemView *recommendView;
@property (nonatomic, strong) SCCartEmptyView *emptyView;
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
    [self.viewModel requestFavoriteList:^(NSString * _Nullable errorMsg) {
        [self stopLoading];
        self.tableView.tableHeaderView = VALID_ARRAY(self.viewModel.favouriteList) ? nil : self.emptyView;
        [self.tableView reloadData];
    }];
    
    if (!self.viewModel.recommendList) {
        [self.viewModel requestRecommend:^(NSString * _Nullable errorMsg) {
            self.recommendView.list = self.viewModel.recommendList;
            self.tableView.tableFooterView = self.recommendView;
//            [self.tableView reloadData];
        }];
    }
    
}

#pragma mark -UITableViewDelegate, UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.viewModel.favouriteList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SCFavouriteCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(SCFavouriteCell.class) forIndexPath:indexPath];
    
    SCFavouriteModel *model = self.viewModel.favouriteList[indexPath.row];
    cell.model = model;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SCFavouriteModel *model = self.viewModel.favouriteList[indexPath.row];
    
    [SCURLSerialization gotoNewPage:model.categoryUrl title:@"" navigation:self.navigationController];
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self favouriteDelete:indexPath.row];
    }
}

#pragma mark -action
- (void)favouriteDelete:(NSInteger)row
{
    if (row >= self.viewModel.favouriteList.count) {
        return;
    }
    
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"确定要删除该商品吗" message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    [ac addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self showLoading];
        SCFavouriteModel *model = self.viewModel.favouriteList[row];
        [self.viewModel requestFavoriteDelete:model success:^(id  _Nullable responseObject) {
            [self stopLoading];
            [self.viewModel.favouriteList removeObjectAtIndex:row];
            [self.tableView reloadData];
            if (self.viewModel.favouriteList.count == 0) {
                self.tableView.tableHeaderView = self.emptyView;
            }
            
        } failure:^(NSString * _Nullable errorMsg) {
            [self stopLoading];
            [self showWithStatus:errorMsg];
            
        }];

    }]];
    
    [ac addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    
    [self presentViewController:ac animated:YES completion:nil];
}


#pragma mark -ui
- (SCTableView *)tableView
{
    if (!_tableView) {
        CGFloat h = SCREEN_HEIGHT - NAV_BAR_HEIGHT - (self.isMainTabVC ? TAB_BAR_HEIGHT: 0);
        
        _tableView = [[SCTableView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, h)];
        _tableView.backgroundColor = HEX_RGB(@"#F5F6F7");
        _tableView.rowHeight = SCREEN_FIX(148);
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [self.view addSubview:_tableView];
        
        [_tableView registerClass:SCFavouriteCell.class forCellReuseIdentifier:NSStringFromClass(SCFavouriteCell.class)];
        [_tableView registerClass:UITableViewHeaderFooterView.class forHeaderFooterViewReuseIdentifier:@"header"];
        [_tableView registerClass:UITableViewHeaderFooterView.class forHeaderFooterViewReuseIdentifier:@"footer"];
        
        [_tableView showsRefreshHeader];
        
        @weakify(self)
        _tableView.refreshingBlock = ^(NSInteger page) {
            @strongify(self)
            [self requestData];
        };
        
    }
    return _tableView;
}


- (SCRecommendItemView *)recommendView
{
    if (!_recommendView) {
        _recommendView = [[SCRecommendItemView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 0)];
        @weakify(self)
        _recommendView.selectBlock = ^(SCCommodityModel * _Nonnull model) {
            @strongify(self)
            [SCURLSerialization gotoWebcustom:model.detailUrl title:@"" navigation:self.navigationController];
        };
    }
    return _recommendView;
}

- (SCCartEmptyView *)emptyView
{
    if (!_emptyView) {
        _emptyView = [[SCCartEmptyView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, SCREEN_FIX(200))];
        _emptyView.title = @"收藏竟然是空的";
        @weakify(self)
        _emptyView.pushBlock = ^{
            @strongify(self)
            [self.navigationController pushViewController:[SCLifeViewController new] animated:YES];
        };

    }
    return _emptyView;
}

- (SCFavouriteViewModel *)viewModel
{
    if (!_viewModel) {
        _viewModel = [SCFavouriteViewModel new];
    }
    return _viewModel;
}

@end
