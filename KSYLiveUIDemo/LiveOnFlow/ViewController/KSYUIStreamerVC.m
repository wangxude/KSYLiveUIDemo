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

@interface KSYUIStreamerVC ()

@property(nonatomic,copy)NSURL* rtmpUrl;

@end

@implementation KSYUIStreamerVC

-(id)initWithUrl:(NSURL *)rtmpUrl{
    if (self = [super init]) {
        self.rtmpUrl = rtmpUrl;
       
    }
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    if (!_wxStreamerKit) {
        _wxStreamerKit = [[KSYGPUStreamerKit alloc]init];
    }
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
    
    // Do any additional setup after loading the view.
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
    
    //美颜按钮
    UIButton* skinCareBtn = [[UIButton alloc]initButtonWithTitle:@"美颜" titleColor:[UIColor whiteColor] font:KSYUIFont(14) backGroundColor:KSYRGB(112,87,78)  callBack:^(UIButton *sender) {
        NSLog(@"%@",@"美颜");
    }];
    [self.view addSubview:skinCareBtn];
    
    
    //摄像头切换
    UIButton* caremaBtn = [[UIButton alloc]initButtonWithTitle:@"摄像头切换" titleColor:[UIColor whiteColor] font:KSYUIFont(14) backGroundColor:KSYRGB(112,87,78)  callBack:^(UIButton *sender) {
        NSLog(@"摄像头切换");
        [_wxStreamerKit switchCamera];
        
    }];
    [self.view addSubview:caremaBtn];
    
    
    UIButton* recordBtn = [[UIButton alloc]initButtonWithTitle:@"录屏/截屏" titleColor:[UIColor whiteColor] font:KSYUIFont(14) backGroundColor:KSYRGB(112,87,78)  callBack:^(UIButton *sender) {
        NSLog(@"录屏");
    }];
    [self.view addSubview:recordBtn];
  
    float buttonWidth = (KSYScreenWidth-20)/4;
    
    UIButton* funcButton =[[UIButton alloc]initButtonWithTitle:@"功能" titleColor:[UIColor whiteColor] font:KSYUIFont(14) backGroundColor:KSYRGB(112,87,78)  callBack:^(UIButton *sender) {
        NSLog(@"功能");
        KSYCustomCollectView* collectView = [[KSYCustomCollectView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        //collectView.backgroundColor = [UIColor redColor];
        [collectView showView];
    }];
    [self.view addSubview:funcButton];

    
    [skinCareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(5);
        make.bottom.equalTo(self.view).offset(-10);
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
//    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
