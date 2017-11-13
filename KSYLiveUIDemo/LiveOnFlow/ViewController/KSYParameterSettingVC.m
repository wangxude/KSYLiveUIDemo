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
//设置的scrollView
@property(nonatomic,weak)UIScrollView* settingScrollView;
//推流地址
@property(nonatomic,copy)NSString* streamAddress;


@end

@implementation KSYParameterSettingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIScrollView* scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 10, KSYScreenWidth, KSYScreenHeight)];
    scrollView.backgroundColor = [UIColor whiteColor];
    scrollView.contentSize = CGSizeMake(0, KSYScreenHeight*1.5);
    [self.view addSubview:scrollView];
    self.settingScrollView = scrollView;
    
    [self setUpLabelAndRadioButton];
    // Do any additional setup after loading the view.
}

-(void)setUpLabelAndRadioButton{
    //推流地址
    NSString * uuidStr =[[[UIDevice currentDevice] identifierForVendor] UUIDString];
    NSString *devCode  = [[uuidStr substringToIndex:3] lowercaseString];
    NSLog(@"%@",devCode);
    //推流地址
    NSString *streamSrv  = @"rtmp://test.uplive.ks-cdn.com/live";
    NSString *streamUrl      = [ NSString stringWithFormat:@"%@/%@", streamSrv, devCode];
    self.streamAddress = streamUrl;
    //推流textField
    UITextField* putFlowTextField = [[UITextField alloc]init];
    putFlowTextField.frame = KSYScreen_Frame(10,30,KSYScreenWidth-20, 30);
    putFlowTextField.placeholder = LocalString(@"input_CurrentAddress");
    putFlowTextField.text = @"";
    putFlowTextField.layer.borderColor = KSYRGB(235, 235, 235).CGColor;
    putFlowTextField.layer.borderWidth = 1;
    [self.settingScrollView addSubview:putFlowTextField];
    putFlowTextField.text = self.streamAddress;

    
    
    NSArray* pushFlowTitleArray = @[@"360P",@"480P",@"720P"];
    //推流分辨率
    KSYSettingPartView* resolutionView = [[KSYSettingPartView alloc]initWithFrame:KSYScreen_Frame(0, CGRectGetMaxY(putFlowTextField.frame)+10, KSYScreenWidth, 90)];
    [resolutionView setUptitleLabel:LocalString(@"pushFlow_Resolution") withRadioTitleArray:pushFlowTitleArray radioGroupId:@"resolutionGroup" delegate:self];
    resolutionView.layer.borderWidth = 0.5;
    resolutionView.layer.borderColor = KSYRGB(235, 235, 235).CGColor;
    [self.settingScrollView addSubview:resolutionView];
    //直播场景
    NSArray* liveArray = @[@"通用",@"秀场",@"游戏"];
    KSYSettingPartView* liveView = [[KSYSettingPartView alloc]initWithFrame:KSYScreen_Frame(0, CGRectGetMaxY(resolutionView.frame), KSYScreenWidth, 90)];
    [liveView setUptitleLabel:LocalString(@"live_Scene") withRadioTitleArray:liveArray radioGroupId:@"liveGroup" delegate:self];
    liveView.layer.borderWidth = 0.5;
    liveView.layer.borderColor = KSYRGB(235, 235, 235).CGColor;
    [self.settingScrollView addSubview:liveView];
    //性能模式
    NSArray* performanceArray = @[@"低耗能",@"均衡",@"高性能"];
    KSYSettingPartView* performanceView = [[KSYSettingPartView alloc]initWithFrame:KSYScreen_Frame(0, CGRectGetMaxY(liveView.frame), KSYScreenWidth, 90)];
    [performanceView setUptitleLabel:LocalString(@"performance_Model") withRadioTitleArray:performanceArray radioGroupId:@"performanceGroup" delegate:self];
    performanceView.layer.borderWidth = 0.5;
    performanceView.layer.borderColor = KSYRGB(235, 235, 235).CGColor;
    [self.settingScrollView addSubview:performanceView];
    //采集分辨率"collect_Resolution" = "采集分辨率";
//    "video_encoder" = "视频编码器"
//    "audio_encoder" = "音频编码器";
    NSArray* collectTitleArray = @[@"360P",@"480P",@"720P"];
    KSYSettingPartView* collectView = [[KSYSettingPartView alloc]initWithFrame:KSYScreen_Frame(0, CGRectGetMaxY(performanceView.frame), KSYScreenWidth, 90)];
    [collectView setUptitleLabel:LocalString(@"collect_Resolution") withRadioTitleArray:collectTitleArray radioGroupId:@"collectGroup" delegate:self];
    collectView.layer.borderWidth = 0.5;
    collectView.layer.borderColor = KSYRGB(235, 235, 235).CGColor;
    [self.settingScrollView addSubview:collectView];
    //视频编码器自动/H.264（软编）/H.264（硬编）/H.265（软编）

    NSArray* videoEncoderArray = @[@"自动",@"软264",@"硬264",@"软265"];
    KSYSettingPartView* videoEncoderView = [[KSYSettingPartView alloc]initWithFrame:KSYScreen_Frame(0, CGRectGetMaxY(collectView.frame), KSYScreenWidth, 90)];
    [videoEncoderView setUptitleLabel:LocalString(@"video_encoder") withRadioTitleArray:videoEncoderArray radioGroupId:@"videoGroup" delegate:self];
    videoEncoderView.layer.borderWidth = 0.5;
    videoEncoderView.layer.borderColor = KSYRGB(235, 235, 235).CGColor;
    [self.settingScrollView addSubview:videoEncoderView];
    //音频编码器
    NSArray* audioEncoderArray = @[@"AAC LC",@"AAC HE",@"AACHEv2"];
    KSYSettingPartView* audioEncoderView = [[KSYSettingPartView alloc]initWithFrame:KSYScreen_Frame(0, CGRectGetMaxY(videoEncoderView.frame), KSYScreenWidth, 90)];
    [audioEncoderView setUptitleLabel:LocalString(@"audio_encoder") withRadioTitleArray:audioEncoderArray radioGroupId:@"audioGroup" delegate:self];
    audioEncoderView.layer.borderWidth = 0.5;
    audioEncoderView.layer.borderColor = KSYRGB(235, 235, 235).CGColor;
    [self.settingScrollView addSubview:audioEncoderView];
    
    //确认配置按钮
    UIButton* determineConfigurationBtn = [UIButton buttonWithTitle:@"确认配置" titleColor:[UIColor whiteColor] font:KSYUIFont(15) backGroundColor:KSYRGB(236,69,84) target:self action:@selector(determineButtonEvent) backImageName:nil];
    [self.settingScrollView addSubview:determineConfigurationBtn];
    [determineConfigurationBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(audioEncoderView.mas_bottom).offset(30);
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
    [[NSUserDefaults standardUserDefaults] setValue:radioButton.titleLabel.text forKey:groupId];
    
    
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
