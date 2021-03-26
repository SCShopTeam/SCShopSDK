//
//  SCCartModel.m
//  shopping
//
//  Created by gejunyu on 2020/7/9.
//  Copyright © 2020 jsmcc. All rights reserved.
//

#import "SCCartModel.h"

@implementation SCCartModel

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass
{
    return @{@"cartItems": SCCartItemModel.class};
}

- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic
{
    _isApollo = [self.busiType isEqualToString:@"3"];
    
    return YES;
}


- (void)updateData
{
    CGFloat sumPrice     = 0;
    NSInteger balanceNum = 0;
    BOOL selectedAll     = YES;
    
    for (SCCartItemModel *item in self.cartItems) {
        if (!item.selected) {
            selectedAll = NO; //有一个没选中就不是全选状态
            
        }else {
            balanceNum++;
            sumPrice += item.itemPrice*item.itemQuantity;
        }
        
        
    }

    [self setSelectedAll:selectedAll updateItems:NO];
    self.balanceNum  = balanceNum;
    self.sumPrice    = sumPrice;
}

- (void)setSelectedAll:(BOOL)selectedAll
{
    [self setSelectedAll:selectedAll updateItems:YES];
}

- (void)setSelectedAll:(BOOL)selectedAll updateItems:(BOOL)updateItems
{
    _selectedAll = selectedAll;
    
    if (updateItems) {
        for (SCCartItemModel *item in self.cartItems) {
            item.selected = selectedAll;
        }
    }
}

@end





@implementation SCCartItemModel

@end
