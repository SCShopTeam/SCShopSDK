//
//  SCHomeBannerView.m
//  shopping
//
//  Created by gejunyu on 2020/7/7.
//  Copyright © 2020 jsmcc. All rights reserved.
//

#import "SCHomeBannerView.h"
#import <SDCycleScrollView/SDCycleScrollView.h>
#import "UIImage+SCPalette.h"

@interface SCHomeBannerView () <SDCycleScrollViewDelegate>
@property (nonatomic, strong) SDCycleScrollView *cycleView;
//@property (nonatomic, strong) CAGradientLayer *gradientLayer; //渐变色
@property (nonatomic, strong) UIImageView *backImageView;
@property (nonatomic, strong) NSMutableDictionary *colorDict;
@property (nonatomic, strong) UIImageView *defaultImageView;
@end

@implementation SCHomeBannerView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self prepareUI];
    }
    return self;
}

- (void)prepareUI
{
    self.backgroundColor = [UIColor whiteColor];
    
//    [self gradientLayer];
    [self backImageView];
    [self defaultImageView];
   
}

- (void)setBannerList:(NSArray<SCHomeTouchModel *> *)bannerList
{
    if (!VALID_ARRAY(bannerList) || bannerList == _bannerList) {
        return;
    }
    
    _bannerList = bannerList;

    [self.colorDict removeAllObjects];
    
    NSMutableArray *mulArr = [NSMutableArray arrayWithCapacity:bannerList.count];
    
    for (SCHomeTouchModel *model in bannerList) {
        [mulArr addObject:(model.picUrl?:@"")];
    }
    
    self.cycleView.imageURLStringsGroup = mulArr;
    
    [self cycleScrollView:self.cycleView didScrollToIndex:0];
    self.defaultImageView.hidden = YES;
}

#pragma mark -SDCycleScrollViewDelegate
/** 点击图片回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    if (index >= self.bannerList.count || index < 0 || !_selectBlock) {
        return;
    }
    
    SCHomeTouchModel *model = self.bannerList[index];
    
    _selectBlock(index, model);
}

/** 图片滚动回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index
{
//    if (index >= self.bannerList.count || index < 0 ) {
//        return;
//    }
//
//    SCHomeTouchModel *model = self.bannerList[index];
//
//    NSString *colorKey = [NSString stringWithFormat:@"%li",index];
//    UIColor *color = self.colorDict[colorKey];
//
//    if ([color isKindOfClass:UIColor.class]) {
//        self.gradientLayer.colors = @[(__bridge id)color.CGColor,(__bridge id)[UIColor whiteColor].CGColor];
//        return;
//    }
//
//    [[SDWebImageManager sharedManager] loadImageWithURL:[NSURL URLWithString:(model.picUrl?:@"")] options:0 progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
//        UIImage *targetImg = image ?: IMG_PLACE_HOLDER;
//        [targetImg getPaletteImageColor:^(SCPaletteColorModel *recommendColor, NSDictionary *allModeColorDic, NSError *error) {
//            UIColor *imgColor = recommendColor ? HEX_RGB(recommendColor.imageColorString) : HEX_RGB(@"#EE2C3A");
//            self.gradientLayer.colors = @[(__bridge id)imgColor.CGColor,(__bridge id)[UIColor whiteColor].CGColor];
//            self.colorDict[colorKey] = imgColor;
//        }];
//    }];
    
    
}


#pragma mark -ui
- (SDCycleScrollView *)cycleView
{
    if (!_cycleView) {
        CGFloat y = SCREEN_FIX(64) + STATUS_BAR_HEIGHT;
        CGFloat h = self.height - y;
        _cycleView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, y, self.width, h) delegate:self placeholderImage:nil];
        _cycleView.backgroundColor = [UIColor clearColor];
        _cycleView.showPageControl = YES;
        _cycleView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
        _cycleView.currentPageDotColor = [UIColor whiteColor];
        _cycleView.pageDotColor = [UIColor colorWithWhite:0.5 alpha:0.5];
        _cycleView.autoScrollTimeInterval = 3;
        _cycleView.contentMode = UIViewContentModeScaleAspectFill;
        _cycleView.layer.cornerRadius = 5;
        _cycleView.layer.masksToBounds = YES;
        [self addSubview:_cycleView];
        
    }
    return _cycleView;
}

- (UIImageView *)backImageView
{
    if (!_backImageView) {
        CGFloat w = self.width;
        CGFloat h = w/375*201.5;
        _backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, w, h)];
        _backImageView.image = SCIMAGE(@"sc_banner_back");
        [self addSubview:_backImageView];
    }
    return _backImageView;
}

- (UIImageView *)defaultImageView
{
    if (!_defaultImageView) {
        _defaultImageView = [[UIImageView alloc] initWithFrame:self.cycleView.frame];
        _defaultImageView.layer.cornerRadius = 5;
        _defaultImageView.layer.masksToBounds = YES;
        _defaultImageView.image = SCIMAGE(@"sc_home_banner");
        [self addSubview:_defaultImageView];
    }
    return _defaultImageView;
}


//- (CAGradientLayer *)gradientLayer
//{
//    if (!_gradientLayer) {
//        _gradientLayer = [CAGradientLayer layer];
//        _gradientLayer.frame = self.bounds;
//        _gradientLayer.startPoint = CGPointMake(0, 0);
//        _gradientLayer.endPoint = CGPointMake(0, 0.8);
//        _gradientLayer.locations = @[@(0.0),@(1.0)];
//        _gradientLayer.colors = @[(__bridge id)HEX_RGB(@"#c51018").CGColor,(__bridge id)[UIColor whiteColor].CGColor];
//        [self.layer addSublayer:_gradientLayer];
//    }
//    return _gradientLayer;
//}

- (NSMutableDictionary *)colorDict
{
    if (!_colorDict) {
        _colorDict = [NSMutableDictionary dictionary];
    }
    return _colorDict;
}

@end
