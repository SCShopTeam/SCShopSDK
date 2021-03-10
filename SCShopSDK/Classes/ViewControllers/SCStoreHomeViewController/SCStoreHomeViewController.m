//
//  SCStoreHomeViewController.m
//  shopping
//
//  Created by gejunyu on 2021/3/8.
//  Copyright © 2021 jsmcc. All rights reserved.
//

#import "SCStoreHomeViewController.h"
#import "SCStoreHomeViewModel.h"
#import "SCSiftView.h"
#import "SCStoreItemsView.h"

@interface SCStoreScrollView : UIScrollView

@end

@interface SCStoreHomeViewController () <UIScrollViewDelegate>
@property (nonatomic, strong) SCStoreScrollView *scrollView;
@property (nonatomic, strong) SCStoreHomeViewModel *viewModel;
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UIButton *bannerView;
@property (nonatomic, strong) SCSiftView *siftView;
@property (nonatomic, strong) SCStoreItemsView *itemsView;

@property (nonatomic, assign) BOOL canScroll; //多scrollView嵌套 相关参数

@end

@implementation SCStoreHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self prepareUI];
    
    [self requestData];
    
}

- (void)prepareUI
{
    self.title = @"移动好货";
    
    //客服按钮
    self.navigationItem.rightBarButtonItem = [SCUtilities makeBarButtonWithIcon:SCIMAGE(@"sc_store_service") target:self action:@selector(servicePressed) isLeft:NO];
    
    //scrollview联动相关设置
    self.canScroll = YES;
    [[NSNotificationCenter defaultCenter] addObserverForName:SCNOTI_STORE_SCROLL_CAN_SCROLL object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        self.canScroll = YES;
    }];
    
    //主控件
    self.scrollView.contentSize = CGSizeMake(self.scrollView.width, self.itemsView.bottom);
    
    
}

- (void)requestData
{
    if (!VALID_STRING(self.tenantNum)) {
        return;
    }
    
    @weakify(self)
    [self.viewModel requestTenantInfo:_tenantNum completion:^(NSString * _Nullable errorMsg) {
        @strongify(self)
        SCTenantInfoModel *model = self.viewModel.tenantInfo;
        
        self.titleLabel.text = model.shopName;
        [self.titleLabel sizeToFit];
        
        self.iconView.hidden = ![model.tenantType isEqualToString:@"1"];
        self.iconView.left = self.titleLabel.right + SCREEN_FIX(4);
        
        [self.bannerView sd_setBackgroundImageWithURL:[NSURL URLWithString:model.tenantIcon] forState:UIControlStateNormal placeholderImage:IMG_PLACE_HOLDER];
    }];
}

#pragma mark -action
- (void)servicePressed
{
    NSString *url = [self.viewModel getOnlineServiceUrl:self.tenantNum];

    [SCURLSerialization gotoWebcustom:url title:@"在线客服" navigation:self.navigationController];

}
    
#pragma mark -UIScrollViewDelegate

    - (void)scrollViewDidScroll:(UIScrollView *)scrollView
    {
        if (scrollView != _scrollView) {
            return;
        }

        //处理多scrollView联动
        CGFloat y = scrollView.contentOffset.y;

        CGFloat maxOffsetY = self.bannerView.bottom;
        
        if (y >= maxOffsetY && _canScroll) {
            scrollView.contentOffset = CGPointMake(0, maxOffsetY);
            _canScroll = NO;
            [[NSNotificationCenter defaultCenter] postNotificationName:SCNOTI_STORE_CELL_CAN_SCROLL object:nil];
        }
        
        if (!_canScroll) {
            [[NSNotificationCenter defaultCenter] postNotificationName:SCNOTI_STORE_CELL_CAN_SCROLL object:nil];
            scrollView.contentOffset = CGPointMake(0, maxOffsetY);
        }
    }
    
    

#pragma mark -ui
- (SCStoreScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[SCStoreScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_BAR_HEIGHT)];
        _scrollView.backgroundColor = [UIColor whiteColor];
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.delegate = self;
        [self.view addSubview:_scrollView];
    }
    return _scrollView;
}

- (UIView *)topView
{
    if (!_topView) {
        _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.scrollView.width, SCREEN_FIX(45))];
        [self.scrollView addSubview:_topView];
        
        //标题
        CGFloat titleH = SCREEN_FIX(16);
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_FIX(19.5), (_topView.height-titleH)/2, 0, titleH)];
        _titleLabel.font = SCFONT_SIZED(titleH);
        [_topView addSubview:_titleLabel];
        
        //图标
        CGFloat iconH = SCREEN_FIX(15.5);
        _iconView = [[UIImageView alloc] initWithFrame:CGRectMake(0, (_topView.height-iconH)/2, SCREEN_FIX(30), iconH)];
        _iconView.image = SCIMAGE(@"qijian");

        [_topView addSubview:_iconView];
    }
    return _topView;
}

- (UIButton *)bannerView
{
    if (!_bannerView) {
        _bannerView = [[UIButton alloc] initWithFrame:CGRectMake(0, self.topView.bottom, self.scrollView.width, SCREEN_FIX(140))];
        _bannerView.adjustsImageWhenHighlighted = NO;
        [self.scrollView addSubview:_bannerView];
        
        @weakify(self)
        [_bannerView sc_addEventTouchUpInsideHandle:^(id  _Nonnull sender) {
           @strongify(self)
            [SCUtilities scXWMobStatMgrStr:@"IOS_T_NZDSCSDDP_A01" url:@"" inPage:NSStringFromClass(self.class)];
        }];
    }
    return _bannerView;
}

- (SCSiftView *)siftView
{
    if (!_siftView) {
        _siftView = [[SCSiftView alloc] initWithFrame:CGRectMake(0, self.bannerView.bottom, self.scrollView.width, SCREEN_FIX(51.5))];
        [self.scrollView addSubview:_siftView];
        
        @weakify(self)
        _siftView.selectBlock = ^(NSInteger index) {
          @strongify(self)
            self.itemsView.currentIndex = index;
            
        };
    }
    return _siftView;
}

- (SCStoreItemsView *)itemsView
{
    if (!_itemsView) {
        _itemsView = [[SCStoreItemsView alloc] initWithFrame:CGRectMake(0, self.siftView.bottom, self.scrollView.width, self.scrollView.height - self.siftView.height)];
        _itemsView.tenantNum = self.tenantNum;
        _itemsView.itemList = self.siftView.itemList;
        [self.scrollView addSubview:_itemsView];
        
        @weakify(self)
        _itemsView.scrollBlock = ^(NSInteger index) {
          @strongify(self)
            self.siftView.currentIndex = index;
        };
    }
    return _itemsView;
}

- (SCStoreHomeViewModel *)viewModel
{
    if (!_viewModel) {
        _viewModel = [SCStoreHomeViewModel new];
    }
    return _viewModel;
}

@end


@implementation SCStoreScrollView

//目的是让外层tableView接收其他手势
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

@end
