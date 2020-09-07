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
#import "SCHomeNearShopView.h"
#import "SCHomeAdView.h"
#import "SCSearchViewController.h"
#import "SCHomeViewModel.h"
#import "SCGoodShopView.h"
#import "SCShoppingManager.h"
#import "SCGoodShopViewController.h"
#import "SCURLSerialization.h"
#import "SCTagView.h"
#import "SCCollectionViewFlowLayout.h"
#import "SCHomeEmptyView.h"

typedef NS_ENUM(NSInteger, SCHomeSection) {
    SCHomeSectionBanner,      //轮播
    SCHomeSectionGrid,        //宫格
    SCHomeSectionNear,        //附近门店
    SCHomeSectionGood,        //发现好店
    SCHomeSectionAd,          //广告
    SCHomeSectionTagItems,    //标签和商品
    SCHomeSectionEmptyData    //无数据提示
};

#define kSectionNum (SCHomeSectionEmptyData + 1)

#define kBannerH     SCREEN_FIX(214.5) + STATUS_BAR_HEIGHT
#define kGridH       SCREEN_FIX(201)
#define kNearH       (self.viewModel.nearShopModel ? SCREEN_FIX(373) : 0)
#define kAdH         (self.viewModel.adList.count ? SCREEN_FIX(120) : SCREEN_FIX(0))

@interface SCHomeViewController () <UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) UIView *topView; //搜索框
@property (nonatomic, strong) SCCollectionView *collectionView;
@property (nonatomic, strong) SCHomeViewModel *viewModel;

@end

@implementation SCHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self prepareUI];
    
    [self showLoading];
    [self requestData:1 onlyCommodity:NO];
    
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
- (void)requestData:(NSInteger)page onlyCommodity:(BOOL)onlyCommodity
{
    if (page == 1 && !onlyCommodity) {
        //请求触点
        [self requestTouchData];
        
        //请求店铺
        [self requestStoreRecommand];
    }
    
    if (onlyCommodity) {
        [self showLoading];
    }
    
    //请求商品
    [self requestCommodityList:page];
    
}

//请求触点
- (void)requestTouchData
{
    [self.viewModel requestTouchData:^(id  _Nullable responseObject) {
        //如果商品已经请求完整个页面已经刷新，就更新下section0,1,4.  商品还没有请求，则不用操作，后续商品请求结束会刷新整个页面
        if (self.viewModel.commodityRequestFinish) {
            [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:SCHomeSectionBanner]];
            [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:SCHomeSectionGrid]];
            [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:SCHomeSectionAd]];
        }
        
    } failure:^(NSString * _Nullable errorMsg) {
    }];
}

//请求店铺
- (void)requestStoreRecommand
{
    [self.viewModel requestStoreRecommend:^(id  _Nullable responseObject) {
        //如果商品已经请求完整个页面已经刷新，就更新下section2,3.  商品还没有请求，则不用操作，后续商品请求结束会刷新整个页面
        if (self.viewModel.commodityRequestFinish) {
            [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:SCHomeSectionNear]];
            [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:SCHomeSectionGood]];
        }
    } failure:^(NSString * _Nullable errorMsg) {
    }];
    
}

//请求商品
- (void)requestCommodityList:(NSInteger)page
{
    [self.viewModel requestCommodityList:page completion:^(NSString * _Nullable errorMsg) {
        [self stopLoading];
        [self.collectionView reloadDataShowFooter:self.viewModel.hasMoreData];
    }];
    
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
        
    }else if (section == SCHomeSectionNear) { //near
        height = kNearH;
        
    }else if (section == SCHomeSectionGood) { //goodshop
        height = [SCGoodShopView sectionHeight:self.viewModel.goodShopList.count];
        
    }else if (section == SCHomeSectionAd) { //ad
        height = kAdH;
        
    }else if (section == SCHomeSectionTagItems) { //tag
        height = SCREEN_FIX(55);
        
    }else {  //空数据
        height = (self.viewModel.commodityList && self.viewModel.commodityList.count == 0) ? SCREEN_FIX(220) : 0;
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
        bannerView.selectBlock = ^(NSInteger index, SCHomeTouchModel * _Nonnull model) {
            @strongify(self)
            [SCUtilities scXWMobStatMgrStr:NSStringFormat(@"IOS_T_NZDSC_A0%li",index+3) url:model.linkUrl inPage:NSStringFromClass(self.class)];
            [self pushToWebView:model.linkUrl title:model.linkUrl];
        };
        return bannerView;
    }
    
    if (section == SCHomeSectionGrid) { //grid
        SCHomeGridView *gridView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass(SCHomeGridView.class) forIndexPath:indexPath];
        gridView.touchList = self.viewModel.touchList;
        
        @weakify(self)
        gridView.selectBlock = ^(NSInteger index) {
            @strongify(self)
            [self gridSelect:index];
        };
        
        return gridView;
    }
    
    if (section == SCHomeSectionNear) { //store
        SCHomeNearShopView *nearView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass(SCHomeNearShopView.class) forIndexPath:indexPath];
        nearView.model = self.viewModel.nearShopModel;
        @weakify(self)
        nearView.enterShopBlock = ^(SCHShopInfoModel * _Nonnull shopInfoModel) {
            @strongify(self)
            [SCUtilities scXWMobStatMgrStr:@"IOS_T_NZDSC_C01" url:shopInfoModel.link inPage:NSStringFromClass(self.class)];
            [self pushToWebView:shopInfoModel.link title:@"智慧门店"];
        };
        nearView.bannerBlock = ^(NSInteger index, SCHBannerModel * _Nonnull bannerModel) {
            @strongify(self)
            [SCUtilities scXWMobStatMgrStr:NSStringFormat(@"IOS_T_NZDSC_C0%li",index+2) url:bannerModel.bannerImageLink inPage:NSStringFromClass(self.class)];
            [self pushToWebView:bannerModel.bannerImageLink title:@"详情"];
        };
        
        nearView.actBlock = ^(NSInteger index, SCHActImageModel * _Nonnull imgModel) {
            @strongify(self)
            [SCUtilities scXWMobStatMgrStr:NSStringFormat(@"IOS_T_NZDSC_C0%li",index+5) url:imgModel.actImageLink inPage:NSStringFromClass(self.class)];
            [self pushToWebView:imgModel.actImageLink title:@"商品详情"];
        };
        
        return nearView;
    }
    
    if (section == SCHomeSectionGood) { //goodshop
        SCGoodShopView *goodView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass(SCGoodShopView.class) forIndexPath:indexPath];
        goodView.goodShopList = self.viewModel.goodShopList;
        @weakify(self)
        goodView.moreBlock = ^{
            @strongify(self)
            [SCUtilities scXWMobStatMgrStr:@"IOS_T_NZDSC_C09" url:@"" inPage:NSStringFromClass(self.class)];
            [self pushToGoodShops];
        };
        goodView.enterShopBlock = ^(NSInteger row, SCHShopInfoModel * _Nonnull shopModel) {
            @strongify(self)
            [SCUtilities scXWMobStatMgrStr:NSStringFormat(@"IOS_T_NZDSC_C%li",row*4+10) url:shopModel.link inPage:NSStringFromClass(self.class)];
            [self pushToWebView:shopModel.link title:@"智慧门店"];
        };
        
        goodView.imgBlock = ^(NSInteger row, NSInteger index, SCHActImageModel * _Nonnull imgModel) {
            @strongify(self)
            [SCUtilities scXWMobStatMgrStr:NSStringFormat(@"IOS_T_NZDSC_C%li",row*4+11+index) url:imgModel.actImageLink inPage:NSStringFromClass(self.class)];
            
            [self pushToWebView:imgModel.actImageLink title:@"商品详情"];
        };
        
        return goodView;
    }
    
    if (section == SCHomeSectionAd) { //ad
        SCHomeAdView *adView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass(SCHomeAdView.class) forIndexPath:indexPath];
        adView.adList = self.viewModel.adList;
        @weakify(self)
        adView.selectBlock = ^(NSInteger index, SCHomeTouchModel * _Nonnull touchModel) {
            @strongify(self)
            [SCUtilities scXWMobStatMgrStr:NSStringFormat(@"IOS_T_NZDSC_D0%li",index+1) url:touchModel.linkUrl inPage:NSStringFromClass(self.class)];
            [self pushToWebView:touchModel.linkUrl title:touchModel.txt];
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
    return emptyView;
    
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section == SCHomeSectionTagItems) {
        return self.viewModel.commodityList.count;
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
    
    if (indexPath.row < self.viewModel.commodityList.count) {
        SCCommodityModel *model = self.viewModel.commodityList[indexPath.row];
        cell.model = model;
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section != SCHomeSectionTagItems) {
        return;
    }
    SCCommodityModel *model = self.viewModel.commodityList[indexPath.row];
    
    [self pushToWebView:model.detailUrl title:@"商品详情"];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offsetY = scrollView.contentOffset.y;
    
    //坐标
    if (offsetY < 0) {
        self.topView.top = -offsetY;
        
    }else {
        self.topView.top = 0;
    }
    
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
    
    //跳转web
    [self pushToWebView:model.linkUrl title:model.txt];
    
    //回调
    SCShoppingManager *manager = [SCShoppingManager sharedInstance];
    if ([manager.delegate respondsToSelector:@selector(scADTouchClick:back:)]) {
        NSDictionary *dict = [model yy_modelToJSONObject] ?: @{};
        [manager.delegate scADTouchClick:dict back:^{}];
        
    }
    
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

- (void)pushToGoodShops
{
    SCGoodShopViewController *vc = [SCGoodShopViewController new];
    vc.viewModel = self.viewModel;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)changeTag:(NSInteger)index
{
    NSString *code = [NSString stringWithFormat:@"%li",index+1];
    [SCUtilities scXWMobStatMgrStr:NSStringFormat(@"IOS_T_NZDSC_E%@%@", (code.length == 1 ? @"0" : @""), code) url:@"" inPage:NSStringFromClass(self.class)];
    
    self.collectionView.page = 1;
    [self requestData:1 onlyCommodity:YES];
    
    //悬停高度
    CGFloat hoverY = kBannerH - self.topView.height + kGridH + kNearH + [SCGoodShopView sectionHeight:self.viewModel.goodShopList.count] + kAdH;
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
        CGFloat lWh = SCREEN_FIX(22.5);
        UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_FIX(18.5), SCREEN_FIX(18) + STATUS_BAR_HEIGHT, lWh, lWh)];
        backButton.tintColor = [UIColor whiteColor];
        [backButton setImage:[SCIMAGE(@"newnavbar_back") imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
        backButton.adjustsImageWhenHighlighted = NO;
        
        [backButton sc_addEventTouchUpInsideHandle:^(UIButton * _Nonnull sender) {
            [SCUtilities scXWMobStatMgrStr:@"IOS_T_NZDSC_A01" url:@"" inPage:NSStringFromClass(self.class)];
            [SCShoppingManager dissmissMallPage];
        }];
        [_topView addSubview:backButton];
        
        //客服按钮
        CGFloat sWh = SCREEN_FIX(25);
        UIButton *serviceBtn = [[UIButton alloc] initWithFrame:CGRectMake(_topView.width - SCREEN_FIX(16.5) - sWh, SCREEN_FIX(17.5) + STATUS_BAR_HEIGHT, sWh, sWh)];
        [serviceBtn setImage:SCIMAGE(@"sc_service") forState:UIControlStateNormal];
        @weakify(self)
        [serviceBtn sc_addEventTouchUpInsideHandle:^(id  _Nonnull sender) {
            @strongify(self)
            NSString *param = [NSString stringWithFormat:@"phoneNum=%@&tenantId=1&skillId=1&requestSource=2",[SCUserInfo currentUser].phoneNumber];
            NSString *base64Param = [NSString base64StringFromText:param];
            NSString *fullUrl = [NSString stringWithFormat:@"%@%@",SC_KEFU_URL,base64Param];
            [self pushToWebView:fullUrl title:@"客服"];
        }];
        [_topView addSubview:serviceBtn];
        
        //搜索框
        CGFloat sX = backButton.right + SCREEN_FIX(15);
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
        _collectionView.backgroundColor = HEX_RGB(@"#F5F5F5");
        _collectionView.delegate        = self;
        _collectionView.dataSource      = self;
        [self.view addSubview:_collectionView];
        [self.view insertSubview:_collectionView belowSubview:self.topView];
        
        [_collectionView registerClass:SCShopCollectionCell.class forCellWithReuseIdentifier:NSStringFromClass(SCShopCollectionCell.class)];
        [_collectionView registerClass:SCHomeBannerView.class forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass(SCHomeBannerView.class)];
        [_collectionView registerClass:SCHomeGridView.class forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass(SCHomeGridView.class)];
        [_collectionView registerClass:SCHomeNearShopView.class forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass(SCHomeNearShopView.class)];
        [_collectionView registerClass:SCHomeAdView.class forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass(SCHomeAdView.class)];
        [_collectionView registerClass:SCTagView.class forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass(SCTagView.class)];
        [_collectionView registerClass:SCGoodShopView.class forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass(SCGoodShopView.class)];
        [_collectionView registerClass:SCHomeEmptyView.class forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass(SCHomeEmptyView.class)];
        //
        [_collectionView showsRefreshHeader];
//        [_collectionView showsRefreshFooter];
        @weakify(self)
        _collectionView.refreshingBlock = ^(NSInteger page) {
            @strongify(self)
            [self requestData:page onlyCommodity:NO];
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
