//
//  SCHomeViewController.m
//  shopping
//
//  Created by gejunyu on 2020/7/3.
//  Copyright © 2020 jsmcc. All rights reserved.
//

#import "SCHomeViewController.h"
#import "SCCartViewController.h"
#import "SCShopCollectionCell.h"
#import "SCHomeBannerView.h"
#import "SCHomeGridView.h"
#import "SCHomeRecommendStoreView.h"
#import "SCHomeAdView.h"
#import "SCSearchViewController.h"
#import "SCHomeViewModel.h"
#import "SCGoodStoreView.h"
#import "SCShoppingManager.h"
//#import "SCGoodStoreViewController.h"
#import "SCURLSerialization.h"
#import "SCTagView.h"
#import "SCCollectionViewFlowLayout.h"
#import "SCHomeEmptyView.h"
#import "SCWitStoreViewController.h"
//#import "SCStoreHomeViewController.h"
#import "SCHomePopupView.h"

typedef NS_ENUM(NSInteger, SCHomeSection) {
    SCHomeSectionBanner,      //轮播
    SCHomeSectionGrid,        //宫格
    SCHomeSectionRecommend,   //推荐门店
    SCHomeSectionGood,        //发现好店
    SCHomeSectionAd,          //广告
    SCHomeSectionTagItems,    //标签和商品
    SCHomeSectionEmptyData    //无数据提示
};

#define kSectionNum (SCHomeSectionEmptyData + 1)

#define kBannerH     SCREEN_FIX(219.5) + STATUS_BAR_HEIGHT
#define kGridH       (self.viewModel.touchList ? SCREEN_FIX(201) : 0)
#define kRecommnedH  (self.viewModel.recommendStoreModel ? SCREEN_FIX(373) : 0)
#define kAdH         SCREEN_FIX(105)
#define kTagH        SCREEN_FIX(55)

@interface SCHomeViewController () <UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) UIView *topView; //搜索框
@property (nonatomic, strong) SCCollectionView *collectionView;
@property (nonatomic, strong) SCHomeViewModel *viewModel;

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
    
    [self prepareUI];
    
    [self requestTotalData:1];
    
    [self addNotification];
    
}

- (void)addNotification
{
    [[NSNotificationCenter defaultCenter] addObserverForName:SC_LOGINED_NOTIFICATION object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        [self.viewModel clear];
        [self requestTotalData:1];
    }];
}


- (void)prepareUI
{
    //隐藏导航栏
    self.hideNavigationBar = YES;
    
    //如果没有导航栏，会有滚动视图向下偏移20像素的bug,如下设置可以避免
    self.extendedLayoutIncludesOpaqueBars = YES;
    if (@available(iOS 11.0, *)) {
        self.collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
        
    }
    
    [self collectionView];
}


#pragma mark -request
- (void)requestTotalData:(NSInteger)page
{
    if (page == 1) {
        //请求触点
        [self requestTouchData];
        
        //请求店铺
        [self requestStoreRecommand];
    }
    
    if (self.viewModel.categoryList.count > 0) { //请求商品
        [self requestCommodityList:page showCache:NO];
        
    }else { //请求分类
        [self requestCategoryList];
    }

    
}

//请求触点
- (void)requestTouchData
{
    
    [self.viewModel requestTouchData:^(id  _Nullable responseObject) {
        //这里不一定会回调，打开一次商城，除非请求失败，否则只会请求一次触点
        [self.collectionView reloadData];
        
        [self showPopup];//展示弹窗
        
    } failure:^(NSString * _Nullable errorMsg) {
    }];
}

//请求店铺
- (void)requestStoreRecommand
{
    [self.viewModel requestStoreList:^(id  _Nullable responseObject) {
//        if (!self.viewModel.isCategoryRequesting) {
//            [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:SCHomeSectionRecommend]];
//            [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:SCHomeSectionGood]];
//        }
        [self.collectionView reloadData];
        
    } failure:^(NSString * _Nullable errorMsg) {
    }];
    
}

//请求分类
- (void)requestCategoryList
{
    [self.viewModel requestCategoryList:^(NSString * _Nullable errorMsg) {
        if (errorMsg) {
            [self stopLoading];
            [self showWithStatus:errorMsg];
            [self.collectionView reloadData];
            
        }else {
            [self requestCommodityList:1 showCache:NO];
        }
        
    }];
}

//请求商品
- (void)requestCommodityList:(NSInteger)page showCache:(BOOL)showCache
{
    [self.viewModel getCommodityList:page showCache:showCache completion:^(NSString * _Nullable errorMsg) {
//        [self stopLoading];
        SCHomeCacheModel *cacheModel = self.viewModel.currentCacheModel;
        self.collectionView.page = cacheModel.page;
//        [self.collectionView reloadDataShowFooter:cacheModel.hasMoreData];
        [self.collectionView reloadDataWithNoMoreData:!cacheModel.hasMoreData];
    }];
    
}


#pragma mark -private
- (void)showPopup
{
    //侧边弹窗
    SCHomeTouchModel *sideModel = self.viewModel.popupDict[@(SCPopupTypeSide)];
    if (sideModel) {
        [self.viewModel touchShow:sideModel];
        CGFloat w = SCREEN_FIX(62.5);
        SCHomePopupView *sidePopupView = [[SCHomePopupView alloc] initWithFrame:CGRectMake(self.view.width-w, 0, w, SCREEN_FIX(78))];
        sidePopupView.centerY = self.collectionView.centerY;
        sidePopupView.moveAfterClicked = NO;
        [self.view addSubview:sidePopupView];
        
        sidePopupView.model = sideModel;
        @weakify(self)
        sidePopupView.linkBlock = ^(SCHomeTouchModel * _Nonnull model) {
          @strongify(self)
            [self pushToWebView:model.linkUrl title:model.contentName];
            [self.viewModel touchClick:model];
        };
    }
    
    //底部弹窗
    SCHomeTouchModel *bottomModel = self.viewModel.popupDict[@(SCPopupTypeBottom)];
    if (bottomModel) {
        [self.viewModel touchShow:bottomModel];
        SCHomePopupView *bottomPopupView = [[SCHomePopupView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, SCREEN_FIX(200))];
        bottomPopupView.bottom = self.collectionView.bottom;
        [self.view addSubview:bottomPopupView];
        
        bottomPopupView.model = bottomModel;
        @weakify(self)
        bottomPopupView.linkBlock = ^(SCHomeTouchModel * _Nonnull model) {
          @strongify(self)
            [self pushToWebView:model.linkUrl title:model.contentName];
            [self.viewModel touchClick:model];
        };
    }

    
    //中心弹窗
    SCHomeTouchModel *centerModel = self.viewModel.popupDict[@(SCPopupTypeCenter)];
    if (centerModel) {
        [self.viewModel touchShow:centerModel];
        SCHomePopupView *centerPopupView = [[SCHomePopupView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_FIX(285), SCREEN_FIX(400))];
        centerPopupView.center = self.collectionView.center;
        [self.view addSubview:centerPopupView];
        
        centerPopupView.model = centerModel;
        @weakify(self)
        centerPopupView.linkBlock = ^(SCHomeTouchModel * _Nonnull model) {
            @strongify(self)
            [self pushToWebView:model.linkUrl title:model.contentName];
            [self.viewModel touchClick:model];
        };
        
    }
    
}


#pragma mark - UICollectionViewDelegate, UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return kSectionNum;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    
    CGFloat width = collectionView.width;
    CGFloat height = 0.0;
    if (section == SCHomeSectionBanner) {  //banner
        height = kBannerH;
        
    }else if (section == SCHomeSectionGrid) { //grid
        height = kGridH;
        
    }else if (section == SCHomeSectionRecommend) { //recommend
        height = kRecommnedH;
        
    }else if (section == SCHomeSectionGood) { //goodshop
        height = [SCGoodStoreView sectionHeight:self.viewModel.goodStoreList.count];
        
    }else if (section == SCHomeSectionAd) { //ad
        height = kAdH;
        
    }else if (section == SCHomeSectionTagItems) { //tag
        height = kTagH;
        
    }else {  //空数据
        SCHomeCacheModel *cacheModel = self.viewModel.currentCacheModel;
        height = (cacheModel && cacheModel.commodityList.count > 0) ? 0 : self.collectionView.height - kTagH;
    }
    
    return CGSizeMake(width, height);
}



- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    
    if (section == SCHomeSectionBanner) { //banner
        SCHomeBannerView *bannerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass(SCHomeBannerView.class) forIndexPath:indexPath];
        bannerView.bannerList = self.viewModel.bannerList;
        @weakify(self)
        bannerView.showblock = ^(NSInteger index, SCHomeTouchModel * _Nonnull model) {
            @strongify(self)
            [self.viewModel touchShow:model];
        };
        
        bannerView.selectBlock = ^(NSInteger index, SCHomeTouchModel * _Nonnull model) {
            @strongify(self)
            [self pushToWebView:model.linkUrl title:model.contentName];
            [SCUtilities scXWMobStatMgrStr:NSStringFormat(@"IOS_T_NZDSC_A0%li",index+3) url:model.linkUrl inPage:NSStringFromClass(self.class)];
            [self.viewModel touchClick:model];
        };
        return bannerView;
    }
    
    if (section == SCHomeSectionGrid) { //grid
        SCHomeGridView *gridView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass(SCHomeGridView.class) forIndexPath:indexPath];
        gridView.touchList = self.viewModel.touchList;
        if (gridView.touchList.count > 0) {
            [self.viewModel touchShow:gridView.touchList.firstObject];
        }
        @weakify(self)
        gridView.selectBlock = ^(NSInteger index) {
            @strongify(self)
            [self gridSelect:index];
        };
        
        return gridView;
    }
    
    if (section == SCHomeSectionRecommend) { //store
        SCHomeRecommendStoreView *recommendView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass(SCHomeRecommendStoreView.class) forIndexPath:indexPath];
        recommendView.model = self.viewModel.recommendStoreModel;
        @weakify(self)
        recommendView.enterShopBlock = ^(SCHShopInfoModel * _Nonnull shopInfoModel) {
            @strongify(self)
            [SCUtilities scXWMobStatMgrStr:@"IOS_T_NZDSC_C01" url:shopInfoModel.link inPage:NSStringFromClass(self.class)];
            [self pushToWebView:shopInfoModel.link title:@""]; //智慧门店
        };
        recommendView.bannerBlock = ^(NSInteger index, SCHBannerModel * _Nonnull bannerModel) {
            @strongify(self)
            [SCUtilities scXWMobStatMgrStr:NSStringFormat(@"IOS_T_NZDSC_C0%li",index+2) url:bannerModel.bannerImageLink inPage:NSStringFromClass(self.class)];
            [self pushToWebView:bannerModel.bannerImageLink title:@""];
        };
        
        recommendView.actBlock = ^(NSInteger index, SCHActImageModel * _Nonnull imgModel) {
            @strongify(self)
            [SCUtilities scXWMobStatMgrStr:NSStringFormat(@"IOS_T_NZDSC_C0%li",index+5) url:imgModel.actImageLink inPage:NSStringFromClass(self.class)];
            [self pushToWebView:imgModel.actImageLink title:@""];
        };
        
        return recommendView;
    }
    
    if (section == SCHomeSectionGood) { //goodshop
        SCGoodStoreView *goodView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass(SCGoodStoreView.class) forIndexPath:indexPath];
        goodView.goodStoreList = self.viewModel.goodStoreList;
        @weakify(self)
        goodView.moreBlock = ^{
            @strongify(self)
            [SCUtilities scXWMobStatMgrStr:@"IOS_T_NZDSC_C09" url:@"" inPage:NSStringFromClass(self.class)];
            [self pushToGoodStore];
        };
        goodView.enterShopBlock = ^(NSInteger row, SCHShopInfoModel * _Nonnull shopModel) {
            @strongify(self)
            [SCUtilities scXWMobStatMgrStr:NSStringFormat(@"IOS_T_NZDSC_C%li",row*4+10) url:shopModel.link inPage:NSStringFromClass(self.class)];
            [self pushToWebView:shopModel.link title:@""]; //智慧门店
        };
        
        goodView.imgBlock = ^(NSInteger row, NSInteger index, SCHActImageModel * _Nonnull imgModel) {
            @strongify(self)
            [SCUtilities scXWMobStatMgrStr:NSStringFormat(@"IOS_T_NZDSC_C%li",row*4+11+index) url:imgModel.actImageLink inPage:NSStringFromClass(self.class)];
            
            [self pushToWebView:imgModel.actImageLink title:@""];
        };
        
        return goodView;
    }
    
    if (section == SCHomeSectionAd) { //ad
        SCHomeAdView *adView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass(SCHomeAdView.class) forIndexPath:indexPath];
        adView.adList = self.viewModel.adList;
        if (adView.adList.count>0) {
            [self.viewModel touchShow:adView.adList.firstObject];
        }
        @weakify(self)
        adView.selectBlock = ^(NSInteger index, SCHomeTouchModel * _Nonnull touchModel) {
            @strongify(self)
            [self pushToWebView:touchModel.linkUrl title:touchModel.contentName];
            [SCUtilities scXWMobStatMgrStr:NSStringFormat(@"IOS_T_NZDSC_D0%li",index+1) url:touchModel.linkUrl inPage:NSStringFromClass(self.class)];
            [self.viewModel touchClick:touchModel];
        };
        return adView;
    }
    
    if (section == SCHomeSectionTagItems) { //商品
        //tag
        SCTagView *tagView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass(SCTagView.class) forIndexPath:indexPath];
        tagView.contentEdgeInsets = UIEdgeInsetsMake(SCREEN_FIX(10), 0, SCREEN_FIX(10), 0);
        tagView.backgroundColor = collectionView.backgroundColor;
        tagView.categoryList = self.viewModel.categoryList;
        
        @weakify(self)
        tagView.selectBlock = ^(NSInteger index) {
            @strongify(self)
            [self changeTag:index];
        };
        
        return tagView;
    }
    
    //无数据提示
    SCHomeEmptyView *emptyView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass(SCHomeEmptyView.class) forIndexPath:indexPath];
    emptyView.status = self.viewModel.currentCacheModel ? SCHomeEmptyStatusNull : SCHomeEmptyStatusLoading;
    return emptyView;
    
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section == SCHomeSectionTagItems) {
        SCHomeCacheModel *cacheModel = self.viewModel.currentCacheModel;
        return cacheModel.commodityList.count;
    }
    return 0;
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    if (section == SCHomeSectionTagItems) {
        CGFloat margin = SCREEN_FIX(18);
        return UIEdgeInsetsMake(0, margin, SCREEN_FIX(10), margin);
    }
    
    return UIEdgeInsetsZero;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section != SCHomeSectionTagItems) {
        return [UICollectionViewCell new];
    }
    
    
    SCShopCollectionCell *cell = (SCShopCollectionCell *)[collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(SCShopCollectionCell.class) forIndexPath:indexPath];
    
    SCHomeCacheModel *cacheModel = self.viewModel.currentCacheModel;
    
    if (indexPath.row < cacheModel.commodityList.count) {
        SCCommodityModel *model = cacheModel.commodityList[indexPath.row];
        cell.model = model;
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section != SCHomeSectionTagItems) {
        return;
    }
    SCHomeCacheModel *cacheModel = self.viewModel.currentCacheModel;
    
    SCCommodityModel *model = cacheModel.commodityList[indexPath.row];
    
    [self pushToWebView:model.detailUrl title:@""];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offsetY = scrollView.contentOffset.y;
    
    //坐标
    self.topView.top = MAX(-offsetY, 0);
    
    //颜色
    CGFloat alpha;
    if (offsetY <= 0) {
        alpha = 0;
    }else {
        CGFloat bannerH = kBannerH;
        alpha = offsetY/bannerH;
    }
    
    self.topView.backgroundColor = HEX_RGBA(@"#F2270C", alpha);
}

#pragma mark -Action
- (void)gridSelect:(NSInteger)index
{
    SCHomeTouchModel *model = self.viewModel.touchList[index];
    
    [SCUtilities scXWMobStatMgrStr:NSStringFormat(@"IOS_T_NZDSC_B0%li",index+1) url:model.linkUrl inPage:NSStringFromClass(self.class)];
    
    SCShoppingManager *manager = [SCShoppingManager sharedInstance];
    
    //判断是否登录
    if (model.isLogin.integerValue > 0 && ![SCUserInfo currentUser].isLogin) {
        if ([manager.delegate respondsToSelector:@selector(scLoginWithNav:back:)]) {
            [manager.delegate scLoginWithNav:self.navigationController back:^(UIViewController * _Nonnull controller) {
                [[NSNotificationCenter defaultCenter] postNotificationName:SC_LOGINED_NOTIFICATION object:nil];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self pushToWebView:model.linkUrl title:model.contentName];
                });

            }];
        }
        
    }else { //直接跳转
        [self pushToWebView:model.linkUrl title:model.contentName];
    }
    
    //触点回调
    [self.viewModel touchClick:model];
    
}

- (void)pushToWebView:(NSString *)url title:(NSString *)title
{
    if (!VALID_STRING(url)) {
        return;
    }
    
    if ([url hasPrefix:@"https://"] || [url hasPrefix:@"http://"]) {
        [[SCURLSerialization shareSerialization] gotoWebcustom:url title:title navigation:self.navigationController];
        
    }else {
        [[SCURLSerialization shareSerialization] gotoController:url navigation:self.navigationController];
    }
    
}

- (void)pushToGoodStore
{
//    SCGoodStoreViewController *vc = [SCGoodStoreViewController new];
//    vc.viewModel = self.viewModel;
//    [self.navigationController pushViewController:vc animated:YES];
    SCWitStoreViewController *vc = [SCWitStoreViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)changeTag:(NSInteger)index
{
    NSString *code = [NSString stringWithFormat:@"%li",index+1];
    [SCUtilities scXWMobStatMgrStr:NSStringFormat(@"IOS_T_NZDSC_E%@%@", (code.length == 1 ? @"0" : @""), code) url:@"" inPage:NSStringFromClass(self.class)];
    
    SCHomeCacheModel *cacheModel = [self.viewModel getCacheModel:index];
    if (!cacheModel) { //显示加载中提示
        self.viewModel.currentCacheModel = nil;
        [self.collectionView reloadData];
    }
    
    [self requestCommodityList:1 showCache:YES];
    
    //悬停高度
    CGFloat hoverY = kBannerH - self.topView.height + kGridH + kRecommnedH + [SCGoodStoreView sectionHeight:self.viewModel.goodStoreList.count] + kAdH;
    if (self.collectionView.contentOffset.y > hoverY) {
        [self.collectionView setContentOffset:CGPointMake(0, hoverY) animated:NO];
    }
    
}

#pragma mark - ui
- (UIView *)topView
{
    if (!_topView) {
        _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_FIX(50) + STATUS_BAR_HEIGHT)];
        _topView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:_topView];
        
        //返回
//        CGFloat lWh = SCREEN_FIX(22.5);
        CGFloat lWh = SCREEN_FIX(32.5);
        UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_FIX(13.5), SCREEN_FIX(13) + STATUS_BAR_HEIGHT, lWh, lWh)];
        backButton.tintColor = [UIColor whiteColor];
        [backButton setImage:[SCIMAGE(@"newnavbar_back") imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
        backButton.adjustsImageWhenHighlighted = NO;
        
        [backButton sc_addEventTouchUpInsideHandle:^(UIButton * _Nonnull sender) {
            [SCUtilities scXWMobStatMgrStr:@"IOS_T_NZDSC_A01" url:@"" inPage:NSStringFromClass(self.class)];
            [SCShoppingManager dissmissMallPage];
            
//            SCWitStoreViewController *vc = [SCWitStoreViewController new];
//            [self.navigationController pushViewController:vc animated:YES];
//            SCStoreHomeViewController *vc = [SCStoreHomeViewController new];
//            vc.tenantNum = @"supp329910042810";
//            [self.navigationController pushViewController:vc animated:YES];
        }];
        [_topView addSubview:backButton];
        
        //客服按钮
        CGFloat sWh = SCREEN_FIX(25);
        UIButton *serviceBtn = [[UIButton alloc] initWithFrame:CGRectMake(_topView.width - SCREEN_FIX(16.5) - sWh, SCREEN_FIX(17.5) + STATUS_BAR_HEIGHT, sWh, sWh)];
        [serviceBtn setImage:SCIMAGE(@"sc_service") forState:UIControlStateNormal];
        @weakify(self)
        [serviceBtn sc_addEventTouchUpInsideHandle:^(id  _Nonnull sender) {
            @strongify(self)

            [self pushToWebView:SC_ONLINE_SERVICE_URL title:@"在线客服"];
        }];
        [_topView addSubview:serviceBtn];
        
        //搜索框
        CGFloat sX = backButton.right + SCREEN_FIX(10);
        CGFloat sW = serviceBtn.left - sX - SCREEN_FIX(10);
        UIButton *searchButton = [[UIButton alloc] initWithFrame:CGRectMake(sX, 0, sW, SCREEN_FIX(32.5))];
        searchButton.centerY = backButton.centerY;
        searchButton.backgroundColor = [UIColor whiteColor];
        searchButton.layer.cornerRadius = searchButton.height/2;
        searchButton.layer.masksToBounds = YES;
        [searchButton setImage:SCIMAGE(@"Home_Search") forState:UIControlStateNormal];
        [searchButton setTitleColor:HEX_RGB(@"#D8D8D8") forState:UIControlStateNormal];
        searchButton.titleLabel.font = SCFONT_SIZED(14);
        searchButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [searchButton setTitle:@"去搜索你喜欢的商品" forState:UIControlStateNormal];
        CGSize imgSize = searchButton.currentImage.size;
        CGFloat verMargin = (searchButton.height - imgSize.height)/2;
        searchButton.imageEdgeInsets = UIEdgeInsetsMake(verMargin , SCREEN_FIX(11), verMargin, 0);
        searchButton.titleEdgeInsets = UIEdgeInsetsMake(0, SCREEN_FIX(16.5), 0, 0);
        searchButton.adjustsImageWhenHighlighted = NO;
        [_topView addSubview:searchButton];
        
        [searchButton sc_addEventTouchUpInsideHandle:^(UIButton * _Nonnull sender) {
            @strongify(self)
            [SCUtilities scXWMobStatMgrStr:@"IOS_T_NZDSC_A02" url:@"" inPage:NSStringFromClass(self.class)];
            SCSearchViewController *vc = [SCSearchViewController new];
            [self.navigationController pushViewController:vc animated:YES];
        }];
        
        
    }
    return _topView;
}

- (SCCollectionView *)collectionView
{
    if (!_collectionView) {
        
        SCCollectionViewFlowLayout *layout = [SCCollectionViewFlowLayout new];
//        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        layout.minimumLineSpacing      = SCREEN_FIX(15);
        layout.minimumInteritemSpacing = SCREEN_FIX(13.5);
        layout.itemSize                = CGSizeMake(kCommodityItemW, kCommodityItemH);
        layout.scrollDirection         = UICollectionViewScrollDirectionVertical;
        layout.naviHeight              = self.topView.height;
        
        _collectionView = [[SCCollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - TAB_BAR_HEIGHT) collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.delegate        = self;
        _collectionView.dataSource      = self;
        [self.view addSubview:_collectionView];
        [self.view insertSubview:_collectionView belowSubview:self.topView];
        
        [_collectionView registerClass:SCShopCollectionCell.class forCellWithReuseIdentifier:NSStringFromClass(SCShopCollectionCell.class)];
        [_collectionView registerClass:SCHomeBannerView.class forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass(SCHomeBannerView.class)];
        [_collectionView registerClass:SCHomeGridView.class forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass(SCHomeGridView.class)];
        [_collectionView registerClass:SCHomeRecommendStoreView.class forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass(SCHomeRecommendStoreView.class)];
        [_collectionView registerClass:SCHomeAdView.class forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass(SCHomeAdView.class)];
        [_collectionView registerClass:SCTagView.class forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass(SCTagView.class)];
        [_collectionView registerClass:SCGoodStoreView.class forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass(SCGoodStoreView.class)];
        [_collectionView registerClass:SCHomeEmptyView.class forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass(SCHomeEmptyView.class)];
        //
        [_collectionView showsRefreshHeader];
        [_collectionView showsRefreshFooter];
        @weakify(self)
        _collectionView.refreshingBlock = ^(NSInteger page) {
            @strongify(self)
            [self requestTotalData:page];
        };
    }
    return _collectionView;
    
}

- (SCHomeViewModel *)viewModel
{
    if (!_viewModel) {
        _viewModel = [SCHomeViewModel new];
    }
    return _viewModel;
}

@end
