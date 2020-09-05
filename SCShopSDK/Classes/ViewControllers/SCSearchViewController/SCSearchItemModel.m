//
//  SCSearchItemModel.m
//  shopping
//
//  Created by gejunyu on 2020/8/18.
//  Copyright © 2020 jsmcc. All rights reserved.
//

#import "SCSearchItemModel.h"


@implementation SCSearchItemModel

- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic
{
    if (!VALID_DICTIONARY(dic)) {
        return YES;
    }
    
    NSArray *colunms = dic[@"columns"];
    
    if (!VALID_ARRAY(colunms)) {
        return YES;
    }
    
    
    for (NSDictionary *dict in colunms) {
        if (!VALID_DICTIONARY(dict)) {
            continue;
        }
        
        if ([dict.allKeys containsObject:@"name"] && VALID_STRING(dict[@"name"])) {
            NSString *name = dict[@"name"];
            if ([name isEqualToString:@"F_GOODS_SOURCE"]) {
                self.goodsSource = [self safeValueFor:dict];

            }else if ([name isEqualToString:@"F_SHOP_ADDR"]) {
                self.shopAddr = [self safeValueFor:dict];

            }else if ([name isEqualToString:@"rate"]) {
                self.rate = [self safeValueFor:dict];

            }else if ([name isEqualToString:@"F_LINE_PRICE"]) {
                self.linePrice = [self safeValueFor:dict];

            }else if ([name isEqualToString:@"F_SHOP_NAME"]) {
                self.shopName = [self safeValueFor:dict];

            }else if ([name isEqualToString:@"F_SHOP_LNG"]) {
                self.shopLng = [self safeValueFor:dict];

            }else if ([name isEqualToString:@"F_SHOP_LAT"]) {
                self.shopLat = [self safeValueFor:dict];

            }else if ([name isEqualToString:@"F_DISTANCE_NUM"]) {
                self.distanceNum = [self safeValueFor:dict];

            }else if ([name isEqualToString:@"t_busi_num"]) {
                self.busiNum = [self safeValueFor:dict];

            }else if ([name isEqualToString:@"F_TARGET_ID"]) {
                self.targetId = [self safeValueFor:dict];

            }else if ([name isEqualToString:@"t_busi_image"]) {
                self.busiImage = [self safeValueFor:dict];

            }else if ([name isEqualToString:@"F_SOURCE_ID"]) {
                self.sourceId = [self safeValueFor:dict];

            }else if ([name isEqualToString:@"F_TSECTION_ID"]) {
                self.tsectionId = [self safeValueFor:dict];

            }else if ([name isEqualToString:@"t_introduce"]) {
                self.introduce = [self safeValueFor:dict];

            }else if ([name isEqualToString:@"F_TSECTION_NAME"]) {
                self.tsectionName = [self safeValueFor:dict];

            }else if ([name isEqualToString:@"F_TSECTION_NUM"]) {
                self.tsectionNum = [self safeValueFor:dict];

            }else if ([name isEqualToString:@"labels"]) {
                self.labels = [self safeValueFor:dict];

            }
        
        }
        
    }
    
    return YES;
}

- (NSString *)safeValueFor:(NSDictionary *)dict
{
    if ([dict.allKeys containsObject:@"value"] && VALID_STRING(dict[@"value"])) {
        NSString *value = dict[@"value"];
        return value;
        
    }else {
        return @"";
    }
}

- (NSAttributedString *)addressAttributedText
{
    BOOL hasAddress = VALID_STRING(self.shopAddr);
    if (hasAddress) {
        NSString *length = NSStringFormat(@"%@km",self.distanceNum);
        NSString *address = self.shopAddr;
        NSString *text = NSStringFormat(@"距离您%@|%@",length,address);
        NSMutableAttributedString *mulAtt = [[NSMutableAttributedString alloc] initWithString:text];
        [mulAtt addAttributes:@{NSForegroundColorAttributeName:HEX_RGB(@"#FA1C3A")} range:[text rangeOfString:length]];
        return mulAtt;
        
    }else {
        return nil;
    }
}

@end









