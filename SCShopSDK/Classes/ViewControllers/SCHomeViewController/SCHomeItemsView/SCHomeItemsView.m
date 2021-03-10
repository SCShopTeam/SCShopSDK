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
@property (nonatomic, strong) NSMutableDictionary <NSString *, SCHomeSubItemView *> *subViewDict;

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
    if (categoryList == _categoryList) {
        return;
    }
    
    _categoryList = categoryList;
    
    [self.subViewDict removeAllObjects];
    
    [categoryList enumerateObjectsUsingBlock:^(SCCategoryModel * _Nonnull model, NSUInteger idx, BOOL * _Nonnull stop) {
        SCHomeSubItemView *view = [[SCHomeSubItemView alloc] initWithFrame:self.bounds];
        view.model = model;
        [self.subViewDict setValue:view forKey:[self getKeyFromIndex:idx]];
    }];
    
    
    
    [self.collectionView reloadData];
}

- (NSString *)getKeyFromIndex:(NSInteger)index
{
    return [NSString stringWithFormat:@"%li",index];
}

- (void)refresh
{
    [self.subViewDict.allValues enumerateObjectsUsingBlock:^(SCHomeSubItemView * _Nonnull subView, NSUInteger idx, BOOL * _Nonnull stop) {
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
    
    NSString *key = [self getKeyFromIndex:indexPath.row];
    SCHomeSubItemView *subView = self.subViewDict[key];
    if (subView) {
        [cell.contentView addSubview:subView];
    }
    
    @weakify(self)
    subView.selectBlock = ^(SCCommodityModel * _Nonnull model) {
        @strongify(self)
        if (self.selectBlock) {
            self.selectBlock(model);
        }
    };
    
    
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
    if (currentIndex == self.currentIndex) {
        SCHomeSubItemView *view = self.subViewDict[[self getKeyFromIndex:self.currentIndex]];
        if (view) {
            [view refresh:YES];
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
        [_collectionView registerClass:UICollectionViewCell.class forCellWithReuseIdentifier:NSStringFromClass(UICollectionViewCell.class)];
        
        [self addSubview:_collectionView];
    }
    return _collectionView;
}

- (NSMutableDictionary<NSString *,SCHomeSubItemView *> *)subViewDict
{
    if (!_subViewDict) {
        _subViewDict = [NSMutableDictionary dictionary];
    }
    return _subViewDict;
}

@end
