//
//  SCCustomAlertController.m
//  shopping
//
//  Created by zhangtao on 2020/9/14.
//  Copyright © 2020 jsmcc. All rights reserved.
//

#import "SCCustomAlertController.h"

@interface SCCustomAlertController ()
@property(nonatomic,copy)void(^changeNum)(void);
@property(nonatomic,copy)void(^jumtDifNet)(void);

@end

@implementation SCCustomAlertController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = HEX_RGB(@"#EDEBED");
}


-(void)difNetAlertChangeNum:(void (^)(void))changeNum difNet:(void (^)(void))jumtDifNet{
    
    _changeNum = changeNum;
    _jumtDifNet = jumtDifNet;
    
    UIView *bgView = [[UIView alloc]init];
    bgView.backgroundColor = HEX_RGB(@"#FFFFFF");
    bgView.layer.cornerRadius = 10;
    bgView.layer.masksToBounds = YES;
    [self.view addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(SCREEN_FIX(100));
        make.left.mas_equalTo(SCREEN_FIX(38));
        make.right.mas_equalTo(SCREEN_FIX(-38));
        make.bottom.mas_equalTo(SCREEN_FIX(-100));
    }];
    
    UIImageView *titleImg = [[UIImageView alloc]init];
    titleImg.image = [UIImage bundleImageNamed:@"sc_login_alert_img"];
    [bgView addSubview:titleImg];
    [titleImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(bgView.mas_centerX);
        make.top.mas_equalTo(SCREEN_FIX(30));
        make.width.height.mas_equalTo(SCREEN_FIX(50));
    }];
    
    UILabel *titleLab = [[UILabel alloc]init];
    [bgView addSubview:titleLab];
    titleLab.text = @"服务须知";
    titleLab.font = [UIFont systemFontOfSize:14];
    titleLab.textColor = HEX_RGB(@"#333333");
    titleLab.font = [UIFont boldSystemFontOfSize:20];
    titleLab.textAlignment = NSTextAlignmentCenter;
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(bgView.mas_centerX);
        make.top.equalTo(titleImg.mas_bottom).mas_offset(15);
    }];
    
    UILabel *infoLab = [[UILabel alloc]init];
    [bgView addSubview:infoLab];
    infoLab.numberOfLines = 0;
    infoLab.font = [UIFont systemFontOfSize:14];
    infoLab.font = [UIFont fontWithName:@"Hiragino Sans GB" size:14];
    infoLab.textColor = HEX_RGB(@"#000000");
    infoLab.text = @"尊敬的用户，您好！\n      江苏移动商城平台提供的商品购买、业务订购等和平台经营活动相关的服务，目前仅支持“中国移动用户”参与享受，非中国移动登陆用户暂时无法享受完整的平台服务。您可以选择切换移动号码登录后下单，不便之处，敬请谅解！";

//    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@"尊敬的用户，您好！\n      江苏移动商城平台提供的商品购买、业务订购等和平台经营活动相关的服务，目前仅支持“中国移动用户”参与享受，非中国移动登陆用户暂时无法享受完整的平台服务。您可以选择切换移动号码登录后下单，不便之处，敬请谅解！" attributes:@{NSFontAttributeName: [UIFont fontWithName:@"Hiragino Sans GB" size: 14],NSForegroundColorAttributeName: [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:1.0]}];
//
//    infoLab.attributedText = string;


    [infoLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(SCREEN_FIX(37));
        make.right.mas_equalTo(SCREEN_FIX(-37));
        make.top.equalTo(titleLab.mas_bottom).mas_offset(SCREEN_FIX(23));
    }];
    
    
    UIButton *difBtn = [[UIButton alloc]init];
       [bgView addSubview:difBtn];
       difBtn.backgroundColor = HEX_RGB(@"#EDEBED");
       [difBtn setTitle:@"去异网专区看看" forState:UIControlStateNormal];
        difBtn.titleLabel.font = [UIFont systemFontOfSize:15];
       [difBtn setTitleColor:HEX_RGB(@"#333333") forState:UIControlStateNormal];
       difBtn.layer.cornerRadius = 5;
        [difBtn addTarget:self action:@selector(jumpDiffentNet) forControlEvents:UIControlEventTouchUpInside];
       [difBtn mas_makeConstraints:^(MASConstraintMaker *make) {
           make.left.mas_equalTo(SCREEN_FIX(78.5));
           make.right.mas_equalTo(SCREEN_FIX(-78.5));
           make.bottom.mas_equalTo(SCREEN_FIX(-37.5));
           make.height.mas_equalTo(SCREEN_FIX(35));
       }];
    
    
    UIButton *changeBtn = [[UIButton alloc]init];
    [bgView addSubview:changeBtn];
    changeBtn.backgroundColor = HEX_RGB(@"#0195FF");
    [changeBtn setTitle:@"换个号码登录" forState:UIControlStateNormal];
    changeBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [changeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    changeBtn.layer.cornerRadius = 5;
    [changeBtn addTarget:self action:@selector(changeNumLogin) forControlEvents:UIControlEventTouchUpInside];
    [changeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(difBtn.mas_top).mas_offset(SCREEN_FIX(-16));
        make.left.equalTo(difBtn.mas_left);
        make.right.equalTo(difBtn.mas_right);
        make.height.mas_equalTo(difBtn.mas_height);
    }];
    
}
-(void)jumpDiffentNet{
    [self.navigationController popViewControllerAnimated:NO];
//    [self popoverPresentationController];
    self.jumtDifNet();
}
-(void)changeNumLogin{
    [self.navigationController popViewControllerAnimated:NO];

//    [self popoverPresentationController];
    self.changeNum();
    
}

@end
