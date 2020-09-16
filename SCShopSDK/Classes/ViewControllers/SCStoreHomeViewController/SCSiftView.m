//
//  SCSiftView.m
//  shopping
//
//  Created by gejunyu on 2020/7/23.
//  Copyright © 2020 jsmcc. All rights reserved.
//

#import "SCSiftView.h"

@interface SiftItem : NSObject
@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) BOOL sort;      //是否有排序
@property (nonatomic, assign) BOOL selected;  //是否被选中
@property (nonatomic, assign) BOOL isAscend;  //是否是升序
@property (nonatomic, assign) SCCategorySortKey sortKey;

@end

@interface SiftCell : UICollectionViewCell
@property (nonatomic, strong) SiftItem *item;
@property (nonatomic, strong) UILabel *titleLabel;      //标题
@property (nonatomic, strong) UIImageView *ascendIcon;   //升序按钮
@property (nonatomic, strong) UIImageView *descendIcon;  //降序按钮

@end


@interface SCSiftView () <UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray <SiftItem *>*itemList;
@end

@implementation SCSiftView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _currentSortKey  = SCCategorySortKeyRecommand;
        _currentSortType = SCCategorySortTypeDesc;
        
        [self collectionView];
    }
    return self;
}

#pragma mark -UICollectionViewDelegate, UICollectionViewDataSource
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//
//}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _itemList.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SiftCell *cell = (SiftCell *)[collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(SiftCell.class) forIndexPath:indexPath];
    
    SiftItem *item = self.itemList[indexPath.row];
    cell.item = item;
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{

    SiftItem *item = self.itemList[indexPath.row];
    
    //先判断点击的是否是当前选中的
    if (item.selected) { //如果就是当前选中的，判断是否需要排序
        if (item.sort) { //需要排序就改变排序方式
            item.isAscend ^= 1;
        }
        
        
    }else {  //不是当前的，则改变选中状态
        [self.itemList enumerateObjectsUsingBlock:^(SiftItem * _Nonnull item, NSUInteger idx, BOOL * _Nonnull stop) {
            item.selected = idx == indexPath.row;
        }];

    }
    
    [collectionView reloadData];
    
    _currentSortKey = item.sortKey;
    _currentSortType = item.isAscend ? SCCategorySortTypeAsc : SCCategorySortTypeDesc;
    
    if (_selectBlock) {
        _selectBlock();
    }

}

#pragma mark -ui
- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        CGFloat itemW = self.width/self.itemList.count;
        CGFloat itemH = self.height;
        
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        layout.minimumLineSpacing      = 0;
        layout.minimumInteritemSpacing = 0;
        layout.itemSize                = CGSizeMake(itemW, itemH);
        layout.scrollDirection         = UICollectionViewScrollDirectionHorizontal;
        
        _collectionView = [[SCCollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
        _collectionView.backgroundColor = HEX_RGB(@"#F6F6F6");
        _collectionView.delegate        = self;
        _collectionView.dataSource      = self;
        [self addSubview:_collectionView];
        
        [_collectionView registerClass:SiftCell.class forCellWithReuseIdentifier:NSStringFromClass(SiftCell.class)];
    }
    return _collectionView;
}

- (NSArray<SiftItem *> *)itemList
{
    if (!_itemList) {
        SiftItem *recommend = [SiftItem new];
        recommend.name     = @"店铺推荐";
        recommend.selected = YES;
        recommend.sortKey  = SCCategorySortKeyRecommand;
        
        SiftItem *new = [SiftItem new];
        new.name    = @"上新";
        new.sortKey = SCCategorySortKeyTime;
        
        SiftItem *price = [SiftItem new];
        price.name     = @"价格";
        price.sort     = YES;
        price.isAscend = YES;
        price.sortKey  = SCCategorySortKeyPrice;
        
        SiftItem *sale = [SiftItem new];
        sale.name    = @"销量";
        sale.sortKey = SCCategorySortKeySale;
        
        _itemList = @[recommend, new, price, sale];
        
    }
    return _itemList;
}

@end


@implementation SiftItem

@end


@implementation SiftCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (void)setItem:(SiftItem *)item
{
    _item = item;
    
    //排序
    self.ascendIcon.hidden  = !item.sort;
    self.descendIcon.hidden = !item.sort;
    
    //选中
    if (item.selected) {
        self.titleLabel.font = [UIFont boldSystemFontOfSize:15];
        self.titleLabel.textColor = HEX_RGB(@"#F64E52");
        
    }else {
        self.titleLabel.font = SCFONT_SIZED(12);
        self.titleLabel.textColor = HEX_RGB(@"#888888");
        
    }
    
    //降序/升序
    BOOL isDescend = item.selected && !item.isAscend;
    BOOL isAscend  = item.selected && item.isAscend;
    
    self.descendIcon.image = isDescend ? SCIMAGE(@"sift_descend_se") : SCIMAGE(@"sift_descend");
    self.ascendIcon.image  = isAscend ? SCIMAGE(@"sift_ascend_se") : SCIMAGE(@"sift_ascend");

    //标题
    self.titleLabel.text = item.name;
    [self.titleLabel sizeToFit];
    self.titleLabel.center = CGPointMake(self.width/2, self.height/2);
    
    self.ascendIcon.left  = self.titleLabel.right + SCREEN_FIX(9);
    self.descendIcon.left = self.ascendIcon.left;

}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        [self.contentView addSubview:_titleLabel];
        
    }
    return _titleLabel;
}

- (UIImageView *)ascendIcon
{
    if (!_ascendIcon) {
        _ascendIcon = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.height/2 - 6, SCREEN_FIX(8.5), SCREEN_FIX(5))];
        [self.contentView addSubview:_ascendIcon];
    }
    return _ascendIcon;
}

- (UIImageView *)descendIcon
{
    if (!_descendIcon) {
        _descendIcon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_FIX(8.5), SCREEN_FIX(5))];
        _descendIcon.bottom = self.height/2 + 6;
        [self.contentView addSubview:_descendIcon];
    }
    return _descendIcon;
}



@end
