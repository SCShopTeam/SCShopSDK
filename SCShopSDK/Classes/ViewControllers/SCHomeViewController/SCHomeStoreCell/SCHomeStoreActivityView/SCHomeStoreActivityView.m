//
//  SCHomeStoreActivityView.m
//  shopping
//
//  Created by gejunyu on 2021/3/4.
//  Copyright © 2021 jsmcc. All rights reserved.
//

#import "SCHomeStoreActivityView.h"
#import "SCHomeStoreActivityCell.h"

static NSInteger kTotalCount = 9999;

@interface SCHomeStoreActivityView () <UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, weak) NSTimer *timer;

@end

@implementation SCHomeStoreActivityView

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
    //背景色
    self.backgroundColor = [UIColor whiteColor];
    
    //背景图
    CGFloat imgW = SCREEN_FIX(235.5);
    CGFloat imgH = SCREEN_FIX(90.5);
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(self.width-imgW, self.height-imgH, imgW, imgH)];
    imgView.image = SCIMAGE(@"home_recommend_bg");
    [self addSubview:imgView];
    
}

- (void)setActivityList:(NSArray *)activityList
{
    _activityList = activityList;

    [self.collectionView reloadData];
    
    self.pageControl.numberOfPages = activityList.count;
    
    [self setupTimer];
}

#pragma mark -UICollectionViewDelegate, UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _activityList.count > 1 ? kTotalCount : _activityList.count;//可循环滚动
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger index = indexPath.row%_activityList.count;
    
    SCHomeStoreActivityCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(SCHomeStoreActivityCell.class) forIndexPath:indexPath];
    cell.delegate = self.delegate;
    
    NSArray *models = _activityList[index];
    cell.models = models;
    
    return cell;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger page = [self currentCollectionIndex]%_activityList.count;
    
    self.pageControl.currentPage = page;
    
    [self setupTimer];
}

- (NSInteger)currentCollectionIndex
{
    NSInteger index = self.collectionView.contentOffset.x/self.collectionView.width;
    return index;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self invalidateTimer];
}

#pragma mark -timer
- (void)invalidateTimer
{
    [_timer invalidate];
    _timer = nil;
}

- (void)setupTimer
{
    [self invalidateTimer]; //创建定时器前先停止定时器，不然会出现僵尸定时器，导致轮播频率错误
    
    if (self.activityList.count <= 1) {
        return;
    }
    
    @weakify(self)
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:4 repeats:YES block:^(NSTimer * _Nonnull timer) {
        @strongify(self)
        NSInteger nextIndex = [self currentCollectionIndex] + 1;
        
        if (nextIndex > kTotalCount) {
            nextIndex = kTotalCount*0.5;
        }
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:nextIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
        NSInteger page = nextIndex%self.activityList.count;
        
        self.pageControl.currentPage = page;
        
    }];
    
    _timer = timer;
    
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}

//解决当父View释放时，当前视图因为被Timer强引用而不能释放的问题
- (void)willMoveToSuperview:(UIView *)newSuperview
{
    if (!newSuperview) {
        [self invalidateTimer];
    }
}

//解决当timer释放后 回调scrollViewDidScroll时访问野指针导致崩溃
- (void)dealloc
{
    _collectionView.delegate = nil;
    _collectionView.dataSource = nil;
}

#pragma mark -ui
- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.itemSize                = CGSizeMake(self.width, self.height);
        layout.scrollDirection         = UICollectionViewScrollDirectionHorizontal;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.pagingEnabled = YES;
        _collectionView.bounces = NO;
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.showsHorizontalScrollIndicator = NO;
        [_collectionView registerClass:SCHomeStoreActivityCell.class forCellWithReuseIdentifier:NSStringFromClass(SCHomeStoreActivityCell.class)];
        [self addSubview:_collectionView];
        
    }
    return _collectionView;
}

- (UIPageControl *)pageControl
{
    if (!_pageControl) {
        
        _pageControl = [UIPageControl new];
        _pageControl.bottom = self.height;
        
        _pageControl.hidesForSinglePage = YES;

        _pageControl.pageIndicatorTintColor = HEX_RGB(@"#D3D3D3");
        _pageControl.currentPageIndicatorTintColor = HEX_RGB(@"#F8235F");
        _pageControl.userInteractionEnabled = NO;
        [_pageControl setTransform:CGAffineTransformMakeScale(0.75, 0.75)];
        
        [self addSubview:_pageControl];
        
        @weakify(self)
        [self.pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self)
            make.centerX.mas_equalTo(self.mas_centerX);
            make.bottom.mas_equalTo(self.mas_bottom).offset(-3);
//            make.width.mas_equalTo(40);
            make.height.mas_equalTo(5);
        }];
    }
    return _pageControl;
}

@end
