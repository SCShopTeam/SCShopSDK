//
//  SCHomeTagCell.m
//  shopping
//
//  Created by gejunyu on 2021/3/2.
//  Copyright © 2021 jsmcc. All rights reserved.
//

#import "SCHomeTagCell.h"


@interface SCHomeTagCell ()
@property (nonatomic, strong) SCTagView *tagView;

@end

@implementation SCHomeTagCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)setCategoryList:(NSArray<SCCategoryModel *> *)categoryList
{
    self.tagView.categoryList = categoryList;
}

- (SCTagView *)tagView
{
    if (!_tagView) {
        _tagView = [[SCTagView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kHomeTagRowH)];
        _tagView.contentEdgeInsets = UIEdgeInsetsMake(SCREEN_FIX(9), 0, SCREEN_FIX(7), 0);
        _tagView.backgroundColor = self.backgroundColor;
        
        @weakify(self)
        _tagView.selectBlock = ^(NSInteger index) {
          @strongify(self)
            if (self.selectBlock) {
                self.selectBlock(index);
            }
        };
        
        [self.contentView addSubview:_tagView];
    }
    return _tagView;
}

@end
