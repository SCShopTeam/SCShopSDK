//
//  SCStoreItemCell.m
//  shopping
//
//  Created by gejunyu on 2020/7/9.
//  Copyright © 2020 jsmcc. All rights reserved.
//

#import "SCStoreItemCell.h"
#import "SCCartModel.h"

static NSString *kAdd    = @"+";
static NSString *kReduce = @"-";

@interface SCStoreItemCell () <UITextFieldDelegate>
@property (nonatomic, strong) UIButton *selectButton;
@property (nonatomic, strong) UIImageView *icon;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *tipLabel;
@property (nonatomic, strong) UILabel *oldPriceLabel;
@property (nonatomic, strong) UILabel *currentPriceLabel;
@property (nonatomic, strong) UIView *line;
//计数区
@property (nonatomic, strong) UIView *countView;
//@property (nonatomic, strong) UITextField *numTextField;
@property (nonatomic, strong) UILabel *numLabel;

@end

@implementation SCStoreItemCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self countView];
    }
    return self;
}


#pragma mark -data
- (void)setItem:(SCCartItemModel *)item
{
    _item = item;
    
    //选中
    self.userSelected = item.selected;
    
    //icon
    [self.icon sd_setImageWithURL:[NSURL URLWithString:item.itemThumb] placeholderImage:IMG_PLACE_HOLDER];

    //标题
    self.titleLabel.size = CGSizeMake(SCREEN_FIX(220), SCREEN_FIX(300));
    NSString *text = item.itemTitle;
    self.titleLabel.attributedText = [text attributedStringWithLineSpacing:2];
    [self.titleLabel sizeToFit];
    
    //tip
    self.tipLabel.text = item.skuName;
    
    //现价
    self.currentPriceLabel.attributedText = [SCUtilities priceAttributedString:item.itemPrice font:SCFONT_BOLD_SIZED(13) color:HEX_RGB(@"#F2270C")];
    [self.currentPriceLabel sizeToFit];
    
    //原价
//    self.oldPriceLabel.attributedText = [SCUtilities oldPriceAttributedString:[NSString stringWithFormat:@"%li",item.oldPrice] font:SCFONT_SIZED(7) color:HEX_RGB(@"#7D7F82")];
//    self.oldPriceLabel.left = self.currentPriceLabel.right + SCREEN_FIX(4.5);
////    self.oldPriceLabel.bottom = self.currentPriceLabel.bottom;
    
    //数量
//    self.numTextField.text = [NSString stringWithFormat:@"%li",item.itemQuantity];
    self.numLabel.text = [NSString stringWithFormat:@"%li",(long)item.itemQuantity];
    
    
}

#pragma mark -public
- (void)setUserSelected:(BOOL)userSelected
{
    _userSelected = userSelected;
    [self.selectButton setImage:(userSelected ? SCIMAGE(@"Circle_selected") : SCIMAGE(@"Circle_normal")) forState:UIControlStateNormal];
}



#pragma mark -UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *checkedNumString = [string stringByTrimmingCharactersInSet:[NSCharacterSet decimalDigitCharacterSet]];
    if(checkedNumString.length > 0) {
        return NO;
    }
    
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    if (textField.text.integerValue == 0 || textField.text.length == 0) {
        textField.text = @"1";
    }
    
    self.item.itemQuantity = textField.text.integerValue;
    [self updateNum];
    
    return YES;
}

#pragma mark -btnAction
- (void)countClicked:(UIButton *)sender
{
    
    BOOL isAdd = [sender.currentTitle isEqualToString:kAdd];
    
    if (!isAdd && self.item.itemQuantity == 1) { //不能减到0
        return;
    }
    
//    if ([self.numTextField isEditing]) {
//        [self.numTextField resignFirstResponder];
//    }
    NSInteger newNum = isAdd ? self.item.itemQuantity + 1 : self.item.itemQuantity - 1;
    
    [self showLoading];
    [SCRequest requestCartMerge:self.item.cartItemNum itemNum:self.item.itemNum itemQuantity:newNum success:^(id  _Nullable responseObject) {
        [self stopLoading];
        self.item.itemQuantity = newNum;
        self.numLabel.text = [NSString stringWithFormat:@"%li",(long)newNum];
        [self updateNum];
        
    } failure:^(NSString * _Nullable errorMsg) {
        [self stopLoading];
        [self showWithStatus:errorMsg];
    }];
     
    
//    isAdd ? self.item.itemQuantity++ : self.item.itemQuantity--;

//    self.numTextField.text = [NSString stringWithFormat:@"%li",self.item.itemQuantity];
    
//    [self updateNum];
}


- (void)selectClicked
{
    //过期商品不能点击
//    if (!self.item.selected && !self.item.itemValid) {
//        UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"该商品已下架" message:@"是否移出购物车？" preferredStyle:UIAlertControllerStyleAlert];
//        [ac addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
//            if (self.deleteBlock) {
//                self.deleteBlock(self.item);
//            }
//        }]];
//        [ac addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
//        [[SCUtilities currentViewController] presentViewController:ac animated:YES completion:nil];
//        
//        return;
//    }
    
    
    self.item.selected ^=1;
    self.userSelected = self.item.selected;
    
    if (_selectBlock) {
        _selectBlock();
    }
}

- (void)updateNum
{
    if (_numBlock) {
        _numBlock();
    }
}

#pragma mark -ui
- (void)layoutSubviews
{
    [super layoutSubviews];
    self.line.width      = self.width;
    self.countView.right = self.width - SCREEN_FIX(11);
}

- (UIButton *)selectButton
{
    if (!_selectButton) {
//        CGFloat wh = SCREEN_FIX(15.5); //实际大小比图像大一点，方便点击
        CGFloat wh = SCREEN_FIX(11.5) + SCREEN_FIX(15.5) + SCREEN_FIX(8);
        _selectButton = [[UIButton alloc] initWithFrame:CGRectMake(0, (kCartStoreRowH - wh)/2, wh, wh)];
        [_selectButton setImage:SCIMAGE(@"Cart_normal") forState:UIControlStateNormal];
        [_selectButton addTarget:self action:@selector(selectClicked) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_selectButton];
    }
    return _selectButton;
}

- (UIImageView *)icon
{
    if (!_icon) { //500 333
        CGFloat wh = SCREEN_FIX(73);
        _icon = [[UIImageView alloc] initWithFrame:CGRectMake(self.selectButton.right, (self.height-wh)/2, wh, wh)];
        _icon.contentMode = UIViewContentModeScaleAspectFit;
        _icon.layer.masksToBounds = YES;
        [self.contentView addSubview:_icon];
    }
    return _icon;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.icon.right + SCREEN_FIX(10), SCREEN_FIX(16), SCREEN_FIX(240), SCREEN_FIX(30))];
        _titleLabel.font = SCFONT_SIZED(14);
        _titleLabel.numberOfLines = 2;
        [self.contentView addSubview:_titleLabel];
    }
    return _titleLabel;
}

- (UILabel *)tipLabel
{
    if (!_tipLabel) {
        _tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.titleLabel.left, SCREEN_FIX(55), SCREEN_FIX(160), SCREEN_FIX(11))];
        _tipLabel.font = SCFONT_SIZED(11);
        _tipLabel.textColor = HEX_RGB(@"#888888");
        [self.contentView addSubview:_tipLabel];
    }
    return _tipLabel;
}

- (UILabel *)currentPriceLabel
{
    if (!_currentPriceLabel) {
        _currentPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.titleLabel.left, self.tipLabel.bottom + SCREEN_FIX(5), 40, SCREEN_FIX(13))];
        [self.contentView addSubview:_currentPriceLabel];
    }
    return _currentPriceLabel;
}

- (UILabel *)oldPriceLabel
{
    if (!_oldPriceLabel) {
        _oldPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, SCREEN_FIX(7))];
        _oldPriceLabel.bottom = _currentPriceLabel.bottom - SCREEN_FIX(3);
        [self.contentView addSubview:_oldPriceLabel];
    }
    return _oldPriceLabel;
}

- (UIView *)line
{
    if (!_line) {
        _line = [[UIView alloc] initWithFrame:CGRectMake(0, kCartStoreRowH-0.5, 0, 0.5)];
        _line.backgroundColor = HEX_RGB(@"#E1E1E1");
        [self.contentView addSubview:_line];
    }
    return _line;
}

- (UIView *)countView
{
    if (!_countView) {
        CGFloat w = SCREEN_FIX(81);
        CGFloat h = SCREEN_FIX(20);
        
        _countView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, w, h)];
        _countView.bottom = kCartStoreRowH - SCREEN_FIX(11.5);
        _countView.layer.borderWidth   = 1;
        _countView.layer.borderColor   = HEX_RGB(@"#EDEDED").CGColor;
        _countView.layer.cornerRadius  = 5;
        _countView.layer.masksToBounds = YES;
        [self.contentView addSubview:_countView];
        
        CGFloat btnW = SCREEN_FIX(23);
        CGFloat tfW  = w-btnW*2;
        
        for (int i=0; i<2; i++) {
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake((btnW+tfW)*i, 0, btnW, h)];
            btn.titleLabel.font = SCFONT_SIZED(17);
            [btn setTitleColor:HEX_RGB(@"#D1D1D1") forState:UIControlStateNormal];
            [btn setTitle:(i==0 ? kReduce : kAdd) forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(countClicked:) forControlEvents:UIControlEventTouchUpInside];
            [_countView addSubview:btn];
        }
        
        _numLabel = [[UILabel alloc] initWithFrame:CGRectMake(btnW, 0, tfW, h)];
        _numLabel.textAlignment = NSTextAlignmentCenter;
        _numLabel.layer.borderWidth   = 1;
        _numLabel.layer.borderColor   = HEX_RGB(@"#EDEDED").CGColor;
        _numLabel.layer.masksToBounds = YES;
        _numLabel.font                = SCFONT_SIZED(12);
        [_countView addSubview:_numLabel];
        
//        _numTextField = [[UITextField alloc] initWithFrame:CGRectMake(btnW, 0, tfW, h)];
//        _numTextField.text = @"1";
//        _numTextField.delegate = self;
//        _numTextField.textAlignment = NSTextAlignmentCenter;
//        _numTextField.layer.borderWidth   = 1;
//        _numTextField.layer.borderColor   = HEX_RGB(@"#EDEDED").CGColor;
//        _numTextField.layer.masksToBounds = YES;
//        _numTextField.font = SCFONT_SIZED(12);
//        _numTextField.keyboardType = UIKeyboardTypeNumberPad;
//        [_countView addSubview:_numTextField];

        
    }
    return _countView;
}

@end
