//
//  SCHomeItemsView.m
//  shopping
//
//  Created by gejunyu on 2021/3/3.
//  Copyright © 2021 jsmcc. All rights reserved.
//

#import "SCHomeItemsView.h"
#import "SCHomeSubItemView.h"

@interface SCHomeItemsView () <UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView *collectionView;
//@property (nonatomic, strong) NSMutableDictionary <NSString *, SCHomeSubItemView *> *subViewDict;
@property (nonatomic, strong) NSMutableArray <SCHomeSubItemView *> *subViewList;

@end

@implementation SCHomeItemsView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)setCategoryList:(NSArray<SCCategoryModel *> *)categoryList
{
    _categoryList = categoryList;
    
    [self createItemViews];
    
    __block NSInteger selectIndex = 0;
    
    [categoryList enumerateObjectsUsingBlock:^(SCCategoryModel * _Nonnull model, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx >= self.subViewList.count) {
            *stop = YES;
        }
        
        SCHomeSubItemView *view = self.subViewList[idx];
        view.model = model;
        
        if (model.selected) {
            selectIndex = idx;
        }
        
    }];
    
    [self.collectionView reloadData];
    
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:selectIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
}

- (void)createItemViews
{
    //不重建，只增量补
    NSInteger num = self.categoryList.count - self.subViewList.count;
    
    if (num <= 0) {
        return;
    }
    
    for (NSInteger i = 0; i < num; i++) {
        SCHomeSubItemView *view = [[SCHomeSubItemView alloc] initWithFrame:self.bounds];
        [self.subViewList addObject:view];
    }
}

- (void)refresh
{
    [self.subViewList enumerateObjectsUsingBlock:^(SCHomeSubItemView * _Nonnull subView, NSUInteger idx, BOOL * _Nonnull stop) {
        [subView refresh:(idx == self.currentIndex)];
    }];

}

#pragma mark -UICollectionViewDelegate,UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.categoryList.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(UICollectionViewCell.class) forIndexPath:indexPath];
    
    for (UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    
    if (indexPath.row < self.subViewList.count) {
        SCHomeSubItemView *subView = self.subViewList[indexPath.row];
        if (subView) {
            [cell.contentView addSubview:subView];
            
            @weakify(self)
            subView.selectBlock = ^(SCCommodityModel * _Nonnull model) {
                @strongify(self)
                if (self.selectBlock) {
                    self.selectBlock(model);
                }
            };
            
        }
    }

    

    
    return cell;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (_scrollBlock) {
        _scrollBlock(self.currentIndex);
    }
    
}

- (NSInteger)currentIndex
{
    NSInteger index = self.collectionView.contentOffset.x/self.collectionView.width;
    return index;
}

- (void)setCurrentIndex:(NSInteger)currentIndex
{
    if (currentIndex < 0 || currentIndex >= self.subViewList.count || currentIndex >= self.categoryList.count) {
        currentIndex = 0;
        return;
    }
    
    if (currentIndex == self.currentIndex) {
        SCHomeSubItemView *view = self.subViewList[currentIndex];
        if (view) {
//            [view refresh:YES];
            [view scrollToTop];
        }
        
    }else {
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:currentIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    }
    

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
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.pagingEnabled   = YES;
        _collectionView.delegate        = self;
        _collectionView.dataSource      = self;
        _collectionView.bounces         = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        [_collectionView registerClass:UICollectionViewCell.class forCellWithReuseIdentifier:NSStringFromClass(UICollectionViewCell.class)];
        
        [self addSubview:_collectionView];
    }
    return _collectionView;
}

//- (NSMutableDictionary<NSString *,SCHomeSubItemView *> *)subViewDict
//{
//    if (!_subViewDict) {
//        _subViewDict = [NSMutableDictionary dictionary];
//    }
//    return _subViewDict;
//}

- (NSMutableArray<SCHomeSubItemView *> *)subViewList
{
    if (!_subViewList) {
        _subViewList = [NSMutableArray array];
    }
    return _subViewList;
}

@end
