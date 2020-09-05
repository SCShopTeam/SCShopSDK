//
//  SCTagShopsViewController.m
//  shopping
//
//  Created by gejunyu on 2020/7/13.
//  Copyright © 2020 jsmcc. All rights reserved.
//

#import "SCTagShopsViewController.h"
#import "SCTagView.h"
#import "SCTagShopViewModel.h"
#import "SCShopTableCell.h"

@interface SCTagShopsViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) SCTableView *tableView;
@property (nonatomic, strong) SCTagView *tagView;
@property (nonatomic, strong) SCTagShopViewModel *viewModel;
@property (nonatomic, strong) UILabel *emptyTipLabel;
@end

@implementation SCTagShopsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"智能生活";
    
    [self requestCategoryList];
    
}

- (void)requestCategoryList
{
    [self showLoading];
    [self.viewModel requestCategoryList:^(id  _Nullable responseObject) {
        [self.viewModel setModelSelected:self.paramDic];

        self.tagView.categoryList = self.viewModel.categoryList;
        [self requestCommodityList:1];
        
    } failure:^(NSString * _Nullable errorMsg) {
        [self stopLoading];
        [self showWithStatus:errorMsg];
    }];
}


- (void)requestCommodityList:(NSInteger)page
{
    [self showLoading];
    [self.viewModel requestCommodityList:page completion:^(NSString * _Nullable errorMsg) {
        [self stopLoading];
        [self.tableView reloadDataShowFooter:self.viewModel.hasMoreData];
        
        if (errorMsg) {
            [self showError:errorMsg];
            
        }else {
            self.emptyTipLabel.hidden = self.viewModel.commodityList.count;
        }
    }];

}

#pragma mark -UITableViewDelegate, UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.viewModel.commodityList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kCommonShopRowH;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SCShopTableCell *cell = (SCShopTableCell *)[tableView dequeueReusableCellWithIdentifier:NSStringFromClass(SCShopTableCell.class) forIndexPath:indexPath];
    
    SCCommodityModel *model = self.viewModel.commodityList[indexPath.row];
    
    cell.model = model;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SCCommodityModel *model = self.viewModel.commodityList[indexPath.row];
    
    [[SCURLSerialization shareSerialization] gotoWebcustom:model.detailUrl title:@"商品详情" navigation:self.navigationController];
}

- (SCTagView *)tagView
{
    if (!_tagView) {
        _tagView = [[SCTagView alloc] initWithFrame:CGRectMake(0, SCREEN_FIX(10), self.view.width, SCREEN_FIX(30))];
        [self.view addSubview:_tagView];
        
        @weakify(self)
        _tagView.selectBlock = ^(NSInteger index) {
            @strongify(self)
            self.tableView.page = 1;
            [self requestCommodityList:1];
        };

    }
    return _tagView;
}


- (SCTableView *)tableView
{
    if (!_tableView) {
        CGFloat y = self.tagView.bottom + SCREEN_FIX(5);
        _tableView = [[SCTableView alloc] initWithFrame:CGRectMake(0, y, SCREEN_WIDTH, SCREEN_HEIGHT- NAV_BAR_HEIGHT - y)];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate   = self;
        _tableView.dataSource = self;
        [_tableView registerClass:SCShopTableCell.class forCellReuseIdentifier:NSStringFromClass(SCShopTableCell.class)];
        [_tableView showsRefreshHeader];
//        [_tableView showsRefreshFooter];
        @weakify(self)
        _tableView.refreshingBlock = ^(NSInteger page) {
            @strongify(self)
            [self requestCommodityList:page];
        };
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

- (SCTagShopViewModel *)viewModel
{
    if (!_viewModel) {
        _viewModel = [SCTagShopViewModel new];
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
        _emptyTipLabel.text = @"抱歉，暂无商品，看看其他品类吧~";
        [_emptyTipLabel sizeToFit];
        _emptyTipLabel.center = self.tableView.center;
        [self.view addSubview:_emptyTipLabel];
    }
    return _emptyTipLabel;
}


@end
