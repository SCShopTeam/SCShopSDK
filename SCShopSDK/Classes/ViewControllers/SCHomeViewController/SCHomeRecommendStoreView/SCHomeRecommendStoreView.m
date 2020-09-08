//
//  SCHomeRecommendStoreView.m
//  shopping
//
//  Created by gejunyu on 2020/8/20.
//  Copyright © 2020 jsmcc. All rights reserved.
//

#import "SCHomeRecommendStoreView.h"
#import <SDCycleScrollView/SDCycleScrollView.h>
#import "SCRecommendStoreActView.h"
#import "SCRecommendStoreInfoView.h"

@interface SCHomeRecommendStoreView () <SDCycleScrollViewDelegate>
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) SCRecommendStoreInfoView *shopInfoView;
@property (nonatomic, strong) SDCycleScrollView *bannerView;
@property (nonatomic, strong) SCRecommendStoreActView *actView;


@end

@implementation SCHomeRecommendStoreView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)setModel:(SCHomeStoreModel *)model
{
    _model = model;
    
    //门店信息
    self.shopInfoView.shopInfoModel = model.shopInfo;
    self.shopInfoView.couponList    = model.couponList;
    
    //banner
    NSMutableArray *mulArr = [NSMutableArray arrayWithCapacity:model.bannerList.count];
    for (SCHBannerModel *banner in model.bannerList) {
        if (VALID_STRING(banner.bannerImageUrl)) {
            [mulArr addObject:banner.bannerImageUrl];
        }
    }
    self.bannerView.imageURLStringsGroup = mulArr;
    
    //活动
    self.actView.actList = model.actList;
    
}

#pragma mark -SDCycleScrollViewDelegate
/** 点击图片回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    if (index < 0 || index >= self.model.bannerList.count || !_bannerBlock) {
        return;
    }
    
    SCHBannerModel *model = self.model.bannerList[index];
    _bannerBlock(index, model);
    
}

#pragma mark -ui
- (UIView *)topView
{
    if (!_topView) {
        _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, SCREEN_FIX(44))];
        _topView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_topView];
        
        UILabel *label = [UILabel new];
        label.textColor = [UIColor blackColor];
        label.font = SCFONT_SIZED(18);
        label.text = @"推荐门店";
        [label sizeToFit];
        label.center = CGPointMake(_topView.width/2, _topView.height/2);
        [_topView addSubview:label];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, _topView.height-0.5, _topView.width, 0.5)];
        line.backgroundColor = HEX_RGB(@"#DBDBDB");
        [_topView addSubview:line];

    }
    return _topView;
}

- (SCRecommendStoreInfoView *)shopInfoView
{
    if (!_shopInfoView) {
        _shopInfoView = [[SCRecommendStoreInfoView alloc] initWithFrame:CGRectMake(0, self.topView.bottom, self.width, SCREEN_FIX(80))];
        [self addSubview:_shopInfoView];
        @weakify(self)
        _shopInfoView.enterShopBlock = ^(SCHShopInfoModel * _Nonnull model) {
            @strongify(self)
            if (self.enterShopBlock) {
                self.enterShopBlock(model);
            }
        };
        
    }
    return _shopInfoView;
}

- (SDCycleScrollView *)bannerView
{
    if (!_bannerView) {
        _bannerView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, self.shopInfoView.bottom, self.width, SCREEN_FIX(93)) delegate:self placeholderImage:SCIMAGE(@"home_witapollo_banner_def")];
        
        _bannerView.pageDotImage = SCIMAGE(@"pageControlNormal");
        _bannerView.currentPageDotImage = SCIMAGE(@"pageControlSelected");
        _bannerView.autoScrollTimeInterval = 5.0;
        [self addSubview:_bannerView];
    }
    return _bannerView;
}

- (SCRecommendStoreActView *)actView
{
    if (!_actView) {
        CGFloat y = self.bannerView.bottom;
        _actView = [[SCRecommendStoreActView alloc] initWithFrame:CGRectMake(0, y, self.width, self.height-y)];
        [self addSubview:_actView];
        
        @weakify(self)
        _actView.actBlock = ^(NSInteger index, SCHActImageModel * _Nonnull imgModel) {
            @strongify(self)
            if (self.actBlock) {
                self.actBlock(index, imgModel);
            }
        };
        
    }
    return _actView;
}

@end
