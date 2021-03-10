//
//  SCHomeRecommendStoreCell.m
//  shopping
//
//  Created by gejunyu on 2021/3/2.
//  Copyright © 2021 jsmcc. All rights reserved.
//

#import "SCHomeRecommendStoreCell.h"
#import "SCHomeRecommendTopView.h"
#import "SCHomeRecommendActivityView.h"
#import "SCHomeRecommendCouponView.h"

#define kTopH      SCREEN_FIX(64.5)
#define kMargin    SCREEN_FIX(1)
#define kActivityH SCREEN_FIX(159.5)
#define kCoupontH SCREEN_FIX(165.5)

@interface SCHomeRecommendStoreCell ()
@property (nonatomic, strong) SCHomeRecommendTopView *topView;
@property (nonatomic, strong) SCHomeRecommendActivityView *activityView;
@property (nonatomic, strong) SCHomeRecommendCouponView *couponView;

@end

@implementation SCHomeRecommendStoreCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = HEX_RGB(@"#EEEEEE");
        
    }
    return self;
}

+ (CGFloat)getRowHeight
{
    return 0;
//    return kTopH + kMargin + kActivityH + kMargin + kCoupontH;
}

- (void)setData
{
//    [self.topView getData];
//    [self.activityView getData];
//    [self.couponView getData];
    
}

#pragma mark -ui
- (SCHomeRecommendTopView *)topView
{
    if (!_topView) {
        _topView = [[SCHomeRecommendTopView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kTopH)];
        [self.contentView addSubview:_topView];
        
        @weakify(self)
        _topView.enterStoreBlock = ^{
            @strongify(self)
            if (self.enterStoreBlock) {
                self.enterStoreBlock();
            }
        };
        
        _topView.telBlock = ^{
          @strongify(self)
            if (self.telBlock) {
                self.telBlock();
            }
        };
        
        _topView.serviceBlock = ^{
          @strongify(self)
            if (self.serviceBlock) {
                self.serviceBlock();
            }
        };
        
    }
    return _topView;
}

- (SCHomeRecommendActivityView *)activityView
{
    if (!_activityView) {
        _activityView = [[SCHomeRecommendActivityView alloc] initWithFrame:CGRectMake(0, self.topView.bottom + kMargin, SCREEN_WIDTH, kActivityH)];
        [self.contentView addSubview:_activityView];
    }
    return _activityView;
}

- (SCHomeRecommendCouponView *)couponView
{
    if (!_couponView) {
        _couponView = [[SCHomeRecommendCouponView alloc] initWithFrame:CGRectMake(0, self.activityView.bottom + kMargin, SCREEN_WIDTH, kCoupontH)];
        [self.contentView addSubview:_couponView];
    }
    return _couponView;
}

@end
