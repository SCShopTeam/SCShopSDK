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
@property (nonatomic, strong) NSArray <SCWitSortButton *> *btnList;
@end

@implementation SCWitStoreSortView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 8;
        self.layer.masksToBounds = YES;
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

- (NSArray<SCWitSortButton *> *)btnList
{
    if (!_btnList) {
        NSMutableArray *mulArr = [NSMutableArray arrayWithCapacity:2];
    
        CGFloat h = self.height/2;
        for (int i=0; i<2; i++) {
            SCWitSortButton *btn = [[SCWitSortButton alloc] initWithFrame:CGRectMake(0, h*i, self.width, h)];
            if (i == 0) {
                [btn setTitle:@"有券优先" forState:UIControlStateNormal];
                btn.sortType = SCWitSortTypeCoupon;
            }else {
                [btn setTitle:@"人少优先" forState:UIControlStateNormal];
                btn.sortType = SCWitSortTypePeople;
            }
            [self addSubview:btn];
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
        [self setTitleColor:HEX_RGB(@"#4AAAFB") forState:UIControlStateSelected];
    }
    return self;
}

@end
