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
        
        NSString *name = [dict safeStringValueForKey:@"name"];
        
        if (name.length <= 0) {
            continue;
        }
        
        NSString *value = [dict safeStringValueForKey:@"value"];
        
        if ([name isEqualToString:@"F_GOODS_SOURCE"]) {
            self.goodsSource = value;

        }else if ([name isEqualToString:@"F_SHOP_ADDR"]) {
            self.shopAddr = value;

        }else if ([name isEqualToString:@"rate"]) {
            self.rate = value;

        }else if ([name isEqualToString:@"F_LINE_PRICE"]) {
            self.linePrice = value;

        }else if ([name isEqualToString:@"F_SHOP_NAME"]) {
            self.shopName = value;

        }else if ([name isEqualToString:@"F_SHOP_LNG"]) {
            self.shopLng = value;

        }else if ([name isEqualToString:@"F_SHOP_LAT"]) {
            self.shopLat = value;

        }else if ([name isEqualToString:@"F_DISTANCE_NUM"]) {
            self.distanceNum = value;

        }else if ([name isEqualToString:@"t_busi_num"]) {
            self.busiNum = value;

        }else if ([name isEqualToString:@"F_TARGET_ID"]) {
            self.targetId = value;

        }else if ([name isEqualToString:@"t_busi_image"]) {
            self.busiImage = value;

        }else if ([name isEqualToString:@"F_SOURCE_ID"]) {
            self.sourceId = value;

        }else if ([name isEqualToString:@"F_TSECTION_ID"]) {
            self.tsectionId = value;

        }else if ([name isEqualToString:@"t_introduce"]) {
            self.introduce = value;

        }else if ([name isEqualToString:@"F_TSECTION_NAME"]) {
            self.tsectionName = value;

        }else if ([name isEqualToString:@"F_TSECTION_NUM"]) {
            self.tsectionNum = value;

        }else if ([name isEqualToString:@"labels"]) {
            self.labels = value;

        }
        
    }
    
    return YES;
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









