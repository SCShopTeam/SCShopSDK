//
//  SCAddAddressController.m
//  shopping
//
//  Created by zhangtao on 2020/7/15.
//  Copyright © 2020 jsmcc. All rights reserved.
//

#import "SCAddAddressController.h"
#import "SCAddressSelectView.h"
#import "SCAlertViewController.h"
@interface SCAddAddressController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property(nonatomic,strong)SCAddressModel *editModel;
@property(nonatomic,strong)UITableView    *table;


@end

@implementation SCAddAddressController
{
    
    NSArray *leftArr;
    UITextField *nametf;
    UITextField *phonetf;
    UITextField *areatf;
    UIButton *selectAreaBtn;
    UITextField *detailtf;
    
    BOOL isDefault;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = HEX_RGB(@"#F7F7F7");
    self.title  = @"新建地址";
    leftArr = @[@"收货人",@"手机号码",@"所在地区",@"详细地址"];
    _table = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-100 -STATUS_BAR_HEIGHT) style:UITableViewStyleGrouped];
    [self.view addSubview:_table];
    _table.backgroundColor = HEX_RGB(@"#F7F7F7");
    _table.delegate = self;
    _table.dataSource = self;
    [_table mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(self.view);
        make.bottom.mas_equalTo(90);
    }];
    
    _table.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tableTap)];
    [_table addGestureRecognizer:tap];
    
    UIButton *add = [[UIButton alloc]init];
    [self.view addSubview:add];
    add.backgroundColor = HEX_RGB(@"#F2180B");
    add.titleLabel.textColor = [UIColor whiteColor];
    add.titleLabel.font = [UIFont systemFontOfSize:15];
    [add setTitle:@"保存" forState:UIControlStateNormal];
    add.layer.cornerRadius = 17;
    add.layer.masksToBounds = YES;
    [add addTarget:self action:@selector(saveAddress) forControlEvents:UIControlEventTouchUpInside];
    
    [add mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(30);
        make.right.mas_equalTo(-30);
        make.bottom.mas_equalTo(-50);
        make.height.mas_equalTo(34);
    }];
    
    if (@available (iOS 11.0,*)) {
        _table.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else{
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}

-(void)tableTap{
    [nametf resignFirstResponder];
    [phonetf resignFirstResponder];
    [detailtf resignFirstResponder];
    
}

-(void)setAddressNum:(NSString *)addressNum{
    __weak typeof(self)weakSelf = self;
    [self showLoading];
    if ([SCUtilities isValidString:addressNum]) {
        [SCRequest scAddressDetail:addressNum block:^(BOOL success, NSDictionary * _Nullable objDic, NSString * _Nullable errMsg) {
            [self stopLoading];
            if (success && [SCUtilities isValidDictionary:objDic]) {
                weakSelf.editModel = [SCAddressModel yy_modelWithDictionary:objDic];            }
            if (weakSelf.table) {
                [weakSelf.table reloadData];
            }
        }];
    }
}


-(void)saveAddress{
    _editModel.realName = nametf.text;
    _editModel.mobile = phonetf.text;
    _editModel.detail = detailtf.text;
    if (![SCUtilities isValidString:_editModel.realName] ||
        ![SCUtilities isValidString:_editModel.mobile] ||
        ![SCUtilities isValidString:_editModel.provinceName] ||
        ![SCUtilities isValidString:_editModel.cityName] ||
        /*![SCUtilities isValidString:_editModel.regionName] ||*/
        ![SCUtilities isValidString:_editModel.detail]) {
        NSString *msg = @"";
       
        
        if (![SCUtilities isValidString:nametf.text]){
            msg = @"请填写姓名";
        } else if(![SCUtilities isValidString:phonetf.text]){
            msg = @"请输入联系号码";
        }else if (![SCUtilities isValidString:areatf.text]){
            msg = @"请选择所在省市区";
        }else  if (![SCUtilities isValidString:detailtf.text]) {
            msg = @"请输入小区楼栋";
        }
        SCAlertViewController *alert = [SCAlertViewController alertControllerWithTitle:@"提示" message:msg preferredStyle:UIAlertControllerStyleAlert];
        [alert showAlertAct1:nil act2:@"确定" act1Back:nil act2Back:nil];
        [self presentViewController:alert animated:YES completion:nil];
 
        
    }else{
        NSMutableDictionary *param = [_editModel yy_modelToJSONObject];
        if (_editModel.isDefault) {
            param[@"default"] = [NSNumber numberWithInteger:1];
        }else{
            param[@"default"] = [NSNumber numberWithInteger:0];
        }
        [self showLoading];
        [SCRequest scAddressEdit:param block:^(BOOL success, NSDictionary * _Nullable objDic, NSString * _Nullable errMsg) {
            [self stopLoading];
            if (success) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"EDIT_ADDRESS_SUCCESS" object:nil];
                [self.navigationController popViewControllerAnimated:YES];
            }
        }];
    }
    
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return leftArr.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 50;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return .1;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = leftArr[indexPath.row];
    switch (indexPath.row) {
        case 0:
            nametf = [self createTF:@"请填写姓名"];
            [cell addSubview:nametf];
            if (_editModel) {
                nametf.text = _editModel.realName;
            }
        break;
        case 1:
            phonetf = [self createTF:@"请输入联系号码"];
            [cell addSubview:phonetf];
            if (_editModel) {
                phonetf.text = _editModel.mobile;
                phonetf.keyboardType = UIKeyboardTypeNumberPad;
            }
        break;
        case 2:
            areatf = [self createTF:@"请选择所在省市区"];
            [cell addSubview:areatf];
            
            selectAreaBtn = [[UIButton alloc]initWithFrame:areatf.frame];
            [cell addSubview:selectAreaBtn];
            [selectAreaBtn addTarget:self action:@selector(showSelectAreaView) forControlEvents:UIControlEventTouchUpInside];
            selectAreaBtn.backgroundColor = [UIColor clearColor];
            
            if (_editModel) {
                NSString *address = @"";
                if ([SCUtilities isValidString:_editModel.provinceName]) {
                    address = [address stringByAppendingString:_editModel.provinceName];
                }
                if ([SCUtilities isValidString:_editModel.cityName]) {
                    address = [address stringByAppendingString:_editModel.cityName];
                }
                if ([SCUtilities isValidString:_editModel.regionName]) {
                    address = [address stringByAppendingString:_editModel.regionName];
                }
                areatf.text = address;
            }
//            areatf.delegate = self;
            areatf.enabled = NO;
        break;
        case 3:
            detailtf = [self createTF:@"请输入小区楼栋"];
            [cell addSubview:detailtf];
            if (_editModel) {
                detailtf.text = _editModel.detail;
            }
        break;
            
        default:
            break;
    }
    
    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
    view.backgroundColor = [UIColor clearColor];
    
    UIButton *defaultBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-130, 15, 20, 20)];
    defaultBtn.backgroundColor = [UIColor clearColor];
    [view addSubview:defaultBtn];
    if (_editModel) {
        isDefault = _editModel.isDefault;
        defaultBtn.selected = isDefault;

    }
    [defaultBtn setImage:[UIImage bundleImageNamed:@"home_login_uncheck"] forState:UIControlStateNormal];
    [defaultBtn setImage:[UIImage bundleImageNamed:@"home_login_check"] forState:UIControlStateSelected];
    [defaultBtn addTarget:self action:@selector(choseDefault:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-100, 18, 80, 13)];
    lab.text = @"设为默认地址";
    lab.font = [UIFont systemFontOfSize:13];
    lab.textColor = HEX_RGB(@"#333333");
    [view addSubview:lab];
    
    
    return view;
}

//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    if (indexPath.row == 2) {
//        [self showSelectAreaView];
//    }
//}


-(void)choseDefault:(UIButton *)sender{
    UIButton *btn = sender;
    btn.selected = !btn.selected;
    isDefault = btn.selected;
    _editModel.isDefault = isDefault;
}

-(UITextField *)createTF:(NSString *)placeholder{
    UITextField *tf = [[UITextField alloc]initWithFrame:CGRectMake(100, 0, self.view.frame.size.width-115, 45)];
    tf.font = [UIFont systemFontOfSize:15];
    tf.placeholder = placeholder;
    tf.textAlignment = NSTextAlignmentRight;
    return tf;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (textField == areatf) {
        [self showSelectAreaView];
        return NO;
    }
    
    return YES;
}

-(void)showSelectAreaView{
            if (!self.editModel) {
                self.editModel = [[SCAddressModel alloc]init];
            }
            [self tableTap];
            __weak typeof(self.editModel)wkmodel = self.editModel;
            [SCAddressSelectView show:^(SCAddressModel * _Nonnull addressModel) {
                NSLog(@"...");
                wkmodel.provinceNum = addressModel.provinceNum;
                wkmodel.provinceName = addressModel.provinceName;
                
                wkmodel.cityNum = addressModel.cityNum;
                wkmodel.cityName = addressModel.cityName;
                
                wkmodel.regionNum = addressModel.regionNum;
                wkmodel.regionName = addressModel.regionName;
    //            [self.table reloadData];
                [self.table reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:2 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            }];
}

@end
