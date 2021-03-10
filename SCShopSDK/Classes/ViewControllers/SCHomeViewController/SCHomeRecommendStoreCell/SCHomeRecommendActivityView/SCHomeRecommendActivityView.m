//
//  SCHomeRecommendActivityView.m
//  shopping
//
//  Created by gejunyu on 2021/3/4.
//  Copyright © 2021 jsmcc. All rights reserved.
//

#import "SCHomeRecommendActivityView.h"
#import "SCRecommendActivityCell.h"

@interface SCHomeRecommendActivityView () <UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIPageControl *pageControl;

@property (nonatomic, strong) NSArray *list; //假数据
@end

@implementation SCHomeRecommendActivityView

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

- (void)getData
{
    _list = @[@[@"直播"],@[@"限时秒杀", @"新品预售"], @[@"超值拼团", @"优惠券"]];
    [self.collectionView reloadData];
    self.pageControl.numberOfPages = _list.count;
}

#pragma mark -UICollectionViewDelegate, UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 999;//可循环滚动
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger index = indexPath.row%_list.count;
    
    SCRecommendActivityCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(SCRecommendActivityCell.class) forIndexPath:indexPath];
    
    [cell getData];
    
    return cell;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger index = self.collectionView.contentOffset.x/self.collectionView.width;
    index = index%_list.count;
    
    self.pageControl.currentPage = index;
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
        [_collectionView registerClass:SCRecommendActivityCell.class forCellWithReuseIdentifier:NSStringFromClass(SCRecommendActivityCell.class)];
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
