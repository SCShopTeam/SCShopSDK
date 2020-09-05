//
//  SCWitStoreQueryView.m
//  shopping
//
//  Created by gejunyu on 2020/8/29.
//  Copyright © 2020 jsmcc. All rights reserved.
//

#import "SCWitStoreQueryView.h"

@interface SCWSQueryButton : UIButton
@property (nonatomic, assign) BOOL isQuerying;
@property (nonatomic, strong) UIView *line;
@end

@interface SCWitStoreQueryView ()
@property (nonatomic, strong) NSArray <SCWSQueryButton *> *btnList;
@property (nonatomic, strong) UIView *contentView;
@end

@implementation SCWitStoreQueryView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self btnList];
    }
    return self;
}
//#308BFB/
- (UIView *)contentView
{
    if (!_contentView) {
        _contentView = [[UIView alloc] initWithFrame:self.bounds];
        _contentView.backgroundColor = [UIColor whiteColor];
        
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.contentView.bounds byRoundingCorners:UIRectCornerTopLeft|UIRectCornerTopRight cornerRadii:CGSizeMake(kWitStoreCorner, kWitStoreCorner)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = self.contentView.bounds;
        maskLayer.path = maskPath.CGPath;
        _contentView.layer.mask = maskLayer;
        [self addSubview:_contentView];
    }
    return _contentView;
}

- (void)showBgColor:(BOOL)show
{
    self.backgroundColor = show ? HEX_RGB(@"#308BFB") : [UIColor clearColor];
}

- (void)clear
{
    for (SCWSQueryButton *btn in self.btnList) {
        btn.isQuerying = btn == self.btnList.firstObject;
    }
}

- (void)btnSelect:(SCWSQueryButton *)sender
{
    NSInteger index = [self.btnList indexOfObject:sender];
    
    if (index == 3) { //智能排序
        if (_showSortBlock) {
            _showSortBlock();
        }
        
        return;
    }
    
    //0附近门店  1会员门店  2常用门店
    for (int i=0; i<3; i++) {
        SCWSQueryButton *btn = self.btnList[i];
        btn.isQuerying = index == i;
    }
    
    SCWitQueryType type = index + 1;
    if (_queryBlock) {
        _queryBlock(type);
    }
}

- (NSArray<SCWSQueryButton *> *)btnList
{
    if (!_btnList) {
        
        NSArray *titles = @[@"附近门店", @"会员门店", @"常用门店", @"智能排序"];
        NSMutableArray *mulArr = [NSMutableArray arrayWithCapacity:titles.count];
        
        CGFloat w = self.contentView.width/titles.count;
        CGFloat h = self.contentView.height;
        
        [titles enumerateObjectsUsingBlock:^(NSString *_Nonnull str, NSUInteger idx, BOOL * _Nonnull stop) {
            SCWSQueryButton *btn = [[SCWSQueryButton alloc] initWithFrame:CGRectMake(w*idx, 0, w, h)];
            btn.isQuerying = idx == 0;
            [btn setTitle:str forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(btnSelect:) forControlEvents:UIControlEventTouchUpInside];
            [self.contentView addSubview:btn];
            
            [mulArr addObject:btn];
        }];

        _btnList = mulArr.copy;
        
        //分割线
        NSInteger count = titles.count - 1;
        for (int i=0; i<count; i++) {
            CGFloat x = w - 0.5 + w*i;
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(x, 0, 1, SCREEN_FIX(10))];
            line.centerY = self.contentView.height/2;
            line.backgroundColor = HEX_RGB(@"#E9E9E9");
            [self.contentView addSubview:line];
        }
    }
    return _btnList;
}



@end


@implementation SCWSQueryButton

- (void)setIsQuerying:(BOOL)isQuerying
{
    _isQuerying = isQuerying;
    
    if (isQuerying) {
        self.line.hidden = NO;
        self.titleLabel.font = SCFONT_BOLD_SIZED(15);
        
    }else {
        self.line.hidden = YES;
        self.titleLabel.font = SCFONT_SIZED(13);
    }
}


- (UIView *)line
{
    if (!_line) {
        CGFloat w = SCREEN_FIX(52.5);
        _line = [[UIView alloc] initWithFrame:CGRectMake((self.width-w)/2, SCREEN_FIX(29), w, SCREEN_FIX(6.5))];
        [self addSubview:_line];
        [self sendSubviewToBack:_line];
        // gradient
        CAGradientLayer *gl = [CAGradientLayer layer];
        gl.frame = _line.bounds;
        gl.startPoint = CGPointMake(1, 0.5);
        gl.endPoint = CGPointMake(-0.13, 0.5);
        gl.colors = @[(__bridge id)[UIColor colorWithRed:61/255.0 green:188/255.0 blue:255/255.0 alpha:1.0].CGColor, (__bridge id)[UIColor colorWithRed:59/255.0 green:135/255.0 blue:255/255.0 alpha:1.0].CGColor];
        gl.locations = @[@(0), @(1.0f)];
        _line.layer.cornerRadius = _line.height/2;
        _line.layer.shadowColor = [UIColor colorWithRed:48/255.0 green:181/255.0 blue:255/255.0 alpha:0.5].CGColor;
        _line.layer.shadowOffset = CGSizeMake(0,2);
        _line.layer.shadowOpacity = 1;
        _line.layer.shadowRadius = 9;
        _line.layer.masksToBounds = YES;
        [_line.layer addSublayer:gl];
    }
    return _line;
}



@end
