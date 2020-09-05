//
//  SCCategoryCommodityCtr.m
//  shopping
//
//  Created by zhangtao on 2020/7/14.
//  Copyright © 2020 jsmcc. All rights reserved.
//

#import "SCCategoryCommodityCtr.h"
#import "SCCateCommodityCollectionCell.h"
@interface SCCategoryCommodityCtr ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>


@end

@implementation SCCategoryCommodityCtr

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.collectionView.backgroundColor = [UIColor whiteColor];
//    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
//    
//    CGFloat itemW =SCREEN_FIX(65.5);
//    CGFloat itemH = SCREEN_FIX(94);
//          
//    layout.minimumLineSpacing      = SCREEN_FIX(24.5);
//    layout.minimumInteritemSpacing = SCREEN_FIX(24.5);
//    layout.itemSize                = CGSizeMake(itemW, itemH);
//    layout.scrollDirection         = UICollectionViewScrollDirectionVertical;
          
//    self.collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
//    self.collectionView.backgroundColor = [UIColor whiteColor];
//    self.collectionView.delegate        = self;
//    self.collectionView.dataSource      = self;
////    [self.view addSubview:_collectionView];
          
    [self.collectionView registerClass:SCCateCommodityCollectionCell.class forCellWithReuseIdentifier:NSStringFromClass(SCCateCommodityCollectionCell.class)];
   
    [self.collectionView registerClass:UICollectionReusableView.class forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    
}

-(void)setSourceArrs:(NSArray *)sourceArrs{
    if ([SCUtilities isValidArray:sourceArrs]) {
        _sourceArrs = sourceArrs;
    }
}

-(void)reloadData{
    [self.collectionView reloadData];
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SCCateCommodityCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(SCCateCommodityCollectionCell.class) forIndexPath:indexPath];
    cell.dataDic = @{};
//    SCShopCollectionCell *cell = (SCShopCollectionCell *)[collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(SCShopCollectionCell.class) forIndexPath:indexPath];
    return cell;
}
//
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(self.view.frame.size.width, 50);
}
//
-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];
        UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, headerView.frame.size.width, headerView.frame.size.height)];
        lab.text = @"    热门";
        [headerView addSubview:lab];
        return headerView;
    }
    return nil;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _sourceArrs.count;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.delegate && [self.delegate respondsToSelector:@selector(cagegoryCommodityClick:)]) {
        [self.delegate cagegoryCommodityClick:indexPath];
    }
}

@end
