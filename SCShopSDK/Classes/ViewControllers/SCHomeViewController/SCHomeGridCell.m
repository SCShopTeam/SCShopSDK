//
//  SCHomeGridCell.m
//  shopping
//
//  Created by gejunyu on 2021/3/2.
//  Copyright © 2021 jsmcc. All rights reserved.
//

#import "SCHomeGridCell.h"
#import "SCFlowLayout.h"

@interface HomeGridCell : UICollectionViewCell
@property (nonatomic, strong) UIImageView *icon;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) WKWebView *webView;
- (void)setData:(SCHomeTouchModel *)model;
@end

@interface SCHomeGridCell () <UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation SCHomeGridCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)setGridList:(NSArray<SCHomeTouchModel *> *)gridList
{
    if (_gridList == gridList || gridList.count == 0) {
        return;
    }
    
    _gridList = gridList;
    
    [self.collectionView reloadData];
    
    if (self.touchShowBlock) {
        for (SCHomeTouchModel *model in gridList) {
            self.touchShowBlock(model);
        }
    }
    
}

#pragma mark -UICollectionViewDelegate, UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.gridList.count;
}

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    HomeGridCell *cell = (HomeGridCell *)[collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(HomeGridCell.class) forIndexPath:indexPath];
    
    SCHomeTouchModel *model = self.gridList[indexPath.row];
    
    [cell setData:model];

    
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
//        CGFloat itemW = SCREEN_FIX(55.5) + SCREEN_FIX(18)*2;
//        CGFloat itemH = SCREEN_FIX(58.5) + SCREEN_FIX(12)*2;
//        layout.itemSize = CGSizeMake(itemW, itemH);
        
//        CGFloat w = itemW*4;
//        CGFloat h = itemH*2;
        
//        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-w)/2, (kHomeGridRowH-h)/2, w, h) collectionViewLayout:layout];
        layout.itemSize = CGSizeMake(SCREEN_WIDTH/4, kHomeGridRowH/2);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0,SCREEN_WIDTH, kHomeGridRowH) collectionViewLayout:layout];
        
        _collectionView.backgroundColor                = [UIColor whiteColor];
        _collectionView.delegate                       = self;
        _collectionView.dataSource                     = self;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.pagingEnabled                  = YES;
        [self.contentView addSubview:_collectionView];
        
        [_collectionView registerClass:HomeGridCell.class forCellWithReuseIdentifier:NSStringFromClass(HomeGridCell.class)];
        
        
    }
    return _collectionView;
}


@end


@implementation HomeGridCell

- (void)setData:(SCHomeTouchModel *)model
{
    self.label.text = model.txt;
    
    if ([model.picUrl hasSuffix:@"gif"]) { //sdwebimage的gif加载方式有bug,当tableview滚动时动画会失效，所以使用wkwebview
        _webView.hidden = NO;
        
        [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:model.picUrl] completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
            [self.webView loadData:data MIMEType:@"image/gif" characterEncodingName:@"" baseURL:[NSURL URLWithString:@""]];
        }];
        
    }else {
        _webView.hidden = YES;
        [self.icon sd_setImageWithURL:[NSURL URLWithString:model.picUrl] placeholderImage:IMG_PLACE_HOLDER];
    }
    
    
}




- (UIImageView *)icon
{
    if (!_icon) {
        CGFloat wh = SCREEN_FIX(42.5);
        _icon = [[UIImageView alloc] initWithFrame:CGRectMake((self.width-wh)/2, SCREEN_FIX(8.5), wh, wh)];
        [self.contentView addSubview:_icon];
    }
    return _icon;
}

- (UILabel *)label
{
    if (!_label) {
        _label = [[UILabel alloc] initWithFrame:CGRectMake(0, self.icon.bottom+SCREEN_FIX(5), self.contentView.width, SCREEN_FIX(12))];
        _label.font = SCFONT_SIZED(12);
        _label.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_label];
    }
    return _label;
}

- (WKWebView *)webView
{
    if (!_webView) {
        _webView = [[WKWebView alloc] initWithFrame:self.icon.frame];
        _webView.userInteractionEnabled = NO;
        [self.contentView addSubview:_webView];
    }
    return _webView;
}

@end
