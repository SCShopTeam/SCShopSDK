//
//  SCAlertViewController.m
//  shopping
//
//  Created by zhangtao on 2020/8/26.
//  Copyright © 2020 jsmcc. All rights reserved.
//

#import "SCAlertViewController.h"

@implementation SCAlertViewController



-(void)showAlertAct1:(NSString *)act1Name act2:(NSString *)act2Name act1Back:(void(^)(void))act1Back act2Back:(void(^)(void))act2Back{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if ([SCUtilities isValidString:act1Name]) {
            UIAlertAction *action1 = [UIAlertAction actionWithTitle:act1Name style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                if (act1Back) {
                    act1Back();
                }else{
                    [self dismissViewControllerAnimated:YES completion:nil];
                }
            }];
            [self addAction:action1];
        }
        
        if ([SCUtilities isValidString:act2Name]) {
            UIAlertAction *action2 = [UIAlertAction actionWithTitle:act2Name style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                if (act2Back) {
                    act2Back();
                }else{
                    [self dismissViewControllerAnimated:YES completion:nil];
                }
            }];
            [self addAction:action2];
        }
        
    }) ;
}


@end
