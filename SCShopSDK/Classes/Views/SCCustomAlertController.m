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
    // Do any additional setup after loading the view.
}


-(void)difNetAlertChangeNum:(void (^)(void))changeNum difNet:(void (^)(void))jumtDifNet{
    
    _changeNum = changeNum;
    _jumtDifNet = jumtDifNet;
    
    UIView *bgView = [[UIView alloc]init];
    bgView.backgroundColor = HEX_RGB(@"888888");
    bgView.layer.cornerRadius = 10;
    bgView.layer.masksToBounds = YES;
    [self.view addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(SCREEN_FIX(40));
        make.right.mas_equalTo(SCREEN_FIX(-40));
        make.bottom.mas_equalTo(SCREEN_FIX(-100));
    }];
    
    UIImageView *titleImg = [[UIImageView alloc]init];
    titleImg.image = [UIImage bundleImageNamed:@""];
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
    titleLab.textColor = HEX_RGB(@"555555");
    titleLab.font = [UIFont boldSystemFontOfSize:15];
    titleLab.textAlignment = NSTextAlignmentCenter;
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(bgView.mas_centerX);
        make.top.equalTo(titleImg.mas_bottom).mas_offset(15);
    }];
    
    UILabel *infoLab = [[UILabel alloc]init];
    [bgView addSubview:infoLab];
    infoLab.numberOfLines = 0;
    infoLab.text = @"服务须知";
    infoLab.font = [UIFont systemFontOfSize:14];
    infoLab.textColor = HEX_RGB(@"555555");
    infoLab.font = [UIFont boldSystemFontOfSize:15];
    infoLab.textAlignment = NSTextAlignmentCenter;
    [infoLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.top.equalTo(infoLab.mas_bottom).mas_offset(15);
    }];
    
    
    UIButton *difBtn = [[UIButton alloc]init];
       [bgView addSubview:difBtn];
       difBtn.backgroundColor = [UIColor lightGrayColor];
       [difBtn setTitle:@"去异网专区看看" forState:UIControlStateNormal];
        difBtn.titleLabel.font = [UIFont systemFontOfSize:12];
       [difBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
       difBtn.layer.cornerRadius = 5;
        [difBtn addTarget:self action:@selector(jumpDiffentNet) forControlEvents:UIControlEventTouchUpInside];
       [difBtn mas_makeConstraints:^(MASConstraintMaker *make) {
           make.left.mas_equalTo(50);
           make.right.mas_equalTo(-50);
           make.bottom.mas_equalTo(-30);
           make.height.mas_equalTo(50);
       }];
    
    
    UIButton *changeBtn = [[UIButton alloc]init];
    [bgView addSubview:changeBtn];
    changeBtn.backgroundColor = [UIColor blueColor];
    [changeBtn setTitle:@"换个号码登录" forState:UIControlStateNormal];
    changeBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [changeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    changeBtn.layer.cornerRadius = 5;
    [changeBtn addTarget:self action:@selector(changeNumLogin) forControlEvents:UIControlEventTouchUpInside];
    [changeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(difBtn.mas_top).mas_offset(-15);
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
