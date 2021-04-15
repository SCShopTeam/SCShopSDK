//
//  SCHomeViewController.m
//  shopping
//
//  Created by gejunyu on 2021/3/2.
//  Copyright © 2021 jsmcc. All rights reserved.
//

#import "SCHomeViewController.h"
#import "SCHomeViewModel.h"
#import "SCHomePopupView.h"
#import "SCHomeNavBar.h"
#import "SCHomeTopCell.h"
#import "SCHomeBannerCell.h"
#import "SCHomeGridCell.h"
#import "SCHomeStoreCell.h"
#import "SCHomeGoodStoresCell.h"
#import "SCHomeAdCell.h"
#import "SCShoppingManager.h"
#import "SCHomeItemsView.h"
#import "SCSearchViewController.h"
#import "SCHomeMoreView.h"
#import "SCCartViewController.h"
#import "SCMyOrderViewController.h"
#import "SCTagView.h"

typedef NS_ENUM(NSInteger, SCHomeRow) {
    SCHomeRowTop,         //顶部标签
    SCHomeRowBanner,      //轮播
    SCHomeRowGrid,        //宫格
    SCHomeRowStore,       //推荐门店
    SCHomeRowGoodStores,  //发现好店
    SCHomeRowAd,          //广告
    SCHomeRowTags,        //分类标签
    SCHomeRowItems        //商品
};

//导航栏高度
#define kNavBarH     (SCREEN_FIX(48) + STATUS_BAR_HEIGHT)

@interface SCHomeViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) SCTableView *tableView;
@property (nonatomic, strong) SCHomeViewModel *viewModel;
@property (nonatomic, strong) SCHomeMoreView *moreView;

@property (nonatomic, assign) BOOL canScroll; //多scrollView嵌套 相关参数
@property (nonatomic, assign) CGFloat maxOffsetY;

@property (nonatomic, strong) SCHomeItemsView *itemsView; //这个楼层不用cell,是因为需要提前加载请求
@property (nonatomic, strong) SCTagView *tagView; //这个楼层不用cell

@property (nonatomic, assign) BOOL needRefresh; //是否需要刷新
@end

@implementation SCHomeViewController

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    if (self.navigationController.viewControllers.count <= 1) { //说明是切换到其它tab页了
        self.needRefresh = YES;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //ui
    self.hideNavigationBar = YES;
    [self tableView];
    
    //scrollview联动相关设置
    self.canScroll = YES;
    [[NSNotificationCenter defaultCenter] addObserverForName:SCNOTI_HOME_TABLE_CAN_SCROLL object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        self.canScroll = YES;
    }];

    //请求数据
    [self requestData];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //每次进入页面判断用户是否变化，比如登录，或者退出登录，发生变化需要刷新当前页数据
    if (self.viewModel.userHasChanged) {
        _needRefresh = YES;
    }
    
    if (_needRefresh) {
        _needRefresh = NO;
        [self requestData];
    }
    
}


#pragma mark -request
- (void)requestData
{
    //触点
    [self.viewModel requestTouchData:self success:^(id  _Nullable responseObject) {
        [self.tableView reloadData];
        [self showPopup]; //展示弹窗
        
    } failure:^(NSString * _Nullable errorMsg) {

    }];
    
    //推荐门店
    [self.viewModel requestRecommendStoreData:^(NSString * _Nullable errorMsg) {
        [self.tableView reloadData];
    }];
    
    //发现好店
    [self.viewModel requestGoodStoreList:^(NSString * _Nullable errorMsg) {
        [self.tableView reloadData];
    }];

    //分类
//    if (!self.viewModel.categoryList) {
        [self.viewModel requestCategoryList:^(NSString * _Nullable errorMsg) {
            if (errorMsg) {
                [self showWithStatus:errorMsg];
            }
            self.itemsView.categoryList = self.viewModel.categoryList;
            self.tagView.categoryList = self.viewModel.categoryList;
            [self.tableView reloadData];
        }];
        
//    }else { //刷新商品
//        [_itemsView refresh];
//    }
}


#pragma mark -UITableViewDelegate, UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    self.maxOffsetY = kHomeTopRowH + kHomeBannerRowH + self.viewModel.gridRowHeight + self.viewModel.storeRowHeight + self.viewModel.goodStoresRowHeight + kHomeAdRowH;
    
    if (self.viewModel.categoryList) {
        return SCHomeRowItems+1;
        
    }else {
        return SCHomeRowAd+1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return kNavBarH;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    SCHomeNavBar *navBar = [[SCHomeNavBar alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kNavBarH)];
    
    @weakify(self)
    navBar.searchBlock = ^{
        @strongify(self)
        [SCUtilities scXWMobStatMgrStr:@"IOS_T_NZDSC_A02" url:@"" inPage:NSStringFromClass(self.class)];
        SCSearchViewController *vc = [SCSearchViewController new];
        [self.navigationController pushViewController:vc animated:YES];
    };
    
    navBar.serviceBlock = ^{
        @strongify(self)
        [self pushToNewPage:SC_ONLINE_SERVICE_URL title:@"在线客服"];
        
    };
    
    navBar.moreBlock = ^{
        @strongify(self)
        self.moreView.hidden ^= 1;
    };
    
    
    return navBar;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    if (row == SCHomeRowTop) {
        return kHomeTopRowH;
        
    }else if (row == SCHomeRowBanner) {  //banner
        return kHomeBannerRowH;
        
    }else if (row == SCHomeRowGrid) { //grid
        return self.viewModel.gridRowHeight;
        
    }else if (row == SCHomeRowStore) { //recommend
        return self.viewModel.storeRowHeight;
        
    }else if (row == SCHomeRowGoodStores) { //goodshop
        return self.viewModel.goodStoresRowHeight;
        
    }else if (row == SCHomeRowAd) { //ad
        return kHomeAdRowH;
        
    }else if (row == SCHomeRowTags) { //tag
        return self.tagView.height;
        
    }else if (row == SCHomeRowItems) { //商品
        return self.itemsView.height;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    
    //顶部标签
    if (row == SCHomeRowTop) {
        SCHomeTopCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(SCHomeTopCell.class) forIndexPath:indexPath];
        cell.topList = self.viewModel.topList;
        
        @weakify(self)
        cell.selectBlock = ^(SCHomeTopType type, SCHomeTouchModel * _Nonnull model) {
            @strongify(self)
            if (type == SCHomeTopTypeCart) { //购物车
                [self pushToNewPage:SC_JSMCC_PATH(SCJsmccCodeTabCart) title:@""];
                
            }else if (type == SCHomeTopTypeOrder) { //我的订单
                [self pushToNewPage:SC_JSMCC_PATH(SCJsmccCodeOrder) title:@""];
                
            }else {
                if (VALID_STRING(model.linkUrl)) {
                    [self pushToNewPage:model.linkUrl title:model.contentName];
                    
                }else {
                    [self showWithStatus:@"敬请期待"];
                    
                }
            }
        };
        
        return cell;
    }
    
    //轮播图
    if (row == SCHomeRowBanner) {
        SCHomeBannerCell *bannerCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(SCHomeBannerCell.class) forIndexPath:indexPath];
        bannerCell.bannerList = self.viewModel.bannerList;
        
        bannerCell.showblock = ^(NSInteger index, SCHomeTouchModel * _Nonnull model) {
            [SCUtilities touchShow:model];
        };
        
        @weakify(self)
        bannerCell.selectBlock = ^(NSInteger index, SCHomeTouchModel * _Nonnull model) {
            @strongify(self)
            [self pushToNewPage:model.linkUrl title:model.contentName];
            [SCUtilities scXWMobStatMgrStr:NSStringFormat(@"IOS_T_NZDSC_A0%li",index+3) url:model.linkUrl inPage:NSStringFromClass(self.class)];
            [SCUtilities touchClick:model];
        };
        
        return bannerCell;
    }
    
    //宫格
    if (row == SCHomeRowGrid) {
        SCHomeGridCell *gridCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(SCHomeGridCell.class) forIndexPath:indexPath];
        
        gridCell.gridList = self.viewModel.gridList;
        
        @weakify(self)
        gridCell.selectBlock = ^(NSInteger index) {
            @strongify(self)
            [self gridSelect:index];
        };
        
        gridCell.touchShowBlock = ^(SCHomeTouchModel * _Nonnull model) {
            [SCUtilities touchShow:model];
        };
        
        return gridCell;
    }
    
    //推荐门店
    if (row == SCHomeRowStore) {
        SCHomeStoreCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(SCHomeStoreCell.class) forIndexPath:indexPath];
        cell.model = self.viewModel.storeModel;
        
        @weakify(self)
        //电话
        cell.callBlock = ^(NSString * _Nonnull contactPhone) {
            @strongify(self)
            [SCUtilities scXWMobStatMgrStr:@"IOS_T_NZDSC_F02" url:contactPhone inPage:NSStringFromClass(self.class)];
            [SCUtilities call:contactPhone];
        };
        
        //客服
        cell.serviceBlock = ^(NSString * _Nonnull serviceUrl) {
            @strongify(self)
            [SCUtilities scXWMobStatMgrStr:@"IOS_T_NZDSC_F01" url:serviceUrl inPage:NSStringFromClass(self.class)];
            [self pushToNewPage:serviceUrl title:@""];
        };
        
        //门店首页
        cell.storePageBlock = ^(NSString * _Nonnull storeLink) {
            @strongify(self)
            [SCUtilities scXWMobStatMgrStr:@"IOS_T_NZDSC_F06" url:storeLink inPage:NSStringFromClass(self.class)];
            [self pushToNewPage:storeLink title:@""];
        };
        
        //本店优惠商品
        cell.storeGoodsBlock = ^(NSString * _Nonnull goodsDetailUrl, NSInteger index) {
            @strongify(self)
            [SCUtilities scXWMobStatMgrStr:NSStringFormat(@"IOS_T_NZDSC_F0%li",index+7)   url:goodsDetailUrl inPage:NSStringFromClass(self.class)];
            [self pushToNewPage:goodsDetailUrl title:@""];
        };
        
        //活动商品
        cell.activityGoodsBlock = ^(NSString * _Nonnull link, NSInteger index) {
            @strongify(self)
            [SCUtilities scXWMobStatMgrStr:NSStringFormat(@"IOS_T_NZDSC_F0%li",index+3) url:link inPage:NSStringFromClass(self.class)];
            [self pushToNewPage:link title:@""];
        };
        
        //活动链接
        cell.activityLinkBlock = ^(NSString * _Nonnull link) {
            @strongify(self)
            [SCUtilities scXWMobStatMgrStr:@"IOS_T_NZDSC_F05" url:link inPage:NSStringFromClass(self.class)];
            [self pushToNewPage:link title:@""];
        };
        
        return cell;
    }
    
    //发现好店
    if (row == SCHomeRowGoodStores) {
        SCHomeGoodStoresCell *goodCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(SCHomeGoodStoresCell.class) forIndexPath:indexPath];
        
        goodCell.goodStoreList = self.viewModel.goodStoreList;
        @weakify(self)
        goodCell.moreBlock = ^{
            @strongify(self)
            [self pushToNewPage:SC_JSMCC_PATH(SCJsmccCodeWitStore) title:@""];
            [SCUtilities scXWMobStatMgrStr:@"IOS_T_NZDSC_C09" url:@"" inPage:NSStringFromClass(self.class)];
        };
        
        goodCell.enterShopBlock = ^(NSInteger row, SCGShopInfoModel * _Nonnull shopModel) {
            @strongify(self)
            [self pushToNewPage:shopModel.link title:@""];
            [SCUtilities scXWMobStatMgrStr:NSStringFormat(@"IOS_T_NZDSC_C%li",row*4+10) url:shopModel.link inPage:NSStringFromClass(self.class)];
        };
        
        goodCell.imgBlock = ^(NSInteger row, NSInteger index, SCGActImageModel * _Nonnull imgModel) {
            @strongify(self)
            [self pushToNewPage:imgModel.actImageLink title:@""];
            [SCUtilities scXWMobStatMgrStr:NSStringFormat(@"IOS_T_NZDSC_C%li",row*4+11+index) url:imgModel.actImageLink inPage:NSStringFromClass(self.class)];
        };
        
        return goodCell;
    }
    
    //广告
    if (row == SCHomeRowAd) {
        SCHomeAdCell *adCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(SCHomeAdCell.class) forIndexPath:indexPath];
        
        adCell.adList = self.viewModel.adList;
        
        @weakify(self)
        adCell.selectBlock = ^(NSInteger index, SCHomeTouchModel * _Nonnull touchModel) {
            @strongify(self)
            [self pushToNewPage:touchModel.linkUrl title:touchModel.contentName];
            [SCUtilities scXWMobStatMgrStr:NSStringFormat(@"IOS_T_NZDSC_D0%li",index+1) url:touchModel.linkUrl inPage:NSStringFromClass(self.class)];
            [SCUtilities touchClick:touchModel];
        };
        
        adCell.touchShowBlock = ^(SCHomeTouchModel * _Nonnull model) {
            [SCUtilities touchShow:model];
        };
        
        return adCell;
    }
    
    //标签
    if (row == SCHomeRowTags) {
        UITableViewCell *tagCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(SCTagView.class) forIndexPath:indexPath];
        [tagCell.contentView addSubview:self.tagView];
        
        @weakify(self)
        self.tagView.selectBlock = ^(NSInteger index) {
          @strongify(self)
            self.itemsView.currentIndex = index;
            NSInteger code = index+1;
            [SCUtilities scXWMobStatMgrStr:[NSString stringWithFormat:@"IOS_T_NZDSC_E%@%li",(code<10?@"0":@""),code] url:@"" inPage:NSStringFromClass(self.class)];

        };
        
        return tagCell;
    }
    
    //商品
    if (row == SCHomeRowItems) {
        UITableViewCell *itemsCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(SCHomeItemsView.class) forIndexPath:indexPath];
        [itemsCell.contentView addSubview:self.itemsView];
        
        @weakify(self)
        self.itemsView.scrollBlock = ^(NSInteger index) {
            @strongify(self)
            [self.tagView pushToIndex:index needCallBack:NO];
            NSInteger code = index+1;
            [SCUtilities scXWMobStatMgrStr:[NSString stringWithFormat:@"IOS_T_NZDSC_E%@%li",(code<10?@"0":@""),code] url:@"" inPage:NSStringFromClass(self.class)];
            
        };
        
        self.itemsView.selectBlock = ^(SCCommodityModel * _Nonnull model) {
            @strongify(self)
            [self pushToNewPage:model.detailUrl title:@""];
        };
        
        return itemsCell;
    }
    
    return [UITableViewCell new];
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView != _tableView) {
        return;
    }
    
    self.moreView.hidden = YES;
    
    //处理多scrollView联动
    CGFloat y = scrollView.contentOffset.y;
    
    
    if (y >= _maxOffsetY && _canScroll) {
        scrollView.contentOffset = CGPointMake(0, _maxOffsetY);
        _canScroll = NO;
        [[NSNotificationCenter defaultCenter] postNotificationName:SCNOTI_HOME_CELL_CAN_SCROLL object:nil];
    }
    
    if (!_canScroll) {
        [[NSNotificationCenter defaultCenter] postNotificationName:SCNOTI_HOME_CELL_CAN_SCROLL object:nil];
        scrollView.contentOffset = CGPointMake(0, _maxOffsetY);
    }
}

#pragma mark -Action
- (void)gridSelect:(NSInteger)index
{
    if (index >= self.viewModel.gridList.count) {
        return;
    }
    
    SCHomeTouchModel *model = self.viewModel.gridList[index];
    
    [SCUtilities scXWMobStatMgrStr:NSStringFormat(@"IOS_T_NZDSC_B0%li",model.codeIndex+1) url:model.linkUrl inPage:NSStringFromClass(self.class)];
    
    SCShoppingManager *manager = [SCShoppingManager sharedInstance];
    
    //判断是否登录
    if (model.isLogin.integerValue > 0 && ![SCUserInfo currentUser].isLogin) {
        if ([manager.delegate respondsToSelector:@selector(scLoginWithNav:back:)]) {
            [manager.delegate scLoginWithNav:self.navigationController back:^{
                //                [self pushToNewPage:model.linkUrl title:model.contentName]; //>>标记  掌厅登录代理有bug,暂不执行该方法
                [SCUtilities postLoginSuccessNotification];
            }];
        }
        
    }else { //直接跳转
        [self pushToNewPage:model.linkUrl title:model.contentName];
    }
    
    //触点回调
    [SCUtilities touchClick:model];
    
}

#pragma mark -private
- (void)pushToNewPage:(NSString *)url title:(NSString *)title;
{
    self.moreView.hidden = YES;
    [SCURLSerialization gotoNewPage:url title:title navigation:self.navigationController];
}

- (void)showPopup
{
    for (SCHomeTouchModel *model in self.viewModel.popupList) {
        [SCUtilities touchShow:model];
        
        @weakify(self)
        [SCHomePopupView showIn:self model:model clickBlock:^(SCHomeTouchModel * _Nonnull model) {
         @strongify(self)
            [self pushToNewPage:model.linkUrl title:model.contentName];
            [SCUtilities touchClick:model];
        }];
    }

}

#pragma mark -ui
- (SCTableView *)tableView
{
    if (!_tableView) {
        CGFloat h = SCREEN_HEIGHT - (self.isMainTabVC ? TAB_BAR_HEIGHT : 0);
        _tableView = [[SCTableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, h)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.bounces = NO;
        _tableView.shouldRecognizeSimultaneouslyWithOtherGestureRecognizer = YES;
        [self.view addSubview:_tableView];
        
        [_tableView registerClass:SCHomeTopCell.class        forCellReuseIdentifier:NSStringFromClass(SCHomeTopCell.class)];
        [_tableView registerClass:SCHomeBannerCell.class     forCellReuseIdentifier:NSStringFromClass(SCHomeBannerCell.class)];
        [_tableView registerClass:SCHomeGridCell.class       forCellReuseIdentifier:NSStringFromClass(SCHomeGridCell.class)];
        [_tableView registerClass:SCHomeStoreCell.class      forCellReuseIdentifier:NSStringFromClass(SCHomeStoreCell.class)];
        [_tableView registerClass:SCHomeGoodStoresCell.class forCellReuseIdentifier:NSStringFromClass(SCHomeGoodStoresCell.class)];
        [_tableView registerClass:SCHomeAdCell.class         forCellReuseIdentifier:NSStringFromClass(SCHomeAdCell.class)];
        [_tableView registerClass:UITableViewCell.class      forCellReuseIdentifier:NSStringFromClass(SCTagView.class)];
        [_tableView registerClass:UITableViewCell.class      forCellReuseIdentifier:NSStringFromClass(SCHomeItemsView.class)];
        
        //如果没有导航栏，会有滚动视图向下偏移20像素的bug,如下设置可以避免
        self.extendedLayoutIncludesOpaqueBars = YES;
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            self.automaticallyAdjustsScrollViewInsets = NO;
            
        }
    }
    return _tableView;
}

- (SCHomeItemsView *)itemsView
{
    if (!_itemsView) {
        _itemsView = [[SCHomeItemsView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.width, self.tableView.height - kNavBarH - self.tagView.height)];
    }
    return _itemsView;
}

- (SCTagView *)tagView
{
    if (!_tagView) {
        _tagView = [[SCTagView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.width, SCREEN_FIX(51))];
        _tagView.contentEdgeInsets = UIEdgeInsetsMake(SCREEN_FIX(9), 0, SCREEN_FIX(7), 0);
    }
    return _tagView;
}

- (SCHomeMoreView *)moreView
{
    if (!_moreView) {
        CGFloat w = SCREEN_FIX(104.5);
        _moreView = [[SCHomeMoreView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-SCREEN_FIX(6.5)-w, SCREEN_FIX(44.5)+STATUS_BAR_HEIGHT, w, SCREEN_FIX(109.5))];
        [self.view addSubview:_moreView];
        [self.view bringSubviewToFront:_moreView];
        
        @weakify(self)
        _moreView.selectBlock = ^(SCShopMoreType type) {
            @strongify(self)
            if (type == SCShopMoreTypeMessage || type == SCShopMoreTypeSuggest) { //消息，建议
                SCShoppingManager *manager = [SCShoppingManager sharedInstance];
                if ([manager.delegate respondsToSelector:@selector(scMoreSelect:nav:)]) {
                    [manager.delegate scMoreSelect:type nav:self.navigationController];
                }
                
            }else {  //刷新
                [self.itemsView showLoading];
                [self requestData];
            }
            
        };
    }
    return _moreView;
}

- (SCHomeViewModel *)viewModel
{
    if (!_viewModel) {
        _viewModel = [SCHomeViewModel new];
    }
    return _viewModel;
}

@end
