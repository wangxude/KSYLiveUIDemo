//
//  KSYBrushLiveVC.m
//  KSYLiveUIDemo
//
//  Created by 王旭 on 2017/11/19.
//  Copyright © 2017年 王旭. All rights reserved.
//

#import "KSYBrushLiveVC.h"
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
//画笔视图
#import "KSYDrawingView.h"

#import "UIView+Extension.h"

//文件下载 工具
#import "KSYFileSelector.h"
//解码gif图片需要的库
#import <YYImage/YYImage.h>

//滑块的view视图
#import "KSYSliderView.h"

#import "ZipArchive.h"

#import "KSYDecalBGView.h"

#import "KSYQRCode.h"

@interface KSYBrushLiveVC (){
    //静态图标
    GPUImagePicture *_logoPicure;
    //图片的方向
    UIImageOrientation _logoOrientation;
    //解码器
    YYImageDecoder  * _animateDecoder;
    //加锁
    NSLock          *_dlLock;
    NSTimeInterval   _dlTime;
    //跟屏幕刷新频率一样的定时器
    CADisplayLink   *_displayLink;
    //动画的索引
    int _animateIdx;
 
}

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
//画笔视图
@property(nonatomic,strong)KSYDrawingView *drawView;

//滤镜贴纸数组
@property(nonatomic,strong)NSArray* filterImageArray;

@property(nonatomic,strong)UIView* decalBackGroundView;

@property(nonatomic,readonly) KSYDecalBGView *decalBGView;

//贴纸图片数组
@property(nonatomic,strong)NSArray* tiezhiArray;


//创建5个全局的模块
//美颜slider  view视图
@property(nonatomic,strong)UIView* skinSliderView;
@property(nonatomic,strong)UIView* backgroundSliderView;

//音量
@property(nonatomic,strong)KSYSliderView* volumnSlider;
//音调
@property(nonatomic,strong)KSYSliderView* voiceSlider;
//磨皮
@property(nonatomic,strong)KSYSliderView* exfoliatingSlider;
//美白滑块
@property(nonatomic,strong)KSYSliderView* whiteSlider;
//红润
@property(nonatomic,strong)KSYSliderView* hongrunSlider;

@property(nonatomic,strong)KSYToolTipsView * topTipView;

@end

@implementation KSYBrushLiveVC

-(KSYToolTipsView*)topTipView{
    if (!_topTipView) {
        _topTipView = [[KSYToolTipsView alloc]init];
    }
    return _topTipView;
}

/**
 添加贴纸图层
 */
-(void)addStickerView{
    //贴纸页面(贴纸列表view在贴纸页面创建的时候就会添加到这个图层上)
    _decalBackGroundView = [[UIView alloc] init];
    //  _decalBackGroundView.frame = self.view.frame;
    //贴纸组合view
    _decalBGView = [[KSYDecalBGView alloc] init];
    // _decalBGView.frame = self.view.frame;
    
    //添加视图
    [_decalBackGroundView addSubview:_decalBGView];
    [self.view addSubview:self.decalBackGroundView];
    
    [self.decalBackGroundView sendSubviewToBack:_decalBGView];
    //单个贴纸view
    [_decalBackGroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(0);
        make.bottom.equalTo(self.view).offset(-130);
        make.width.equalTo(self.view);
        make.height.mas_equalTo(@400);
    }];
    [_decalBGView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(0);
        make.bottom.equalTo(self.view).offset(-130);
        make.width.equalTo(self.view);
        make.height.mas_equalTo(@400);
    }];
}

-(void)addSliderView{
    self.backgroundSliderView = [[UIView alloc]init];
    self.backgroundSliderView.backgroundColor = [UIColor colorWithWhite:0.2f alpha:0.2];
    [self.view addSubview:self.backgroundSliderView];
    
    
    self.volumnSlider = [[KSYSliderView alloc]initWithFrame:CGRectMake(0, 0, KSYScreenWidth, 20) leftTitle:@"音量" rightTitle:100 minimumValue:0 maxValue:100];
    [self.backgroundSliderView addSubview: self.volumnSlider];
    self.volumnSlider.sliderBlockEvent = ^(UISlider *slider) {
        
    };
    self.voiceSlider = [[KSYSliderView alloc]initWithFrame:CGRectMake(0, 30, KSYScreenWidth, 20) leftTitle:@"音调" rightTitle:100 minimumValue:0 maxValue:100];
    [self.backgroundSliderView addSubview: self.voiceSlider];
    self.voiceSlider.sliderBlockEvent = ^(UISlider *slider) {
        
    };
    
    [self.backgroundSliderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(0);
        make.bottom.equalTo(self.view).offset(-130);
        make.width.equalTo(self.view);
        make.height.mas_equalTo(@60);
    }];
    self.backgroundSliderView.hidden = YES;
    
    
    self.skinSliderView = [[UIView alloc]init];
    self.skinSliderView.backgroundColor = [UIColor colorWithWhite:0.2f alpha:0.2];
    [self.view addSubview:self.skinSliderView];
    
    
    self.whiteSlider = [[KSYSliderView alloc]initWithFrame:CGRectMake(0, 0, KSYScreenWidth, 20) leftTitle:@"美白" rightTitle:1 minimumValue:0 maxValue:1];
    [self.skinSliderView addSubview: self.whiteSlider];
    self.whiteSlider.sliderBlockEvent = ^(UISlider *slider) {
        
    };
    self.hongrunSlider = [[KSYSliderView alloc]initWithFrame:CGRectMake(0, 30, KSYScreenWidth, 20) leftTitle:@"红润" rightTitle:1 minimumValue:-1 maxValue:1];
    [self.skinSliderView addSubview: self.hongrunSlider];
    self.hongrunSlider.sliderBlockEvent = ^(UISlider *slider) {
        
    };
    
    self.exfoliatingSlider = [[KSYSliderView alloc]initWithFrame:CGRectMake(0, 60, KSYScreenWidth, 20) leftTitle:@"磨皮" rightTitle:1 minimumValue:0 maxValue:1];
    [self.skinSliderView addSubview: self.exfoliatingSlider];
    self.exfoliatingSlider.sliderBlockEvent = ^(UISlider *slider) {
        
    };
    
    [self.skinSliderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(0);
        make.bottom.equalTo(self.view).offset(-130);
        make.width.equalTo(self.view);
        make.height.mas_equalTo(@90);
    }];
    self.skinSliderView.hidden = YES;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    if (!_wxStreamerKit) {
        _wxStreamerKit = [[KSYGPUBrushStreamerKit alloc]init];
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
    
    [self addSubDrawView];
    
    //[self addStickerView];
    //添加滑块的view视图
    [self addSliderView];
    
    [self addObserver];
    
    //添加贴纸视图
   // [self addStickerView];
    _dlLock = [[NSLock alloc]init];
}

-(void)addSubDrawView{
    _drawView = [[KSYDrawingView alloc] init];
   // _drawView.centerX = self.view.center.x;
//    _drawView.centerY = self.view.center.y;
    _drawView.frame = CGRectMake(60, 80, KSYScreenWidth-120, 400);
    [_drawView.layer setBorderColor:[[UIColor redColor] CGColor]];
    [_drawView.layer setBorderWidth:1.0f];
    [self.view addSubview:_drawView];
    _drawView.hidden = YES;
}

//通知底部的按钮隐藏
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
    [notification addObserver:self selector:@selector(streamVolumnChangeState:) name:KSYStreamVoiceVolumeChangeNotice object:nil];
    //监听配置改变
    [notification addObserver:self selector:@selector(streamConfigChange:) name:KYSStreamChangeNotice object:nil];
    
     [notification addObserver:self selector:@selector(hideOrDisplaySliderView:) name: KSYSliderHideNotice object:nil];
    
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

-(void)streamVolumnChangeState:(NSNotification*)notice{
    KSYWeakSelf;
    NSDictionary* dic =notice.userInfo;
    for (NSString* string in [dic allKeys]) {
        if ([string isEqualToString:@"音量"]) {
            // 仅仅修改播放音量, 观众音量请调节mixer的音量
            float  number = [[dic valueForKey:string] floatValue];
            _wxStreamerKit.bgmPlayer.bgmVolume = number;
        }
        else if([string isEqualToString:@"音调"]){
            // 同时修改本地和观众端的 音调 (推荐变调的取值范围为 -3 到 3的整数)
            float  number = [[dic valueForKey:string] floatValue];
            _wxStreamerKit.bgmPlayer.bgmPitch = number;
        }
    }
}

#pragma mark - 监听配置改变的通知
-(void)streamConfigChange:(NSNotification*)notice{
    //    reverbType＝ 0;//关闭
    //    reverbType ＝1;//录音棚
    //    reverbType ＝2;//演唱会
    //    reverbType ＝3;//KTV
    //    reverbType ＝4;//小舞台
    
    KSYWeakSelf;
    NSDictionary* dic =notice.userInfo;
    for (NSString* string in [dic allKeys]) {
        //混响设置
        if ([string isEqualToString:@"混响"]) {
            int  number = [[dic valueForKey:string] intValue];
            _wxStreamerKit.aCapDev.reverbType = number;
            
        }
        //变声设置
        else if ([string isEqualToString:@"变声"]){
            int number = [[dic valueForKey:string] intValue];
            _wxStreamerKit.aCapDev.effectType = number;
        }
        //背景音乐设置
        else if ([string isEqualToString:@"背景音乐"]){
            
            //self.backgroundSliderView.hidden = NO;
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
        //logo设置
        else if ([string isEqualToString:@"LOGO"]){
            int number = [[dic valueForKey:string] intValue];
            if (number == 0) {
                //清除logo
                [_dlLock lock];
                _animateDecoder = nil;
                _wxStreamerKit.logoPic = nil;
                [_wxStreamerKit setLogoOrientaion:_logoOrientation];
                [_dlLock unlock];
            }
            else if (number == 1){
                //设置静态logo
                [_dlLock lock];
                _animateDecoder = nil;
                // _wxStreamerKit.logoPic = nil;
                [_wxStreamerKit setLogoOrientaion:_logoOrientation];
                [_dlLock unlock];
                [self setUpLogo];
            }
            else{
                //设置动态logo
                [self setupAnimateLogo:self.logoFileDownLoadTool.filePath];
                
            }
        }
        else if ([string isEqualToString:@"滤镜"]){
            self.skinSliderView.hidden = YES;
            int number = [[dic valueForKey:string] intValue];
            if (number == 0) {
                _currentFilter = nil;
                [_wxStreamerKit setupFilter: _currentFilter];//取消滤镜只要将_filter置为nil就行
            }
            else {
                KSYBeautifyProFilter * filter = [[KSYBeautifyProFilter alloc] initWithIdx:number];
                filter.grindRatio  = self.exfoliatingSlider.sldier.value;
                filter.whitenRatio = self.whiteSlider.sldier.value;
                filter.ruddyRatio  = self.hongrunSlider.sldier.value;
                _currentFilter    = filter;
                [_wxStreamerKit setupFilter: _currentFilter];
                
            }
        }
        else if ([string isEqualToString:@"美颜"]){
            int number = [[dic valueForKey:string] intValue];
            self.skinSliderView.hidden = NO;
            //            NSString *imgPath=[_gpuResourceDir stringByAppendingString:@"3_tianmeikeren.png"];
            //            UIImage *rubbyMat=[[UIImage alloc]initWithContentsOfFile:imgPath];
            //            if (rubbyMat == nil) {
            //                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
            //                                                                message:@"特效资源正在下载，请稍后重试"
            //                                                               delegate:nil
            //                                                      cancelButtonTitle:nil
            //                                                      otherButtonTitles:@"确定", nil];
            //                alert.alertViewStyle = UIAlertViewStyleDefault;
            //                [alert show];
            //            }
            //            KSYBeautifyFaceFilter *bf = [[KSYBeautifyFaceFilter alloc] initWithRubbyMaterial:rubbyMat];
            if (! [_currentFilter isMemberOfClass:[GPUImageFilterGroup class]]){
                return;
            }
            GPUImageFilterGroup * fg = (GPUImageFilterGroup *)_currentFilter;
            if (![fg.terminalFilter isMemberOfClass:[KSYBuildInSpecialEffects class]]) {
                return;
            }
            KSYBuildInSpecialEffects * sf = (KSYBuildInSpecialEffects *)fg.terminalFilter;
            [sf setSpecialEffectsIdx:number];
            
            [_wxStreamerKit setupFilter: sf];
            
        }
        else if ([string isEqualToString:@"贴纸"]){
            self.skinSliderView.hidden = YES;
            
            _decalBGView.interactionEnabled = YES;
            int number = [[dic valueForKey:string] intValue];
            
            [_decalBGView genDecalViewWithImgName:self.tiezhiArray[number]];
            [self updateAePicView];
        }
    }
}

#pragma mark - 监听 滑块视图是否显示
-(void)hideOrDisplaySliderView:(NSNotification*)notice{
    NSDictionary* dic =notice.userInfo;
    for (NSString* string in [dic allKeys]) {
        if ([string isEqualToString:@"滤镜"]){
            self.skinSliderView.hidden = YES;
        }
        else if ([string isEqualToString:@"美颜"]){
            self.skinSliderView.hidden = NO;
        }
        else if ([string isEqualToString:@"贴纸"]){
            self.skinSliderView.hidden = YES;
            
        }
    }
}

#pragma mark - Decal 相关
- (void)genDecalViewWithImgName:(NSString *)imgName{
    [_decalBGView genDecalViewWithImgName:imgName];
}

//刷新贴纸view
- (void) updateAePicView{
    if (_decalBGView){
        _wxStreamerKit.aePic = [[GPUImageUIElement alloc] initWithView:_decalBGView];
        //        [_wxStreamerKit.vStreamMixer  clearPicOfLayer:_aeLayer];
        //        [_wxStreamerKit.aePic removeAllTargets];
        //        [_wxStreamerKit.aePic addTarget:_wxStreamerKit.vStreamMixer atTextureLocation:_aeLayer];
        [_wxStreamerKit.streamerBase startStream:self.rtmpUrl];
    }
}

#pragma mark -设置动态logo 或者设置静态logo
-(void)setUpLogo{
    
    CGFloat yPos = 0.15;
    // 预览视图的scale
    CGFloat scale = MAX(self.view.frame.size.width, self.view.frame.size.height) / self.view.frame.size.height;
    CGFloat hgt  = 0.1 * scale; // logo图片的高度是预览画面的十分之一
    UIImage * logoImg = [UIImage imageNamed:@"ksvc"];
    _logoPicure   =  [[GPUImagePicture alloc] initWithImage:logoImg];
    _wxStreamerKit.logoPic  = _logoPicure;
    _logoOrientation = logoImg.imageOrientation;
    [_wxStreamerKit setLogoOrientaion: _logoOrientation];
    //设置大小
    _wxStreamerKit.logoRect = CGRectMake(0.05, yPos, 0, hgt);
    //设置透明度
    _wxStreamerKit.logoAlpha= 0.5;
}

- (void) setupAnimateLogo:(NSString*)path {
    CGFloat yPos = 0.15;
    // 预览视图的scale
    CGFloat scale = MAX(self.view.frame.size.width, self.view.frame.size.height) / self.view.frame.size.height;
    CGFloat hgt  = 0.1 * scale; // logo图片的高度是预览画面的十分之一
    //设置大小
    _wxStreamerKit.logoRect = CGRectMake(0.05, yPos, 0, hgt);
    
    NSData *data = [NSData dataWithContentsOfFile:path];
    [_dlLock lock];
    _animateDecoder = [YYImageDecoder decoderWithData:data scale: [[UIScreen mainScreen] scale]];
    [_wxStreamerKit setLogoOrientaion:UIImageOrientationUp];
    [_dlLock unlock];
    _animateIdx = 0;
    _dlTime = 0;
    if(!_displayLink){
        KSYWeakProxy *proxy = [KSYWeakProxy proxyWithTarget:self];
        SEL dpCB = @selector(displayLinkCallBack:);
        _displayLink = [CADisplayLink displayLinkWithTarget:proxy
                                                   selector:dpCB];
        [_displayLink addToRunLoop:[NSRunLoop currentRunLoop]
                           forMode:NSRunLoopCommonModes];
    }
}

- (void) updateAnimateLogo {
    if (_animateDecoder==nil) {
        return;
    }
    [_dlLock lock];
    YYImageFrame* frame = [_animateDecoder frameAtIndex:_animateIdx
                                       decodeForDisplay:NO];
    if (frame.image) {
        _wxStreamerKit.logoPic = [[GPUImagePicture alloc] initWithImage:frame.image];
    }
    _animateIdx = (_animateIdx+1)%_animateDecoder.frameCount;
    [_dlLock unlock];
}

- (void)displayLinkCallBack:(CADisplayLink *)link {
    dispatch_async( dispatch_get_global_queue(0, 0), ^(){
        if (_animateDecoder) {
            _dlTime += link.duration;
            // 读取 图像的 duration 来决定下一帧的刷新时间
            // 也可以固定设置为一个值来调整动画的快慢程度
            NSTimeInterval delay = [_animateDecoder frameDurationAtIndex:_animateIdx];
            if (delay < 0.04) {
                delay = 0.04;
            }
            if (_dlTime < delay) return;
            _dlTime -= delay;
            [self updateAnimateLogo];
        }
    });
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
            [KSYUIBaseViewController deleteFile:_byPassFilePath];
            NSURL *url =[[NSURL alloc] initFileURLWithPath:self.byPassFilePath];
            [_wxStreamerKit.streamerBase startBypassRecord:url];
            
            [self.topTipView showLabelLongTime:@"00:01"];
            // [[KSYToolTipsView shareInstance] showLabelLongTime:@"00:00"];
        }
        else {
            NSString * msg = @"推流过程中才能旁路录像";
            [self toast:msg time:1];
        }
    }
    else{
        [self.topTipView stopTimer];
        //[[KSYToolTipsView shareInstance] stopTimer];
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
        [_wxStreamerKit.streamerBase startStream:self.rtmpUrl];
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
        //[[KSYToolTipsView shareInstance]removeSubView];
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
        KSYQRCode *playUrlQRCodeVc = [[KSYQRCode alloc] init];
        //状态为直播视频
        //推流地址对应的拉流地址
        NSString * uuidStr =[[[UIDevice currentDevice] identifierForVendor] UUIDString];
        NSString *devCode  = [[uuidStr substringToIndex:3] lowercaseString];
        NSString *streamPlaySrv = @"http://test.hdllive.ks-cdn.com/live";
        NSString *streamPlayPostfix = @".flv";
        playUrlQRCodeVc.url = [ NSString stringWithFormat:@"%@/%@%@", streamPlaySrv, devCode,streamPlayPostfix];
        [self presentViewController:playUrlQRCodeVc animated:YES completion:nil];
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
    UIButton* brushBtn = [[UIButton alloc]initButtonWithTitle:@"画笔\n推流" titleColor:[UIColor whiteColor] font:KSYUIFont(14) backGroundColor:KSYRGB(112,87,78)  callBack:^(UIButton *sender) {
         sender.selected = !sender.selected;
        if (sender.selected) {
            _wxStreamerKit.drawPic = [[KSYGPUViewCapture alloc] initWithView:_drawView];
            [_wxStreamerKit.drawPic  start];
            _drawView.hidden = NO;
            }
        else{
            [_wxStreamerKit.drawPic stop];
            _wxStreamerKit.drawPic = nil;
            _drawView.hidden = YES;
            [_drawView clearAllPath];
        }
     
        
       
    }];
    [brushBtn setTitle:@"关闭\n画笔" forState: UIControlStateSelected];
    brushBtn.titleLabel.lineBreakMode = 0;
    [self.view addSubview:brushBtn];
    
    [brushBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).offset(-10);
        make.centerY.equalTo(self.view);
        make.width.mas_equalTo(@50);
        make.height.mas_equalTo(@40);
    }];
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
          [self.topTipView showLabelWithString:@"截图已保存至手机相册"];
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
       // [[KSYToolTipsView shareInstance] stopTimer];
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
        self.skinCareView = [[KSYSecondView alloc]init];
        self.skinCareView.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.2];
        NSArray* titleArray = @[@"美颜",@"滤镜",@"贴纸"];
        
        [self.skinCareView setUpSubView:titleArray viewHeight:210];
        
        self.skinCareView.voiceArray =  [[NSArray alloc]initWithObjects:@"无",@"粉嫩",@"自然",@"白皙",nil];
        self.skinCareView.pictureArray =  [[NSArray alloc]initWithObjects:@"ksy_media_edit_record_beauty_origin",@"ksy_media_edit_record_beauty_NaturalFitler_fennen",@"ksy_media_edit_record_beauty_ExtTilter_ziran",@"ksy_media_edit_record_beauty_ProFitler_baixi",nil];
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
        
        self.backgroundSliderView.hidden = YES;
        self.skinSliderView.hidden = YES;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
