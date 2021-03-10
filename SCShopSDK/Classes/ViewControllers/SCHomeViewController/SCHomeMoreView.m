//
//  SCHomeMoreView.m
//  shopping
//
//  Created by gejunyu on 2021/3/3.
//  Copyright © 2021 jsmcc. All rights reserved.
//

#import "SCHomeMoreView.h"

@interface SCHomeMoreButton : UIButton
@property (nonatomic, strong) UIView *line;
@end

@interface SCHomeMoreView ()

@end

@implementation SCHomeMoreView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.image = SCIMAGE(@"home_more_view");
        self.userInteractionEnabled = YES;
        [self createButtons];
        
    }
    return self;
}

- (void)createButtons;
{
    NSArray *titleList = @[@"消息", @"意见" , @"刷新"];
    NSArray *imgList   = @[@"home_more_message", @"home_more_suggest", @"home_more_refresh"];
    
    CGFloat h = SCREEN_FIX(33);
    
    for (int i=0; i<titleList.count; i++) {
        SCHomeMoreButton *btn = [[SCHomeMoreButton alloc] initWithFrame:CGRectMake(0, SCREEN_FIX(10.5)+h*i, self.width, h)];
        [btn setTitle:titleList[i] forState:UIControlStateNormal];
        [btn setImage:SCIMAGE(imgList[i]) forState:UIControlStateNormal];
        btn.line.hidden = i==titleList.count - 1;
        [self addSubview:btn];
        
        @weakify(self)
        [btn sc_addEventTouchUpInsideHandle:^(id  _Nonnull sender) {
            @strongify(self)
            if (self.selectBlock) {
                self.selectBlock(i);
            }
            self.hidden = YES;
        }];
    }

}

@end



@implementation SCHomeMoreButton
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setTitleColor:HEX_RGB(@"#333333") forState:UIControlStateNormal];
        self.titleLabel.font = SCFONT_SIZED(13);
        self.adjustsImageWhenHighlighted = NO;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat imgWH = SCREEN_FIX(18);
    self.imageView.frame  = CGRectMake(SCREEN_FIX(18.5), (self.height-imgWH)/2, imgWH, imgWH);
    
    self.titleLabel.frame = CGRectMake(self.imageView.right + SCREEN_FIX(13.5), 0, SCREEN_FIX(70), SCREEN_FIX(15));
    self.titleLabel.centerY = self.imageView.centerY;
    
}

- (UIView *)line
{
    if (!_line) {
        CGFloat w = SCREEN_FIX(88);
        CGFloat h = 0.5;
        _line = [[UIView alloc] initWithFrame:CGRectMake((self.width-w)/2, self.height-h, w, h)];
        _line.backgroundColor = HEX_RGB(@"#DBDBDB");
        [self addSubview:_line];
    }
    return _line;
}


@end
