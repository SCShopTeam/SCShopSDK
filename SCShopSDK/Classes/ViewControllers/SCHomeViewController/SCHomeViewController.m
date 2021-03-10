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
#import "SCHomeRecommendStoreCell.h"
#import "SCHomeGoodStoreCell.h"
#import "SCHomeAdCell.h"
#import "SCHomeTagCell.h"
#import "SCShoppingManager.h"
#import "SCWitStoreViewController.h"
#import "SCHomeItemsView.h"
#import "SCSearchViewController.h"
#import "SCHomeMoreView.h"
#import "SCCartViewController.h"
#import "SCMyOrderViewController.h"

typedef NS_ENUM(NSInteger, SCHomeRow) {
    SCHomeRowTop,         //顶部标签
    SCHomeRowBanner,      //轮播
    SCHomeRowGrid,        //宫格
    SCHomeRowRecommend,   //推荐门店
    SCHomeRowGood,        //发现好店
    SCHomeRowAd,          //广告
    SCHomeRowTags,        //分类标签
    SCHomeRowItems        //商品
};

//楼层数量
#define kRowNum      (SCHomeRowItems + 1)
//部分楼层高度
#define kNavBarH     (SCREEN_FIX(48) + STATUS_BAR_HEIGHT)
#define kGridH       (self.viewModel.gridList ? kHomeGridRowH : 0)
#define kRecommendH  [SCHomeRecommendStoreCell getRowHeight]
#define kGoodH       [SCHomeGoodStoreCell getRowHeight:self.viewModel.goodStoreList.count]


@interface SCHomeViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) SCTableView *tableView;
@property (nonatomic, strong) SCHomeViewModel *viewModel;
@property (nonatomic, strong) SCHomeMoreView *moreView;

@property (nonatomic, assign) BOOL canScroll; //多scrollView嵌套 相关参数
@property (nonatomic, assign) CGFloat maxOffsetY;

@property (nonatomic, strong) SCHomeItemsView *itemsView; //这个楼层不用cell,是因为需要提前加载请求
@property (nonatomic, weak) SCTagView *tagView;
@end

@implementation SCHomeViewController

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];

}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    //隐藏原生导航栏
    self.hideNavigationBar = YES;
    
    //scrollview联动相关设置
    self.canScroll = YES;
    [[NSNotificationCenter defaultCenter] addObserverForName:SCNOTI_HOME_TABLE_CAN_SCROLL object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        self.canScroll = YES;
    }];
    
    //主控件
    [self tableView];
    
    //请求数据
    [self requestData];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //每次进入页面判断用户是否变化，比如登录，或者退出登录，发生变化需要刷新当前页数据
    if (self.viewModel.userHasChanged) {
        [self refreshCurrentPage];
    }
}


#pragma mark -request
- (void)requestData
{
    //请求触点
    [self requestTouchData];
    
    //请求店铺
    [self requestStoreData];
    
    //请求分类
    [self requestCategoryData];
}

- (void)requestTouchData
{
    
    [self.viewModel requestTouchData:self success:^(id  _Nullable responseObject) {
        [self.tableView reloadData];
        [self showPopup]; //展示弹窗
        
    } failure:^(NSString * _Nullable errorMsg) {
        
    }];
}

- (void)requestStoreData
{
    
    [self.viewModel requestStoreList:^(id  _Nullable responseObject) {
        [self.tableView reloadData];
        
    } failure:^(NSString * _Nullable errorMsg) {
        
    }];
}

- (void)requestCategoryData
{
    [self.viewModel requestCategoryList:^(NSString * _Nullable errorMsg) {
        if (errorMsg) {
            [self showWithStatus:errorMsg];
        }
        self.itemsView.categoryList = self.viewModel.categoryList;
        [self.tableView reloadData];
    }];
}

- (void)refreshCurrentPage  //刷新当前页数据
{
    [self requestStoreData];
    [self.itemsView refresh];
}

#pragma mark -UITableViewDelegate, UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    self.maxOffsetY = kHomeTopRowH + kHomeBannerRowH + kGridH + kRecommendH + kGoodH + kHomeAdRowH;
    
    return kRowNum;
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
        return kGridH;
        
    }else if (row == SCHomeRowRecommend) { //recommend
        return kRecommendH;
        
    }else if (row == SCHomeRowGood) { //goodshop
        return kGoodH;
        
    }else if (row == SCHomeRowAd) { //ad
        return kHomeAdRowH;
        
    }else if (row == SCHomeRowTags) { //tag
        return kHomeTagRowH;
        
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
                if (model) {
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
        
        @weakify(self)
        bannerCell.showblock = ^(NSInteger index, SCHomeTouchModel * _Nonnull model) {
            @strongify(self)
            [self.viewModel touchShow:model];
        };
        
        bannerCell.selectBlock = ^(NSInteger index, SCHomeTouchModel * _Nonnull model) {
            @strongify(self)
            [self pushToNewPage:model.linkUrl title:model.contentName];
            [SCUtilities scXWMobStatMgrStr:NSStringFormat(@"IOS_T_NZDSC_A0%li",index+3) url:model.linkUrl inPage:NSStringFromClass(self.class)];
            [self.viewModel touchClick:model];
        };
        
        return bannerCell;
    }
    
    //宫格
    if (row == SCHomeRowGrid) {
        SCHomeGridCell *gridCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(SCHomeGridCell.class) forIndexPath:indexPath];
        
        gridCell.gridList = self.viewModel.gridList;

        @weakify(self)
        gridCell.touchShowBlock = ^(SCHomeTouchModel * _Nonnull model) {
            @strongify(self)
            [self.viewModel touchShow:model];
        };
        
        gridCell.selectBlock = ^(NSInteger index) {
            @strongify(self)
            [self gridSelect:index];
        };
        
        return gridCell;
    }
    
    if (row == SCHomeRowRecommend) {
        SCHomeRecommendStoreCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(SCHomeRecommendStoreCell.class) forIndexPath:indexPath];
        [cell setData]; //假数据
        
        @weakify(self)
        cell.serviceBlock = ^{
            @strongify(self)
            [self pushToNewPage:@"" title:@""];
        };
        
        cell.telBlock = ^{
            [SCUtilities call:@""];
        };
        
        cell.enterStoreBlock = ^{
          @strongify(self)
            [self pushToNewPage:@"" title:@""];
        };
        
        return cell;
    }
    
    if (row == SCHomeRowGood) {
        SCHomeGoodStoreCell *goodCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(SCHomeGoodStoreCell.class) forIndexPath:indexPath];
        
        goodCell.goodStoreList = self.viewModel.goodStoreList;
        @weakify(self)
        goodCell.moreBlock = ^{
            @strongify(self)
            SCWitStoreViewController *vc = [SCWitStoreViewController new];
            [self.navigationController pushViewController:vc animated:YES];
            [SCUtilities scXWMobStatMgrStr:@"IOS_T_NZDSC_C09" url:@"" inPage:NSStringFromClass(self.class)];
        };
        
        goodCell.enterShopBlock = ^(NSInteger row, SCHShopInfoModel * _Nonnull shopModel) {
            @strongify(self)
            [self pushToNewPage:shopModel.link title:@""];
            [SCUtilities scXWMobStatMgrStr:NSStringFormat(@"IOS_T_NZDSC_C%li",row*4+10) url:shopModel.link inPage:NSStringFromClass(self.class)];
        };
        
        goodCell.imgBlock = ^(NSInteger row, NSInteger index, SCHActImageModel * _Nonnull imgModel) {
            @strongify(self)
            [self pushToNewPage:imgModel.actImageLink title:@""];
            [SCUtilities scXWMobStatMgrStr:NSStringFormat(@"IOS_T_NZDSC_C%li",row*4+11+index) url:imgModel.actImageLink inPage:NSStringFromClass(self.class)];
        };
        
        return goodCell;
    }
    
    if (row == SCHomeRowAd) {
        SCHomeAdCell *adCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(SCHomeAdCell.class) forIndexPath:indexPath];
        
        adCell.adList = self.viewModel.adList;

        @weakify(self)
        adCell.touchShowBlock = ^(SCHomeTouchModel * _Nonnull model) {
          @strongify(self)
            [self.viewModel touchShow:model];
        };
        
        adCell.selectBlock = ^(NSInteger index, SCHomeTouchModel * _Nonnull touchModel) {
            @strongify(self)
            [self pushToNewPage:touchModel.linkUrl title:touchModel.contentName];
            [SCUtilities scXWMobStatMgrStr:NSStringFormat(@"IOS_T_NZDSC_D0%li",index+1) url:touchModel.linkUrl inPage:NSStringFromClass(self.class)];
            [self.viewModel touchClick:touchModel];
        };
        
        return adCell;
    }
    
    if (row == SCHomeRowTags) {
        SCHomeTagCell *tagCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(SCHomeTagCell.class) forIndexPath:indexPath];
        _tagView = tagCell.tagView;
        [tagCell setCategoryList:self.viewModel.categoryList];
        
        @weakify(self)
        tagCell.selectBlock = ^(NSInteger index) {
            @strongify(self)
            self.itemsView.currentIndex = index;

        };
        
        return tagCell;
    }
    
    if (row == SCHomeRowItems) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(UITableViewCell.class) forIndexPath:indexPath];
        [cell.contentView addSubview:self.itemsView];
        
        @weakify(self)
        self.itemsView.scrollBlock = ^(NSInteger index) {
            @strongify(self)
            [self.tagView pushToIndex:index needCallBack:NO];
            

        };
        
        self.itemsView.selectBlock = ^(SCCommodityModel * _Nonnull model) {
            @strongify(self)
            [self pushToNewPage:model.detailUrl title:@""];
        };
        
        return cell;
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
    SCHomeTouchModel *model = self.viewModel.gridList[index];
    
    [SCUtilities scXWMobStatMgrStr:NSStringFormat(@"IOS_T_NZDSC_B0%li",index+1) url:model.linkUrl inPage:NSStringFromClass(self.class)];
    
    SCShoppingManager *manager = [SCShoppingManager sharedInstance];
    
    //判断是否登录
    if (model.isLogin.integerValue > 0 && ![SCUserInfo currentUser].isLogin) {
        if ([manager.delegate respondsToSelector:@selector(scLoginWithNav:back:)]) {
            [manager.delegate scLoginWithNav:self.navigationController back:^(UIViewController * _Nonnull controller) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self pushToNewPage:model.linkUrl title:model.contentName];
                    [SCUtilities postLoginSuccessNotification];
                });
                
            }];
        }
        
    }else { //直接跳转
        [self pushToNewPage:model.linkUrl title:model.contentName];
    }
    
    //触点回调
    [self.viewModel touchClick:model];
    
}

#pragma mark -private
- (void)pushToNewPage:(NSString *)url title:(NSString *)title;
{
    self.moreView.hidden = YES;
    [SCURLSerialization gotoNewPage:url title:title navigation:self.navigationController];
}

- (void)showPopup
{
    //侧边弹窗
    SCHomeTouchModel *sideModel = self.viewModel.popupDict[@(SCPopupTypeSide)];
    if (sideModel) {
        [self.viewModel touchShow:sideModel];
        CGFloat w = SCREEN_FIX(62.5);
        SCHomePopupView *sidePopupView = [[SCHomePopupView alloc] initWithFrame:CGRectMake(self.view.width-w, 0, w, SCREEN_FIX(78))];
        sidePopupView.centerY = self.tableView.centerY;
        sidePopupView.moveAfterClicked = NO;
        [self.view addSubview:sidePopupView];
        
        sidePopupView.model = sideModel;
        @weakify(self)
        sidePopupView.linkBlock = ^(SCHomeTouchModel * _Nonnull model) {
            @strongify(self)
            [self pushToNewPage:model.linkUrl title:model.contentName];
            [self.viewModel touchClick:model];
        };
    }
    
    //底部弹窗
    SCHomeTouchModel *bottomModel = self.viewModel.popupDict[@(SCPopupTypeBottom)];
    if (bottomModel) {
        [self.viewModel touchShow:bottomModel];
        SCHomePopupView *bottomPopupView = [[SCHomePopupView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, SCREEN_FIX(200))];
        bottomPopupView.bottom = self.tableView.bottom;
        [self.view addSubview:bottomPopupView];
        
        bottomPopupView.model = bottomModel;
        @weakify(self)
        bottomPopupView.linkBlock = ^(SCHomeTouchModel * _Nonnull model) {
            @strongify(self)
            [self pushToNewPage:model.linkUrl title:model.contentName];
            [self.viewModel touchClick:model];
        };
    }
    
    
    //中心弹窗
    SCHomeTouchModel *centerModel = self.viewModel.popupDict[@(SCPopupTypeCenter)];
    if (centerModel) {
        [self.viewModel touchShow:centerModel];
        SCHomePopupView *centerPopupView = [[SCHomePopupView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_FIX(285), SCREEN_FIX(400))];
        centerPopupView.center = self.tableView.center;
        [self.view addSubview:centerPopupView];
        
        centerPopupView.model = centerModel;
        @weakify(self)
        centerPopupView.linkBlock = ^(SCHomeTouchModel * _Nonnull model) {
            @strongify(self)
            [self pushToNewPage:model.linkUrl title:model.contentName];
            [self.viewModel touchClick:model];
        };
        
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
        
        [_tableView registerClass:SCHomeTopCell.class            forCellReuseIdentifier:NSStringFromClass(SCHomeTopCell.class)];
        [_tableView registerClass:SCHomeBannerCell.class         forCellReuseIdentifier:NSStringFromClass(SCHomeBannerCell.class)];
        [_tableView registerClass:SCHomeGridCell.class           forCellReuseIdentifier:NSStringFromClass(SCHomeGridCell.class)];
        [_tableView registerClass:SCHomeRecommendStoreCell.class forCellReuseIdentifier:NSStringFromClass(SCHomeRecommendStoreCell.class)];
        [_tableView registerClass:SCHomeGoodStoreCell.class      forCellReuseIdentifier:NSStringFromClass(SCHomeGoodStoreCell.class)];
        [_tableView registerClass:SCHomeAdCell.class             forCellReuseIdentifier:NSStringFromClass(SCHomeAdCell.class)];
        [_tableView registerClass:SCHomeTagCell.class            forCellReuseIdentifier:NSStringFromClass(SCHomeTagCell.class)];
        [_tableView registerClass:UITableViewCell.class          forCellReuseIdentifier:NSStringFromClass(UITableViewCell.class)];
        
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
        _itemsView = [[SCHomeItemsView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.width, self.tableView.height - kNavBarH - kHomeTagRowH)];
    }
    return _itemsView;
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
            if (type > 1) { //刷新
                [self refreshCurrentPage];
                
            }else { //消息，意见
                SCShoppingManager *manager = [SCShoppingManager sharedInstance];
                if ([manager.delegate respondsToSelector:@selector(scMoreSelect:nav:)]) {
                    [manager.delegate scMoreSelect:type nav:self.navigationController];
                }
                
            }
            
        };
    }
    return _moreView;
}

-(SCHomeViewModel *)viewModel
{
    if (!_viewModel) {
        _viewModel = [SCHomeViewModel new];
    }
    return _viewModel;
}



@end
