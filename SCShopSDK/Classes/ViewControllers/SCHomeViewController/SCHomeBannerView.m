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
@property (nonatomic, strong) CAGradientLayer *gradientLayer; //渐变色
@property (nonatomic, strong) NSMutableDictionary *colorDict;
@property (nonatomic, strong) NSArray *localImagePath;
@property (nonatomic, assign) BOOL isShowUrl;
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
    [self gradientLayer];
    
    UIImage *defaultImage = SCIMAGE(@"sc_home_banner");
    if (defaultImage) {
        self.localImagePath = @[defaultImage];
    }
}

- (void)setBannerList:(NSArray<SCHomeTouchModel *> *)bannerList
{
    if (!VALID_ARRAY(bannerList) || bannerList == _bannerList) {
        return;
    }
    
    _bannerList = bannerList;
    
    _isShowUrl = YES;
    [self.colorDict removeAllObjects];
    
    NSMutableArray *mulArr = [NSMutableArray arrayWithCapacity:bannerList.count];
    
    for (SCHomeTouchModel *model in bannerList) {
        if (VALID_STRING(model.picUrl)) {
            [mulArr addObject:model.picUrl];
        }
    }
    
    self.cycleView.imageURLStringsGroup = mulArr;
    
    [self cycleScrollView:self.cycleView didScrollToIndex:0];
}

- (void)setLocalImagePath:(NSArray *)localImagePath
{
    if (!VALID_ARRAY(localImagePath) || localImagePath == _localImagePath) {
        return;
    }
    
    _isShowUrl = NO;
    _localImagePath = localImagePath;
    [self.colorDict removeAllObjects];
    self.cycleView.localizationImageNamesGroup = localImagePath;
    [self cycleScrollView:self.cycleView didScrollToIndex:0];
}

#pragma mark -SDCycleScrollViewDelegate
/** 点击图片回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    if (!_isShowUrl || index >= self.bannerList.count || index < 0 || !_selectBlock) {
        return;
    }
    
    SCHomeTouchModel *model = self.bannerList[index];
    
    _selectBlock(index, model);
}

/** 图片滚动回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index
{
    if ((index >= self.bannerList.count && index >= self.localImagePath.count)|| index < 0 ) {
        return;
    }
    
    NSString *colorKey = [NSString stringWithFormat:@"%li",index];
    
    if (VALID_DICTIONARY(self.colorDict) && [self.colorDict.allKeys containsObject:colorKey]) {
        UIColor *color = self.colorDict[colorKey];
        self.gradientLayer.colors = @[(__bridge id)color.CGColor,(__bridge id)[UIColor whiteColor].CGColor];
        return;
    }
    
    
    if (_isShowUrl) {
        SCHomeTouchModel *model = self.bannerList[index];
        [[SDWebImageManager sharedManager] loadImageWithURL:[NSURL URLWithString:model.picUrl] options:0 progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
            UIImage *targetImg = image ?: IMG_PLACE_HOLDER;
            [targetImg getPaletteImageColor:^(SCPaletteColorModel *recommendColor, NSDictionary *allModeColorDic, NSError *error) {
                UIColor *imgColor = recommendColor ? HEX_RGB(recommendColor.imageColorString) : HEX_RGB(@"#EE2C3A");
                self.gradientLayer.colors = @[(__bridge id)imgColor.CGColor,(__bridge id)[UIColor whiteColor].CGColor];
                self.colorDict[colorKey] = imgColor;
            }];
        }];
        
    }else {
        UIImage *img = self.localImagePath[index];
        [img getPaletteImageColor:^(SCPaletteColorModel *recommendColor, NSDictionary *allModeColorDic, NSError *error) {
            UIColor *imgColor = HEX_RGB(recommendColor.imageColorString);
            self.gradientLayer.colors = @[(__bridge id)imgColor.CGColor,(__bridge id)[UIColor whiteColor].CGColor];
            self.colorDict[colorKey] = imgColor;
        }];
    }
    
    
}


#pragma mark -ui
- (SDCycleScrollView *)cycleView
{
    if (!_cycleView) {
        CGFloat x = SCREEN_FIX(18);
        CGFloat y = SCREEN_FIX(59) + STATUS_BAR_HEIGHT;
        CGFloat w = self.width - x*2;
        CGFloat h = self.height - y;
        _cycleView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(x, y, w, h) delegate:self placeholderImage:IMG_PLACE_HOLDER];
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


- (CAGradientLayer *)gradientLayer
{
    if (!_gradientLayer) {
        _gradientLayer = [CAGradientLayer layer];
        _gradientLayer.frame = self.bounds;
        _gradientLayer.startPoint = CGPointMake(0, 0);
        _gradientLayer.endPoint = CGPointMake(0, 0.8);
        _gradientLayer.locations = @[@(0.0),@(1.0)];
        
        [self.layer addSublayer:_gradientLayer];
    }
    return _gradientLayer;
}

- (NSMutableDictionary *)colorDict
{
    if (!_colorDict) {
        _colorDict = [NSMutableDictionary dictionary];
    }
    return _colorDict;
}

@end
