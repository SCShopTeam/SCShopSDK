//
//  SCHomeSubItemView.m
//  shopping
//
//  Created by gejunyu on 2021/3/3.
//  Copyright © 2021 jsmcc. All rights reserved.
//

#import "SCHomeSubItemView.h"
#import "SCCollectionView.h"
#import "SCShopCollectionCell.h"
#import "SCHomeViewModel.h"

@interface SCHomeSubItemView () <UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) SCCollectionView *collectionView;
@property (nonatomic, strong) SCHomeViewModel *viewModel;
@property (nonatomic, assign) BOOL canScroll;
@property (nonatomic, strong) UILabel *tipLabel;

@end

@implementation SCHomeSubItemView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        [self tipLabel];
        
        [[NSNotificationCenter defaultCenter] addObserverForName:SCNOTI_HOME_CELL_CAN_SCROLL object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
            self.canScroll = YES;
        }];
        
    }
    return self;
}

- (void)setModel:(SCCategoryModel *)model
{
    _model = model;
    
    [self requestData];
}

- (void)requestData
{
    if (!_model) {
        return;
    }

    [self.viewModel requestCommodityListData:_model.typeNum pageNum:self.collectionView.page completion:^(NSString * _Nullable errorMsg) {
        [self stopLoading];
        [self.collectionView showsRefreshFooter];
        [self.collectionView reloadDataWithNoMoreData:self.viewModel.hasNoData];
        
        if (VALID_ARRAY(self.viewModel.commodityList)) {
            self.tipLabel.hidden = YES;
            
        }else {
            self.tipLabel.hidden = NO;
            self.tipLabel.text = @"抱歉，暂无商品，看看其他商品吧~";
        }
    }];
    
}

- (void)refresh:(BOOL)showLoading
{
    self.collectionView.page = 1;
    
    if (showLoading) {
        [self showLoading];
    }
    
    [self requestData];
    
    self.collectionView.contentOffset = CGPointMake(0, 1);
}

- (void)scrollToTop
{
    [self.collectionView setContentOffset:CGPointMake(0, 1) animated:YES];
}

#pragma mark -UICollectionViewDelegate, UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.viewModel.commodityList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    SCShopCollectionCell *cell = (SCShopCollectionCell *)[collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(SCShopCollectionCell.class) forIndexPath:indexPath];
    
    NSArray *list = self.viewModel.commodityList;
    if (indexPath.row < list.count) {
        cell.model = list[indexPath.row];
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *list = self.viewModel.commodityList;
    
    if (indexPath.row < list.count && _selectBlock) {
        SCCommodityModel *model = list[indexPath.row];
        _selectBlock(model);
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView != self.collectionView) {
        return;
    }
    
    CGFloat y = scrollView.contentOffset.y;
    
    if (y<=0 && _canScroll) {
        scrollView.contentOffset = CGPointZero;
        _canScroll = NO;
        [[NSNotificationCenter defaultCenter] postNotificationName:SCNOTI_HOME_TABLE_CAN_SCROLL object:nil];
    }
    if (!_canScroll) {
        scrollView.contentOffset = CGPointZero;
    }
}


#pragma mark -ui
- (SCCollectionView *)collectionView
{
    if (!_collectionView) {
        
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        //        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        layout.minimumLineSpacing      = SCREEN_FIX(15);
        layout.minimumInteritemSpacing = SCREEN_FIX(13.5);
        layout.itemSize                = CGSizeMake(kCommodityItemW, kCommodityItemH);
        layout.sectionInset            = UIEdgeInsetsMake(SCREEN_FIX(6), SCREEN_FIX(18), SCREEN_FIX(10), SCREEN_FIX(18));
        layout.scrollDirection         = UICollectionViewScrollDirectionVertical;
        
        
        _collectionView = [[SCCollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.delegate        = self;
        _collectionView.dataSource      = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        [self addSubview:_collectionView];
        
        [_collectionView registerClass:SCShopCollectionCell.class forCellWithReuseIdentifier:NSStringFromClass(SCShopCollectionCell.class)];
        
        @weakify(self)
        _collectionView.refreshingBlock = ^(NSInteger page) {
            @strongify(self)
            [self requestData];
        };
        
        
    }
    return _collectionView;
    
}

- (UILabel *)tipLabel
{
    if (!_tipLabel) {
        _tipLabel = [[UILabel alloc] initWithFrame:self.bounds];
        _tipLabel.backgroundColor = [UIColor whiteColor];
        _tipLabel.textAlignment = NSTextAlignmentCenter;
        _tipLabel.font = SCFONT_SIZED(15);
        _tipLabel.textColor = HEX_RGB(@"#999999");
        _tipLabel.text = @"加载中...";
        [self addSubview:_tipLabel];
        [self insertSubview:_tipLabel aboveSubview:self.collectionView];
    }
    return _tipLabel;
}

- (SCHomeViewModel *)viewModel
{
    if (!_viewModel) {
        _viewModel = [SCHomeViewModel new];
    }
    return _viewModel;
}


@end
