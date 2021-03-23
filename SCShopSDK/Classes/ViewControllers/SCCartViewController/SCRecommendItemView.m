//
//  SCRecommendItemView.m
//  shopping
//
//  Created by gejunyu on 2021/3/18.
//  Copyright © 2021 jsmcc. All rights reserved.
//

#import "SCRecommendItemView.h"
#import "SCShopCollectionCell.h"

//#define kHeaderH

@interface SCRecommendItemView () <UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation SCRecommendItemView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (void)setList:(NSArray<SCCommodityModel *> *)list
{
    _list = list;
    
    [self.collectionView reloadData];
    
    if (!VALID_ARRAY(list)) {
        self.height = 0;
        
    }else {
        UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
        self.collectionView.height = layout.collectionViewContentSize.height;
        self.height = self.collectionView.height;
    }
}

#pragma mark -UICollectionViewDelegate, UICollectionViewDataSource
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass(UICollectionReusableView.class) forIndexPath:indexPath];
    UIImageView *imgView = [header viewWithTag:100];
    
    if (!imgView) {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:SCIMAGE(@"Cart_Recommend")];
        imageView.center = CGPointMake(header.width/2, header.height/2);
        imageView.tag = 100;
        [header addSubview:imageView];
    }
    
    return header;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    //最多显示10个
    return MIN(self.list.count, 10);
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SCShopCollectionCell *cell = (SCShopCollectionCell *)[collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(SCShopCollectionCell.class) forIndexPath:indexPath];
    SCCommodityModel *model = self.list[indexPath.row];
    cell.model = model;
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.selectBlock) {
        SCCommodityModel *model = self.list[indexPath.row];
        self.selectBlock(model);
    }

    
}

#pragma mark -ui
- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.itemSize = CGSizeMake(kCommodityItemW, kCommodityItemH);
        layout.sectionInset = UIEdgeInsetsMake(0, SCREEN_FIX(17), SCREEN_FIX(10), SCREEN_FIX(17));
        layout.minimumLineSpacing = SCREEN_FIX(19);
        layout.minimumInteritemSpacing = SCREEN_FIX(13.5);
        layout.headerReferenceSize = CGSizeMake(self.width, SCREEN_FIX(40));
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height) collectionViewLayout:layout];
        _collectionView.backgroundColor = HEX_RGB(@"#F5F6F7");
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.scrollEnabled = NO;
        [self addSubview:_collectionView];
        
        [_collectionView registerClass:SCShopCollectionCell.class forCellWithReuseIdentifier:NSStringFromClass(SCShopCollectionCell.class)];
        [_collectionView registerClass:UICollectionReusableView.class forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass(UICollectionReusableView.class)];
    }
    return _collectionView;
}

@end
