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
//点击空白视图
#import "KSYSubBlackView.h"
//截图提示框
#import "KSYToolTipsView.h"
//文件下载 工具
#import "KSYFileSelector.h"

@interface KSYUIStreamerVC (){
    KSYFileSelector * fileDownLoadTool;
}

@property(nonatomic,strong)NSArray* filePathArray;

@property(nonatomic,copy)NSURL* rtmpUrl;

@property(nonatomic,strong)NSDictionary* modelSenderDic;
//底部bottomView
@property(nonatomic,strong)UIView* bottomView;
//底部的录屏按钮的view
@property(nonatomic,strong)KSYSubBlackView* recordView;
//功能视图的view
@property(nonatomic,strong)KSYCustomCollectView * collectView;
//美颜的二级视图的view
@property(nonatomic,strong)KSYSecondView* skinCareView;
//顶部视图的view
@property(nonatomic,strong)UIView* topView;

//旁路录像文件的路径
@property(nonatomic,copy)NSString* byPassFilePath;

//镜像状态
@property(nonatomic,assign)BOOL mirrorState;
//静音状态
@property(nonatomic,assign)BOOL muteState;
@end

@implementation KSYUIStreamerVC

-(id)initWithUrl:(NSURL *)rtmpUrl{
    if (self = [super init]) {
        self.rtmpUrl = rtmpUrl;
       
    }
    return self;
}

-(NSDictionary*)modelSenderDic{
    if (!_modelSenderDic) {
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
    _wxStreamerKit.streamDimension =  model.strResolutionSize;;
    //性能模式
    _wxStreamerKit.streamerBase.videoEncodePerf = model.performanceModel;
    //直播场景
    _wxStreamerKit.streamerBase.liveScene = model.liveSence;

    //videoFPS (测试)
    _wxStreamerKit.streamerBase.videoFPS = 20;
    //扩展增强美颜滤镜
    _currentFilter = [[KSYGPUBeautifyExtFilter alloc]init];
    //摄像头的位置
    _wxStreamerKit.cameraPosition = AVCaptureDevicePositionBack;
    //视频输出格式
    _wxStreamerKit.gpuOutputPixelFormat = kCVPixelFormatType_32BGRA;
    //采集格式
    _wxStreamerKit.capturePixelFormat = kCVPixelFormatType_32BGRA;
    
    //
    _wxStreamerKit.streamerBase.videoInitBitrate =  800;
    _wxStreamerKit.streamerBase.videoMaxBitrate  = 1000;
    _wxStreamerKit.streamerBase.videoMinBitrate  =    0;
    _wxStreamerKit.streamerBase.audiokBPS        =   48;
    // 设置编码码率控制
    _wxStreamerKit.streamerBase.recScene     = KSYRecScene_ConstantQuality;
    //旁路录制会回调该block
    
    self.byPassFilePath =[NSHomeDirectory() stringByAppendingString:@"/Library/Caches/rec.mp4"];
    weakObj(self);
    _wxStreamerKit.streamerBase.bypassRecordStateChange = ^(KSYRecordState recordState) {
        [selfWeak onBypassRecordStateChange:recordState];
    };
    //开始采集的代码
    [self beginCapture];
    //开始推流
    [self streamFunc];
    
    //添加布局的代码
    [self addTopSubView];
    [self addCenterView];
    [self addBottomSubView];
    
    [self addObserver];
    
    NSArray* bgmPatternArray  = @[@".mp3", @".m4a", @".aac"];
    fileDownLoadTool  = [[KSYFileSelector alloc] initWithDir:@"/Documents/bgms/"
                                             andSuffix:bgmPatternArray];
    //下载背景音乐
    //NSString* path = fileDownLoadTool.filePath;
    self.filePathArray = fileDownLoadTool.fileList;
    NSLog(@"%@",self.filePathArray);
    if (self.filePathArray.count == 0) {
        NSString *urlStr = @"https://ks3-cn-beijing.ksyun.com/ksy.vcloud.sdk/Ios/bgm.aac";
        [fileDownLoadTool downloadFile:urlStr name:@"bgm.aac" ];
        urlStr = @"https://ks3-cn-beijing.ksyun.com/ksy.vcloud.sdk/Ios/test1.mp3";
        [fileDownLoadTool downloadFile:urlStr name:@"test1.mp3"];
        [fileDownLoadTool downloadFile:urlStr name:@"test2.mp3"];
        [fileDownLoadTool downloadFile:urlStr name:@"test3.mp3"];
       
        
    }
    
    
}
-(void)displayBottom:(NSNotification*)notice{
    self.bottomView.alpha = 1;
}
#pragma mark - 自定义的方法
/**
添加观察者,监听推流状态改变的通知
 */
-(void)addObserver{
    
    //监听底部按钮的view
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(displayBottom:) name:@"displayBottomView" object:nil];
    //监听推流状态
    NSNotificationCenter* notification = [NSNotificationCenter defaultCenter];
    [notification addObserver:self selector:@selector(streamStateChange:) name:KSYStreamStateDidChangeNotification object:nil];
    //监听采集状态的改变
//    [notification addObserver:self selector:@selector(onCaptureStateChange:) name:KSYCaptureStateDidChangeNotification object:nil];
    //监听背景音乐改变
     [notification addObserver:self selector:@selector(streamStateChange:) name:KSYStreamBackgroundMusicChangeNotice object:nil];
    //监听变声的通知
    [notification addObserver:self selector:@selector(streamVoiceChange:) name:KSYStreamVoiceNotice object:nil];

}
/**
 移除观察者
 */

-(void)removeObserver{
    [[NSNotificationCenter defaultCenter]removeObserver: self];
}

-(void)streamStateChange:(NSNotification*)notice{
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
#pragma mark - 监听变声的通知
-(void)streamVoiceChange:(NSNotification*)notice{
//    reverbType＝ 0;//关闭
//    reverbType ＝1;//录音棚
//    reverbType ＝2;//演唱会
//    reverbType ＝3;//KTV
//    reverbType ＝4;//小舞台
    
    KSYWeakSelf;
    NSDictionary* dic =notice.userInfo;
    for (NSString* string in [dic allKeys]) {
        if ([string isEqualToString:@"混响"]) {
            int  number = [[dic valueForKey:string] intValue];
            _wxStreamerKit.aCapDev.reverbType = number;
            
        }
        else if ([string isEqualToString:@"变声"]){
            int number = [[dic valueForKey:string] intValue];
            _wxStreamerKit.aCapDev.effectType = number;
        }
        else if ([string isEqualToString:@"背景音乐"]){
            int number = [[dic valueForKey:string] intValue];
            //停止播放背景音乐
            [_wxStreamerKit.bgmPlayer stopPlayBgm];
            if (number == 0) {
                return;
            }
            NSString* path = [NSHomeDirectory() stringByAppendingString:[NSString stringWithFormat:@"/Documents/bgms/%@",self.filePathArray[number-1]]];
           
            if (!path) {
                return;
            }
            [_wxStreamerKit.bgmPlayer startPlayBgm:path isLoop:NO];
            
        }
    }
}

#pragma mark - 旁路录制状态的改变
- (void) onBypassRecordStateChange: (KSYRecordState) newState {
    if (newState == KSYRecordStateRecording){
        NSLog(@"start bypass record");
    }
    else if (newState == KSYRecordStateStopped) {
        NSLog(@"stop bypass record");
        [self saveVideoToAlbum:_byPassFilePath];
       // _miscView.swBypassRec.on = NO;
    }
    else if (newState == KSYRecordStateError) {
        NSLog(@"bypass record error %@", _wxStreamerKit.streamerBase.bypassRecordErrorName);
    }
}
#pragma mark - bypass record & record
-(void) onBypassRecord:(BOOL)selectState{
    BOOL bRec = _wxStreamerKit.streamerBase.bypassRecordState == KSYRecordStateRecording;
    if (selectState){
        if ( _wxStreamerKit.streamerBase.isStreaming && !bRec){
            // 如果启动录像时使用和上次相同的路径,则会覆盖掉上一次录像的文件内容
            [KSYUIStreamerVC deleteFile:_byPassFilePath];
            NSURL *url =[[NSURL alloc] initFileURLWithPath:self.byPassFilePath];
            [_wxStreamerKit.streamerBase startBypassRecord:url];
            [[KSYToolTipsView shareInstance] showLabelLongTime:@"00:00"];
        }
        else {
            NSString * msg = @"推流过程中才能旁路录像";
            [self toast:msg time:1];
        }
    }
    else{
        [[KSYToolTipsView shareInstance] stopTimer];
        [_wxStreamerKit.streamerBase stopBypassRecord];
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
#pragma mark - 添加顶部视图
/** 添加顶部的按钮*/
-(void)addTopSubView{
    
    self.topView = [[UIView alloc]initWithFrame:KSYScreen_Frame(0, 0, KSYScreenWidth, KSYScreenHeight)];
    [self.view addSubview:self.topView];
    
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(10);
        make.top.equalTo(self.view).offset(30);
        make.width.equalTo(self.view);
        make.height.mas_equalTo(@40);
    }];
    
    KSYHeadControl* control = [[KSYHeadControl alloc]init];
    [self.topView addSubview:control];
    [control mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.topView).offset(10);
        make.top.equalTo(self.topView);
        make.width.mas_equalTo(@120);
        make.height.mas_equalTo(@40);
    }];
    
    
    
    UIButton* closeBtn = [[UIButton alloc]initButtonWithTitle:@"" titleColor:[UIColor whiteColor] font:KSYUIFont(14) backGroundColor:KSYRGB(112,87,78)  callBack:^(UIButton *sender) {
        NSLog(@"%@",@"关闭");
        //从父视图中移除
        [self.collectView removeFromSuperview];
        //移除美颜的二级视图
        [self.skinCareView removeFromSuperview];
        [self removeObserver];
        [_wxStreamerKit stopPreview];
        _wxStreamerKit = nil;
        [self dismissViewControllerAnimated:YES completion:nil];
        [[KSYToolTipsView shareInstance]removeSubView];
    }];
    [closeBtn setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
    [self.topView addSubview:closeBtn];
    
    [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.topView).offset(-10);
        make.top.equalTo(control.mas_top);
        make.width.mas_equalTo(@40);
        make.height.equalTo(control.mas_height);
    }];
    
    UIButton* flowAddressBtn = [[UIButton alloc]initButtonWithTitle:@"拉流地址" titleColor:[UIColor whiteColor] font:KSYUIFont(14) backGroundColor:KSYRGB(112,87,78)  callBack:^(UIButton *sender) {
        NSLog(@"%@",@"拉流地址");
    }];
    [self.topView addSubview:flowAddressBtn];
    
    [flowAddressBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(closeBtn.mas_left).offset(-10);
        make.top.equalTo(control.mas_top);
        make.width.mas_equalTo(@80);
        make.height.equalTo(control.mas_height);
    }];
}

/** 添加中间的按钮 */
-(void)addCenterView{
    
}

#pragma mark -  添加底部的按钮
-(void)addBottomSubView{
#pragma mark - 录屏的view
   //录屏的view
   self.recordView = [[KSYSubBlackView alloc]initWithFrame:KSYScreen_Frame(0, 0, KSYScreenWidth, KSYScreenHeight)];
    [self.view addSubview:self.recordView];

    //摄像头切换
    UIButton* screenShotBtn = [[UIButton alloc]initButtonWithTitle:@"截屏" titleColor:[UIColor whiteColor] font:KSYUIFont(14) backGroundColor:KSYRGB(112,87,78)  callBack:^(UIButton *sender) {
        
        //  如果有美颜滤镜, 可以从滤镜上获取截图(UIImage) 不带水印
        //GPUImageOutput * filter = self.ksyFilterView.curFilter;
        //  直接从预览mixer上获取截图(UIImage) 带水印
        GPUImageOutput * filter = _wxStreamerKit.vPreviewMixer;
        if (filter){
            [filter useNextFrameForImageCapture];
            UIImage * img =  filter.imageFromCurrentFramebuffer;
            [KSYUIBaseViewController saveImage: img
                            to: @"snap2.png" ];
            UIImageWriteToSavedPhotosAlbum(img,nil,nil,nil);
            [[KSYToolTipsView shareInstance] showLabelWithString:@"截图已保存至手机相册"];
        }
    }];
    [self.recordView addSubview:screenShotBtn];
    
    
   
    
    weakObj(self);
    UIButton* recordScreenBtn = [[UIButton alloc]initButtonWithTitle:@"" titleColor:[UIColor whiteColor] font:KSYUIFont(14) backGroundColor:KSYRGB(112,87,78)  callBack:^(UIButton *sender) {
        // 省略了部分非关键代码
       sender.selected = !sender.selected;
        if (sender.selected) {
            [selfWeak onBypassRecord:YES];
        }
        else{
            [selfWeak onBypassRecord:NO];
        }
    }];
    
    [recordScreenBtn setImage:[UIImage imageNamed:@"录屏白"] forState:UIControlStateNormal];
    [recordScreenBtn setImage:[UIImage imageNamed:@"录屏红"] forState:UIControlStateSelected];
    [self.recordView addSubview:recordScreenBtn];
    
    UIButton* cancelBtn = [[UIButton alloc]initButtonWithTitle:@"返回" titleColor:[UIColor whiteColor] font:KSYUIFont(14) backGroundColor:KSYRGB(112,87,78)  callBack:^(UIButton *sender) {
        recordScreenBtn.selected = NO;
        [[KSYToolTipsView shareInstance] stopTimer];
        self.recordView.alpha = 0;
        self.topView.alpha = 1;
        self.bottomView.alpha = 1;
    }];
    [self.recordView addSubview:cancelBtn];
    
    [screenShotBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.recordView).offset(10);
        make.width.mas_equalTo(@80);
        make.bottom.equalTo(self.recordView.mas_bottom).offset(-10);
        make.height.mas_equalTo(@40);
    }];
    [recordScreenBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.recordView);
        make.width.mas_equalTo(@80);
        make.bottom.equalTo(screenShotBtn.mas_bottom);
        make.height.equalTo(screenShotBtn.mas_height);
    }];
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).offset(-10);
        
        make.width.mas_equalTo(@80);
        make.bottom.equalTo(screenShotBtn.mas_bottom);
        make.height.equalTo(screenShotBtn.mas_height);
    }];
    
    self.recordView.alpha = 0;
 #pragma 底部视图
    
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
        //隐藏底部的视图和顶部的视图  显示录屏界面
        self.bottomView.alpha = 0;
        self.topView.alpha = 0;
        self.recordView.alpha = 1;
    }];
    [self.bottomView addSubview:recordBtn];
  
    float buttonWidth = (KSYScreenWidth-20)/4;
    //功能
    UIButton* funcButton =[[UIButton alloc]initButtonWithTitle:@"功能" titleColor:[UIColor whiteColor] font:KSYUIFont(14) backGroundColor:KSYRGB(112,87,78)  callBack:^(UIButton *sender) {
        NSLog(@"功能");
        //隐藏  底部按钮
      self.bottomView.alpha = 0;
      //镜像状态
      self.mirrorState = NO;
      //静音状态
        self.muteState = NO;
      self.collectView = [[KSYCustomCollectView alloc]init];
      self.collectView.titleBlock = ^(NSString *title) {
          if ([title isEqualToString:@"镜像"]) {
              selfWeak.mirrorState = !selfWeak.mirrorState;
              selfWeak.wxStreamerKit.streamerMirrored = selfWeak.mirrorState;
              selfWeak.wxStreamerKit.previewMirrored = selfWeak.mirrorState;
          }
          else if ([title isEqualToString:@"闪光灯"]){
              [selfWeak.wxStreamerKit toggleTorch];
          }
          else if([title isEqualToString:@"静音"]){
              selfWeak.muteState = !selfWeak.muteState;
              [selfWeak.wxStreamerKit.streamerBase muteStream:selfWeak.muteState];
          }
          else if ([title isEqualToString:@"背景图"]){
             // [selfWeak ]
          }
          
          
        };
        
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

#pragma mark - 点击当前view视图的touch事件
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    //判断当前视图是不是录屏视图
    if (self.recordView.alpha == 1) {
        
    }
    else{
    [self.collectView removeFromSuperview];
    [self.skinCareView removeFromSuperview];
    self.bottomView.alpha = 1;
    self.recordView.alpha = 0;
    self.topView.alpha = 1;
   }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
