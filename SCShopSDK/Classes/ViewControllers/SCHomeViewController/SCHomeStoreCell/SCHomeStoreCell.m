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

#define kTopH      SCREEN_FIX(64.5)
#define kMargin    SCREEN_FIX(1)
#define kActivityH SCREEN_FIX(159.5)
#define kCouponH   SCREEN_FIX(165.5)

@interface SCHomeStoreCell ()
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
        height = kTopH + (model.activityList.count > 0 ? (kMargin+kActivityH) : 0) + kMargin + kCouponH;
    }
    
    return height;
    
}

#pragma mark -data
- (void)setModel:(SCHomeStoreModel *)model
{
    _model = model;
    
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

#pragma mark -ui
- (SCHomeStoreTopView *)topView
{
    if (!_topView) {
        _topView = [[SCHomeStoreTopView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kTopH)];
        [self.contentView addSubview:_topView];
        
        @weakify(self)
        _topView.enterStoreBlock = ^{
            @strongify(self)
            if (self.enterStoreBlock) {
                self.enterStoreBlock(self.model);
            }
        };
        
        _topView.phoneBlock = ^{
          @strongify(self)
            if (self.phoneBlock) {
                self.phoneBlock(self.model.contactPhone);
            }
        };
        
        _topView.serviceBlock = ^{
          @strongify(self)
            if (self.serviceBlock) {
                self.serviceBlock(self.model.serviceUrl);
            }
        };
        
    }
    return _topView;
}

- (SCHomeStoreActivityView *)activityView
{
    if (!_activityView) {
        _activityView = [[SCHomeStoreActivityView alloc] initWithFrame:CGRectMake(0, self.topView.bottom + kMargin, SCREEN_WIDTH, kActivityH)];
        [self.contentView addSubview:_activityView];
    }
    return _activityView;
}

- (SCHomeStoreCouponView *)couponView
{
    if (!_couponView) {
        _couponView = [[SCHomeStoreCouponView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kCouponH)];
        
        @weakify(self)
        _couponView.pushBlock = ^{
          @strongify(self)
            if (self.enterStoreBlock) {
                self.enterStoreBlock(self.model);
            }
        };
        
        [self.contentView addSubview:_couponView];
    }
    return _couponView;
}

@end
