//
//  SCHomeNavBar.m
//  shopping
//
//  Created by gejunyu on 2021/3/1.
//  Copyright © 2021 jsmcc. All rights reserved.
//

#import "SCHomeNavBar.h"
#import "SCLocationService.h"

@interface SCHomeNavBar ()
@property (nonatomic, strong) UIButton *locationIcon;  //定位
@property (nonatomic, strong) UIButton *searchButton;  //搜索按钮
@property (nonatomic, strong) UIButton *serviceButton; //客服按钮
@property (nonatomic, strong) UIButton *moreButton;    //更多按钮

@end

@implementation SCHomeNavBar
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
    self.backgroundColor = HEX_RGB(@"#F2270C");
    
    SCLocationService *ls = [SCLocationService new];
    [ls startLocation:^(NSString * _Nullable longitude, NSString * _Nullable latitude) {
        if (VALID_STRING(ls.city)) {
            [self.locationIcon setTitle:ls.city forState:UIControlStateNormal];
        }
    }];
    
    [self moreButton];
}


#pragma mark -ui
- (UIButton *)locationIcon
{
    if (!_locationIcon) {
        _locationIcon = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_FIX(5), SCREEN_FIX(8.5) + STATUS_BAR_HEIGHT, SCREEN_FIX(34.5), SCREEN_FIX(30))];
        _locationIcon.userInteractionEnabled = NO;
        [_locationIcon setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _locationIcon.titleLabel.font = SCFONT_SIZED(11);
        [_locationIcon setImage:SCIMAGE(@"home_location") forState:UIControlStateNormal];
        [_locationIcon setTitle:@"南京" forState:UIControlStateNormal];
        _locationIcon.adjustsImageWhenHighlighted = NO;
        _locationIcon.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        
        [_locationIcon layoutButtonWithEdgeInsetsStyle:XGButtonEdgeInsetsStyleTop imageTitleSpace:1];
        
        [self addSubview:_locationIcon];

    }
    return _locationIcon;
}


- (UIButton *)searchButton
{
    if (!_searchButton) {
        _searchButton = [[UIButton alloc] initWithFrame:CGRectMake(self.locationIcon.right + SCREEN_FIX(5), SCREEN_FIX(6) + STATUS_BAR_HEIGHT, SCREEN_FIX(254.1), SCREEN_FIX(32.5))];
        _searchButton.backgroundColor = [UIColor whiteColor];
        _searchButton.layer.cornerRadius = _searchButton.height/2;
        _searchButton.layer.masksToBounds = YES;
        [_searchButton setTitleColor:HEX_RGB(@"#D8D8D8") forState:UIControlStateNormal];
        [_searchButton setImage:SCIMAGE(@"Home_Search") forState:UIControlStateNormal];
        _searchButton.titleLabel.font = SCFONT_SIZED(14);
        _searchButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_searchButton setTitle:@"去搜索你喜欢的商品" forState:UIControlStateNormal];
        CGSize imgSize = _searchButton.currentImage.size;
        CGFloat verMargin = (_searchButton.height - imgSize.height)/2;
        _searchButton.imageEdgeInsets = UIEdgeInsetsMake(verMargin , SCREEN_FIX(11), verMargin, 0);
        _searchButton.titleEdgeInsets = UIEdgeInsetsMake(0, SCREEN_FIX(16.5), 0, 0);
        _searchButton.adjustsImageWhenHighlighted = NO;
        
        [self addSubview:_searchButton];
        
        @weakify(self)
        [_searchButton sc_addEventTouchUpInsideHandle:^(UIButton * _Nonnull sender) {
            @strongify(self)
            if (self.searchBlock) {
                self.searchBlock();
            }
        }];
        
    }
    return _searchButton;
}



- (UIButton *)serviceButton
{
    if (!_serviceButton) {
        _serviceButton = [[UIButton alloc] initWithFrame:CGRectMake(self.searchButton.right + SCREEN_FIX(5.5), self.searchButton.top, SCREEN_FIX(30), self.searchButton.height)];
        [_serviceButton setImage:SCIMAGE(@"home_service") forState:UIControlStateNormal];
        
        [self addSubview:_serviceButton];
        
        @weakify(self)
        [_serviceButton sc_addEventTouchUpInsideHandle:^(UIButton * _Nonnull sender) {
            @strongify(self)
            if (self.serviceBlock) {
                self.serviceBlock();
            }
        }];
    }
    return _serviceButton;
}

- (UIButton *)moreButton
{
    if (!_moreButton) {
        _moreButton = [[UIButton alloc] initWithFrame:CGRectMake(self.serviceButton.right + SCREEN_FIX(3.5), self.searchButton.top, SCREEN_FIX(30), self.searchButton.height)];
        [_moreButton setImage:SCIMAGE(@"home_more") forState:UIControlStateNormal];
        [self addSubview:_moreButton];
        
        @weakify(self)
        [_moreButton sc_addEventTouchUpInsideHandle:^(UIButton * _Nonnull sender) {
            @strongify(self)
            if (self.moreBlock) {
                self.moreBlock();
            }
        }];
    }
    return _moreButton;
}


@end
