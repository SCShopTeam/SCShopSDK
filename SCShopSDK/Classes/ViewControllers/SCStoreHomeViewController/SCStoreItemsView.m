//
//  SCStoreItemsView.m
//  shopping
//
//  Created by gejunyu on 2021/3/8.
//  Copyright © 2021 jsmcc. All rights reserved.
//

#import "SCStoreItemsView.h"
#import "SCStoreSubItemCell.h"

@interface SCStoreItemsView () <UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation SCStoreItemsView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (void)setItemList:(NSArray<SCSiftItem *> *)itemList
{
    _itemList = itemList;
    
    //注册cell
    for (int i=0; i<itemList.count; i++) { //不让cell复用
        [self.collectionView registerClass:SCStoreSubItemCell.class forCellWithReuseIdentifier:[self cellId:i]];
    }
    
    [self.collectionView reloadData];
}

- (NSString *)cellId:(NSInteger)index
{
    return [NSString stringWithFormat:@"cellid:%li",index];
}

- (void)setCurrentIndex:(NSInteger)currentIndex
{
    if (currentIndex >= self.itemList.count) {
        return;
    }

    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:currentIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];

}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger index = self.collectionView.contentOffset.x/self.collectionView.width;
    
    if (_scrollBlock) {
        _scrollBlock(index);
    }
}


#pragma mark -UICollectionViewDelegate,UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.itemList.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SCStoreSubItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[self cellId:indexPath.row] forIndexPath:indexPath];
    cell.tenantNum = self.tenantNum;
    cell.item = self.itemList[indexPath.row];
    
    @weakify(self)
    cell.selectBlock = ^(SCCommodityModel * _Nonnull model) {
      @strongify(self)
        if (self.selectBlock) {
            self.selectBlock(model);
        }
    };

    return cell;
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
        [_collectionView registerClass:SCStoreSubItemCell.class forCellWithReuseIdentifier:NSStringFromClass(SCStoreSubItemCell.class)];
        
        [self addSubview:_collectionView];
    }
    return _collectionView;
}

@end
