//
//  SCLifeCell.m
//  shopping
//
//  Created by gejunyu on 2020/9/16.
//  Copyright © 2020 jsmcc. All rights reserved.
//

#import "SCLifeCell.h"
#import "SCLifeViewModel.h"
#import "SCShopTableCell.h"

@interface SCLifeCell () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) SCTableView *tableView;
@property (nonatomic, strong) SCLifeViewModel *viewModel;
@property (nonatomic, strong) UILabel *emptyTipLabel;

@end

@implementation SCLifeCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self emptyTipLabel];
    }
    return self;
}

- (void)setTypeNum:(NSString *)typeNum
{
    _typeNum = typeNum ?: @"";
    
    if (!self.viewModel.commodityList) {
        [self requestData:1];
    }

}

- (void)requestData:(NSInteger)page
{
    [self.viewModel requestCommodityList:self.typeNum page:page completion:^(NSString * _Nullable errorMsg) {
        [self.tableView reloadDataShowFooter:self.viewModel.hasMoreData];
        
        if (errorMsg) {
            self.emptyTipLabel.text = errorMsg;
            
        }else {
            self.emptyTipLabel.text = @"抱歉，暂无商品，看看其他商品吧~";
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
    
    if (indexPath.row < self.viewModel.commodityList.count) {
        SCCommodityModel *model = self.viewModel.commodityList[indexPath.row];
        
        cell.model = model;
    }

    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SCCommodityModel *model = self.viewModel.commodityList[indexPath.row];
    //改
    [[SCURLSerialization shareSerialization] gotoWebcustom:model.detailUrl title:@"" navigation:[SCUtilities currentNavigationController]];
}

#pragma mark -ui
- (SCTableView *)tableView
{
    if (!_tableView) {
        _tableView = [[SCTableView alloc] initWithFrame:self.bounds];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView showsRefreshHeader];
        [self addSubview:_tableView];
        [_tableView registerClass:SCShopTableCell.class forCellReuseIdentifier:NSStringFromClass(SCShopTableCell.class)];
        
        @weakify(self)
        _tableView.refreshingBlock = ^(NSInteger page) {
            @strongify(self)
            [self requestData:page];
        };
    }
    return _tableView;
}

- (UILabel *)emptyTipLabel
{
    if (!_emptyTipLabel) {
        _emptyTipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.width, 20)];
        _emptyTipLabel.textAlignment = NSTextAlignmentCenter;
        _emptyTipLabel.font = SCFONT_SIZED(15);
        _emptyTipLabel.textColor = HEX_RGB(@"#999999");
        _emptyTipLabel.text = @"加载中...";
        _emptyTipLabel.centerY = self.tableView.height/2;
        [self addSubview:_emptyTipLabel];
    }
    return _emptyTipLabel;
}

- (SCLifeViewModel *)viewModel
{
    if (!_viewModel) {
        _viewModel = [SCLifeViewModel new];
    }
    return _viewModel;
}

@end
