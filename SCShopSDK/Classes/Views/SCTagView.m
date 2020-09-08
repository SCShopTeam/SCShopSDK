//
//  SCTagView.m
//  shopping
//
//  Created by gejunyu on 2020/7/7.
//  Copyright © 2020 jsmcc. All rights reserved.
//

#import "SCTagView.h"

#define kSelectedFont SCFONT_BOLD_SIZED_FIX(16)

@interface HomeTagCell : UICollectionViewCell
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *selectedIcon;
@property (nonatomic, assign) BOOL isSelected;

@end



@interface SCTagView () <UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation SCTagView

- (void)setCategoryList:(NSArray<SCCategoryModel *> *)categoryList
{
    if (!VALID_ARRAY(categoryList)) {
        return;
    }
    _categoryList = categoryList;
    
    //计算宽度
    for (SCCategoryModel *model in categoryList) {
//        CGFloat minWidth = SCREEN_FIX(68);
        CGFloat margin = SCREEN_FIX(10);
        
        NSString *str = model.typeName;
        CGFloat strWidth = [str calculateWidthWithFont:kSelectedFont height:self.height];
        CGFloat labelWidth = strWidth + margin*2;
//        CGFloat width = MAX(labelWidth, minWidth);
//        model.tagWidth = width;
        model.tagWidth = labelWidth;
    }

    [self.collectionView reloadData];

}

- (void)setBackgroundColor:(UIColor *)backgroundColor
{
    [super setBackgroundColor:backgroundColor];
    self.collectionView.backgroundColor = backgroundColor;
}

- (void)pushToIndex:(NSInteger)index
{
    [self.categoryList enumerateObjectsUsingBlock:^(SCCategoryModel * _Nonnull model, NSUInteger idx, BOOL * _Nonnull stop) {
        model.selected = idx == index;
    }];
    
    [self.collectionView reloadData];
    
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    
    if (self.selectBlock) {
        self.selectBlock(index);
    }
}

#pragma mark -<UICollectionViewDelegate, UICollectionViewDataSource>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.categoryList.count;
}

- (CGSize)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath*)indexPath
{
    SCCategoryModel *model = self.categoryList[indexPath.row];

    return CGSizeMake(model.tagWidth, collectionView.height);
    
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    HomeTagCell *cell = (HomeTagCell *)[collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(HomeTagCell.class) forIndexPath:indexPath];
   
    SCCategoryModel *model = self.categoryList[indexPath.row];
    
    cell.isSelected = model.selected;
    cell.titleLabel.text = model.typeName;
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self.categoryList enumerateObjectsUsingBlock:^(SCCategoryModel * _Nonnull model, NSUInteger idx, BOOL * _Nonnull stop) {
        model.selected = idx == indexPath.row;
    }];
    
    [collectionView reloadData];
    
    [collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    
    if (_selectBlock) {
        _selectBlock(indexPath.row);
    }
}

#pragma mark -ui
- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        CGFloat margin = SCREEN_FIX(10);

        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        layout.minimumLineSpacing      = SCREEN_FIX(10);
        layout.minimumInteritemSpacing = SCREEN_FIX(10);
        layout.sectionInset            = UIEdgeInsetsMake(0, margin, 0, margin);
        layout.scrollDirection         = UICollectionViewScrollDirectionHorizontal;
        
        CGFloat x = _contentEdgeInsets.left;
        CGFloat y = _contentEdgeInsets.top;
        CGFloat w = self.width - x - _contentEdgeInsets.right;
        CGFloat h = self.height - y - _contentEdgeInsets.bottom;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(x, y, w, h) collectionViewLayout:layout];
        _collectionView.backgroundColor                = [UIColor whiteColor];
        _collectionView.delegate                       = self;
        _collectionView.dataSource                     = self;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.bounces                        = NO;
        [self addSubview:_collectionView];
        
        [_collectionView registerClass:HomeTagCell.class forCellWithReuseIdentifier:NSStringFromClass(HomeTagCell.class)];
        
    }
    return _collectionView;
}



@end





@implementation HomeTagCell
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.selectedIcon.centerX = self.contentView.width/2;
    self.titleLabel.width     = self.contentView.width;
}

- (void)setIsSelected:(BOOL)isSelected
{
    _isSelected = isSelected;
    
    self.selectedIcon.hidden  = !isSelected;
    
    self.titleLabel.textColor = isSelected ? HEX_RGB(@"#F64E52") : HEX_RGB(@"#333333");
    self.titleLabel.font      = isSelected ? kSelectedFont : SCFONT_SIZED_FIX(14);
}

- (UIImageView *)selectedIcon
{
    if (!_selectedIcon) {
        CGFloat h = SCREEN_FIX(6.5);
        _selectedIcon = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.height-h, SCREEN_FIX(24), h)];
        _selectedIcon.image = SCIMAGE(@"sc_tag_icon");
        [self.contentView addSubview:_selectedIcon];
    }
    return _selectedIcon;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.contentView.width, self.height-self.selectedIcon.height)];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_titleLabel];
    }
    return _titleLabel;
}

@end
