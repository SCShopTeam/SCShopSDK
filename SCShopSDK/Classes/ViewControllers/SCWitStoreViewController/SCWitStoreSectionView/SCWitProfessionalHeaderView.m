//
//  SCWitProfessionalHeaderView.m
//  shopping
//
//  Created by gejunyu on 2020/9/3.
//  Copyright © 2020 jsmcc. All rights reserved.
//

#import "SCWitProfessionalHeaderView.h"

@interface SCWitProfessionalHeaderView ()
@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation SCWitProfessionalHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundView = ({
        UIView *view = [[UIView alloc] initWithFrame:self.bounds];
        view.backgroundColor = [UIColor clearColor];
        view;
        });

    }
    return self;
}

- (UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithImage:SCIMAGE(@"sc_recommend_store")];
        [self.contentView addSubview:_imageView];
    }
    return _imageView;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.imageView.center = CGPointMake(self.width/2, self.height/2);
}

@end
