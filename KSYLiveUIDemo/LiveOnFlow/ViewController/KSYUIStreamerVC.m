//
//  KSYUIStreamerVC.m
//  KSYLiveUIDemo
//
//  Created by 王旭 on 2017/11/9.
//  Copyright © 2017年 王旭. All rights reserved.
//

#import "KSYUIStreamerVC.h"
//九宫格View
#import "KSYCustomCollectView.h"
//头部的头像和名称
#import "KSYHeadControl.h"
//数据模型
#import "KSYSettingModel.h"
@interface KSYUIStreamerVC ()

@property(nonatomic,copy)NSURL* rtmpUrl;

@property(nonatomic,strong)NSDictionary* modelSenderDic;
//底部bottomView
@property(nonatomic,strong)UIView* bottomView;

@property(nonatomic,strong)KSYCustomCollectView * collectView;

@property(nonatomic,strong)KSYSecondView* skinCareView;

@end

@implementation KSYUIStreamerVC

-(id)initWithUrl:(NSURL *)rtmpUrl{
    if (self = [super init]) {
        self.rtmpUrl = rtmpUrl;
       
    }
    return self;
}

-(NSDictionary*)modelSenderDic{
    if (_modelSenderDic) {
         NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        _modelSenderDic = [NSDictionary dictionaryWithObjectsAndKeys:[defaults objectForKey:@"resolutionGroup"],@"resolutionGroup",[defaults objectForKey:@"liveGroup"],@"liveGroup",[defaults objectForKey:@"performanceGroup"],@"performanceGroup",[defaults objectForKey:@"collectGroup"],@"collectGroup",[defaults objectForKey:@"videoGroup"],@"videoGroup",[defaults objectForKey:@"audioGroup"],@"audioGroup",nil];
    }
    return _modelSenderDic;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    if (!_wxStreamerKit) {
        _wxStreamerKit = [[KSYGPUStreamerKit alloc]init];
    }
    
    KSYSettingModel* model = [KSYSettingModel modelWithDictionary:self.modelSenderDic];
    //音频编码器类型
    _wxStreamerKit.streamerBase.audioCodec = model.audioCodecType;
    //视频编码器类型
    _wxStreamerKit.streamerBase.videoCodec = model.videoCodecTpye;
    //推流分辨率
    //_wxStreamerKit.previewDimension = model.strResolutionSize;
    _wxStreamerKit.streamDimension = model.strResolutionSize;
    //性能模式
    _wxStreamerKit.streamerBase.videoEncodePerf = model.performanceModel;
    //直播场景
    _wxStreamerKit.streamerBase.liveScene = model.liveSence;

    //扩展增强美颜滤镜
    _currentFilter = [[KSYGPUBeautifyExtFilter alloc]init];
    //摄像头的位置
    _wxStreamerKit.cameraPosition = AVCaptureDevicePositionBack;
    //视频输出格式
    _wxStreamerKit.gpuOutputPixelFormat = kCVPixelFormatType_32BGRA;
    //采集格式
    _wxStreamerKit.capturePixelFormat = kCVPixelFormatType_32BGRA;
    [self beginCapture];
    //开始推流
    [self streamFunc];
    
    [self addTopSubView];
    [self addCenterView];
    [self addBottomSubView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(displayBottom:) name:@"displayBottomView" object:nil];
    // Do any additional setup after loading the view.
}
-(void)displayBottom:(NSNotification*)notice{
    self.bottomView.alpha = 1;
}
#pragma mark - 自定义的方法
/**
添加观察者,监听推流状态改变的通知
 */
-(void)addObserver{
    NSNotificationCenter* notification = [NSNotificationCenter defaultCenter];
    [notification addObserver:self selector:@selector(streamStateChange) name:KSYStreamStateDidChangeNotification object:nil];
/**
 移除观察者
 */
}
-(void)removeObserver{
    [[NSNotificationCenter defaultCenter]removeObserver: self];
}
-(void)streamStateChange{
    switch (_wxStreamerKit.streamerBase.streamState) {
        case KSYStreamStateIdle:
            NSLog(@"-----%@",@"空闲状态");
            break;
        case KSYStreamStateConnected:
            NSLog(@"----%@",@"连接中");
            break;
        case KSYStreamStateDisconnecting:
            NSLog(@"----%@",@"断开连接中");
        default:
            NSLog(@"----%@",@"发生错误");
            break;
    }
}

/**
 开始预览
 */
-(void)beginCapture{
    if (!_wxStreamerKit.vCapDev.isRunning) {
        _wxStreamerKit.videoOrientation = [[UIApplication sharedApplication]statusBarOrientation];
        [_wxStreamerKit setupFilter:_currentFilter];
        //启动预览
        [_wxStreamerKit startPreview:self.view];
    }
    else{
        [_wxStreamerKit stopPreview];
    }
}

/**
 开始推流
 */
-(void)streamFunc{
    if (_wxStreamerKit.streamerBase.streamState == KSYStreamStateIdle || _wxStreamerKit.streamerBase.streamState == KSYStreamStateError) {
        //启动推流
        [_wxStreamerKit.streamerBase startStream:_rtmpUrl];
    }
    else{
        [_wxStreamerKit stopPreview];
    }
}

/**
 添加顶部的按钮
 */
-(void)addTopSubView{
    KSYHeadControl* control = [[KSYHeadControl alloc]init];
    [self.view addSubview:control];
    [control mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(10);
        make.top.equalTo(self.view).offset(30);
        make.width.mas_equalTo(@120);
        make.height.mas_equalTo(@40);
    }];
    
    
    
    UIButton* closeBtn = [[UIButton alloc]initButtonWithTitle:@"" titleColor:[UIColor whiteColor] font:KSYUIFont(14) backGroundColor:KSYRGB(112,87,78)  callBack:^(UIButton *sender) {
        NSLog(@"%@",@"关闭");
        //从父视图中移除
        [self.collectView removeFromSuperview];
        [self dismissViewControllerAnimated:YES completion:nil];
        [self removeObserver];
        [_wxStreamerKit stopPreview];
        _wxStreamerKit = nil;
    }];
    [closeBtn setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
    [self.view addSubview:closeBtn];
    
    [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).offset(-10);
        make.top.equalTo(control.mas_top);
        make.width.mas_equalTo(@40);
        make.height.equalTo(control.mas_height);
    }];
    
    UIButton* flowAddressBtn = [[UIButton alloc]initButtonWithTitle:@"拉流地址" titleColor:[UIColor whiteColor] font:KSYUIFont(14) backGroundColor:KSYRGB(112,87,78)  callBack:^(UIButton *sender) {
        NSLog(@"%@",@"拉流地址");
    }];
    [self.view addSubview:flowAddressBtn];
    
    [flowAddressBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(closeBtn.mas_left).offset(-10);
        make.top.equalTo(control.mas_top);
        make.width.mas_equalTo(@80);
        make.height.equalTo(control.mas_height);
    }];
}

/**
 添加中间的按钮
 */
-(void)addCenterView{
    
}
/**
 添加底部的按钮
 */
-(void)addBottomSubView{
    
   
   
    
    
    self.bottomView = [[UIView alloc]init];
    [self.view addSubview:self.bottomView];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.width.equalTo(self.view);
        make.bottom.equalTo(self.view);
        make.height.mas_equalTo(50);
    }];
    //美颜按钮
    
    UIButton* skinCareBtn = [[UIButton alloc]initButtonWithTitle:@"美颜" titleColor:[UIColor whiteColor] font:KSYUIFont(14) backGroundColor:KSYRGB(112,87,78)  callBack:^(UIButton *sender) {
        NSLog(@"%@",@"美颜");
        self.skinCareView = [[KSYSecondView alloc]init];
        self.skinCareView.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.2];
        NSArray* titleArray = @[@"美颜",@"滤镜",@"贴纸"];
        
        [self.skinCareView setUpSubView:titleArray viewHeight:200];
        self.skinCareView.voiceArray = [[NSArray alloc]initWithObjects:@"无",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",nil];
        [self.skinCareView showSecondView];
        //隐藏底部视图
        self.bottomView.alpha = 0;

    }];
    [self.bottomView addSubview:skinCareBtn];
    
    
    //摄像头切换
    UIButton* caremaBtn = [[UIButton alloc]initButtonWithTitle:@"摄像头切换" titleColor:[UIColor whiteColor] font:KSYUIFont(14) backGroundColor:KSYRGB(112,87,78)  callBack:^(UIButton *sender) {
        NSLog(@"摄像头切换");
        [_wxStreamerKit switchCamera];
        
    }];
    [self.bottomView addSubview:caremaBtn];
    
    //录屏
    UIButton* recordBtn = [[UIButton alloc]initButtonWithTitle:@"录屏/截屏" titleColor:[UIColor whiteColor] font:KSYUIFont(14) backGroundColor:KSYRGB(112,87,78)  callBack:^(UIButton *sender) {
        NSLog(@"录屏");
        [_wxStreamerKit.streamerBase stopStream];
        NSString *url = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/RecordAv.mp4"];
        NSURL *hostURL =[[NSURL alloc] initFileURLWithPath:url];
        
        [_wxStreamerKit.streamerBase startStream:hostURL];
        
        
    }];
    [self.bottomView addSubview:recordBtn];
  
    float buttonWidth = (KSYScreenWidth-20)/4;
    //功能
    UIButton* funcButton =[[UIButton alloc]initButtonWithTitle:@"功能" titleColor:[UIColor whiteColor] font:KSYUIFont(14) backGroundColor:KSYRGB(112,87,78)  callBack:^(UIButton *sender) {
        NSLog(@"功能");
        //隐藏   底部按钮
      self.bottomView.alpha = 0;
      
      self.collectView = [[KSYCustomCollectView alloc]init];
      self.collectView.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.2];
      [self.collectView showView];
    }];
    [self.bottomView addSubview:funcButton];

    //布局代码
    [skinCareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bottomView).offset(5);
        make.bottom.equalTo(self.bottomView).offset(-10);
        make.width.mas_equalTo(buttonWidth);
        make.height.mas_equalTo(@40);
    }];
    [caremaBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(skinCareBtn.mas_right).offset(5);
        
        make.width.mas_equalTo(buttonWidth);
        make.bottom.equalTo(skinCareBtn.mas_bottom);
        make.height.equalTo(skinCareBtn.mas_height);
    }];
    [recordBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(caremaBtn.mas_right).offset(5);
        
        make.width.mas_equalTo(buttonWidth);
        make.bottom.equalTo(skinCareBtn.mas_bottom);
        make.height.equalTo(skinCareBtn.mas_height);
    }];
    [funcButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).offset(-5);
        
        make.width.mas_equalTo(buttonWidth);
        make.bottom.equalTo(skinCareBtn.mas_bottom);
        make.height.equalTo(skinCareBtn.mas_height);
    }];
  
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.collectView removeFromSuperview];
    [self.skinCareView removeFromSuperview];
    self.bottomView.alpha = 1;
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
