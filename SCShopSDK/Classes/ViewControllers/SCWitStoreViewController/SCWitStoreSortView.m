//
//  SCWitStoreSortView.m
//  shopping
//
//  Created by gejunyu on 2020/9/3.
//  Copyright © 2020 jsmcc. All rights reserved.
//

#import "SCWitStoreSortView.h"

@interface SCWitSortButton : UIButton
@property (nonatomic, assign) SCWitSortType sortType;
@end

@interface SCWitStoreSortView ()
@property (nonatomic, strong) UIImageView *backImgView;
@property (nonatomic, strong) NSArray <SCWitSortButton *> *btnList;
@end

@implementation SCWitStoreSortView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

    }
    return self;
}


- (void)show:(SCWitSortType)sortType
{
    self.hidden = NO;
    for (SCWitSortButton *btn in self.btnList) {
        btn.selected = btn.sortType == sortType;
    }
}

- (void)hide
{
    self.hidden = YES;
}

- (UIImageView *)backImgView
{
    if (!_backImgView) {
        _backImgView = [[UIImageView alloc] initWithFrame:self.bounds];
        _backImgView.image = SCIMAGE(@"sc_wit_sort");
        _backImgView.userInteractionEnabled = YES;
        [self addSubview:_backImgView];
    }
    return _backImgView;
}

- (NSArray<SCWitSortButton *> *)btnList
{
    if (!_btnList) {
        NSMutableArray *mulArr = [NSMutableArray arrayWithCapacity:2];
        
        //背景图
        CGFloat x = SCREEN_FIX(6.5);
        CGFloat y = SCREEN_FIX(11);
        CGFloat w = self.backImgView.width - x*2;
        CGFloat bottom = SCREEN_FIX(8.5);
        CGFloat h = self.backImgView.height - y - bottom;
        
        CGFloat btnH = h/2;
        
        for (int i=0; i<2; i++) {
            SCWitSortButton *btn = [[SCWitSortButton alloc] initWithFrame:CGRectMake(x, y+btnH*i, w, btnH)];
            if (i == 0) {
                [btn setTitle:@"距离优先" forState:UIControlStateNormal];
                btn.sortType = SCWitSortTypeNear;
            }else {
                [btn setTitle:@"旗舰优先" forState:UIControlStateNormal];
                btn.sortType = SCWitSortTypeVIP;
            }
            [self.backImgView addSubview:btn];
            [mulArr addObject:btn];
            
            @weakify(self)
            [btn sc_addEventTouchUpInsideHandle:^(id  _Nonnull sender) {
                @strongify(self)
                self.hidden = YES;
                
                if (self.sortBlock) {
                    self.sortBlock(((SCWitSortButton *) sender).sortType);
                }
            }];
            
        }
        
        _btnList = mulArr.copy;
        
        //分隔线
        CGFloat lx = x + SCREEN_FIX(9);
        CGFloat lw = self.backImgView.width - lx*2;
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(lx, 0, lw, 0.5)];
        line.centerY = h/2+y;
        line.backgroundColor = HEX_RGB(@"#DBDBDB");
        [self.backImgView addSubview:line];

    }
    return _btnList;
}


@end



@implementation SCWitSortButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.titleLabel.font = SCFONT_SIZED(12);
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self setTitleColor:HEX_RGB(@"#4992FB") forState:UIControlStateSelected];
    }
    return self;
}

@end
