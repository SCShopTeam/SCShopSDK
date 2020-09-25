//
//  SCSearchHistoryView.m
//  shopping
//
//  Created by gejunyu on 2020/7/10.
//  Copyright © 2020 jsmcc. All rights reserved.
//

#import "SCSearchHistoryView.h"
#import "SCSearchHistoryUtil.h"

//@interface SCSearchRecordCell : UICollectionViewCell
//@property (nonatomic, strong) UILabel *label;
//@end

@interface SCSearchHistoryView ()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *deleteButton;
@property (nonatomic, strong) SCSearchHistoryUtil *util;
@property (nonatomic, strong) NSMutableArray <UIButton *> *btnList;

@end

static CGFloat kFontSize = 13;

@implementation SCSearchHistoryView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self layoutButtons];
    }
    return self;
}


#pragma mark -public
- (void)addSearchRecord:(NSString *)record
{
    [self.util addSearchRecord:record];
    [self layoutButtons];
}

#pragma mark -private
- (void)layoutButtons
{
    
    NSArray <NSString *> *records = [self.util queryAllRecords];
    
    if (records.count > 0) {
        _lastRecord = records.firstObject;
    }
    
    CGFloat p      = SCREEN_FIX(11); //按钮间水平和垂直间距
    CGFloat margin = SCREEN_FIX(17.5); //屏幕左右边距
    __block CGFloat x = margin;
    __block CGFloat y = self.deleteButton.bottom + SCREEN_FIX(20);
    CGFloat h = SCREEN_FIX(27);
    
    [self.btnList enumerateObjectsUsingBlock:^(UIButton * _Nonnull btn, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx >= records.count) {
            btn.hidden = YES;
            
        }else {
            btn.hidden = NO;
            
            NSString *text = records[idx];
            CGFloat textW = [text calculateWidthWithFont:SCFONT_SIZED(kFontSize) height:kFontSize];
            CGFloat w = MIN(textW + SCREEN_FIX(25), self.width-margin*2) ;
            
            //如果超过右边界，就换下一行显示
            if (x + w > self.width - margin) {
                x = margin;
                y += (h + p);
            }
            
            btn.frame = CGRectMake(x, y, w, h);
            btn.layer.cornerRadius = h/2;
            [btn setTitle:text forState:UIControlStateNormal];
            
            @weakify(self)
            [btn sc_addEventTouchUpInsideHandle:^(UIButton * _Nonnull sender) {
                @strongify(self)
                if (self.selectBlock) {
                    self.selectBlock(text);
                }
            }];
            
            x = btn.right + p;
        }
    }];
    
}

#pragma mark -ui
- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_FIX(15), SCREEN_FIX(14), 100, SCREEN_FIX(15))];
        _titleLabel.font = SCFONT_SIZED(14);
        _titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _titleLabel.text = @"搜索历史";
        [self addSubview:_titleLabel];
    }
    return _titleLabel;
}

- (UIButton *)deleteButton
{
    if (!_deleteButton) {
        CGFloat wh = SCREEN_FIX(20);
        _deleteButton = [[UIButton alloc] initWithFrame:CGRectMake(self.width - SCREEN_FIX(12) - wh, 0, wh, wh)];
        _deleteButton.centerY = self.titleLabel.centerY;
        [_deleteButton setImage:SCIMAGE(@"search_delete") forState:UIControlStateNormal];
        [self addSubview:_deleteButton];
        
        @weakify(self)
        [_deleteButton sc_addEventTouchUpInsideHandle:^(UIButton * _Nonnull sender) {
            @strongify(self)
            [self.util deleteAllRecords];
            [self layoutButtons];
        }];
    }
    return _deleteButton;
}


- (SCSearchHistoryUtil *)util
{
    if (!_util) {
        _util = [SCSearchHistoryUtil new];
    }
    return _util;
}

- (NSMutableArray<UIButton *> *)btnList
{
    if (!_btnList) {
        _btnList = [NSMutableArray arrayWithCapacity:kMaxRecordsNum];
        
        for (int i=0; i<kMaxRecordsNum; i++) {
            UIButton *btn = [UIButton new];
            btn.titleLabel.font = SCFONT_SIZED(13);
            [btn setTitleColor:HEX_RGB(@"#666666") forState:UIControlStateNormal];
            [btn setBackgroundColor:HEX_RGB(@"#F6F6F6")];
            btn.layer.masksToBounds = YES;
            [self addSubview:btn];
            [_btnList addObject:btn];
        }

    }
    return _btnList;
}

@end

