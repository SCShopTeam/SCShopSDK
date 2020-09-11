//
//  SCGoodStoreViewController.m
//  shopping
//
//  Created by gejunyu on 2020/8/20.
//  Copyright © 2020 jsmcc. All rights reserved.
//

#import "SCGoodStoreViewController.h"
#import "SCGoodStoreCell.h"

@interface SCGoodStoreViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation SCGoodStoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self prepareUI];
}

- (void)prepareUI
{
    self.title = @"发现好店";
    
    if (_viewModel) {
        [self.tableView reloadData];
    }
}

#pragma mark -UITableViewDelegate, UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.viewModel.goodStoreList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kGoodStoreRowH;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SCGoodStoreCell *cell = (SCGoodStoreCell *)[tableView dequeueReusableCellWithIdentifier:NSStringFromClass(SCGoodStoreCell.class) forIndexPath:indexPath];
    
    SCHomeStoreModel *model = self.viewModel.goodStoreList[indexPath.row];
    
    cell.model = model;
    
    @weakify(self)
    cell.enterShopBlock = ^(SCHShopInfoModel * _Nonnull shopModel) {
        @strongify(self)
        [SCUtilities scXWMobStatMgrStr:NSStringFormat(@"IOS_T_NZDSC_C%li",indexPath.row*4+10) url:shopModel.link inPage:NSStringFromClass(self.class)];
        [self pushToWebView:shopModel.link title:@"智慧门店"];
    };
    
    cell.imgBlock = ^(NSInteger index, SCHActImageModel * _Nonnull imgModel) {
        @strongify(self)
        [SCUtilities scXWMobStatMgrStr:NSStringFormat(@"IOS_T_NZDSC_C%li",indexPath.row*4+11+index) url:imgModel.actImageLink inPage:NSStringFromClass(self.class)];
        [self pushToWebView:imgModel.actImageLink title:@"商品详情"];
    };

    
    return cell;
}

- (void)pushToWebView:(NSString *)url title:(NSString *)title
{
    [[SCURLSerialization shareSerialization] gotoWebcustom:url title:@"" navigation:self.navigationController];
}

#pragma mark -ui
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-NAV_BAR_HEIGHT)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
        [self.view addSubview:_tableView];
        [_tableView registerClass:SCGoodStoreCell.class forCellReuseIdentifier:NSStringFromClass(SCGoodStoreCell.class)];
    }
    return _tableView;
}

@end
