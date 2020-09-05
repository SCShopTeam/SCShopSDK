//
//  SCWitStoreViewController.m
//  shopping
//
//  Created by gejunyu on 2020/8/28.
//  Copyright © 2020 jsmcc. All rights reserved.
//

#import "SCWitStoreViewController.h"
#import "SCWitStoreHeaderView.h"
#import "SCWitStoreViewModel.h"
#import "SCWitStoreCell.h"
#import "SCWitStoreQueryView.h"
#import "SCAreaSelectView.h"
#import "SCWitProfessionalHeaderView.h"
#import "SCWitNoStoreHeaderView.h"
#import "SCWitStoreHeader.h"
#import "SCWitStoreSortView.h"

@interface SCAreaButton : UIButton
@end

@interface SCWitStoreViewController () <UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) SCAreaButton *areaBtn;
@property (nonatomic, strong) UIImageView *backImgView;
@property (nonatomic, strong) UITextField *searchField;
@property (nonatomic, strong) UIButton *deleteSearchButton;
@property (nonatomic, strong) SCTableView *tableView;
@property (nonatomic, strong) SCWitStoreViewModel *viewModel;
@property (nonatomic, strong) SCWitStoreHeaderView *headerView;
@property (nonatomic, strong) SCWitStoreQueryView *queryView;
@property (nonatomic, strong) SCWitStoreSortView *sortView;
@end

@implementation SCWitStoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self prepareUI];
    
    //请求地市信息
    [self requestAreaList];

}

- (void)prepareUI
{
    self.title = @"官方好店";
    self.view.backgroundColor = HEX_RGB(@"#EEEEEE");
    [self backImgView];
    self.tableView.tableHeaderView = self.headerView;
    [self queryView];
}

#pragma mark -request

- (void)requestAreaList
{
    //请求地市
    [self showLoading];
    [self.viewModel requestAreaList:^(NSString * _Nonnull areaName) {
        [self.areaBtn setTitle:areaName forState:UIControlStateNormal];
        [self requestStoreList:1 showHud:NO];
    }];

}

- (void)requestStoreList:(NSInteger)page showHud:(BOOL)showHud
{
    if (showHud) {
        [self showLoading];
    }
    
    if (page == 1) {
        self.tableView.page = 1;
    }
    
    self.viewModel.requestModel.queryType == SCWitQueryTypeSearch ? [self.tableView hidesRefreshHeader] : [self.tableView showsRefreshHeader];

    [self.viewModel requestAggregateStoreWithPage:page completion:^(NSString * _Nullable errorMsg) {
        [self stopLoading];
        [self.tableView reloadDataShowFooter:self.viewModel.hasMoreData];
        
        if (page == 1) {
            [self.tableView setContentOffset:CGPointMake(0, 0) animated:NO];
        }
        
        if (errorMsg) {
            [self showWithStatus:errorMsg];
            
        }else {
            [self updateNearStoreInfo:page];
        }
    }];

}

- (void)updateNearStoreInfo:(NSInteger)page
{
    if (self.viewModel.requestModel.queryType == SCWitQueryTypeSearch) {
        self.tableView.tableHeaderView = nil;
        self.queryView.hidden = YES;
        
        return;
    }
    
    if (page > 1) {
        return;
    }
    
    self.queryView.hidden = NO;
    
    if (!self.tableView.tableHeaderView) {
        self.tableView.tableHeaderView = self.headerView;
    }
    
    if (self.headerView.model != self.viewModel.nearStoreModel) {
        self.headerView.model = self.viewModel.nearStoreModel;
        [self requestRecommendGoods];
    }
    
}

- (void)requestRecommendGoods
{
    [self.viewModel requestRecommendGoods:^(id  _Nullable responseObject) {
        self.headerView.goodsList = self.viewModel.goodsList;
        
    } failure:^(NSString * _Nullable errorMsg) {
        
    }];
}


- (void)requestOrder:(SCWitStoreModel *)storeModel indexPath:(NSIndexPath *)indexPath
{
    [self showLoading];
    [self.viewModel requestVouchNumber:storeModel success:^(id  _Nullable responseObject) {
        [self stopLoading];
        [self showWithStatus:@"取号成功"];
        if (indexPath) { //是cell
            storeModel.cell.model = storeModel;
            
        }else { //是header
            storeModel.headerView.model = storeModel;
        }
        [self pushToWebView:storeModel.storeLink title:@"智慧门店"];
        
        
    } failure:^(NSString * _Nullable errorMsg) {
        [self stopLoading];
        [self showWithStatus:errorMsg];
    }];
}


#pragma mark -UITableViewDelegate, UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.viewModel.showProfessionalList ? 2 : 1;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        if (self.viewModel.storeList.count > 0) {
            return 0;
        }else {
            return SCREEN_FIX(280);
        }
        
    }else { //为你推荐
        return self.viewModel.professionalList.count ? self.queryView.height : 0;
    }
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    if (section == 0) {
        SCWitNoStoreHeaderView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass(SCWitNoStoreHeaderView.class)];
        view.showTip = self.viewModel.storeList && self.viewModel.storeList.count == 0;
        return view;
        
    }else {
        SCWitProfessionalHeaderView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass(SCWitProfessionalHeaderView.class)];
        
        return view;
        
    }


    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return self.viewModel.storeList.count;
        
    }else {
        return self.viewModel.professionalList.count;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    SCWitStoreModel *model = indexPath.section == 0 ? self.viewModel.storeList[indexPath.row] : self.viewModel.professionalList[indexPath.row] ;
    return model.rowHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SCWitStoreCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(SCWitStoreCell.class) forIndexPath:indexPath];
//
    NSInteger section = indexPath.section;
    NSInteger row     = indexPath.row;
    
    NSArray <SCWitStoreModel *> *dataList = section == 0 ? self.viewModel.storeList : self.viewModel.professionalList;
    
    if (row == 0) {  //第一个cell是顶部圆角
        if (dataList.count == 1) { //只有一个cell
            cell.style = SCWitCornerStyleTop|SCWitCornerStyleBottom;
        }else {
            cell.style = SCWitCornerStyleTop;
        }

        
    }else if (row == dataList.count - 1) { //最后一个cell是底部圆角
        cell.style = SCWitCornerStyleBottom;
        
    }else { //没有圆角
        cell.style = SCWitCornerStyleNone;
    }
    
  
    cell.model = dataList[row];
    
    @weakify(self)
    cell.phoneBlock = ^(NSString * _Nonnull phone) {
        @strongify(self)
        [self phoneAction:phone];
    };
    
    cell.enterBlock = ^(SCWitStoreModel * _Nonnull storeModel) {
      @strongify(self)
        [self pushToWebView:storeModel.storeLink title:@"智慧门店"];
    };
    
    cell.orderBlock = ^(SCWitStoreModel * _Nonnull model) {
      @strongify(self)
        [self requestOrder:model indexPath:indexPath];
    };
    
    
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offsetY = scrollView.contentOffset.y;
    //坐标
    CGFloat originY = self.topView.bottom + self.headerView.height + kWitStoreCorner - self.queryView.height;
    CGFloat newY = originY - offsetY;
    if (newY < self.topView.bottom) {
        newY = self.topView.bottom;
        [self.queryView showBgColor:YES];
    }else {
        [self.queryView showBgColor:NO];
    }
    self.queryView.top = newY;
    self.sortView.top  = self.queryView.bottom;
}

#pragma mark -UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self hideNoNeedUI];
    SCWitRequestModel *requestModel = self.viewModel.requestModel;
    
    if (VALID_STRING(textField.text)) {
        requestModel.queryStr  = textField.text;
        requestModel.queryType = SCWitQueryTypeSearch;
        _deleteSearchButton.hidden = NO;
        [self requestStoreList:1 showHud:YES];
        
    }else {
        [self textFieldClear];
    }
    
    return YES;
}

- (void)textFieldClear
{
    [self hideNoNeedUI];
    _deleteSearchButton.hidden = YES;
    self.searchField.text = nil;
    self.viewModel.requestModel.queryType = SCWitQueryTypeNear;
    [self requestStoreList:1 showHud:YES];
    [self.queryView clear];
}

#pragma mark -btnAction
- (void)showAreaSelect:(UIButton *)sender
{
    [self hideNoNeedUI];
    
    if (self.viewModel.areaList.count == 0) {
        [self showWithStatus:@"获取定位信息失败"];
        return;
    }
    
    [SCAreaSelectView show:self.viewModel.areaList selectBlock:^(SCAreaModel * _Nonnull model) {
        //区域名称
        [self.areaBtn setTitle:model.name forState:UIControlStateNormal];
        //区域编码
        self.viewModel.requestModel.busiRegCityCode = model.code;
        //清除搜索框
        self.searchField.text = nil;
        //重置筛选条件
        [self.queryView clear];
        
        [self requestStoreList:1 showHud:YES];
    }];
}

- (void)phoneAction:(NSString *)phoneNum
{
    [self hideNoNeedUI];
    [SCUtilities call:phoneNum];
}

- (void)pushToWebView:(NSString *)url title:(NSString *)title
{
    [self hideNoNeedUI];
    [[SCURLSerialization shareSerialization] gotoWebcustom:url title:title navigation:self.navigationController];
}


#pragma mark -private
- (void)hideNoNeedUI
{
    [self.searchField resignFirstResponder];
    self.sortView.hidden = YES;
}

#pragma mark -UI
- (UIView *)topView
{
    if (!_topView) {
        _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, SCREEN_FIX(50.5))];
        [self.view addSubview:_topView];
        
        //地址按钮
        _areaBtn = [[SCAreaButton alloc] initWithFrame:CGRectMake(SCREEN_FIX(13), SCREEN_FIX(10), SCREEN_FIX(50), SCREEN_FIX(30))];
        [_areaBtn addTarget:self action:@selector(showAreaSelect:) forControlEvents:UIControlEventTouchUpInside];
        [_topView addSubview:_areaBtn];

        
        //搜索框
        CGFloat sX = _areaBtn.right + SCREEN_FIX(9.5);
        UIView *searchView = [[UIView alloc] initWithFrame:CGRectMake(sX, SCREEN_FIX(10), _topView.width-sX-SCREEN_FIX(12), SCREEN_FIX(30))];
        searchView.backgroundColor = [UIColor whiteColor];
        searchView.layer.cornerRadius = searchView.height/2;
        [_topView addSubview:searchView];
        
        //图片
        CGFloat iconWH = SCREEN_FIX(13.5);
        UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_FIX(10), (searchView.height-iconWH)/2, iconWH, iconWH)];
        icon.image = SCIMAGE(@"sc_wit_search");
        [searchView addSubview:icon];
        
        //输入框
        CGFloat fieldX = icon.right + SCREEN_FIX(5);
        CGFloat fieldW = searchView.width - fieldX - SCREEN_FIX(9);
        _searchField = [[UITextField alloc] initWithFrame:CGRectMake(fieldX, 0, fieldW, searchView.height)];
        _searchField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _searchField.delegate        = self;
        _searchField.font            = SCFONT_SIZED(14);
        _searchField.returnKeyType   = UIReturnKeySearch;
        _searchField.textColor       = HEX_RGB(@"#888888");
        _searchField.placeholder     = @"输入门店名称或地址";
        _searchField.clearButtonMode = UITextFieldViewModeNever;
        [searchView addSubview:_searchField];
        
        //删除搜索结果
        CGFloat dWH = SCREEN_FIX(30);
        _deleteSearchButton = [[UIButton alloc] initWithFrame:CGRectMake(_searchField.width - dWH, (_searchField.height - dWH)/2, dWH, dWH)];
        [_deleteSearchButton setImage:SCIMAGE(@"sc_wit_delete") forState:UIControlStateNormal];
        _deleteSearchButton.hidden = YES;
        [_deleteSearchButton addTarget:self action:@selector(textFieldClear) forControlEvents:UIControlEventTouchUpInside];
        [_searchField addSubview:_deleteSearchButton];
    }
    return _topView;
}

- (UIImageView *)backImgView
{
    if (!_backImgView) {
        CGFloat w = self.view.width;
        CGFloat h = w/750*422;
        _backImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, w, h)];
        _backImgView.image = SCIMAGE(@"sc_wit_top");
        [self.view addSubview:_backImgView];
        [self.view sendSubviewToBack:_backImgView];
    }
    return _backImgView;
}

- (SCTableView *)tableView
{
    if (!_tableView) {
        CGFloat y = self.topView.bottom;
        _tableView = [[SCTableView alloc] initWithFrame:CGRectMake(0, y, SCREEN_WIDTH, SCREEN_HEIGHT-NAV_BAR_HEIGHT-y)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:_tableView];
        
        [_tableView registerClass:SCWitStoreCell.class forCellReuseIdentifier:NSStringFromClass(SCWitStoreCell.class)];
        [_tableView registerClass:SCWitProfessionalHeaderView.class forHeaderFooterViewReuseIdentifier:NSStringFromClass(SCWitProfessionalHeaderView.class)];
        [_tableView registerClass:SCWitNoStoreHeaderView.class forHeaderFooterViewReuseIdentifier:NSStringFromClass(SCWitNoStoreHeaderView.class)];
        
        [_tableView showsRefreshHeader];
        [_tableView showsRefreshFooter];
        
        @weakify(self)
        _tableView.refreshingBlock = ^(NSInteger page) {
            @strongify(self)
            [self hideNoNeedUI];
            [self requestStoreList:page showHud:NO];
        };
    }
    return _tableView;
}

- (SCWitStoreHeaderView *)headerView
{
    if (!_headerView) {
        _headerView = [[SCWitStoreHeaderView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.width, SCREEN_FIX(389))];
        
        @weakify(self)
        //打电话
        _headerView.phoneBlock = ^(NSString * _Nonnull phone) {
            @strongify(self)
            [self phoneAction:phone];
        };
        
        //选择商品
        _headerView.goodSelectBlock = ^(SCWitStoreGoodModel * _Nonnull goodModel) {
            @strongify(self)
            [self pushToWebView:goodModel.goodsH5Link title:@"商品详情"];
        };
        
        //立即取号
        _headerView.orderBlock = ^(SCWitStoreModel * _Nonnull model) {
            @strongify(self)
            [self hideNoNeedUI];
            [self requestOrder:model indexPath:nil];
        };
        
        //进店逛逛
        _headerView.enterBlock = ^(SCWitStoreModel * _Nonnull model) {
            @strongify(self)
            [self pushToWebView:model.storeLink title:@"智慧门店"];
        };
        
        //排队记录
        _headerView.orderHistoryBlock = ^{
          @strongify(self)
            [self hideNoNeedUI];
            
        };
        
    }
    return _headerView;
}

- (SCWitStoreQueryView *)queryView
{
    if (!_queryView) {
        CGFloat x = kWitStoreHorMargin;
        _queryView = [[SCWitStoreQueryView alloc] initWithFrame:CGRectMake(x, 0, self.view.width - x*2, SCREEN_FIX(50))];
        _queryView.bottom = self.topView.bottom + self.headerView.height + kWitStoreCorner;
        
        @weakify(self)
        _queryView.showSortBlock = ^{
            @strongify(self)
            [self.searchField resignFirstResponder];
            
            if (self.sortView.hidden) {
                [self.sortView show:self.viewModel.requestModel.sortType];
                
            }else {
                self.sortView.hidden = YES;
            }
            
        };
        
        _queryView.queryBlock = ^(SCWitQueryType queryType) {
            @strongify(self)
            [self hideNoNeedUI];
            self.viewModel.requestModel.queryType = queryType;
            [self requestStoreList:1 showHud:YES];
        };
        
        [self.view addSubview:_queryView];
    }
    return _queryView;
}

- (SCWitStoreSortView *)sortView
{
    if (!_sortView) {
        CGFloat w = self.queryView.width/4;
        CGFloat x = SCREEN_WIDTH - kWitStoreHorMargin - w;
        
        _sortView = [[SCWitStoreSortView alloc] initWithFrame:CGRectMake(x, self.queryView.bottom, w, SCREEN_FIX(60))];
        _sortView.hidden = YES;
        [self.view addSubview:_sortView];
        
        @weakify(self)
        _sortView.sortBlock = ^(SCWitSortType sortType) {
            @strongify(self)
            [self hideNoNeedUI];
            self.viewModel.requestModel.sortType = sortType;

            [self requestStoreList:1 showHud:YES];
        };
    }
    return _sortView;
}

- (SCWitStoreViewModel *)viewModel
{
    if (!_viewModel) {
        _viewModel = [SCWitStoreViewModel new];
    }
    return _viewModel;
}

@end


@implementation SCAreaButton
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.titleLabel.font = SCFONT_SIZED(14);
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self setImage:SCIMAGE(@"sc_down_arrow") forState:UIControlStateNormal];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.adjustsImageWhenHighlighted = NO;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.imageView.right = self.width;
    self.titleLabel.frame = CGRectMake(0, 0, self.imageView.left, self.height);
}


@end

