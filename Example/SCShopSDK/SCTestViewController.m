//
//  SCTestViewController.m
//  shopping
//
//  Created by gejunyu on 2021/3/1.
//  Copyright © 2021 jsmcc. All rights reserved.
//

#import "SCTestViewController.h"
#import <SCShopSDK.h>

BOOL isLogined = YES;

@interface SCTestViewController ()
@property (weak, nonatomic) IBOutlet UITextField *locaCodeTF;
@property (weak, nonatomic) IBOutlet UITextField *webCodeTF;



@end

@implementation SCTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

+ (BOOL)isLogined
{
    return isLogined;
}

- (IBAction)pushLocalAction:(id)sender {
    [SCURLSerialization gotoController:_locaCodeTF.text navigation:self.navigationController];
}

- (IBAction)pushWebAction:(id)sender {
    [SCURLSerialization gotoWebcustom:_webCodeTF.text title:@"测试" navigation:self.navigationController];
}

- (IBAction)loginAction:(id)sender {
    
    isLogined = YES;
    
    if (self.loginSuccessBlock) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:NO];
            self.loginSuccessBlock();
        });

    }
}

- (IBAction)outLoginAction:(id)sender {
//    [SCUtilities postLoginOutNotification];
    isLogined = NO;

}


@end
