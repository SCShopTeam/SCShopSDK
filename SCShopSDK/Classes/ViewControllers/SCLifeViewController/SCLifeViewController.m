//
//  SCLifeViewController.m
//  shopping
//
//  Created by gejunyu on 2020/7/13.
//  Copyright © 2020 jsmcc. All rights reserved.
//

#import "SCLifeViewController.h"
#import "SCTagView.h"
#import "SCLifeViewModel.h"
#import "SCLifeCell.h"

@interface SCLifeViewController () <UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) SCLifeViewModel *viewModel;
@property (nonatomic, strong) SCTagView *tagView;
@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation SCLifeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"智能生活";
    
    [self requestCategoryList];

}

#pragma mark -requset
- (void)requestCategoryList
{
    [self showLoading];
    [self.viewModel requestCategoryList:self.paramDic success:^(id  _Nullable responseObject) {
        [self stopLoading];
        //标签
        self.tagView.categoryList = self.viewModel.categoryList;
        //scrollview
        [self configCollectionView];
        

        
    } failure:^(NSString * _Nullable errorMsg) {
        [self stopLoading];
        [self showWithStatus:errorMsg];
    }];

}

- (void)configCollectionView
{
    __block NSInteger selectedIndex = 0;
    [self.viewModel.categoryList enumerateObjectsUsingBlock:^(SCCategoryModel * _Nonnull model, NSUInteger idx, BOOL * _Nonnull stop) {
        if (model.selected) {  //
            selectedIndex = idx;
        }
        
        //注册cell
        NSString *cellId= [self cellId:idx];
        [self.collectionView registerClass:SCLifeCell.class forCellWithReuseIdentifier:cellId]; //这样做事为了让cell不复用
        
    }];
    [self.collectionView reloadData];
    
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:selectedIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
}

- (NSString *)cellId:(NSInteger)index
{
    return [NSString stringWithFormat:@"lifecellid:%li",index];
}

#pragma mark -UICollectionViewDelegate, UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.viewModel.categoryList.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellId = [self cellId:indexPath.row];

    SCLifeCell *cell = (SCLifeCell *)[collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    
    if (indexPath.row < self.viewModel.categoryList.count) {
        SCCategoryModel *model = self.viewModel.categoryList[indexPath.row];
        cell.typeNum = model.typeNum;
    }
    
    return cell;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger index = scrollView.contentOffset.x/scrollView.width;
    
    [self.tagView pushToIndex:index needCallBack:NO];
}


#pragma mark -ui
- (SCTagView *)tagView
{
    if (!_tagView) {
        _tagView = [[SCTagView alloc] initWithFrame:CGRectMake(0, SCREEN_FIX(0), self.view.width,SCREEN_FIX(43))];
        _tagView.contentEdgeInsets = UIEdgeInsetsMake(0, 0, SCREEN_FIX(5), 0);
        [self.view addSubview:_tagView];
        
        @weakify(self)
        _tagView.selectBlock = ^(NSInteger index) {
            @strongify(self)
            [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
            
        };
        
    }
    return _tagView;
}

- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        CGFloat y = self.tagView.bottom;
        CGFloat h = SCREEN_HEIGHT - NAV_BAR_HEIGHT - y;
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        layout.itemSize                = CGSizeMake(SCREEN_WIDTH, h);
        layout.scrollDirection         = UICollectionViewScrollDirectionHorizontal;
        layout.minimumLineSpacing      = 0;
        layout.minimumInteritemSpacing = 0;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, y, SCREEN_WIDTH, h) collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.delegate        = self;
        _collectionView.dataSource      = self;
        _collectionView.pagingEnabled   = YES;
        _collectionView.bounces         = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        [self.view addSubview:_collectionView];
        
    }
    return _collectionView;
}


- (SCLifeViewModel *)viewModel
{
    if (!_viewModel) {
        _viewModel = [SCLifeViewModel new];
    }
    return _viewModel;
}

@end
