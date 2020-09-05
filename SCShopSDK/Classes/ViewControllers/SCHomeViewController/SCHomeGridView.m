//
//  SCHomeGridView.m
//  shopping
//
//  Created by gejunyu on 2020/7/8.
//  Copyright © 2020 jsmcc. All rights reserved.
//

#import "SCHomeGridView.h"
#import "SCFlowLayout.h"

@interface HomeGridCell : UICollectionViewCell
@property (nonatomic, strong) UIImageView *icon;
@property (nonatomic, strong) UILabel *label;
@end



@interface SCHomeGridView () <UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation SCHomeGridView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}


- (void)setTouchList:(NSArray<SCHomeTouchModel *> *)touchList
{
    _touchList = touchList;
    
    [self.collectionView reloadData];
}

#pragma mark -UICollectionViewDelegate, UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.touchList.count;
}

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    HomeGridCell *cell = (HomeGridCell *)[collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(HomeGridCell.class) forIndexPath:indexPath];
    
    SCHomeTouchModel *model = self.touchList[indexPath.row];
    
    [cell.icon sd_setImageWithURL:[NSURL URLWithString:model.picUrl] placeholderImage:IMG_PLACE_HOLDER];
    cell.label.text = model.txt;
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (_selectBlock) {
        _selectBlock(indexPath.row);
    }
}


#pragma mark - ui
- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        SCFlowLayout *layout = [SCFlowLayout new];
        CGFloat itemW = SCREEN_FIX(55.5) + SCREEN_FIX(18)*2;
        CGFloat itemH = SCREEN_FIX(58.5) + SCREEN_FIX(10.5)*2;
        layout.itemSize = CGSizeMake(itemW, itemH);
        
        CGFloat w = itemW*4;
        CGFloat h = itemH*2;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake((self.width-w)/2, (self.height-h)/2, w, h) collectionViewLayout:layout];
        _collectionView.backgroundColor                = [UIColor whiteColor];
        _collectionView.delegate                       = self;
        _collectionView.dataSource                     = self;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.pagingEnabled                  = YES;
        [self addSubview:_collectionView];
        
        [_collectionView registerClass:HomeGridCell.class forCellWithReuseIdentifier:NSStringFromClass(HomeGridCell.class)];
        
        
    }
    return _collectionView;
}


@end



@implementation HomeGridCell

- (UIImageView *)icon
{
    if (!_icon) {
        CGFloat wh = SCREEN_FIX(55.5);
        _icon = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_FIX(18), SCREEN_FIX(10.5), wh, wh)];
        [self.contentView addSubview:_icon];
    }
    return _icon;
}

- (UILabel *)label
{
    if (!_label) {
        _label = [[UILabel alloc] initWithFrame:CGRectMake(0, self.icon.top + SCREEN_FIX(51.5), self.contentView.width, SCREEN_FIX(12))];
        _label.font = SCFONT_SIZED(12);
        _label.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_label];
    }
    return _label;
}

@end


