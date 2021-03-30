//
//  SCHomeBannerCell.m
//  shopping
//
//  Created by gejunyu on 2021/3/2.
//  Copyright © 2021 jsmcc. All rights reserved.
//

#import "SCHomeBannerCell.h"
#import <SDCycleScrollView/SDCycleScrollView.h>

@interface SCHomeBannerCell () <SDCycleScrollViewDelegate>
@property (nonatomic, strong) SDCycleScrollView *cycleView;
@property (nonatomic, strong) UIImageView *defaultImageView;
@end

@implementation SCHomeBannerCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor whiteColor];
        [self defaultImageView];
    }
    return self;
}

- (void)setBannerList:(NSArray<SCHomeTouchModel *> *)bannerList
{
    if (!VALID_ARRAY(bannerList) || bannerList == _bannerList) {
        return;
    }
    
    _bannerList = bannerList;

//    [self.colorDict removeAllObjects];
    
    NSMutableArray *mulArr = [NSMutableArray arrayWithCapacity:bannerList.count];
    
    for (SCHomeTouchModel *model in bannerList) {
        NSString *picUrl = VALID_STRING(model.picUrl) ? model.picUrl : @"";
        [mulArr addObject:picUrl];
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
    if (index >= self.bannerList.count || index < 0 ) {
        return;
    }

    SCHomeTouchModel *model = self.bannerList[index];

//    //变色
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
//        UIColor *imgColor = [targetImg sc_getPixelColorAtPoint:CGPointMake(image.size.width/2, 0)];
//        self.gradientLayer.colors = @[(__bridge id)imgColor.CGColor,(__bridge id)[UIColor whiteColor].CGColor];
//        self.colorDict[colorKey] = imgColor;
//    }];
    
    //触点展示
    if (_showblock) {
        _showblock(index,model);
    }
    
    
}

#pragma mark -ui
- (SDCycleScrollView *)cycleView
{
    if (!_cycleView) {
        _cycleView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kHomeBannerRowH) delegate:self placeholderImage:nil];
        _cycleView.backgroundColor = [UIColor clearColor];
        _cycleView.showPageControl = YES;
        _cycleView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
        _cycleView.currentPageDotColor = [UIColor whiteColor];
        _cycleView.pageDotColor = [UIColor colorWithWhite:0.5 alpha:0.5];
        _cycleView.autoScrollTimeInterval = 3;
        _cycleView.pageControlRightOffset = -40;
        _cycleView.contentMode = UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:_cycleView];
        
    }
    return _cycleView;
}

//- (UIImageView *)backImageView
//{
//    if (!_backImageView) {
//        CGFloat w = self.width;
//        CGFloat h = w/375*201.5;
//        _backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, w, h)];
//        _backImageView.image = SCIMAGE(@"sc_banner_back");
//        [self addSubview:_backImageView];
//    }
//    return _backImageView;
//}

- (UIImageView *)defaultImageView
{
    if (!_defaultImageView) {
        _defaultImageView = [[UIImageView alloc] initWithFrame:self.cycleView.frame];
        _defaultImageView.layer.cornerRadius = 5;
        _defaultImageView.layer.masksToBounds = YES;
//        _defaultImageView.image = SCIMAGE(@"sc_home_banner");
        _defaultImageView.image = IMG_PLACE_HOLDER;
        [self.contentView addSubview:_defaultImageView];
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

//- (NSMutableDictionary *)colorDict
//{
//    if (!_colorDict) {
//        _colorDict = [NSMutableDictionary dictionary];
//    }
//    return _colorDict;
//}



@end
