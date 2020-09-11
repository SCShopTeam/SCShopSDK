//
//  SCSearchViewController.m
//  shopping
//
//  Created by gejunyu on 2020/7/10.
//  Copyright © 2020 jsmcc. All rights reserved.
//

#import "SCSearchViewController.h"
#import "SCSearchHistoryView.h"
#import "SCShopTableCell.h"
#import "SCSearchViewModel.h"

@interface SCSearchViewController () <UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UIView *searchView;
@property (nonatomic, strong) UITextField *searchField;
@property (nonatomic, strong) UIButton *searchButton;
@property (nonatomic, strong) SCSearchHistoryView *historyView;
@property (nonatomic, strong) SCTableView *tableView;
@property (nonatomic, strong) SCSearchViewModel *viewModel;
@property (nonatomic, strong) UIView *emptyDataView;

@end

@implementation SCSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self prepareUI];
}

- (void)prepareUI
{
    self.title = @"搜索";
    [self historyView];
}


#pragma mark -private
- (void)requestSearchText:(NSString *)text
{
    [self.searchField resignFirstResponder];
    
    if (!VALID_STRING(text)) {
        self.emptyDataView.hidden = YES;
        self.historyView.hidden = NO;
        [self showWithStatus:@"请输入搜索内容"];
        return;
    }
    
    [self showLoading];
    
    [self.viewModel requestSearch:text success:^(id  _Nullable responseObject) {
        [self stopLoading];
        [SCCacheManager cacheObject:text forKey:@"scLastSearchContent"];
        [self.historyView addSearchRecord:text];
        self.historyView.hidden = YES;
        [self.tableView reloadData];
        self.emptyDataView.hidden = VALID_ARRAY(self.viewModel.itemList);
        
    } failure:^(NSString * _Nullable errorMsg) {
        [self stopLoading];
        [self showWithStatus:errorMsg];
    }];
    
}

#pragma mark -UITableViewDelegate, UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.viewModel.itemList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kCommonShopRowH;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SCShopTableCell *cell = (SCShopTableCell *)[tableView dequeueReusableCellWithIdentifier:NSStringFromClass(SCShopTableCell.class) forIndexPath:indexPath];
    
    SCSearchItemModel *item = self.viewModel.itemList[indexPath.row];
    cell.searchModel = item;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SCSearchItemModel *item = self.viewModel.itemList[indexPath.row];
    [[SCURLSerialization shareSerialization] gotoWebcustom:item.url title:/*item.title*/@"" navigation:self.navigationController];
}


#pragma mark -UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self requestSearchText:textField.text];
    return YES;
}

#pragma mark -ui
- (UIView *)searchView
{
    if (!_searchView) {
        _searchView = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_FIX(17), SCREEN_FIX(13), SCREEN_FIX(283), SCREEN_FIX(27))];
        _searchView.backgroundColor = HEX_RGB(@"#F2F2F2");
        _searchView.layer.cornerRadius = _searchView.height/2;
        [self.view addSubview:_searchView];
        
        //图片
        CGFloat iconH = SCREEN_FIX(13.5);
        UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_FIX(9), (_searchView.height-iconH)/2, SCREEN_FIX(15.5), iconH)];
        icon.image = SCIMAGE(@"search_icon");
        [_searchView addSubview:icon];
        
        //输入框
        CGFloat fieldX = icon.right + SCREEN_FIX(5);
        CGFloat fieldW = _searchView.width - fieldX - SCREEN_FIX(9);
        _searchField = [[UITextField alloc] initWithFrame:CGRectMake(fieldX, 0, fieldW, _searchView.height)];
        _searchField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _searchField.delegate        = self;
        _searchField.font            = SCFONT_SIZED(12);
        _searchField.returnKeyType   = UIReturnKeySearch;
        [_searchView addSubview:_searchField];
        
        NSString *historyText = [SCCacheManager getCachedObjectWithKey:@"scLastSearchContent"];
        _searchField.placeholder = [SCUtilities isValidString:historyText]?historyText:@"";
    }
    return _searchView;
}

- (UIButton *)searchButton
{
    if (!_searchButton) {
        _searchButton = [[UIButton alloc] initWithFrame:CGRectMake(self.searchView.right + SCREEN_FIX(9), self.searchView.top, SCREEN_FIX(53.5), self.searchView.height)];
        _searchButton.backgroundColor = HEX_RGB(@"#F23C0B");
        [_searchButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_searchButton setTitle:@"搜索" forState:UIControlStateNormal];
        _searchButton.titleLabel.font = SCFONT_SIZED(12);
        _searchButton.layer.cornerRadius = _searchButton.height/2;
        _searchButton.layer.masksToBounds = YES;
        
        @weakify(self)
        [_searchButton sc_addEventTouchUpInsideHandle:^(UIButton * _Nonnull sender) {
            @strongify(self)
            NSString *text = [SCUtilities isValidString:self.searchField.text]?self.searchField.text:self.searchField.placeholder;
            
            [self requestSearchText:text];
        }];
        
        [self.view addSubview:_searchButton];
    }
    return _searchButton;
}

- (SCSearchHistoryView *)historyView
{
    if (!_historyView) {
        CGFloat y = self.searchButton.bottom + SCREEN_FIX(14);
        _historyView = [[SCSearchHistoryView alloc] initWithFrame:CGRectMake(0, y, SCREEN_WIDTH, SCREEN_HEIGHT-NAV_BAR_HEIGHT-y)];
        [self.view addSubview:_historyView];
        
        @weakify(self)
        _historyView.selectBlock = ^(NSString * _Nonnull record) {
            @strongify(self)
            self.searchField.text = record;
            [self requestSearchText:record];
        };
    }
    return _historyView;
}

- (SCTableView *)tableView
{
    if (!_tableView) {
        _tableView = [[SCTableView alloc] initWithFrame:self.historyView.frame];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:SCShopTableCell.class forCellReuseIdentifier:NSStringFromClass(SCShopTableCell.class)];

        [self.view addSubview:_tableView];
        [self.view sendSubviewToBack:_tableView];
    }
    return _tableView;
}

- (UIView *)emptyDataView
{
    if (!_emptyDataView) {
        _emptyDataView = [[UIView alloc] initWithFrame:self.historyView.frame];
        _emptyDataView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_emptyDataView];
        //图片
        CGFloat wh = SCREEN_FIX(108.5);
        UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake((_emptyDataView.width-wh)/2, SCREEN_FIX(43.5), wh, wh)];
        icon.image = SCIMAGE(@"sc_search_null");
        [_emptyDataView addSubview:icon];
        
        //文字
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, icon.bottom + SCREEN_FIX(19.5), _emptyDataView.width, 14)];
        label.font = SCFONT_SIZED(14);
        label.textColor = HEX_RGB(@"#474747");
        label.textAlignment = NSTextAlignmentCenter;
        label.text = @"抱歉，没有查询到您需要的商品";
        [_emptyDataView addSubview:label];
        
        
    }
    return _emptyDataView;
}

- (SCSearchViewModel *)viewModel
{
    if (!_viewModel) {
        _viewModel = [SCSearchViewModel new];
    }
    return _viewModel;
}

@end
