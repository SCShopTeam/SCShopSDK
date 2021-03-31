//
//  SCHomeStoreCell.m
//  shopping
//
//  Created by gejunyu on 2021/3/2.
//  Copyright © 2021 jsmcc. All rights reserved.
//

#import "SCHomeStoreCell.h"
#import "SCHomeStoreTopView.h"
#import "SCHomeStoreActivityView.h"
#import "SCHomeStoreCouponView.h"
#import "SCHomeStoreProtocol.h"

#define kTopH      SCREEN_FIX(64.5)
#define kMargin    SCREEN_FIX(1)
#define kActivityH SCREEN_FIX(159.5)
#define kCouponH   SCREEN_FIX(165.5)

@interface SCHomeStoreCell () <SCHomeStoreProtocol>
@property (nonatomic, strong) SCHomeStoreTopView *topView;
@property (nonatomic, strong) SCHomeStoreActivityView *activityView;
@property (nonatomic, strong) SCHomeStoreCouponView *couponView;

@end

@implementation SCHomeStoreCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = HEX_RGB(@"#EEEEEE");
    }
    return self;
}

+ (CGFloat)getRowHeight:(SCHomeStoreModel *)model
{
    CGFloat height = 0;
    
    if (model) {
        height = kTopH + (model.activityList.count > 0 ? (kMargin+kActivityH) : 0) + (kMargin + kCouponH);
    }
    
    return height;
    
}

#pragma mark -data
- (void)setModel:(SCHomeStoreModel *)model
{
    _model = model;
    
    self.contentView.hidden = !model;
    if (!model) {
        return;
    }
    
    //标题栏
    self.topView.model = model;
    
    //活动区
    self.activityView.activityList = model.activityList;
    
    //优惠券
    self.couponView.bottom = self.height;
    self.couponView.model = model;
}

#pragma mark -SCHomeStoreProtocol
/*top*/
//电话
- (void)call
{
    if (_callBlock) {
        _callBlock(self.model.contactPhone);
    }
}

//客服
- (void)pushToService
{
    if (_serviceBlock) {
        _serviceBlock(self.model.serviceUrl);
    }
}

//店铺主页
- (void)pushToStorePage
{
    if (_storePageBlock) {
        _storePageBlock(self.model.storeLink);
    }
}

/*coupon*/
//更多热销
- (void)pushToMoreGoods
{
    if (_storePageBlock) {
        _storePageBlock(self.model.storeLink);
    }
}

//跳转本店优惠商品详情
- (void)pushToGoodDetail:(NSInteger)index
{
    if (_storeGoodsBlock && index < self.model.topGoodsList.count) {
        SCHomeGoodsModel *model = self.model.topGoodsList[index];
        _storeGoodsBlock(model.goodsDetailUrl, index);
    }
}

/*activity*/
//跳转活动商品列表
- (void)pushToActivityGoodsList:(SCHomeActivityModel *)model index:(NSInteger)index
{
    if (_activityGoodsBlock) {
        _activityGoodsBlock(model.link, index);
    }
}

//跳转活动链接
- (void)pushToActivityPage:(SCHomeActivityModel *)model
{
    if (_activityLinkBlock) {
        _activityLinkBlock(model.link);
    }
}

//跳转直播
- (void)pushToLivePage:(SCHomeActivityModel *)model
{
    if (_activityLinkBlock) {
        _activityLinkBlock(model.link);
    }
}

#pragma mark -ui
- (SCHomeStoreTopView *)topView
{
    if (!_topView) {
        _topView = [[SCHomeStoreTopView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kTopH)];
        _topView.delegate = self;
        [self.contentView addSubview:_topView];
        
    }
    return _topView;
}

- (SCHomeStoreActivityView *)activityView
{
    if (!_activityView) {
        _activityView = [[SCHomeStoreActivityView alloc] initWithFrame:CGRectMake(0, self.topView.bottom + kMargin, SCREEN_WIDTH, kActivityH)];
        _activityView.delegate = self;
        [self.contentView addSubview:_activityView];
    }
    return _activityView;
}

- (SCHomeStoreCouponView *)couponView
{
    if (!_couponView) {
        _couponView = [[SCHomeStoreCouponView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kCouponH)];
        _couponView.delegate = self;
        [self.contentView addSubview:_couponView];
    }
    return _couponView;
}

@end
