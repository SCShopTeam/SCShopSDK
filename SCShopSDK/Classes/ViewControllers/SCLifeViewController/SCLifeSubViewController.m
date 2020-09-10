//
//  SCLifeSubViewController.m
//  shopping
//
//  Created by gejunyu on 2020/9/7.
//  Copyright © 2020 jsmcc. All rights reserved.
//

#import "SCLifeSubViewController.h"
#import "SCLifeViewModel.h"
#import "SCShopTableCell.h"

@interface SCLifeSubViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) SCTableView *tableView;
@property (nonatomic, strong) SCLifeViewModel *viewModel;
@property (nonatomic, strong) UILabel *emptyTipLabel;

@end

@implementation SCLifeSubViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self requestCommodityList:1];
}


- (void)requestCommodityList:(NSInteger)page
{
    [self.viewModel requestCommodityList:_typeNum page:page completion:^(NSString * _Nullable errorMsg) {
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
    //改
    [[SCURLSerialization shareSerialization] gotoWebcustom:model.detailUrl title:@"商品详情" navigation:self.navigationController];
}


- (SCTableView *)tableView
{
    if (!_tableView) {
        _tableView = [[SCTableView alloc] initWithFrame:self.view.bounds];
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

- (SCLifeViewModel *)viewModel
{
    if (!_viewModel) {
        _viewModel = [SCLifeViewModel new];
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
        _emptyTipLabel.text = @"抱歉，暂无商品，看看其他商品吧~";
        [_emptyTipLabel sizeToFit];
        _emptyTipLabel.center = self.tableView.center;
        [self.view addSubview:_emptyTipLabel];
    }
    return _emptyTipLabel;
}

@end
