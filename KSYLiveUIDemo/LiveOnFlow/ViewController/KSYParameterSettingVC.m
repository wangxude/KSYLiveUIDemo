//
//  KSYParameterSettingVC.m
//  KSYLiveUIDemo
//
//  Created by 王旭 on 2017/11/8.
//  Copyright © 2017年 王旭. All rights reserved.
//

#import "KSYParameterSettingVC.h"
//单选按钮
#import "KSYRadioButton.h"

#import "KSYSettingPartView.h"

@interface KSYParameterSettingVC ()<KSYRadioButtonDelegate>

@end

@implementation KSYParameterSettingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setUpLabelAndRadioButton];
    // Do any additional setup after loading the view.
}

-(void)setUpLabelAndRadioButton{
    
    UITextField* putFlowTextField = [[UITextField alloc]init];
    putFlowTextField.frame = KSYScreen_Frame(10,30,KSYScreenWidth-20, 30);
    putFlowTextField.placeholder = LocalString(@"input_CurrentAddress");
    putFlowTextField.text = @"";
    putFlowTextField.layer.borderColor = KSYRGB(235, 235, 235).CGColor;
    putFlowTextField.layer.borderWidth = 1;
    [self.view addSubview:putFlowTextField];

    
    NSArray* pushFlowTitleArray = @[@"360P",@"480P",@"720P",@"1080P"];
    //推流分辨率
    KSYSettingPartView* resolutionView = [[KSYSettingPartView alloc]initWithFrame:KSYScreen_Frame(0, CGRectGetMaxY(putFlowTextField.frame)+10, KSYScreenWidth, 90)];
    [resolutionView setUptitleLabel:LocalString(@"pushFlow_Resolution") withRadioTitleArray:pushFlowTitleArray radioGroupId:@"resolutionGroup" delegate:self];
    resolutionView.layer.borderWidth = 0.5;
    resolutionView.layer.borderColor = KSYRGB(235, 235, 235).CGColor;
    [self.view addSubview:resolutionView];
    //直播场景
    NSArray* liveArray = @[@"通用",@"秀场",@"游戏"];
    KSYSettingPartView* liveView = [[KSYSettingPartView alloc]initWithFrame:KSYScreen_Frame(0, CGRectGetMaxY(resolutionView.frame), KSYScreenWidth, 90)];
    [liveView setUptitleLabel:LocalString(@"live_Scene") withRadioTitleArray:liveArray radioGroupId:@"liveGroup" delegate:self];
    liveView.layer.borderWidth = 0.5;
    liveView.layer.borderColor = KSYRGB(235, 235, 235).CGColor;
    [self.view addSubview:liveView];
    //性能模式
    NSArray* performanceArray = @[@"低耗能",@"均衡",@"高性能"];
    KSYSettingPartView* performanceView = [[KSYSettingPartView alloc]initWithFrame:KSYScreen_Frame(0, CGRectGetMaxY(liveView.frame), KSYScreenWidth, 90)];
    [performanceView setUptitleLabel:LocalString(@"performance_Model") withRadioTitleArray:performanceArray radioGroupId:@"performanceGroup" delegate:self];
    performanceView.layer.borderWidth = 0.5;
    performanceView.layer.borderColor = KSYRGB(235, 235, 235).CGColor;
    [self.view addSubview:performanceView];
    //确认配置按钮
    UIButton* determineConfigurationBtn = [UIButton buttonWithTitle:@"确认配置" titleColor:[UIColor whiteColor] font:KSYUIFont(15) backGroundColor:KSYRGB(236,69,84) target:self action:@selector(determineButtonEvent) backImageName:nil];
    [self.view addSubview:determineConfigurationBtn];
    [determineConfigurationBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(performanceView.mas_bottom).offset(30);
        make.width.mas_equalTo(@150);
        make.height.mas_equalTo(@40);
    }];
    
}

/**
 确认配置
 */
-(void)determineButtonEvent{
    
}
//点击
-(void)didSelectedRadioButton:(KSYRadioButton *)radioButton groupId:(NSString *)groupId{
    NSLog(@"%@,---%@",groupId,radioButton.titleLabel.text);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
